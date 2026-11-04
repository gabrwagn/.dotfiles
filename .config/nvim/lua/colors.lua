local theme = "paradise"

local pres, base16 = pcall(require, "base16-colorscheme")
if not pres then
  return
end

local present, color = pcall(require, "colors." .. theme)
if present then
  base16.setup(color)
end

-- base16-colorscheme never calls `:colorscheme`, so no colorscheme registers.
-- Without `g:colors_name` LazyVim and most plugins (noice, snacks, which-key,
-- bufferline, lualine theme resolution) skip their per-colorscheme setup and
-- fall back to dark defaults, which is why overlay windows end up unthemed.
vim.g.colors_name = "base16-paradise"
vim.o.background = "dark"

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

-- transparent background for the editor itself
vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })

-- Overlay windows (floats, popups, pickers) must stay opaque. They used to be
-- transparent too, which these plugins (which-key, fzf-lua, cmp, noice, snacks,
-- lsp hover) resolve through NormalFloat/Pmenu/FloatBorder. Transparent floats
-- over a semi-transparent terminal render as undefined default colors.
-- Explicit paradise surfaces, re-applied after plugins load their own groups.
local function paradise_overlay_hl()
  local c = color

  vim.api.nvim_set_hl(0, "NormalFloat", { fg = c.base0F, bg = c.base00 })
  vim.api.nvim_set_hl(0, "FloatBorder", { fg = c.base01, bg = c.base00 })
  vim.api.nvim_set_hl(0, "FloatTitle", { fg = c.base0A, bg = c.base00 })

  vim.api.nvim_set_hl(0, "Pmenu", { fg = c.base0F, bg = c.base01 })
  vim.api.nvim_set_hl(0, "PmenuSel", { fg = c.base05, bg = c.base02 })
  vim.api.nvim_set_hl(0, "PmenuSbar", { bg = c.base01 })
  vim.api.nvim_set_hl(0, "PmenuThumb", { bg = c.base02 })
  vim.api.nvim_set_hl(0, "PmenuKind", { fg = c.base0E })
  vim.api.nvim_set_hl(0, "PmenuKindSel", { fg = c.base0E })

  -- which-key
  vim.api.nvim_set_hl(0, "WhichKey", { fg = c.base0D, bg = c.base01 })
  vim.api.nvim_set_hl(0, "WhichKeyGroup", { fg = c.base0E, bg = c.base01 })
  vim.api.nvim_set_hl(0, "WhichKeyDesc", { fg = c.base05, bg = c.base01 })
  vim.api.nvim_set_hl(0, "WhichKeySeparator", { fg = c.base03, bg = c.base01 })
  vim.api.nvim_set_hl(0, "WhichKeyValue", { fg = c.base03, bg = c.base01 })
  vim.api.nvim_set_hl(0, "WhichKeyNormal", { fg = c.base0F, bg = c.base01 })
  vim.api.nvim_set_hl(0, "WhichKeyBorder", { fg = c.base02, bg = c.base01 })
  vim.api.nvim_set_hl(0, "WhichKeyTitle", { fg = c.base0A, bg = c.base01 })

  -- fzf-lua
  vim.api.nvim_set_hl(0, "FzfLuaNormal", { fg = c.base0F, bg = c.base00 })
  vim.api.nvim_set_hl(0, "FzfLuaBorder", { fg = c.base08, bg = c.base00 })
  vim.api.nvim_set_hl(0, "FzfLuaTitle", { fg = c.base05, bg = c.base00 })
  vim.api.nvim_set_hl(0, "FzfLuaFzfMatch", { fg = c.base0D })
  vim.api.nvim_set_hl(0, "FzfLuaFzfCursorLine", { bg = c.base02 })

  -- cmp
  vim.api.nvim_set_hl(0, "CmpPmenu", { fg = c.base0F, bg = c.base01 })
  vim.api.nvim_set_hl(0, "CmpPmenuSel", { fg = c.base05, bg = c.base02 })
  vim.api.nvim_set_hl(0, "CmpPmenuBorder", { fg = c.base02, bg = c.base01 })
  vim.api.nvim_set_hl(0, "CmpItemAbbr", { fg = c.base0F })
  vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = c.base0D })
  vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = c.base0D, underline = true })
  vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = c.base03 })
  vim.api.nvim_set_hl(0, "CmpItemKind", { fg = c.base0E })

  -- noice
  vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { fg = c.base05, bg = c.base01 })
  vim.api.nvim_set_hl(0, "NoiceFormatError", { fg = c.base08, bg = c.base01 })
  vim.api.nvim_set_hl(0, "NoiceFormatWarn", { fg = c.base0A, bg = c.base01 })
  vim.api.nvim_set_hl(0, "NoiceFormatInfo", { fg = c.base0C, bg = c.base01 })
  vim.api.nvim_set_hl(0, "NoiceBorder", { fg = c.base02, bg = c.base01 })
  vim.api.nvim_set_hl(0, "NoiceTitle", { fg = c.base0A, bg = c.base01 })

  -- snacks
  vim.api.nvim_set_hl(0, "SnacksNotifier", { fg = c.base05, bg = c.base01 })
  vim.api.nvim_set_hl(0, "SnacksNotifierError", { fg = c.base08, bg = c.base01 })
  vim.api.nvim_set_hl(0, "SnacksNotifierWarn", { fg = c.base0A, bg = c.base01 })
  vim.api.nvim_set_hl(0, "SnacksNotifierInfo", { fg = c.base0C, bg = c.base01 })
  vim.api.nvim_set_hl(0, "SnacksDashboardTitle", { fg = c.base0A })
  vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = c.base0E })
  vim.api.nvim_set_hl(0, "SnacksDashboardFooter", { fg = c.base05 })
  vim.api.nvim_set_hl(0, "SnacksDashboardKey", { fg = c.base0D })
  vim.api.nvim_set_hl(0, "SnacksPicker", { fg = c.base05, bg = c.base00 })

  -- lsp hover / trouble
  vim.api.nvim_set_hl(0, "LspFloatWinNormal", { fg = c.base05, bg = c.base00 })
  vim.api.nvim_set_hl(0, "LspFloatWinBorder", { fg = c.base01, bg = c.base00 })
  vim.api.nvim_set_hl(0, "LspInfoTitle", { fg = c.base0A })
  vim.api.nvim_set_hl(0, "TroubleNormal", { fg = c.base05, bg = c.base00 })

  -- cursor line inside floats/pickers
  vim.api.nvim_set_hl(0, "CursorLine", { bg = c.base01 })
end

paradise_overlay_hl()

vim.api.nvim_create_autocmd("ColorScheme", {
  once = true,
  callback = function()
    vim.g.colors_name = "base16-paradise"
    vim.o.background = "dark"
    paradise_overlay_hl()
  end,
})
