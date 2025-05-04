local theme = "paradise"

local pres, base16 = pcall(require, "base16-colorscheme")
if not pres then
  return
end

local present, color = pcall(require, "colors." .. theme)
if present then
  base16.setup(color)
end

-- Highlights
local function hl(highlight, fg, bg)
  if fg == nil then
    fg = "NONE"
  end
  if bg == nil then
    bg = "NONE"
  end
  -- vim.cmd("hi " .. highlight .. " guifg=" .. fg .. " guibg=" .. bg)
  vim.api.nvim_set_hl(0, highlight, { bg=bg, fg=fg, ctermbg='NONE' })
end

-- Diffciew
vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#20303b" })
vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#37222c" })
vim.api.nvim_set_hl(0, "DiffChange", { bg = "#1f2231" })
vim.api.nvim_set_hl(0, "DiffText", { bg = "#394b70" })

-- Custom TS highlighting
-- hl('Identifier', color.base0E)
-- hl('Special', color.base0E)
-- hl('Statement', color.base0E)
-- hl('Keyword', color.base0D)
hl("TSField", color.base08)
hl("TSVariable", color.base09)
hl("TSParameter", color.base08)
hl("TSProperty", color.base08)
hl("TSConstant", color.base0C)
hl("TSInclude", color.base0E)
hl("TSException", color.base0E)

-- Status Line
hl("StatusNormal")
hl("StatusLineNC", color.base03)
hl("StatusActive", color.base05)
hl("StatusLine", color.base02) -- inactive
hl("StatusReplace", color.base08)
hl("StatusInsert", color.base0B)
hl("StatusCommand", color.base0A)
hl("StatusVisual", color.base0D)
hl("StatusTerminal", color.base0E)

-- Nvim Tree
hl("NvimTreeFolderName", color.base05)
hl("NvimTreeOpenedFolderName", color.base05)
hl("NvimTreeEmptyFolderName", color.base05)
hl("NvimTreeFolderIcon", color.base03)
hl("NvimTreeGitDirty", color.base08)
hl("NvimTreeGitNew", color.base0B)
hl("NvimTreeGitDeleted", color.base08)
hl("NvimTreeGitRenamed", color.base0A)
hl("NvimTreeGitExecFile", color.base0B)
hl("NvimTreeSpecialFile", color.base0E)
hl("NvimTreeImageFile", color.base0C)
hl("NvimTreeWindowPicker", color.base05, color.base01)
hl("NvimTreeIndentMarker", color.base03)
hl("NvimTreeWinSeparator", color.base01, nil)

-- Telescope
hl("TelescopePromptBorder", color.base01, color.base01)
hl("TelescopePromptNormal", nil, color.base01)
hl("TelescopePromptPrefix", color.base08, color.base01)
hl("TelescopeSelection", nil, color.base01)


-- fzf-lua
hl("FzfLuaBorder", color.base08)             -- Equivalent to TelescopePromptBorder
hl("FzfLuaNormal", color.base04, '#151515')                       -- Equivalent to TelescopePromptNormal

-- hl("FzfLuaPreviewTitle", color.base08, color.base01)        -- Equivalent to TelescopePromptPrefix (for the preview area title)
-- hl("FzfLuaSelection", nil, color.base01)                    -- Equivalent to TelescopeSelection

-- Noice
hl('NoiceCmdlinePopupBorder', color.base08)
hl('NoiceCmdlineIcon', color.base08)
-- Gitgraph
hl('GitGraphHash', color.base08, color.base00)
hl('GitGraphTimestamp', color.base0C)
hl('GitGraphAuthor', color.base0D)
hl('GitGraphBranchName', color.base0E)
hl('GitGraphBranchTag', color.base0E)
hl('GitGraphBranchMsg', color.base0A)
hl('GitGraphBranch1', color.base08)
hl('GitGraphBranch2', color.base0A)
hl('GitGraphBranch3', color.base0B)
hl('GitGraphBranch4', color.base0C)
hl('GitGraphBranch5', color.base0E)

hl("GitSignsAdd", color.base0B, nil)
hl("GitSignsChange", color.base03, nil)
hl("GitSignsDelete", color.base08, nil)
hl("GitSignsChangedelete", color.base08, nil)
hl("GitSignsTopdelete", color.base08, nil)
hl("GitSignsUntracked", color.base03, nil)

-- Menu
hl("Pmenu", nil, color.base01)
hl("PmenuSbar", nil, color.base01)
hl("PmenuThumb", nil, color.base01)
hl("PmenuSel", nil, color.base02)

-- CMP
hl("CmpItemAbbrMatch", color.base05)
hl("CmpItemAbbrMatchFuzzy", color.base05)
hl("CmpItemAbbr", color.base03)
hl("CmpItemKind", color.base0E)
hl("CmpItemMenu", color.base0E)
hl("CmpItemKindSnippet", color.base0E)

-- Number
hl("CursorLine")
hl("CursorLineNR")
hl("LineNr", color.base03)

-- Others
hl("VertSplit", color.base01, nil)
hl("WinSeparator", color.base01, nil)
hl("NormalFloat", nil, color.base01)
hl("FloatBorder", color.base01, color.base01)

hl("FlashCurrent", color.base01, color.base08)
hl("FlashCursor", color.base01, color.base08)
hl("FlashMatch", color.base01, color.base08)
-- hl("FlashLabel", color.base01, color.base08)
hl("FlashPrompt", color.base01, color.base08)

-- Extra
vim.cmd("hi StatusLine gui=strikethrough")

-- Diffview
vim.api.nvim_set_hl(0, "DiffAdd", {bg = "#20303b"})
vim.api.nvim_set_hl(0, "DiffDelete", {bg = "#37222c"})
vim.api.nvim_set_hl(0, "DiffChange", {bg = "#1f2231"})
vim.api.nvim_set_hl(0, "DiffText", {bg = "#394b70"})

-- transparent background
vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })
vim.api.nvim_set_hl(0, 'Pmenu', { bg = 'none' })
