-- i3/hy3-inspired n-ary tree layout for Hyprland
--
-- Tree model: each node is either a leaf (window) or a container (h/v, n children).
-- New windows split the focused window. If the focused window's parent container
-- matches the split axis, the new window is appended as a sibling (flattened).
-- Otherwise a new container wraps the focused window and the new one.
--
-- Commands (via layoutmsg):
--   splith / splitv / splittoggle  - set/toggle split direction for next insert
--   move left|right|up|down        - move focused window directionally
--   swap left|right|up|down        - swap focused window with neighbor
--   resize left|right|up|down [n]  - adjust ratio between adjacent children
--   promote                        - swap focused window with the first window
--   rotate                         - flip all split directions
--   equalize                       - reset all ratios to equal

-----------------------------
-- Per-workspace state     --
-----------------------------

local workspaces = {}
local next_split = nil  -- nil = auto, "h" or "v" = forced (global, consumed on use)

local function ws_key(ctx)
    for _, target in ipairs(ctx.targets) do
        local w = target.window
        if w and w.workspace then
            -- Hyprland 0.57 leaves `id` nil on special and named workspaces,
            -- which would merge them all into one tree.
            return w.workspace.addressable_name or tostring(w.workspace.id)
        end
    end
    return "_default"
end

local function get_ws(ctx)
    local key = ws_key(ctx)
    if not workspaces[key] then
        workspaces[key] = { root = nil, boxes = {}, leaves = {} }
    end
    return workspaces[key], key
end

-----------------------------
-- Tree constructors       --
-----------------------------

local function make_leaf(id)
    return { type = "leaf", id = id, parent = nil }
end

--- Create a container with direction and a list of children.
--- Ratios default to equal (nil = compute as 1/n).
local function make_container(dir, children)
    local node = {
        type = "container",
        dir = dir,
        children = children,
        ratios = nil,  -- nil means equal; set to a list to override
        parent = nil,
    }
    for _, c in ipairs(children) do
        c.parent = node
    end
    return node
end

-----------------------------
-- ID helpers              --
-----------------------------

local function target_id(target)
    local window = target.window
    return window and tostring(window.stable_id) or tostring(target.index)
end

local function active_id(ctx)
    for _, target in ipairs(ctx.targets) do
        local window = target.window
        if window and window.active then
            return target_id(target)
        end
    end
    return nil
end

-----------------------------
-- Tree helpers            --
-----------------------------

local function find_leaf(ws, id)
    return ws.leaves[id]
end

