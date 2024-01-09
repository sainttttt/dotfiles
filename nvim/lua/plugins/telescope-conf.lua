local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

return
  {
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

          preview = {
            -- default     = 'bat',           -- override the default previewer?
            -- default uses the 'builtin' previewer
            border         = 'border',        -- border|noborder, applies only to
            -- native fzf previewers (bat/cat/git/etc)
            wrap           = 'nowrap',        -- wrap|nowrap
            hidden         = 'nohidden',      -- hidden|nohidden
            vertical       = 'down:45%',      -- up|down:size
            horizontal     = 'right:70%',     -- right|left:size
            layout         = 'flex',          -- horizontal|vertical|flex
            flip_columns   = 120,             -- #cols to switch to horizontal on flex
            -- Only used with the builtin previewer:
            title          = true,            -- preview border title (file/buf)?
            title_align    = "left",          -- left|center|right, title alignment
            scrollbar      = 'float',         -- `false` or string:'float|border'
            -- float:  in-window floating border
            -- border: in-border chars (see below)
            scrolloff      = '-2',            -- float scrollbar offset from right
            -- applies only when scrollbar = 'float'
            scrollchars    = {'█', '' },      -- scrollbar chars ({ <full>, <empty> }
            -- applies only when scrollbar = 'border'
            delay          = 100,             -- delay(ms) displaying the preview
            -- prevents lag on fast scrolling
            winopts = {                       -- builtin previewer window options
              number            = true,
              relativenumber    = false,
              cursorline        = true,
              cursorlineopt     = 'both',
              cursorcolumn      = false,
              signcolumn        = 'no',
              list              = false,
              foldenable        = false,
              foldmethod        = 'manual',
            },
          },



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
            -- ['--keep-right']  = '',
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

          grep = {
            prompt            = 'Rg❯ ',
            input_prompt      = 'Grep For❯ ',
            multiprocess      = true,           -- run command in a separate process
            git_icons         = true,           -- show git icons?
            file_icons        = true,           -- show file icons?
            color_icons       = true,           -- colorize file|git icons
            -- executed command priority is 'cmd' (if exists)
            -- otherwise auto-detect prioritizes `rg` over `grep`
            -- default options are controlled by 'rg|grep_opts'
            -- cmd            = "rg --vimgrep",
            grep_opts         = "--binary-files=without-match --line-number --recursive --color=auto --perl-regexp -e",
            -- rg_opts           = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e | cut -d':' -f1-2 ",
            -- set to 'true' to always parse globs in both 'grep' and 'live_grep'
            -- search strings will be split using the 'glob_separator' and translated
            -- to '--iglob=' arguments, requires 'rg'
            -- can still be used when 'false' by calling 'live_grep_glob' directly
            rg_glob           = false,        -- default to glob parsing?
            glob_flag         = "--iglob",    -- for case sensitive globs use '--glob'
            glob_separator    = "%s%-%-",     -- query separator pattern (lua): ' --'
            -- advanced usage: for custom argument parsing define
            -- 'rg_glob_fn' to return a pair:
            --   first returned argument is the new search query
            --   second returned argument are addtional rg flags
            -- rg_glob_fn = function(query, opts)
            --   ...
            --   return new_query, flags
            -- end,
            actions = {
              -- actions inherit from 'actions.files' and merge
              -- this action toggles between 'grep' and 'live_grep'
              ["ctrl-g"]      = { actions.grep_lgrep }
            },
            no_header             = false,    -- hide grep|cwd header?
            no_header_i           = false,    -- hide interactive header?
          },


        })
        local fzf_lua = require'fzf-lua'
        vim.keymap.set("n", "af", function() fzf_lua.files() end)
        vim.keymap.set("n", "<leader>vc", function() fzf_lua.live_grep({cwd="~/.config/nvim" }) end)
        vim.keymap.set("n", "<leader>vx", function() fzf_lua.files({cwd="~/.config/nvim" }) end)
        vim.keymap.set("n", "<leader>fg", function() fzf_lua.live_grep({ cmd = "rg2() { rg  --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e  \"$@\" | cut -d':' -f1-2; }; rg2" }) end)
        -- vim.keymap.set("n", "<leader>dg", function() fzf_lua.live_grep() end)
        vim.keymap.set("n", "<leader>fw", function() fzf_lua.grep_cword() end)
        vim.keymap.set("n", "gt", function() fzf_lua.resume() end)
        vim.keymap.set("n", "<c-g>", function() fzf_lua.resume() end)
        vim.keymap.set("n", "gr", function() fzf_lua.lsp_references() end)
        vim.keymap.set("n", "1", function() fzf_lua.buffers(({fzf_opts={["--delimiter"]="' '",["--with-nth"]="-1.."}})) end)

                -- :lua require'fzf-lua'.files({ prompt="LS> ", cmd = "ls", cwd="~/<folder>" })
      end
    },


    {'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' },

    {'nvim-telescope/telescope-fzy-native.nvim'},
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

        -- vim.api.nvim_set_keymap("n", "<leader>fg", [[<cmd>Telescope live_grep<cr>]], {})
        vim.api.nvim_set_keymap("n", "<leader>dg", [[<cmd>Telescope live_grep previewer=false<cr>]], {})
        vim.api.nvim_set_keymap("n", "<leader>df", [[<cmd>Telescope live_grep<cr>]], {})
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
        require('telescope').load_extension('fzy_native')
        -- require('telescope').load_extension('fzf')
      end
    },
  }
