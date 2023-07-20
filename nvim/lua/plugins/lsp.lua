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

      require'lspconfig'.nim_langserver.setup{
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
  }
}
