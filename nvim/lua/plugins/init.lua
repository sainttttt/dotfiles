return {
  git = {
    -- defaults for the `Lazy log` command
    -- log = { "-10" }, -- show the last 10 commits
    log = { "--since=3 days ago" }, -- show commits from the last 3 days
timeout = 10000,                -- kill processes that take more than 2 minutes
    url_format = "https://github.com/%s.git",
    -- lazy.nvim requires git >=2.19.0. If you really want to use lazy with an older version,
    -- then set the below to false. This should work, but is NOT supported and will
    -- increase downloads a lot.
    filter = true,
  },

  install = {
    -- install missing plugins on startup. This doesn't increase startup time.
    missing = true,
    -- try to load one of these colorschemes when starting an installation during startup
    colorscheme = { "flesh-and-blood" },
  },

  -- † plugins † ----------------------------------------------
  --

{
    'nullromo/go-up.nvim',
    opts = {}, -- specify options here
    config = function(_, opts)
        local goUp = require('go-up')
        goUp.setup(opts)
    end,
},

  {'NlGHT/vim-eel',
    config = function()
      vim.cmd([[autocmd BufNewFile,BufRead *.jsfx :set filetype=eel2]])
    end

  },

  { 'gbprod/yanky.nvim',
    config = function()
      require("yanky").setup({
        highlight = {
          on_put = true,
          on_yank = true,
          timer = 300,
        },
      })
      -- Configuration for gbprod/yanky.nvim
      vim.keymap.set({"n"}, "p", "<Plug>(YankyPutAfter)")
      vim.keymap.set({"n"}, "P", "<Plug>(YankyPutBefore)")

      vim.keymap.set("n", "zp", "<Plug>(YankyPreviousEntry)")
      vim.keymap.set("n", "zo", "<Plug>(YankyNextEntry)")
    end
  },

  { 'nvim-tree/nvim-tree.lua',
    config = function()
      local show_tree = function()
        local nvimtree = require 'nvim-tree.view'
        if not nvimtree.is_visible() then
          vim.cmd("NvimTreeFindFile")
        else
          vim.cmd("NvimTreeClose")
        end
      end

      vim.keymap.set('n', '<C-a>', show_tree)
      vim.keymap.set('n', '<D-a>', show_tree)

      local HEIGHT_RATIO = 0.5 -- You can change this
      local WIDTH_RATIO = 0.2  -- You can change this too
      require("nvim-tree").setup({
        on_attach = function(bufnr)
          local api = require('nvim-tree.api')
          vim.keymap.set('n', 's', api.node.open.vertical, { buffer = bufnr })
          vim.keymap.set('n', 'aa', api.fs.create, { buffer = bufnr })
          vim.keymap.set('n', '<C-v>', api.node.open.vertical, { buffer = bufnr })
          vim.keymap.set('n', '<C-v>', api.node.open.vertical, { buffer = bufnr })
          vim.keymap.set('n', '<CR>', api.node.open.edit, { buffer = bufnr })
          vim.keymap.set('n', 'l', api.node.open.edit, { buffer = bufnr })
          vim.keymap.set('n', 'h', api.node.navigate.parent_close, { buffer = bufnr })
          vim.keymap.set('n', 'o', api.tree.change_root_to_node, { buffer = bufnr })
          vim.keymap.set('n', 'D', api.fs.trash, { buffer = bufnr })
          vim.keymap.set('n', 'M', api.fs.rename, { buffer = bufnr })
        end,
        actions = {
          open_file = {
            window_picker = {
              enable = false
            }
          }
        },
        filters = {
          dotfiles = true,
        },
        view = {
          relativenumber = true,
          float = {
            enable = false,
            open_win_config = function()
              local screen_w = vim.opt.columns:get()
              local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
              local window_w = screen_w * WIDTH_RATIO
              local window_h = screen_h * HEIGHT_RATIO
              local window_w_int = math.floor(window_w)
              local window_h_int = math.floor(window_h)
              local center_x = (screen_w - window_w) / 2
              local center_y = ((vim.opt.lines:get() - window_h) / 2)
              - vim.opt.cmdheight:get()
              return {
                border = "rounded",
                relative = "editor",
                row = center_y,
                col = center_x,
                width = window_w_int,
                height = window_h_int,
              }
            end,
          },
          width = function()
            return math.max(35, math.floor(vim.opt.columns:get() * WIDTH_RATIO))
          end,
        },
        renderer = {
          icons = {
            show = {
              file = false
            }
          }
        }

      })
    end
  },




  {
    "dgox16/devicon-colorscheme.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("devicon-colorscheme").setup({
        colors = {
          blue = "#92a2d5",
          cyan = "#85b5ba",
          green = "#000000",
          magenta = "#e29eca",
          orange = "#f5a191",
          purple = "#aca1cf",
          red = "#ea83a5",
          white = "#c9c7cd",
          yellow = "#ea83a5",
          bright_blue = "#000000",
          bright_cyan = "#99c9ce",
          bright_green = "#9dc6ac",
          bright_magenta = "#ecaad6",
          bright_orange = "#ffae9f",
          bright_purple = "#b9aeda",
          bright_red = "#f591b2",
          bright_yellow = "#ea83a5",
        },
      })
      require("fzf-lua.devicons").unload()
    end
  },

  {
    "cbochs/grapple.nvim",
    dependencies = {
      { "nvim-tree/nvim-web-devicons", lazy = true }
    },
    config = function()
      vim.keymap.set("n", "<leader>m", require("grapple").toggle)
      vim.keymap.set("n", "<leader>M", require("grapple").toggle_tags)

      -- User command
      vim.keymap.set("n", "<leader>2", "<cmd>Grapple select index=1<cr>")
      vim.keymap.set("n", "<leader>3", "<cmd>Grapple select index=2<cr>")
      vim.keymap.set("n", "<leader>4", "<cmd>Grapple select index=3<cr>")
      vim.keymap.set("n", "<leader>5", "<cmd>Grapple select index=4<cr>")
    end
  },


  { "debugloop/telescope-undo.nvim",
    dependencies = { -- note how they're inverted to above example
      {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
      },
    },
    keys = {
      { -- lazy style key map
        "<leader>e",
        "<cmd>Telescope undo<cr>",
        desc = "undo history",
      },
    },
    opts = {
      -- don't use `defaults = { }` here, do this in the main telescope spec
      extensions = {
        undo = {
          -- telescope-undo.nvim config, see below
          saved_only = true,
        },
        -- no other extensions here, they can have their own spec too
      },
    },
    config = function(_, opts)
      -- Calling telescope's setup from multiple specs does not hurt, it will happily merge the
      -- configs for us. We won't use data, as everything is in it's own namespace (telescope
      -- defaults, as well as each extension).
      require("telescope").setup(opts)
      require("telescope").load_extension("undo")
    end,
  },

  -- { "ThePrimeagen/harpoon",
  --   branch = "harpoon2",
  --   dependencies = { "nvim-lua/plenary.nvim" },
  --   config = function()
  --   end
  -- },

  { "lukas-reineke/headlines.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = true, -- or `opts = {}`
  },

  { 'NStefan002/screenkey.nvim',
    config = function()
    end
  },


  { 'yssl/QFEnter',
    config = function()
      vim.cmd([[
      let g:qfenter_keymap = {}
      let g:qfenter_keymap.vopen = ['<CR>', '<2-LeftMouse>']
      ]])
    end
  },


  { 'romainl/vim-qf',
    config = function()
      -- Configuration for romainl/vim-qf
      --
      --
      vim.cmd([[
      augroup CustomQfMappings
      autocmd!
      autocmd FileType qf silent! unmap <buffer> <up>
      autocmd FileType qf silent! unmap <buffer> <down>
      autocmd FileType qf nmap <buffer> <up> <Plug>(qf_previous_file)
      autocmd FileType qf nmap <buffer> <down> <Plug>(qf_next_file)
      augroup END
      ]])
    end
  },

  { 'bloznelis/before.nvim',
    config = function()
      -- Configuration for bloznelis/before.nvim
      local before = require('before')
      before.setup()
      --
      vim.keymap.set('n', '<M-J>', function()
        before.jump_to_last_edit()
        vim.cmd("normal! zz")
      end, {})

      -- Jump to next entry in the edit history
      vim.keymap.set('n', '<M-Q>', function()
        before.jump_to_next_edit()
        vim.cmd("normal! zz")
      end, {})
    end
  },


  { 'rktjmp/lush.nvim',
    config = function()
      -- Configuration for rktjmp/lush.nvim
    end
  },

  { 'andymass/vim-matchup',
    config = function()
      -- need this to work correctly
      vim.cmd("map q %")
    end
  },

  { 'nmac427/guess-indent.nvim',
    config = function() require('guess-indent').setup {} end,
  },

  { 'nvim-pack/nvim-spectre',
    config = function()
      require("spectre").setup({
        replace_engine = {
          ["sed"] = {
            cmd = "sed",
            args = {
              "-i",
              "",
              "-E",
            },
          },
        },
      })

      vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', {
        desc = "Toggle Spectre"
      })

    end
  },

  { 'ixru/nvim-markdown',
    config = function()
      vim.cmd [[
        map <Plug> <Plug>Markdown_FollowLink
        map <Plug> <Plug>Markdown_Fold
        let g:vim_markdown_conceal = 0
        ]]
    end,
  },

  { 'BartSte/nvim-project-marks',
    lazy = false,
    config = function()
      require('projectmarks').setup({
        shadafile = '.vim/main.shada',
        mappings = false,
      })
    end
  },

  { 'echasnovski/mini.nvim',
    version = false,
    config = function()
      require('mini.trailspace').setup()
      vim.keymap.set('n', 'at', function()
        require('mini.trailspace').trim()
        require('mini.trailspace').trim_last_lines()
        vim.cmd('up')
      end
      )

      -- vim.keymap.set('n', '<leader>mll', MiniTrailspace.trim_last_lines)
      require('mini.splitjoin').setup()
      require('mini.align').setup()

      -- require('mini.comment').setup()

      require('mini.sessions').setup({
        autoread = true,
        autowrite = true,
        directory = "~/.local/share/nvim/sessions",
        verbose = { read = false, write = false, delete = false },

      })
    end
  },

  'tpope/vim-commentary',

  { "ariel-frischer/bmessages.nvim",
    config = function()
      require("bmessages").setup {}
      vim.keymap.set('n', '<leader>z', "<cmd>Bmessagesvs<CR>")
    end
  },


  -- 'wellle/context.vim',

  -- { "luckasRanarison/nvim-devdocs",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-telescope/telescope.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --   },
  --   opts = {
  --     dir_path = vim.fn.stdpath("data") .. "/devdocs", -- installation directory
  --     telescope = {}, -- passed to the telescope picker
  --     filetypes = {
  --       -- extends the filetype to docs mappings used by the `DevdocsOpenCurrent` command, the version doesn't have to be specified
  --       -- scss = "sass",
  --       -- javascript = { "node", "javascript" }
  --     },
  --     float_win = { -- passed to nvim_open_win(), see :h api-floatwin
  --       relative = "editor",
  --       height = 40,
  --       width = 100,
  --       border = "rounded",
  --     },
  --     wrap = false, -- text wrap, only applies to floating window
  --     previewer_cmd = "glow",
  --     cmd_args = {"-s", "dark", "-w", "80" },
  --     picker_cmd_args = { "-p"},
  --     cmd_args = {}, -- example using glow: { "-s", "dark", "-w", "80" }
  --     cmd_ignore = {}, -- ignore cmd rendering for the listed docs
  --     mappings = { -- keymaps for the doc buffer
  --       open_in_browser = ""
  --     },
  --     ensure_installed = {}, -- get automatically installed
  --     after_open = function(bufnr) end, -- callback that runs after the Devdocs window is opened. Devdocs buffer ID will be passed in
  --   }
  -- },

  -- allows you to open nvim from cmdline with line number
  -- {'wsdjeg/vim-fetch'},

  { 'sainttttt/flesh-and-blood',
    -- dir = "~/code/flesh-and-blood",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme flesh-and-blood]])
    end
  },

  -- { dir = "~/code/portion.vim",
  --   config = function()
  --     require('portion').setup({
  --       ratio = 0.4
  --     })
  --   end
  --   },

  -- { 'sainttttt/portion.vim',
  --   config = function()
  --     require('portion').setup({
  --       ratio = 0.4
  --     })
  --   end
  -- },

  {
    -- dir = "~/code/yoke.vim",
    'sainttttt/yoke.vim',
    config = function()
      require('yoke').setup()
    end
  },

  { "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        keymaps = {
          insert = "<C-g>s",
          insert_line = "<C-g>S",
          normal = "ys",
          normal_cur = "yss",
          normal_line = "yS",
          normal_cur_line = "ySS",
          visual = "S",
          visual_line = "gS",
          delete = "dos",
          change = "<leader>cs",
          change_line = "<leader>cS",
        },
        -- Configuration here, or leave empty to use defaults
      })
      vim.cmd([[
      map zh ysiw'
      map zj ysiw"
      map zk ysiw(
      map zl ysiw[

      map zxh dos'
      map zxj dos"
      map zxk dos(
      map zxl dos[
      ]])
    end
  },


  { 'altermo/ultimate-autopair.nvim',
    event = { 'InsertEnter', 'CmdlineEnter' },
    branch = 'v0.6', --recomended as each new version will have breaking changes
    config = function()
      require 'nvim-treesitter.configs'.setup {}
      require('ultimate-autopair').setup {}
      local pair = [[([{"`']]
      local end_pair = [[)]}"`']] .. '\29'
      local pair_insert
      local save = {}
      local group = vim.api.nvim_create_augroup('autopair', {})
      vim.api.nvim_create_autocmd('InsertCharPre', {
        callback = function()
          pair_insert = false
          for c in pair:gmatch '.' do
            if vim.v.char == c then
              local action = require 'ultimate-autopair.core'.run(c)
              if action == '\aU\x80kr' --[[this is dont-new-undo + <right>]] then
                vim.api.nvim_feedkeys(action, 'n', false)
                vim.v.char = ''
                save = {}
                return
              elseif #action > 2 then
                table.insert(save, action:sub(3))
                pair_insert = true
                return
              end
            end
          end
          if not save[1] then return end
          local nsave = save
          save = {}
          if end_pair:find(vim.v.char, 1, true) then return end
          vim.api.nvim_feedkeys(table.concat(nsave), 'n', false)
        end,
        group = group
      })
      vim.api.nvim_create_autocmd('CursorMovedI', {
        callback = function()
          if pair_insert then pair_insert=false return end
          save = {}
        end,
        group = group
      })
      vim.api.nvim_create_autocmd('ModeChanged', { callback = function() save = {} end, group = group })
      for c in pair:gmatch '.' do
        vim.keymap.del('i', c)
      end
    end
  },

  { 'ojroques/nvim-osc52',
    config = function()
      -- vim.keymap.set('n', '<c-y>', require('osc52').copy_operator, { expr = true })
      -- vim.keymap.set('v', '<c-y>', require('osc52').copy_visual)

      require('osc52').setup {
        max_length = 0,          -- Maximum length of selection (0 for no limit)
        silent = false,          -- Disable message on successful copy
        trim = false,            -- Trim surrounding whitespaces before copy
        tmux_passthrough = true, -- Use tmux passthrough (requires tmux: set -g allow-passthrough on)
      }
    end
  },

  { "epwalsh/obsidian.nvim",
    lazy = false,
    event = {
      -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
      -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
      "BufReadPre " .. vim.fn.expand "~" .. "/Library/Mobile Documents/iCloud~md~obsidian/Documents/Katarina/**.md",
      "BufNewFile " .. vim.fn.expand "~" .. "/Library/Mobile Documents/iCloud~md~obsidian/Documents/Katarina/**.md",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local path = vim.fn.expand "~" .. "/Library/Mobile Documents/iCloud~md~obsidian/Documents/Katarina/"
      vim.keymap.set('n', '<Leader>.', ":ObsidianNew ")
      require("obsidian").setup {
        dir = path,

        note_id_func = function(title)
          return title
        end,
        disable_frontmatter = true,

        ui = {
          enable = false,
        },
        finder = "fzf-lua",
        mappings = {
          ["gd"] = {
            action = function()
              return require("obsidian").util.gf_passthrough()
            end,
            opts = { noremap = false, expr = true, buffer = true },
          },
        },
      }
      vim.keymap.set("n", "gd", function()
        if require("obsidian").util.cursor_on_markdown_link() then
          return "<cmd>ObsidianFollowLink<CR>"
        else
          return "gd"
        end
      end, { noremap = false, expr = true })
    end
  },

  { 'tzachar/highlight-undo.nvim',
    config = function()
      require('highlight-undo').setup({
        duration = 500,
        undo = {
          hlgroup = 'HighlightUndo',
          mode = 'n',
          lhs = 'e',
          map = 'undo',
          opts = {}
        },
        redo = {
          hlgroup = 'HighlightUndo',
          mode = 'n',
          lhs = 'E',
          map = 'redo',
          opts = {}
        },
        highlight_for_count = true,
      })
      vim.cmd("map u <Nop>")
    end
  },

  { 'norcalli/nvim-colorizer.lua',
    config = function()
      require 'colorizer'.setup()
    end
  },

  { "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = { char = "│" },
      scope = { enabled = false },
    }
  },

  -- need this for nim comments apparently
  { 'alaviss/nim.nvim' },

  -- {"ericvw/vim-nim"},

  { 'jakemason/ouroboros',
    dependencies = { { 'nvim-lua/plenary.nvim' } },
    config = function()
      vim.cmd("autocmd! Filetype c,cpp noremap<buffer> 4 :Ouroboros<CR>")
    end
  },

  {
    "sainttttt/zen-mode.nvim",
    -- dir =  "~/code/zen-mode.nvim",
    -- "folke/zen-mode.nvim",
    config = function()
      local zenmode = require('zen-mode')

      vim.keymap.set('n', 'vf', function()
        vim.cmd("ZenMode")
        -- vim.cmd("TSContextDisable")
        -- vim.cmd("TSContextEnable")
        -- vim.cmd("redraw")
        -- vim.cmd("exec 'normal l'")
        -- vim.cmd("redraw")
      end)

      vim.keymap.set('n', '<C-h>', function()
        if vim.g.zen_opened then
          zenmode.close({amount = 'half'})
          vim.cmd([[exe "norm! \<C-w>h"]])
          zenmode.open({amount = 'half'})
        else
          vim.cmd([[exe "norm! \<C-w>h"]])
        end
      end)

      vim.keymap.set('n', '<C-t>', function()
        if vim.g.zen_opened then
          zenmode.close({amount = 'half'})
          vim.cmd([[exe "norm! \<C-w>l"]])
          zenmode.open({amount = 'half'})
        else
          vim.cmd([[exe "norm! \<C-w>l"]])
        end
      end)


      require('zen-mode').setup {
        window = {
          backdrop = 1, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
          -- height and width can be:
          -- * an absolute number of cells when > 1
          -- * a percentage of the width / height of the editor when <= 1
          -- * a function that returns the width or the height
          width = 120,   -- width of the Zen window
          height = 0.90, -- height of the Zen window
          -- by default, no options are changed for the Zen window
          -- uncomment any of the options below, or add other vim.wo options you want to apply
          options = {
            -- signcolumn = "no", -- disable signcolumn
            -- number = false, -- disable number column
            -- relativenumber = false, -- disable relative numbers
            -- cursorline = false, -- disable cursorline
            -- cursorcolumn = false, -- disable cursor column
            -- foldcolumn = "0", -- disable fold column
            -- list = false, -- disable whitespace characters
          },
        },

        plugins = {
          neovide = {
            enabled = true,
            scale = 1.0,
            disable_animations = {
              neovide_animation_length = 0,
              neovide_cursor_animate_command_line = false,
              neovide_scroll_animation_length = 0,
              neovide_position_animation_length = 0,
              neovide_fursor_animation_length = 1,
              neovide_cursor_vfx_mode = "",
            }
          },
        },

        -- callback where you can add custom code when the Zen window opens
        on_open = function(win)
          vim.g.zen_opened = true
          vim.cmd("setlocal winhl=Search:LocalSearch,IncSearch:LocalSearch")
        end,
        -- callback where you can add custom code when the Zen window closes
        on_close = function()
          vim.g.zen_opened = false
        end,
      }


    end
  },

  'tpope/vim-fugitive',

  { 'renerocksai/telekasten.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
      require('telekasten').setup({
        home = vim.fn.expand("~/zettelkasten"), -- Put the name of your notes directory here

        vaults = {
          cath = {
            -- configuration for personal vault. E.g.:
            home = vim.fn.expand("~/zettelkasten/cath"), -- Put the name of your notes directory here
          },
          prog = {
            -- configuration for personal vault. E.g.:
            home = vim.fn.expand("~/zettelkasten/prog"), -- Put the name of your notes directory here
          }
        },
      })

      vim.keymap.set('n', '<Leader>tt', "<cmd>Telekasten goto_today<CR>")
    end
  },

  { 'bkad/CamelCaseMotion' },

  -- { "HampusHauffman/block.nvim",
  --   config = function()
  --     require("block").setup({
  --       percent = 0.95,
  --       depth = 4,
  --       colors = nil,
  --       automatic = false,
  --       --      bg = nil,
  --       --      colors = {
  --       --          "#ff0000"
  --       --          "#00ff00"
  --       --          "#0000ff"
  --       --      },
  --     })
  --   end
  -- },

  -- { 'andymass/vim-matchup',
  --   config = function()
  --     -- vim.keymap.set('n', "q", vim.cmd("normal %"))
  --   end
  -- },

  -- { "utilyre/sentiment.nvim",
  --   version = "*",
  --   event = "VeryLazy", -- keep for lazy loading
  --   opts = {
  --     -- config
  --   },
  --   init = function()
  --     -- `matchparen.vim` needs to be disabled manually in case of lazy loading
  --     vim.g.loaded_matchparen = 1
  --   end,
  -- },

  'hood/popui.nvim',
  "sindrets/diffview.nvim",

  { "sainttttt/vim-searchx",
    -- dir = "~/code/vim-searchx",
    branch = "mod",
    config = function()
      vim.keymap.set({"n", "x"}, "f", "<cmd>call searchx#start({ 'dir': 1 })<CR>", { silent = true })
      vim.cmd([[
      let g:searchx = {}

      let g:context_enabled = 0
      let g:context_border_char = ''
      let g:context_highlight_normal = 'Context'
      let g:context_highlight_tag = '<hide>'

      " Auto jump if the recent input matches to any marker.
      let g:searchx.auto_accept = v:true

      " The scrolloff value for moving to next/prev.
      let g:searchx.scrolloff = &scrolloff

      " To enable scrolling animation.
      let g:searchx.scrolltime = 1

      " To enable auto nohlsearch after cursor is moved
      let g:searchx.nohlsearch = {}
      let g:searchx.nohlsearch.jump = v:true

      " Marker characters.
      let g:searchx.markers = split('FDSEWVCXRUIOPHJKLBNMTYGVB', '.\zs')

      function g:searchx.convert(input) abort
      " use two backticks to start regex mode
      " which is basically magic mode I believe in vim parlance
      if a:input[0:1] == '``'
      return '\m' .. a:input[2:]
      endif

      " otherwise turn off all regex stuff and search verbatim
      return '\V' .. a:input
      endfunction

      ]])
    end
  },

  'prichrd/netrw.nvim',

  { 'akinsho/toggleterm.nvim',
    config = function()
      require("toggleterm").setup({
        shell = vim.o.shell, -- change the default shell
        auto_scroll = true,  -- automatically scroll to the bottom on terminal output

        direction = 'float',
        start_in_insert = false,
        close_on_exit = false,

        on_open = function(term)
          vim.keymap.set('n', 'q', '<cmd>q<CR>', { silent = true, buffer = true })
          -- local opts = {buffer = 0}
          -- vim.keymap.set('t', '<esc>', [[<C-\><C-n>]])
        end,

        shading_factor = '0',

        -- size =  function(term)
        --   if term.direction == "horizontal" then
        --     return 30
        --   elseif term.direction == "vertical" then
        --     return vim.o.columns *  0.4
        --   end
        -- end,

        -- highlights = {
        --   -- highlights which map to a highlight group name and a table of it's values
        --   -- NOTE: this is only a subset of values, any group placed here will be set for the terminal window split
        --   Normal = {
        --     guibg = 'Normal'
        --   },
        --   NormalFloat = {
        --     link = 'Normal'
        --   },
        --   -- FloatBorder = {
        --   --   guifg = "<VALUE-HERE>",
        --   --   guibg = "<VALUE-HERE>",
        --   -- },
        -- },



      })

      function _G.TermToggle()
        local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })

        -- if ft == "swift" or ft == "xclog" then
        --   local logger = require "xbase.logger"
        --   logger.toggle()
        -- else
        if true then
          vim.cmd("ToggleTerm")
        end
      end

      -- note: have to check init.lua for another mapping if you want to change
      -- the termtoggle mapping key
      vim.keymap.set('n', '<m-Z>', TermToggle, { noremap = true, silent = false })

      local Terminal = require('toggleterm.terminal').Terminal
      local gitui    = Terminal:new({
        cmd = "gitui",
        -- hidden = true ,
        on_open = function(term)
          vim.cmd("startinsert!")
          -- vim.keymap.del('t', '<esc>')
        end,
        start_in_insert = true
      })

      function _gitui_toggle()
        gitui:toggle()
      end

      -- gh keyword for github
      vim.api.nvim_set_keymap("n", "gh", "<cmd>lua _gitui_toggle()<CR>", { noremap = true, silent = true })
    end
  },

  { 'haya14busa/vim-asterisk',
    config = function()
      -- I've reversed the # and * mappings because # is easier to press
      vim.keymap.set('n', '*', '<Plug>(asterisk-z#)', { noremap = true, silent = false })
      vim.keymap.set('n', '#', '<Plug>(asterisk-z*)', { noremap = true, silent = false })
      vim.keymap.set('n', 'g*', '<Plug>(asterisk-gz#)', { noremap = true, silent = false })
      vim.keymap.set('n', 'g#', '<Plug>(asterisk-gz*)', { noremap = true, silent = false })
      vim.g["asterisk#keeppos"] = 1
    end
  },


  'mfussenegger/nvim-lint',

  { 'CRAG666/code_runner.nvim',
    dependencies = 'nvim-lua/plenary.nvim',

    config = function()
      require('code_runner').setup({
        mode = "toggleterm",
        focus = false,
        startinsert = true,
        term = {
          position = "float",
          size = 50,
        },
        filetype_path = vim.fn.expand('~/.config/nvim/code_runner.json'),
        project_path = vim.fn.expand('~/.config/nvim/projects.json')
      })


      vim.keymap.set('n', '<leader>rf', ':RunFile<CR>', { noremap = true, silent = false })
      vim.keymap.set('n', '<leader>rp', ':RunProject<CR>', { noremap = true, silent = false })
      vim.keymap.set('n', '<leader>rc', ':RunClose<CR>', { noremap = true, silent = false })
    end
  },

  -- 'tpope/vim-scriptease',
  -- { 'JellyApple102/easyread.nvim' },
  'neovim/nvim-lspconfig',

  -- { 'sainttttt/xbase',
  --   build = 'make install', -- or "make install && make free_space" (not recommended, longer build time)
  --   dependencies = {
  --     "neovim/nvim-lspconfig",
  --     "nvim-telescope/telescope.nvim", -- optional
  --     "nvim-lua/plenary.nvim", -- optional/requirement of telescope.nvim
  --     -- "stevearc/dressing.nvim", -- optional (in case you don't use telescope but something else)
  --   },
  --   config = function()
  --     require'xbase'.setup({
  --       sourcekit = {
  --         on_attach = function(client, bufnr)
  --           -- Enable completion triggered by <c-x><c-o>
  --           vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  --           -- Mappings.
  --           -- See `:help vim.lsp.*` for documentation on any of the below functions
  --           local bufopts = { noremap=true, silent=true, buffer=bufnr }
  --           vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  --           vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  --           -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  --           vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  --           -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  --           vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  --         end
  --       },
  --       -- simctl = {
  --       --   iOS = {
  --       --     "iPhone 14"
  --       --   },
  --       --   watchOS = {}, -- all available devices
  --       --   tvOS = {}, -- all available devices
  --       -- },
  --       mappings = {
  --         --- Whether xbase mapping should be disabled.
  --         enable = true,
  --         --- Open build picker. showing targets and configuration.
  --         build_picker = "<leader>rt", --- set to 0 to disable
  --         --- Open run picker. showing targets, devices and configuration
  --         run_picker = "<leader>rf", --- set to 0 to disable
  --         --- Open watch picker. showing run or build, targets, devices and configuration
  --         watch_picker = "<leader>ry", --- set to 0 to disable
  --         --- A list of all the previous pickers
  --         all_picker = "<leader>re", --- set to 0 to disable
  --         --- horizontal toggle log buffer
  --         toggle_split_log_buffer = "<leader>ll",
  --         --- vertical toggle log buffer
  --         toggle_vsplit_log_buffer = "<leader>lp",
  --       },
  --     })

  --     function _G.XbaseBuildDefault()
  --       local xbase_proj = require("xbase.state").project_info
  --       local next = pairs(xbase_proj)
  --       local proj_root = next(xbase_proj)
  --       local logger = require "xbase.logger"

  --       local args = require('xbase.pickers.util').generate_entries(proj_root, 'Run')[1]
  --       local xbase = require("xbase.pickers.util")
  --       require('xbase.logger').clear() -- clear scrollback
  --       logger.open()
  --       xbase.run_command(args)
  --     end

  --     vim.api.nvim_set_keymap("n", "<M-r>", [[<cmd>lua XbaseBuildDefault()<cr>]], {})

  --   end
  -- },

  { "miversen33/sunglasses.nvim",
    config = {
      filter_type = "SHADE",
      filter_percent = .10,
    },

    event = "UIEnter"
  },

  { "RomanoZumbe/yanki.nvim",
    config = function()
      require("yanki").setup()
    end,
    lazy = false
  },


  { "sainttttt/lucy.nvim",
    -- dir = "~/code/lucy.nvim",
    config = function()
      local lucy = require("lucy")
      lucy.setup()
      vim.keymap.set({ 'n', 'x' }, 'vv', function() lucy.toggleMarkPress() end)
      vim.keymap.set('n', '<leader>ba', function() lucy.listMarks() end)
      vim.keymap.set('n', '<leader>bd', function() lucy.readFile() end)
      -- vim.keymap.set('n', '<leader>j', function() lucy.jump() end, {silent = true})
      vim.keymap.set('n', '<s-down>', function() lucy.jump({filejump = true}) end, { silent = true })
      vim.keymap.set('n', '<s-up>', function() lucy.jump({ filejump = true, backwards = true }) end)
      -- vim.keymap.set('n', '<M-^>', function() lucy.fileJump({}) end, { silent = true })
      --vim.keymap.set('n', '<M-!>', function() lucy.fileJump({ backwards = true }) end)
      -- vim.keymap.set('n', '<leader>bc', function() toggleHighlightingGroup("LucyLine") end)
    end
  },

  -- { 'phux/vim-marker' },

  -- {'MattesGroeger/vim-bookmarks',
  --   config = function()
  --     vim.g.bookmark_sign = ''
  --     vim.g.bookmark_save_per_working_dir = 1
  --     vim.g.bookmark_highlight_lines = 1
  --     vim.g.bookmark_no_default_key_mappings = 1
  --   end
  -- },

  -- { 'BartSte/nvim-project-marks',
  --     lazy = false,
  --     config = function()
  --       require('projectmarks').setup({
  --         -- If set to a string, the path to the shada file is set to the given value.
  --         -- If set to a boolean, the global shada file of neovim is used.
  --         shadafile = 'nvim.shada',

  --         -- If set to true, the "'" and "`" mappings are are appended by the
  --         -- `last_position`, and `last_column_position` functions, respectively.
  --         mappings = true,

  --         -- Message to be displayed when jumping to a mark.
  --         message = 'Waiting for mark...'
  --       })
  --     end
  -- },

  { 'piersolenski/telescope-import.nvim',
    dependencies = 'nvim-telescope/telescope.nvim',
    config = function()
      require("telescope").load_extension("import")
    end
  },

  -- {'airblade/vim-matchquote'},

  { 'stevearc/oil.nvim',
    opts = {},
    -- Optional dependencies
    -- dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup()
    end
  },

  { 'metakirby5/codi.vim' },

  -- { 'stevearc/aerial.nvim',
  --   opts = {},
  --   -- Optional dependencies
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter",
  --     "nvim-tree/nvim-web-devicons"
  --   },


  --   config = function()
  --     require("aerial").setup({
  --       -- optionally use on_attach to set keymaps when aerial has attached to a buffer
  --       on_attach = function(bufnr)
  --         -- Jump forwards/backwards with '{' and '}'
  --         vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
  --         vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
  --       end,
  --     })
  --     -- You probably also want to set a keymap to toggle aerial
  --     vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")
  --   end
  -- },

  { "wojciech-kulik/xcodebuild.nvim",
    branch = 'main',
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "MunifTanjim/nui.nvim",
    },

    config = function()
      require("xcodebuild").setup({
        -- logs = { -- build & test logs
        --   auto_open_on_success_tests = false, -- open logs when tests succeeded
        --   auto_open_on_failed_tests = false, -- open logs when tests failed
        --   auto_open_on_success_build = true, -- open logs when build succeeded
        --   auto_open_on_failed_build = true, -- open logs when build failed
        --   auto_close_on_app_launch = false, -- close logs when app is launched
        --   auto_close_on_success_build = false, -- close logs when build succeeded (only if auto_open_on_success_build=false)
        --   auto_focus = true, -- focus logs buffer when opened
        --   filetype = "objc", -- file type set for buffer with logs
        --   open_command = "Float {path}", -- command used to open logs panel. You must use {path} variable to load the log file
        --   logs_formatter = "xcbeautify --disable-colored-output", -- command used to format logs, you can use "" to skip formatting
        --   only_summary = false, -- if true logs won't be displayed, just xcodebuild.nvim summary
        --   live_logs = true, -- if true logs will be updated in real-time
        --   show_warnings = true, -- show warnings in logs summary
        --   notify = function(message, severity) -- function to show notifications from this module (like "Build Failed")
        --     vim.notify(message, severity)
        --   end,
        --   notify_progress = function(message) -- function to show live progress (like during tests)
        --     vim.cmd("echo '" .. message .. "'")
        --   end,
        -- },

      })

      vim.keymap.set("n", "<leader>xl", "<cmd>XcodebuildToggleLogs<cr>", { desc = "Toggle Xcodebuild Logs" })
      vim.keymap.set("n", "<leader>xb", "<cmd>XcodebuildBuild<cr>", { desc = "Build Project" })
      vim.keymap.set("n", "<leader>xr", "<cmd>XcodebuildBuildRun<cr>", { desc = "Build & Run Project" })
      vim.keymap.set("n", "<leader>xt", "<cmd>XcodebuildTest<cr>", { desc = "Run Tests" })
      vim.keymap.set("n", "<leader>xT", "<cmd>XcodebuildTestClass<cr>", { desc = "Run This Test Class" })
      vim.keymap.set("n", "<leader>X", "<cmd>XcodebuildPicker<cr>", { desc = "Show All Xcodebuild Actions" })
      vim.keymap.set("n", "<leader>xd", "<cmd>XcodebuildSelectDevice<cr>", { desc = "Select Device" })
      vim.keymap.set("n", "<leader>xp", "<cmd>XcodebuildSelectTestPlan<cr>", { desc = "Select Test Plan" })
      vim.keymap.set("n", "<leader>xq", "<cmd>Telescope quickfix<cr>", { desc = "Show QuickFix List" })
    end,
  },

  'AndrewRadev/undoquit.vim',

  { 'windwp/nvim-ts-autotag',
    config = function()
      require('nvim-ts-autotag').setup()
    end
  },

  'keith/swift.vim',

  { "sainttttt/everybody-wants-that-line.nvim",
    branch = "saint",
    config = function()
      vim.keymap.set('n', '<leader>nn', require("everybody-wants-that-line.components.filename").toggle_float)
      require("everybody-wants-that-line").setup {
        buffer = {
          enabled = true,
          prefix = "B:",
          symbol = "0",
          max_symbols = 5,
        },
        diagnostics = {
          enabled = true,
        },
        quickfix_list = {
          enabled = true,
        },
        git_status = {
          enabled = true,
        },
        filepath = {
          enabled = true,
          path = "relative",
          shorten = false,
        },
        filesize = {
          enabled = true,
          metric = "decimal"
        },
        ruller = {
          enabled = true,
        },
        filename = {
          enabled = true,
        },
        separator = "│",
      }
    end
  },

  { 'vim-crystal/vim-crystal' },

  { "rcarriga/nvim-notify",
    opts = {
      background_colour = "NotifyBackground",
      fps = 60,
      icons = {
        DEBUG = "",
        ERROR = "",
        INFO = "",
        TRACE = "✎",
        WARN = ""
      },
      level = 3,
      minimum_width = 40,
      max_width = 60,
      render = "wrapped-compact",
      stages = "fade",
      timeout = 1500,
      top_down = true

    },
  },

  { 'folke/noice.nvim',
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    -- enabled = false,
    config = function()

      require("noice").setup {
        views = {
          mini = {
            backend = "mini",
            relative = "editor",
            align = "text-left",
            timeout = 1000,
            reverse = true,
            focusable = false,
            position = {
              row = -1,
              col = "100%",
              -- col = 0,
            },
            size = "auto",
            border = {
              style = "none",
            },
            zindex = 360,
            win_options = {
              winbar = "",
              foldenable = false,
              winblend = 0,
              winhighlight = {
                Normal = "NoiceMini",
                IncSearch = "",
                CurSearch = "",
                Search = "",
              },
            },
          },
          confirm = {
            backend = "popup",
            relative = "editor",
            focusable = false,
            align = "center",
            enter = false,
            zindex = 210,
            format = { "{confirm}" },
            position = {
              row = "50%",
              col = "50%",
            },
            size = "auto",
            border = {
              style = "rounded",
              padding = { 0, 1 },
              text = {
                top = " Confirm ",
              },
            },
          },
          cmdline_popup = {
            filter_options = {},
            position = {
              row = "20%",
              col = "50%",
            },
            size = {
              width = "50",
              height = "1",
            },
          },
        },
        cmdline = {
          enabled = true,         -- enables the Noice cmdline UI
          view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
          opts = {},              -- global options for the cmdline. See section on views
          ---@type table<string, CmdlineFormat>
          format = {
            -- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
            -- view: (default is cmdline view)
            -- opts: any options passed to the view
            -- icon_hl_group: optional hl_group for the icon
            -- title: set to anything or empty string to hide
            cmdline = { pattern = "^:", icon = "", lang = "vim" },
            search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
            search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
            filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
            lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
            help = { pattern = { "^:%s*he?l?p?%s+", "^:%s*vert he?l?p?%s+" }, icon = "" },
            calculator = { pattern = "^=", icon = "", lang = "vimnormal" },
            input = {}, -- Used by input()
            -- lua = false, -- to disable a format, set to `false`
          },
        },

        routes = {
          filter = {
            event = 'msg_show',
            kind = '',
            find = 'more line',
          },
          opts = { skip = true },
        },
        {
          filter = { event = "msg_show", find = "nvim_win_close" },
          opts = { skip = true },
        },
        lsp = {
          hover = {enabled = false },
          signature = { enabled = false },
        },
        -- lsp = {
        --   message = {
        --     -- Messages shown by lsp servers
        --     enabled = false,
        --   },
        --   -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        --   override = {
        --     ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        --     ["vim.lsp.util.stylize_markdown"] = true,
        --     -- ["cmp.entry.get_documentation"] = true,
        --   },
        -- },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = true,          -- use a classic bottom cmdline for search
          -- command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = false, -- long messages will be sent to a split
          inc_rename = false,            -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false,        -- add a border to hover docs and signature help
        },

        messages = {
          -- NOTE: If you enable messages, then the cmdline is enabled automatically.
          -- This is a current Neovim limitation.
          enabled = false,             -- enables the Noice messages UI
          view = "mini",               -- default view for messages
          view_error = "mini",         -- view for errors
          view_warn = "mini",          -- view for warnings
          view_history = "messages",   -- view for :messages
          view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
        },
      }
    end
  },
}
