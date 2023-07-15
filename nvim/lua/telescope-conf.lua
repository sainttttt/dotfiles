
-- " Find files using Telescope command-line sugar.
-- nnoremap <leader>ff <cmd>Telescope resume<cr>
-- nnoremap <leader>fg <cmd>Telescope live_grep<cr>
-- nnoremap <leader>fr <cmd>Telescope lsp_incoming_calls<cr>
-- nnoremap <leader>fb <cmd>Telescope buffers<cr>
-- nnoremap <leader>fh <cmd>Telescope help_tags<cr>
-- nnoremap <leader>fw <cmd>Telescope grep_string<cr>


vim.api.nvim_set_keymap("n", "<leader>fg", [[<cmd>Telescope live_grep<cr>]], {})
vim.api.nvim_set_keymap("n", "<leader>ff", [[<cmd>Telescope resume<cr>]], {})
vim.api.nvim_set_keymap("n", "<leader>fv", [[<cmd>Telescope find_files<cr>]], {})
vim.api.nvim_set_keymap("n", "<leader>fb", [[<cmd>Telescope buffers<cr>]], {})
vim.api.nvim_set_keymap("n", "<leader>fw", [[<cmd>Telescope grep_string<cr>]], {})
vim.api.nvim_set_keymap("n", "<M-U>", [[<cmd>Telescope grep_string<cr>]], {})
vim.api.nvim_set_keymap("n", "<M-u>", [[<cmd>Telescope grep_string<cr>]], {})

vim.api.nvim_set_keymap("n", "<M-i>", [[<cmd>Telescope resume<cr>]], {})
vim.api.nvim_set_keymap("n", "<M-I>", [[<cmd>Telescope resume<cr>]], {})

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
        ["<c-e>"] = trouble.open_with_trouble,
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
