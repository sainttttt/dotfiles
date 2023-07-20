return
{
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

      vim.api.nvim_set_keymap("n", "<leader>fg", [[<cmd>Telescope live_grep<cr>]], {})
      vim.api.nvim_set_keymap("n", "<leader>ff", [[<cmd>Telescope resume<cr>]], {})
      vim.api.nvim_set_keymap("n", "<leader>fv", [[<cmd>Telescope find_files<cr>]], {})
      vim.api.nvim_set_keymap("n", "<leader>fb", [[<cmd>Telescope buffers<cr>]], {})
      vim.api.nvim_set_keymap("n", "<leader>fw", [[<cmd>Telescope grep_string<cr>]], {})
      vim.api.nvim_set_keymap("n", "<M-U>", [[<cmd>Telescope grep_string<cr>]], {})
      vim.api.nvim_set_keymap("n", "<M-u>", [[<cmd>Telescope grep_string<cr>]], {})

      vim.api.nvim_set_keymap("n", "<M-i>", [[<cmd>Telescope resume<cr>]], {})
      vim.api.nvim_set_keymap("n", "<M-I>", [[<cmd>Telescope resume<cr>]], {})
      vim.api.nvim_set_keymap("n", "<leader>vx", [[<cmd>lua require("telescope.builtin").find_files({cwd = "~/.config/nvim/"})<CR>]], {})
      vim.api.nvim_set_keymap("n", "<leader>vc", [[<cmd>lua require("telescope.builtin").live_grep({cwd = "~/.config/nvim/"})<CR>]], {})

-- lua require("telescope.builtin").find_files({cwd = "~/.config/nvim/"})
      vim.api.nvim_set_keymap("n", "`", [[<cmd>Telescope find_files<cr>]], {})
      vim.api.nvim_set_keymap("n", "<Tab>", [[<cmd>Telescope buffers<cr>]], {})

      require('telescope').load_extension('fzf')
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
              ["<C-x>"] = actions.exclude,
              ["<C-k>"] = actions.move_selection_previous
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
  {'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' },
}
