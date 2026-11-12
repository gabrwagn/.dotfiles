return {
  'CoreyKaylor/diffbandit.nvim',
  enabled = false, -- back on diffview (wants folder tree in file panel)
  -- setup() derives its colors from Normal/Diff* once, so load after lua/colors.lua has applied paradise
  event = 'VeryLazy',
  -- Keys remapped towards diffview muscle memory; <Space> is the leader
  opts = {
    actions = { keys = { toggle_stage = '-' } },
    git = {
      file_keys = { next = '<Tab>', prev = '<S-Tab>' },
      panel = {
        keys = { toggle_stage = '-', toggle_amend = '<C-a>', focus_panel = '<leader>e' },
      },
    },
    navigation = { document_keys = { top = false, bottom = false } },
    merge = { keys = { focus_panel = '<leader>e' } },
    folder = { keys = { toggle_expand = 'za' } },
  },
  config = function(_, opts)
    -- Normal has bg=none (transparent), so diffbandit falls back to #000000 and
    -- paints solid black on context/split/gutter groups. Strip that fallback bg.
    local hl = require('diffbandit.highlights')
    local apply = hl.apply
    hl.apply = function(...)
      apply(...)
      for name, def in pairs(vim.api.nvim_get_hl(0, {})) do
        if name:find('^DiffBandit') and def.bg == 0 and not def.link then
          def.bg = nil
          vim.api.nvim_set_hl(0, name, def)
        end
      end
    end
    require('diffbandit').setup(opts)
  end,
}