local function collect_ids(node, out)
    out = out or {}
    if not node then return out end
    if node.type == "leaf" then
        out[#out + 1] = node.id
    else
        for _, c in ipairs(node.children) do
            collect_ids(c, out)
        end
    end
    return out
end

--- Find the index of a child in its parent's children list.
local function child_index(parent, child)
    for i, c in ipairs(parent.children) do
        if c == child then return i end
    end
    return nil
end

local function first_leaf(node)
    if not node then return nil end
    if node.type == "leaf" then return node end
    return first_leaf(node.children[1])
end

local function last_leaf(node)
    if not node then return nil end
    if node.type == "leaf" then return node end
    return last_leaf(node.children[#node.children])
end

--- Replace a child in a container, updating parent pointer.
local function replace_child(parent, old, new)
    local idx = child_index(parent, old)
    if idx then
        parent.children[idx] = new
        new.parent = parent
    end
end

-----------------------------
-- Tree mutations          --
-----------------------------

--- Remove a leaf from the tree. Collapses parent if only 1 child remains.
--- Returns new root.
local function remove_leaf(ws, root, leaf)
    local p = leaf.parent
    if not p then
        ws.leaves[leaf.id] = nil
        return nil  -- leaf was root
    end

    ws.leaves[leaf.id] = nil

    local idx = child_index(p, leaf)
    table.remove(p.children, idx)
    -- Adjust ratios
    if p.ratios then
        table.remove(p.ratios, idx)
        -- Renormalize
        local sum = 0
        for _, r in ipairs(p.ratios) do sum = sum + r end
        if sum > 0 then
            for i = 1, #p.ratios do p.ratios[i] = p.ratios[i] / sum end
        end
    end
    leaf.parent = nil

    if #p.children == 1 then
        -- Collapse: replace parent with the single remaining child
        local sole = p.children[1]
        sole.parent = nil
        local gp = p.parent
        if not gp then
            return sole  -- new root
        end
        replace_child(gp, p, sole)
        return root
    end

    return root
end

--- Insert new_node next to ref_node (after it by default).
--- If ref_node's parent is the same axis as dir, flatten into the children list.
--- Otherwise, wrap ref_node and new_node in a new container.
--- Returns new root.
local function insert_beside(ws, root, ref_node, new_node, dir, before)
    if new_node.type == "leaf" then
        ws.leaves[new_node.id] = new_node
    end
    local p = ref_node.parent

    -- If parent exists and is the same axis, flatten
    if p and p.dir == dir then
        local idx = child_index(p, ref_node)
        local insert_idx = before and idx or (idx + 1)
        table.insert(p.children, insert_idx, new_node)
        new_node.parent = p
        -- Reset ratios to equal
        p.ratios = nil
        return root
    end

    -- Wrap: create new container around ref and new
    local children
    if before then
        children = { new_node, ref_node }
    else
        children = { ref_node, new_node }
    end
    local container = make_container(dir, children)

    if not p then
        return container  -- new root
    end

    replace_child(p, ref_node, container)
    container.parent = p
    return root
end

local function swap_leaves(ws, a, b)
    a.id, b.id = b.id, a.id
    ws.leaves[a.id] = a
    ws.leaves[b.id] = b
end

-----------------------------
-- Sync tree with targets  --
-----------------------------

local function sync_tree(ctx, ws)
    local present = {}
    local targets = {}

    for _, target in ipairs(ctx.targets) do
        local id = target_id(target)
        present[id] = true
        targets[id] = target
    end

    local focused = active_id(ctx)

    -- Remove dead leaves
    if ws.root then
        for _, id in ipairs(collect_ids(ws.root)) do
            if not present[id] then
                local leaf = find_leaf(ws, id)
                if leaf then
                    ws.root = remove_leaf(ws, ws.root, leaf)
                end
                ws.boxes[id] = nil
            end
        end
    end

    -- Add new windows
    for _, target in ipairs(ctx.targets) do
        local id = target_id(target)

        if not ws.root then
            ws.root = make_leaf(id)
            ws.leaves[id] = ws.root
        elseif not find_leaf(ws, id) then
            local ref = focused and find_leaf(ws, focused)
            if not ref then
                ref = last_leaf(ws.root)
            end

            local dir = next_split
            if not dir then
                local box = ws.boxes[ref.id]
                if box then
                    dir = box.w >= box.h and "h" or "v"
                else
                    dir = "h"
                end
            end
            next_split = nil

            ws.root = insert_beside(ws, ws.root, ref, make_leaf(id), dir)
        end
    end

    return targets
end

-----------------------------
-- Placement               --
-----------------------------

local function place_tree(ctx, node, area, targets, ws)
    if not node then return end

    if node.type == "leaf" then
        ws.boxes[node.id] = { x = area.x, y = area.y, w = area.w, h = area.h }
        local target = targets[node.id]
        if target then
            target:place(area)
        end
        return
    end

    local ratios = node.ratios
    local n = #node.children
    local pos = node.dir == "h" and area.x or area.y
    local total = node.dir == "h" and area.w or area.h

    for i, child in ipairs(node.children) do
        local size = ratios and (total * ratios[i]) or (total / n)
        local child_area
        if node.dir == "h" then
            child_area = { x = pos, y = area.y, w = size, h = area.h }
        else
            child_area = { x = area.x, y = pos, w = area.w, h = size }
        end
        place_tree(ctx, child, child_area, targets, ws)
        pos = pos + size
    end
end

-----------------------------
-- Directional neighbor    --
-----------------------------

local function find_neighbor(ws, from_id, direction)
    local from = ws.boxes[from_id]
    if not from then return nil end

    local fx = from.x + from.w / 2
    local fy = from.y + from.h / 2
    local best_id, best_dist = nil, math.huge

    for id, box in pairs(ws.boxes) do
        if id ~= from_id then
            local cx = box.x + box.w / 2
            local cy = box.y + box.h / 2
            local dx, dy = cx - fx, cy - fy
            local valid = false

            if direction == "left" then
                valid = dx < 0 and math.abs(dx) > math.abs(dy)
            elseif direction == "right" then
                valid = dx > 0 and math.abs(dx) > math.abs(dy)
            elseif direction == "up" then
                valid = dy < 0 and math.abs(dy) > math.abs(dx)
            elseif direction == "down" then
                valid = dy > 0 and math.abs(dy) > math.abs(dx)
            end

            if valid then
                local dist = dx * dx + dy * dy
                if dist < best_dist then
                    best_id = id
                    best_dist = dist
                end
            end
        end
    end

    return best_id
end

-----------------------------
-- Move (tree-walk, hy3)   --
-----------------------------

--- Move a window directionally using hy3-style tree-walk.
---
--- Algorithm: walk up from leaf. At each parent container:
---   1. Same axis as move direction:
---      a. Not at edge → shift position within children list.
---      b. At edge → pop out (keep walking up).
---   2. Cross-axis → keep walking up, remembering which side of the
---      nearest one the window sits on.
---   3. Reached root → no-op if already at outermost edge; else detach
---      and prepend/append to root (or wrap if root is cross-axis).
local function move_window_dir(ws, from_id, direction)
    local from_leaf = find_leaf(ws, from_id)
    if not from_leaf then return end

    local move_axis = (direction == "left" or direction == "right") and "h" or "v"
    local forward = (direction == "right" or direction == "down")

    -- Cross-axis position, taken from the nearest cross-axis ancestor on the
    -- way up (not only the immediate parent): the bottom eighth of a column
    -- then lands under the window it moves into instead of beside it.
    local cross_axis = move_axis == "h" and "v" or "h"
    local cross_index = nil  -- index within cross-axis ancestor (for position preservation)
    local cross_count = nil

    local node = from_leaf
    while node.parent do
        local p = node.parent
        if p.dir == move_axis then
            local idx = child_index(p, node)
            local at_edge = (not forward and idx == 1) or (forward and idx == #p.children)

            if not at_edge then
                -- Shift within the children list
                local target_idx = forward and (idx + 1) or (idx - 1)
                local target_node = p.children[target_idx]

                if node == from_leaf then
                    -- Direct child: swap positions in the list
                    p.children[idx] = target_node
                    p.children[target_idx] = from_leaf
                    -- Swap ratios too if custom
                    if p.ratios then
                        p.ratios[idx], p.ratios[target_idx] = p.ratios[target_idx], p.ratios[idx]
                    end
                    return
                end

                -- Node is an ancestor of from_leaf. Detach from_leaf and
                -- insert into the target sibling or beside it.
                ws.root = remove_leaf(ws, ws.root, from_leaf)
                if not ws.root then
                    ws.root = make_leaf(from_id)
                    ws.leaves[from_id] = ws.root
                    return
                end

                -- Re-find the target after tree mutation
                local new_leaf = make_leaf(from_id)
                local target_leaf
                if target_node.type == "leaf" then
                    target_leaf = find_leaf(ws, target_node.id)
                else
                    -- Descend into sibling from the near side
                    local desc = target_node
                    while desc.type == "container" do
                        if desc.dir == move_axis then
                            desc = forward and desc.children[1] or desc.children[#desc.children]
                        else
                            desc = desc.children[1]
                        end
                    end
                    target_leaf = find_leaf(ws, desc.id)
                end
                if not target_leaf then return end

                -- Insert: preserve cross-axis position if applicable
                if cross_index then
                    local tp = target_leaf.parent
                    local container
                    if cross_index == 1 then
                        container = make_container(cross_axis, { new_leaf, target_leaf })
                    else
                        container = make_container(cross_axis, { target_leaf, new_leaf })
                    end
                    ws.leaves[new_leaf.id] = new_leaf
                    if not tp then
                        ws.root = container
                    else
                        replace_child(tp, target_leaf, container)
                        container.parent = tp
                    end
                else
                    -- No cross-axis context: insert beside target along move axis
                    ws.root = insert_beside(ws, ws.root, target_leaf, new_leaf, move_axis, not forward)
                end
                return
            end
            -- At edge: pop out
        elseif not cross_index then
            cross_index = child_index(p, node)
            cross_count = #p.children
        end
        -- Cross-axis or popping out: walk up
        node = p
    end

    -- Reached root. Check if already at outermost edge.
    -- Only walk down same-axis containers; if root is cross-axis,
    -- we're not at any edge for this axis.
    local edge = ws.root
    while edge and edge.type == "container" and edge.dir == move_axis do
        edge = forward and edge.children[#edge.children] or edge.children[1]
    end
    if edge and edge.type == "leaf" and edge.id == from_id then return end

    -- Detach and place at outer edge
    ws.root = remove_leaf(ws, ws.root, from_leaf)
    if not ws.root then
        ws.root = make_leaf(from_id)
        ws.leaves[from_id] = ws.root
        return
    end

    local new_leaf = make_leaf(from_id)
    ws.leaves[from_id] = new_leaf
    if ws.root.type == "container" and ws.root.dir == move_axis then
        -- Flatten into root
        if forward then
            table.insert(ws.root.children, new_leaf)
        else
            table.insert(ws.root.children, 1, new_leaf)
        end
        new_leaf.parent = ws.root
        ws.root.ratios = nil  -- reset to equal
    else
        -- Wrap root
        local children
        if forward then
            children = { ws.root, new_leaf }
        else
            children = { new_leaf, ws.root }
        end
        ws.root = make_container(move_axis, children)
    end
end

-----------------------------
-- Resize                  --
-----------------------------

--- Find the nearest ancestor container matching the axis and adjust ratios
--- between the child and its neighbor.
local function resize_in_dir(ws, active, direction, amount)
    local leaf = find_leaf(ws, active)
    if not leaf then return end

    local axis = (direction == "left" or direction == "right") and "h" or "v"
    local shrink = (direction == "left" or direction == "up")

    local node = leaf
    while node.parent do
        local p = node.parent
        if p.dir == axis then
            local idx = child_index(p, node)
            -- Materialize ratios if needed
            if not p.ratios then
                local n = #p.children
                p.ratios = {}
                for i = 1, n do p.ratios[i] = 1.0 / n end
            end

            -- Try the boundary in the move direction first.
            -- For left/up: boundary is idx-1 (left/top edge of this child)
            -- For right/down: boundary is idx (right/bottom edge of this child)
            local boundary_idx
            if shrink then
                -- Move left/up boundary: try left boundary first
                boundary_idx = idx - 1
                if boundary_idx < 1 then boundary_idx = idx end
            else
                -- Move right/down boundary: try right boundary first
                boundary_idx = idx
                if boundary_idx >= #p.children then boundary_idx = idx - 1 end
            end

            if boundary_idx >= 1 and boundary_idx < #p.children then
                -- Move the boundary in the requested direction.
                -- boundary is between children[boundary_idx] and [boundary_idx+1].
                -- left/up: boundary moves toward start → shrink boundary_idx, grow boundary_idx+1
                -- right/down: boundary moves toward end → grow boundary_idx, shrink boundary_idx+1
                local delta = amount
                if shrink then
                    p.ratios[boundary_idx] = math.max(0.05, p.ratios[boundary_idx] - delta)
                    p.ratios[boundary_idx + 1] = math.max(0.05, p.ratios[boundary_idx + 1] + delta)
                else
                    p.ratios[boundary_idx] = math.max(0.05, p.ratios[boundary_idx] + delta)
                    p.ratios[boundary_idx + 1] = math.max(0.05, p.ratios[boundary_idx + 1] - delta)
                end
                -- Renormalize
                local sum = 0
                for i = 1, #p.ratios do sum = sum + p.ratios[i] end
                for i = 1, #p.ratios do p.ratios[i] = p.ratios[i] / sum end
            end
            return
        end
        node = p
    end
end

-----------------------------
-- Other mutations         --
-----------------------------

local function rotate_tree(node)
    if not node or node.type == "leaf" then return end
    node.dir = node.dir == "h" and "v" or "h"
    for _, c in ipairs(node.children) do
        rotate_tree(c)
    end
end

local function equalize_tree(node)
    if not node or node.type == "leaf" then return end
    node.ratios = nil  -- reset to equal
    for _, c in ipairs(node.children) do
        equalize_tree(c)
    end
end

-----------------------------
-- Persistence             --
-----------------------------

-- A config reload (any save under ~/.config/hypr, or noctalia re-rendering
-- noctalia.lua on a theme switch) restarts the Lua state, which used to drop
-- every tree and rebuild each workspace as one flat row. Trees are saved to
-- the Hyprland instance's runtime dir after each recalculate and restored on
-- load. Stable ids survive a reload but not a restart, and a restart gets a
-- new instance dir, so a stale file is never read.

local state_path
do
    local runtime  = os.getenv("XDG_RUNTIME_DIR")
    local instance = os.getenv("HYPRLAND_INSTANCE_SIGNATURE")
    if runtime and instance then
        state_path = runtime .. "/hypr/" .. instance .. "/i3-trees.lua"
    end
end

-- Saved trees not yet adopted, keyed like `workspaces`. After a reload
-- Hyprland hands the windows back one at a time, recalculating after each,
-- so a workspace is laid out from a pruned copy of its saved tree until all
-- saved windows are back or an unknown one shows up.
local restored = {}
local last_saved = nil

--- Serialize a live or saved tree (both carry id / dir / ratios / children).
local function serialize_node(node, out)
    if node.id then
        out[#out + 1] = string.format("{id=%q}", node.id)
        return
    end
    out[#out + 1] = string.format("{dir=%q,", node.dir)
    if node.ratios then
        out[#out + 1] = "ratios={"
        for _, r in ipairs(node.ratios) do
            out[#out + 1] = string.format("%q,", r)
        end
        out[#out + 1] = "},"
    end
    out[#out + 1] = "children={"
    for _, c in ipairs(node.children) do
        serialize_node(c, out)
        out[#out + 1] = ","
    end
    out[#out + 1] = "}}"
end

local function save_state()
    if not state_path then return end

    local trees = {}
    for key, ws in pairs(workspaces) do
        if ws.root and key ~= "_default" then trees[key] = ws.root end
    end
    -- Pending trees win: the live one is only a pruned copy until adopted.
    for key, saved in pairs(restored) do
        trees[key] = saved.tree
    end

    local keys = {}
    for key in pairs(trees) do keys[#keys + 1] = key end
    table.sort(keys)

    local out = { "return {" }
    for _, key in ipairs(keys) do
        out[#out + 1] = string.format("[%q]=", key)
        serialize_node(trees[key], out)
        out[#out + 1] = ","
    end
    out[#out + 1] = "}"

    local text = table.concat(out)
    if text == last_saved then return end

    -- Write-then-rename, so a crash mid-write never leaves half a file.
    local tmp = state_path .. ".tmp"
    local f = io.open(tmp, "w")
    if not f then return end
    f:write(text)
    f:close()
    if os.rename(tmp, state_path) then
        last_saved = text
    end
end

local function count_saved_leaves(node, ids)
    if node.id then
        ids[node.id] = true
        return 1
    end
    local n = 0
    for _, c in ipairs(node.children) do
        n = n + count_saved_leaves(c, ids)
    end
    return n
end

local function load_state()
    if not state_path then return end
    local f = io.open(state_path, "r")
    if not f then return end
    local text = f:read("a")
    f:close()

    local chunk = text and load(text, "=i3-trees", "t", {})
    if not chunk then return end
    local ok, trees = pcall(chunk)
    if not ok or type(trees) ~= "table" then return end

    for key, tree in pairs(trees) do
        local ids = {}
        local counted, count = pcall(count_saved_leaves, tree, ids)
        if counted and count > 0 then
            restored[key] = { tree = tree, ids = ids, count = count }
        end
    end
    last_saved = text
end

--- Rebuild a saved tree with only the windows in `present`. Emptied
--- containers vanish and single children collapse, as in remove_leaf.
local function rebuild(node, present, leaves)
    if node.id then
        if not present[node.id] then return nil end
        local leaf = make_leaf(node.id)
        leaves[node.id] = leaf
        return leaf
    end

    local children, ratios = {}, {}
    for i, c in ipairs(node.children) do
        local child = rebuild(c, present, leaves)
        if child then
            children[#children + 1] = child
            ratios[#ratios + 1] = node.ratios and node.ratios[i]
        end
    end
    if #children == 0 then return nil end
    if #children == 1 then return children[1] end

    local container = make_container(node.dir, children)
    if node.ratios and #ratios == #children then
        local sum = 0
        for _, r in ipairs(ratios) do sum = sum + r end
        if sum > 0 then
            for i = 1, #ratios do ratios[i] = ratios[i] / sum end
            container.ratios = ratios
        end
    end
    return container
end

--- Lay a workspace out from its saved tree, pruned to the windows Hyprland
--- has handed back so far. Adopted for good once every saved window is
--- back, an unknown window appears, or `finish` is set.
local function restore_step(ctx, ws, key, finish)
    local saved = restored[key]
    local present, seen, unknown = {}, 0, false
    for _, target in ipairs(ctx.targets) do
        local id = target_id(target)
        present[id] = true
        if saved.ids[id] then seen = seen + 1 else unknown = true end
    end

    local leaves = {}
    local ok, root = pcall(rebuild, saved.tree, present, leaves)
    if ok then
        ws.root, ws.leaves = root, leaves
    end
    if finish or unknown or seen == saved.count or not ok then
        restored[key] = nil
    end
end

load_state()

-----------------------------
-- Focus new windows       --
-----------------------------

hl.on("window.open", function(window)
    if window then
        hl.dispatch(hl.dsp.focus({ window = "address:" .. window.address }))
    end
end)

-----------------------------
-- Register layout         --
-----------------------------

hl.layout.register("i3", {
    recalculate = function(ctx)
        local ws, key = get_ws(ctx)
        if restored[key] then restore_step(ctx, ws, key) end

        if #ctx.targets == 0 then
            ws.root = nil
            ws.boxes = {}
            ws.leaves = {}
            return
        end

        local targets = sync_tree(ctx, ws)
        ws.boxes = {}
        place_tree(ctx, ws.root, ctx.area, targets, ws)
        save_state()
    end,

    layout_msg = function(ctx, msg)
        local ws, key = get_ws(ctx)
        if restored[key] then restore_step(ctx, ws, key, true) end
        local focused = active_id(ctx)
        local command, arg = msg:match("^(%S+)%s*(.*)$")

        if command == "splith" then
            next_split = "h"

        elseif command == "splitv" then
            next_split = "v"

        elseif command == "splittoggle" then
            next_split = next_split == "v" and "h" or "v"

        elseif command == "move" then
            if focused and ws.root then
                move_window_dir(ws, focused, arg)
            end

        elseif command == "swap" then
            if focused and ws.root then
                local neighbor = find_neighbor(ws, focused, arg)
                if neighbor then
                    local a = find_leaf(ws, focused)
                    local b = find_leaf(ws, neighbor)
                    if a and b then swap_leaves(ws, a, b) end
                end
            end

        elseif command == "resize" then
            if focused and ws.root then
                local dir, amt_str = arg:match("^(%S+)%s*(.*)$")
                if dir then
                    resize_in_dir(ws, focused, dir, tonumber(amt_str) or 0.05)
                end
            end

        elseif command == "promote" then
            if focused and ws.root then
                local leaf = find_leaf(ws, focused)
                local fst = first_leaf(ws.root)
                if leaf and fst and leaf ~= fst then
                    swap_leaves(ws, leaf, fst)
                end
            end

        elseif command == "rotate" then
            if ws.root then rotate_tree(ws.root) end

        elseif command == "equalize" then
            if ws.root then equalize_tree(ws.root) end

        else
            return "i3: unknown command: " .. (command or msg)
        end

        return true
    end,
})
