return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      clangd = {
        mason = false,
      },
      vacuum = {
        filetypes = { "yaml", "json" },
        root_dir = require('lspconfig.util').root_pattern(
          'openapi.yaml', 
          'openapi.yml',
          'swagger.json',
          '.vacuum.yaml'
        ),
      },
    }
  }
}
