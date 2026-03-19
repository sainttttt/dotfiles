return {
  {
    "yousefhadder/markdown-plus.nvim",
    ft = "markdown",
    config = function()
      require("markdown-plus").setup()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          vim.keymap.set("n", ",", function()
            vim.cmd("normal! O")  -- the ! means no remaps
          end
            , { buffer = true, noremap = true })
        end,
      })
    end
  },

  --_ { 'ixru/nvim-markdown',
  --_   config = function()
  --_     vim.cmd [[
  --_       let g:vim_markdown_conceal = 0
  --_       let g:vim_markdown_no_default_key_mappings = 1
  --_       ]]
  --_
  --_     vim.api.nvim_create_autocmd("FileType", {
  --_       pattern = "markdown",
  --_       callback = function()
  --_         local buffer = vim.api.nvim_get_current_buf()
  --_         vim.keymap.set({"n"}, "o",
  --_           function()
  --_             vim.api.nvim_feedkeys(
  --_               vim.api.nvim_replace_termcodes("<Plug>Markdown_NewLineBelow",
  --_                 true, false, true), "n", false
  --_             )
  --_           end,
  --_           {buffer = buffer, silent = false, noremap = true})
  --_
  --_         vim.keymap.set({"i"}, "<CR>",
  --_           function()
  --_             vim.api.nvim_feedkeys(
  --_               vim.api.nvim_replace_termcodes("<Plug>Markdown_NewLineBelow",
  --_                 true, false, true), "i", false
  --_             )
  --_           end,
  --_           {buffer = buffer, silent = false, noremap = true})
  --_
  --_         --_ vim.keymap.set({"n"}, "O",
  --_         --_   function()
  --_         --_     vim.api.nvim_feedkeys(
  --_         --_       vim.api.nvim_replace_termcodes("<Plug>Markdown_NewLineAbove",
  --_         --_         true, false, true), "n", false
  --_         --_     )
  --_         --_   end,
  --_         --_   {buffer = buffer, silent = false, noremap = true})
  --_       end,
  --_     })
  --_   end,
  --_ },

  --_ { "epwalsh/obsidian.nvim",
  --_   lazy = false,
  --_   event = {
  --_     -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --_     -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
  --_     "BufReadPre " .. vim.fn.expand "~" .. "/Library/Mobile Documents/iCloud~md~obsidian/Documents/Katarina/**.md",
  --_     "BufNewFile " .. vim.fn.expand "~" .. "/Library/Mobile Documents/iCloud~md~obsidian/Documents/Katarina/**.md",
  --_   },
  --_   dependencies = {
  --_     "nvim-lua/plenary.nvim",
  --_   },
  --_   config = function()
  --_     local path = vim.fn.expand "~" .. "/Library/Mobile Documents/iCloud~md~obsidian/Documents/Katarina/"
  --_     vim.keymap.set('n', '<Leader>.', ":ObsidianNew ")
  --_     require("obsidian").setup {
  --_       dir = path,
  --_       note_id_func = function(title)
  --_         return title
  --_       end,
  --_       disable_frontmatter = true,
  --_       ui = {
  --_         enable = false,
  --_       },
  --_       finder = "fzf-lua",
  --_       mappings = {
  --_         ["gd"] = {
  --_           action = function()
  --_             return require("obsidian").util.gf_passthrough()
  --_           end,
  --_           opts = { noremap = false, expr = true, buffer = true },
  --_         },
  --_       },
  --_     }
  --_     vim.keymap.set("n", "gd", function()
  --_       if require("obsidian").util.cursor_on_markdown_link() then
  --_         return "<cmd>ObsidianFollowLink<CR>"
  --_       else
  --_         return "gd"
  --_       end
  --_     end, { noremap = false, expr = true })
  --_   end
  --_ },

  --_ { _   "tadmccorkle/markdown.nvim",
  --_   ft = "markdown", -- or 'event = "VeryLazy"'
  --_   dependencies = {
  --_     "nvim-treesitter/nvim-treesitter",
  --_   },
  --_   opts = {
  --_     -- configuration here or empty for defaults
  --_     on_attach = function(bufnr)
  --_       local map = vim.keymap.set
  --_       local opts = { buffer = bufnr }
  --_       map({ 'n', }, 'o', '<Cmd>MDListItemBelow<CR>', opts)
  --_       map({ 'n', }, 'O', '<Cmd>MDListItemAbove<CR>', opts)
  --_
  --_     end,
  --_   },
  --_
  --_ },

  --_   Your other plugins
  --_   {
  --_       'jakewvincent/mkdnflow.nvim',
  --_       config = function()
  --_           require('mkdnflow').setup({
  --_               -- Config goes here; leave blank for defaults
  --_           })
  --_       end
  --_   },
  --_
  --_ {
  --_   "tadmccorkle/markdown.nvim",
  --_   ft = "markdown", -- or 'event = "VeryLazy"'
  --_   opts = {
  --_     -- configuration here or empty for defaults
  --_   },
  --_ },

}
