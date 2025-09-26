return {
    "Goose97/timber.nvim",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("timber").setup({
        log_templates = {
          default = {
            -- Templates with auto_import: when inserting a log statement, the import line is inserted automatically
            -- javascript = {
            --   [[logger.info('hello world')]],
            --   auto_import = [[const logger = require('pino')()]]
            -- }
            javascript = [[console.log("%log_target", %log_target)]],
            typescript = [[console.log("%log_target", %log_target)]],
            astro = [[console.log("%log_target", %log_target)]],
            vue = [[console.log("%log_target", %log_target)]],
            jsx = [[console.log("%log_target", %log_target)]],
            tsx = [[console.log("%log_target", %log_target)]],
            lua = [[print("%log_target", %log_target)]],
            luau = [[print("%log_target", %log_target)]],
            ruby = [[puts("%log_target #{%log_target}")]],
            elixir = [[IO.inspect(%log_target, label: "%log_target")]],
            go = [[log.Printf("%log_target: %v\n", %log_target)]],
            rust = [[println!("%log_target: {:#?}", %log_target);]],
            python = [[print(f"{%log_target=}")]],
            c = [[printf("%log_target: %s\n", %log_target);]],
            cpp = [[std::cout << "%log_marker %log_target: " << %log_target << " %filename:%line_number" << std::endl;]],
            java = [[System.out.println("%log_target: " + %log_target);]],
            c_sharp = [[Console.WriteLine($"%log_target: {%log_target}");]],
            odin = [[fmt.printfln("%log_target: %v", %log_target)]],
            bash = [[echo "%log_target: ${%log_target}"]],
            swift = [[print("%log_target:", %log_target)]],
            kotlin = [[println("%log_target: ${%log_target}")]],
            scala = [[println(s"%log_target: ${%log_target}")]],
            dart = [[print("%log_target: ${%log_target}");]],
          },
          plain = {
            javascript = [[console.log("%insert_cursor")]],
            typescript = [[console.log("%insert_cursor")]],
            astro = [[console.log("%insert_cursor")]],
            vue = [[console.log("%insert_cursor")]],
            jsx = [[console.log("%insert_cursor")]],
            tsx = [[console.log("%insert_cursor")]],
            lua = [[print("%insert_cursor")]],
            luau = [[print("%insert_cursor")]],
            ruby = [[puts("%insert_cursor")]],
            elixir = [[IO.puts(%insert_cursor)]],
            go = [[log.Println("%insert_cursor")]],
            rust = [[println!("%insert_cursor");]],
            python = [[print(f"%insert_cursor")]],
            c = [[printf("%insert_cursor \n");]],
            cpp = [[std::cout << "%log_marker " << "%insert_cursor" << " %filename:%line_number" << std::endl;]],
            java = [[System.out.println("%insert_cursor");]],
            c_sharp = [[Console.WriteLine("%insert_cursor");]],
            odin = [[fmt.println("%insert_cursor")]],
            bash = [[echo "%insert_cursor"]],
            swift = [[print("%insert_cursor")]],
            kotlin = [[println("%insert_cursor")]],
            scala = [[println("%insert_cursor")]],
            dart = [[print("%insert_cursor");]],
          },
        },
        log_marker = "󰆈", -- Or any other string, e.g: MY_LOG
      }
    )
    end
}
