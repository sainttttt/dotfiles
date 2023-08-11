return {
  {
    'neovim/nvim-lspconfig',
    config = function()

      -- Use an on_attach function to only map the following keys
      -- after the language server attaches to the current buffer
      local on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        -- vim.cmd [[autocmd! CursorHold,CursorHoldI * lua show_line_diagnostics()]]

        -- Mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local bufopts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
      end

      -- require'lspconfig'.nim_langserver.setup{
      --   on_attach = on_attach,
      -- }

      require'lspconfig'.nimls.setup{
        on_attach = on_attach,
      }

      require'lspconfig'.lua_ls.setup {
        on_attach = on_attach,
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
              version = 'LuaJIT',
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = {'vim'},
              disable = { "redefined-local", "missing-parameter", "redundant-parameter" },
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
              enable = false,
            },
          },

        },
      }

      local lsp_config = require('lspconfig')
      require'lspconfig'.sourcekit.setup {
        on_attach = on_attach,
        -- capabilities = capabilities,
        -- cmd = { "sourcekit-lsp" },
        -- filetypes = { "swift", "c", "cpp", "objective-c", "objective-cpp" },
        -- root_dir = lsp_config.util.root_pattern("Package.swift", ".git", "*.xcodeproj")
      }

    end
  },

  {
    'nvimdev/lspsaga.nvim',
    event = "LspAttach",
    config = function()
      require("lspsaga").setup({
        lightbulb = {
          enable = false,
        },
        finder = {
          max_height = 0.6,
          keys = {
            vsplit = 'v'
          }
        }
      })

      vim.keymap.set("n", "gp", "<cmd>Lspsaga peek_definition<CR>", {noremap=true})
      vim.keymap.set("n", "ga", "<cmd>Lspsaga peek_definition<CR>", {noremap=true})


      local keymap = vim.keymap.set

      -- LSP finder - Find the symbol's definition
      -- If there is no definition, it will instead be hidden
      -- When you use an action in finder like "open vsplit",
      -- you can use <C-t> to jump back
      keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>")

      -- Code action
      keymap({"n","v"}, "<leader>ca", "<cmd>Lspsaga code_action<CR>")

      -- Rename all occurrences of the hovered word for the entire file
      keymap("n", "gr", "<cmd>Lspsaga rename<CR>")

      -- Rename all occurrences of the hovered word for the selected files
      keymap("n", "gr", "<cmd>Lspsaga rename ++project<CR>")

      -- Peek definition
      -- You can edit the file containing the definition in the floating window
      -- It also supports open/vsplit/etc operations, do refer to "definition_action_keys"
      -- It also supports tagstack
      -- Use <C-t> to jump back
      keymap("n", "gp", "<cmd>Lspsaga peek_definition<CR>")

      -- Go to definition
      keymap("n","gd", "<cmd>Lspsaga goto_definition<CR>")

      -- Peek type definition
      -- You can edit the file containing the type definition in the floating window
      -- It also supports open/vsplit/etc operations, do refer to "definition_action_keys"
      -- It also supports tagstack
      -- Use <C-t> to jump back
      keymap("n", "gt", "<cmd>Lspsaga peek_type_definition<CR>")

      -- Go to type definition
      keymap("n","gt", "<cmd>Lspsaga goto_type_definition<CR>")


      -- Show line diagnostics
      -- You can pass argument ++unfocus to
      -- unfocus the show_line_diagnostics floating window
      -- keymap("n", "<leader>ls", "<cmd>Lspsaga show_line_diagnostics ++unfocus<CR>")
      keymap("n", "<space>", "<cmd> nohlsearch | Lspsaga show_line_diagnostics ++unfocus<CR>")

      -- Show buffer diagnostics
      keymap("n", "<leader>bs", "<cmd>Lspsaga show_buf_diagnostics<CR>")

      -- Show workspace diagnostics
      -- keymap("n", "<leader>sw", "<cmd>Lspsaga show_workspace_diagnostics<CR>")

      -- Show cursor diagnostics
      -- keymap("n", "<leader>sc", "<cmd>Lspsaga show_cursor_diagnostics<CR>")

      -- Diagnostic jump
      -- You can use <C-o> to jump back to your previous location
      keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
      keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>")

      -- Diagnostic jump with filters such as only jumping to an error
      keymap("n", "[E", function()
        require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
      end)
      keymap("n", "]E", function()
        require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
      end)

      -- Toggle outline
      keymap("n","<leader>o", "<cmd>Lspsaga outline<CR>")


      -- Call hierarchy
      keymap("n", "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>")
      keymap("n", "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>")

      -- Floating terminal
      keymap({"n", "t"}, "<A-d>", "<cmd>Lspsaga term_toggle<CR>")

    end,

    dependencies = {
      {"nvim-tree/nvim-web-devicons"},
      --Please make sure you install markdown and markdown_inline parser
      {"nvim-treesitter/nvim-treesitter"}
    }
  },
}
