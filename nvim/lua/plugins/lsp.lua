local completion_capabilities = require('cmp_nvim_lsp').default_capabilities();

local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  -- vim.cmd [[autocmd! CursorHold,CursorHoldI * lua show_line_diagnostics()]]

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  -- vim.keymap.set('n', 'gf', [[<cmd>vsplit |  exe "normal \<c-w>l" | lua vim.lsp.buf.definition()<CR>]], bufopts)

  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)

  -- vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, bufopts)

  -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  --
  local fzf_lua = require 'fzf-lua'
  if fzf_lua then
    vim.keymap.set("n", "gr", function() fzf_lua.lsp_references() end, bufopts)
    vim.keymap.set("n", "<leader>fd", function() fzf_lua.lsp_workspace_symbols() end, bufopts)
    -- vim.keymap.set('n', 'gd', function() fzf_lua.lsp_definitions() end, bufopts)

    -- vim.keymap.set('n', 'gr', function() require('telescope.builtin').lsp_references() end, { noremap = true, silent = true })
  else
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  end
end

return {

  {
    "williamboman/mason.nvim",
    -- cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    -- build = ":MasonUpdate",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "",
            package_pending = "",
            package_uninstalled = "",
          },
        }
      })
      require("mason-lspconfig").setup {
        ensure_installed = { "lua_ls", "nimls", "html", "crystalline", "tsserver", "pyright" },
        automatic_installation = true,
      }
    end,
  },

  {
    'neovim/nvim-lspconfig',
    config = function()
      -- Use an on_attach function to only map the following keys
      -- after the language server attaches to the current buffer

      -- require'lspconfig'.nim_langserver.setup{
      --   on_attach = on_attach,
      -- }
      --

      local lspconfig = require 'lspconfig'

      -- lspconfig.ccls.setup {
      --   on_attach = on_attach,
      --   init_options = {
      --     compilationDatabaseDirectory = "build";
      --     index = {
      --       threads = 0;
      --     };
      --     clang = {
      --       excludeArgs = { "-frounding-math"} ;
      --     };
      --   }
      -- }

      lspconfig.crystalline.setup {
        on_attach = function(client, bufnr)
          client.server_capabilities.completionProvider = false
          on_attach(client, bufnr)
        end
      }

      lspconfig.tsserver.setup {
        on_attach = on_attach,
      }

      lspconfig.nimls.setup {
        on_attach = on_attach,
      }

      lspconfig.pyright.setup {
        on_attach = on_attach,
      }

      lspconfig.lua_ls.setup {
        on_attach = on_attach,
        handlers = {
          ['textDocument/definition'] = function(err, result, ctx, config)
            if type(result) == 'table' then result = { result[1] } end
            vim.lsp.handlers['textDocument/definition'](err, result, ctx, config)
          end,
        },
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
              version = 'LuaJIT',
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { 'vim' },
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

      lspconfig.sourcekit.setup {
        on_attach = on_attach,
        capabilities = completion_capabilities,
        -- cmd = { "sourcekit-lsp" },
        filetypes = { "swift", "objective-c", "objective-cpp" },
        -- root_dir = lsp_config.util.root_pattern("Package.swift", ".git", "*.xcodeproj")
      }
    end
  },
  {
    'ranjithshegde/ccls.nvim',
    config = function()
      local util = require "lspconfig.util"
      local server_config = {
        filetypes = { "c", "cpp", "objc", "objcpp", "opencl" },
        root_dir = function(fname)
          return util.root_pattern("compile_commands.json", "compile_flags.txt", ".git")(fname)
              or util.find_git_ancestor(fname)
        end,
        init_options = {
          cache = {
            directory = vim.fs.normalize "~/.cache/ccls"
            -- or vim.fs.normalize "~/.cache/ccls" -- if on nvim 0.8 or higher
          }
        },
        on_attach = on_attach,
        capabilities = completion_capabilities,
      }
      require("ccls").setup { lsp = { lspconfig = server_config } }
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
        -- symbol_in_winbar = {
        --   enable = false,
        -- },
        finder = {
          max_height = 0.6,
          keys = {
            vsplit = 'v'
          }
        }
      })

      vim.keymap.set("n", "gp", "<cmd>Lspsaga peek_definition<CR>", { noremap = true })
      vim.keymap.set("n", "ga", "<cmd>Lspsaga peek_definition<CR>", { noremap = true })
      vim.keymap.set("n", "tr", "<cmd>Lspsaga rename<CR>", { noremap = true })



      local keymap = vim.keymap.set

      -- LSP finder - Find the symbol's definition
      -- If there is no definition, it will instead be hidden
      -- When you use an action in finder like "open vsplit",
      -- you can use <C-t> to jump back
      -- keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>")

      -- Code action
      keymap({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>")

      -- -- Rename all occurrences of the hovered word for the entire file
      -- keymap("n", "gr", "<cmd>Lspsaga rename<CR>")

      -- -- Rename all occurrences of the hovered word for the selected files
      -- keymap("n", "gr", "<cmd>Lspsaga rename ++project<CR>")

      -- Peek definition
      -- You can edit the file containing the definition in the floating window
      -- It also supports open/vsplit/etc operations, do refer to "definition_action_keys"
      -- It also supports tagstack
      -- Use <C-t> to jump back
      keymap("n", "gp", "<cmd>Lspsaga peek_definition<CR>")

      -- Go to definition
      keymap("n", "gd", "<cmd>Lspsaga goto_definition<CR>")

      -- Peek type definition
      -- You can edit the file containing the type definition in the floating window
      -- It also supports open/vsplit/etc operations, do refer to "definition_action_keys"
      -- -- It also supports tagstack
      -- -- Use <C-t> to jump back
      -- keymap("n", "gt", "<cmd>Lspsaga peek_type_definition<CR>")

      -- -- Go to type definition
      -- keymap("n","gt", "<cmd>Lspsaga goto_type_definition<CR>")


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
      keymap("n", "<leader>o", "<cmd>Lspsaga outline<CR>")


      -- Call hierarchy
      keymap("n", "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>")
      keymap("n", "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>")

      -- Floating terminal
      keymap({ "n", "t" }, "<A-d>", "<cmd>Lspsaga term_toggle<CR>")
    end,

    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      --Please make sure you install markdown and markdown_inline parser
      { "nvim-treesitter/nvim-treesitter" }
    }
  },

  -- {
  --   'stevearc/conform.nvim',
  --   config = function()
  --     local conform = require("conform")

  --     conform.setup({
  --       formatters_by_ft = {
  --         swift = { "swiftformat" },
  --       },
  --       format_on_save = function(bufnr)
  --         return { timeout_ms = 500, lsp_fallback = true }
  --       end,
  --       log_level = vim.log.levels.ERROR,
  --     })

  --     vim.keymap.set({ "n", "v" }, "<Space>", function()
  --       conform.format({
  --         lsp_fallback = true,
  --         async = false,
  --         timeout_ms = 500,
  --       })
  --     end, { desc = "Format file or range (in visual mode)" })
  --   end
  -- },
}
