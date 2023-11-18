local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

return
  {
    -- { "junegunn/fzf", build = ":call fzf#install()" },
    -- {
    --     "linrongbin16/fzfx.nvim",
    --     dependencies = { "junegunn/fzf" },
    --     config = function()
    --         require("fzfx").setup()
    --     end
    -- },

    {
      "ibhagwan/fzf-lua",
      -- optional for icon support
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        local actions = require('fzf-lua.actions')
        -- calling `setup` is optional for customization
        require("fzf-lua").setup({

          winopts = {

            on_create = function()
              -- called once upon creation of the fzf main window
              -- can be used to add custom fzf-lua mappings, e.g:
              vim.keymap.set("t", "<C-j>", "<Down>", { silent = true, buffer = true })
              vim.keymap.set("t", "<C-k>", "<Up>", { silent = true, buffer = true })
              vim.keymap.set("n", "<esc>", "<C-w>h", { silent = true, buffer = true })
              vim.keymap.set("t", "`", "<C-c>", { silent = true, buffer = true })
              vim.keymap.set("t", "1", "<C-c>", { silent = true, buffer = true })
              vim.keymap.set("t", "<Tab>", "<C-c>", { silent = true, buffer = true })
              vim.keymap.set("t", "<esc>", "<C-c>", { silent = true, buffer = true })
            end,
          },

          fzf_opts = {
            -- options are sent as `<left>=<right>`
            -- set to `false` to remove a flag
            -- set to '' for a non-value flag
            -- for raw args use `fzf_args` instead
            ['--ansi']        = '',
            ['--info']        = 'inline',
            ['--height']      = '100%',
            ['--layout']      = 'default',
            ['--border']      = 'none',
            ['--bind']      = 'change:top',
            ["--prompt"]      = '† >'
          },
          keymap     = {
            fzf = {
              ["ctrl-u"] = "last",
              ["ctrl-y"] = "first",
              ["ctrl-h"] = "half-page-up",
              ["ctrl-l"] = "half-page-down",
            },
          },

        })
        local fzf_lua = require'fzf-lua'
        vim.keymap.set("n", "t", function() fzf_lua.files() end)
        vim.keymap.set("n", "<leader>vc", function() fzf_lua.live_grep({cwd="~/.config/nvim" }) end)
        vim.keymap.set("n", "<leader>vx", function() fzf_lua.files({cwd="~/.config/nvim" }) end)
        vim.keymap.set("n", "<leader>fg", function() fzf_lua.live_grep() end)
        vim.keymap.set("n", "<leader>fw", function() fzf_lua.grep_cword() end)
        vim.keymap.set("n", "<leader>ff", function() fzf_lua.resume() end)
        vim.keymap.set("n", "gr", function() fzf_lua.lsp_references() end)
        vim.keymap.set("n", "1", function() fzf_lua.buffers() end)

                -- :lua require'fzf-lua'.files({ prompt="LS> ", cmd = "ls", cwd="~/<folder>" })
      end
    },


    -- {'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' },
    {
      "folke/trouble.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      opts = {
        -- position = "bo",
        height = 24,
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      },
    },
    {
      'nvim-telescope/telescope.nvim', tag = '0.1.1',
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = function()

        -- vim.keymap.set("n", "<leader>fd", function()

        -- require("telescope.builtin").lsp_document_symbols({
        --     symbols = {'struct',
        --       'function',
        --     }
        --   })

        -- end, {})

        vim.api.nvim_set_keymap("n", "<leader>og", [[<cmd>Telescope live_grep<cr>]], {})
        -- vim.api.nvim_set_keymap("n", "<leader>ff", [[<cmd>Telescope resume<cr>]], {})
        vim.api.nvim_set_keymap("n", "<leader>of", [[<cmd>Telescope find_files<cr>]], {})

        -- vim.api.nvim_set_keymap("n", "<leader>fb", [[<cmd>Telescope buffers<cr>]], {})
        -- vim.api.nvim_set_keymap("n", "<leader>fw", [[<cmd>Telescope grep_string<cr>]], {})
        -- vim.api.nvim_set_keymap("n", "<M-U>", [[<cmd>Telescope grep_string<cr>]], {})
        -- vim.api.nvim_set_keymap("n", "<M-u>", [[<cmd>Telescope grep_string<cr>]], {})

        -- vim.api.nvim_set_keymap("n", "<M-i>", [[<cmd>Telescope resume<cr>]], {})
        -- vim.api.nvim_set_keymap("n", "<M-I>", [[<cmd>Telescope resume<cr>]], {})
        -- vim.api.nvim_set_keymap("n", "<leader>vx", [[<cmd>lua require("telescope.builtin").find_files({cwd = "~/.config/nvim/"})<CR>]], {})
        -- vim.api.nvim_set_keymap("n", "<leader>vc", [[<cmd>lua require("telescope.builtin").live_grep({cwd = "~/.config/nvim/"})<CR>]], {})

        -- vim.api.nvim_set_keymap("n", "`", [[<cmd>Telescope find_files<cr>]], {})
        -- vim.api.nvim_set_keymap("n", "1", [[<cmd>Telescope buffers<cr>]], {})

        -- require('telescope').load_extension('fzf')
        local trouble = require("trouble.providers.telescope")
        local actions = require('telescope.actions')

        require("telescope").setup {
          defaults = {
            file_ignore_patterns = {
              "build",
              "xcodeproj",
              "xcassets",
            },
            mappings = {
              i = {
                -- ["<c-e>"] = trouble.open_with_trouble,
                ["<C-j>"] = actions.move_selection_next,
                -- ["<C-x>"] = actions.exclude,
                ["<C-k>"] = actions.move_selection_previous,
                ["`"] = actions.close,
                ["1"] = actions.close,
                ["!"] = function() feedkey("1", "n") end
              },
              n = {
                [";"] = trouble.open_with_trouble
              },
            },
          },
          pickers = {
            buffers = {
              ignore_current_buffer = true,
              sort_lastused = true,
            },
          },
        }
      end
    },
  }
