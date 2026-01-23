return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false, -- Never set this to "*"!
  build = "make",  -- or "make BUILD_FROM_SOURCE=true" to build from source
  opts = {
    -- Basic configuration
    provider = "copilot",  -- You can also use: "openai", "azure", "gemini", "copilot"
    -- This file can contain project-specific instructions
    instructions_file = "avante.md",
    -- Configure your AI provider
    providers = {
      claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-sonnet-4-20250514",
        timeout = 30000,
        extra_request_body = {
          temperature = 0.75,
          max_tokens = 20480,
        },
      },
    },
    -- Behavior settings
    behaviour = {
      auto_suggestions = false,
      auto_set_keymaps = true,
      auto_approve_tool_permissions = false,
      auto_apply_diff_after_generation = false,
      support_paste_from_clipboard = false,
    },
    -- Window settings
    windows = {
      position = "right",  -- "right" | "left" | "top" | "bottom"
      wrap = true,
      width = 30,  -- percentage based on available width
    },
  },
  -- Dependencies
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
    "hrsh7th/nvim-cmp",  -- for autocompletion
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
    {
      -- Support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          use_absolute_path = true,
        },
      },
    },
  },
}
