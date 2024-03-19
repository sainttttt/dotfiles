return {
  git = {
    -- defaults for the `Lazy log` command
    -- log = { "-10" }, -- show the last 10 commits
    log = { "--since=3 days ago" }, -- show commits from the last 3 days
    timeout = 10000, -- kill processes that take more than 2 minutes
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

  { 'nmac427/guess-indent.nvim',
    config = function() require('guess-indent').setup {} end,
  },

  -- {'rhysd/clever-f.vim'},

  -- disables search highlight when cursor moves
  {'romainl/vim-cool'},

  { 'BartSte/nvim-project-marks',
    lazy = false,
    config = function()
      require('projectmarks').setup({
        shadafile = '.vim/main.shada',
      })
    end
  },

  { 'echasnovski/mini.nvim', version = false,
    config = function()
      require('mini.trailspace').setup()
      vim.keymap.set('n', 'at', function()
        require('mini.trailspace').trim()
        vim.cmd('up')
      end
      )

      -- vim.keymap.set('n', '<leader>mll', MiniTrailspace.trim_last_lines)

      require('mini.splitjoin').setup()
      require('mini.align').setup()

      require('mini.sessions').setup({
        autoread = false,
        autowrite = true,
        directory = "~/.local/share/nvim/sessions",
      })
    end
  },

  {
    "ariel-frischer/bmessages.nvim",
    config = function()
      require("bmessages").setup{}
      vim.keymap.set('n', '<leader>z', "<cmd>Bmessagesvs<CR>")
    end
  },

  -- 'wellle/context.vim',

  {'RRethy/vim-illuminate',
    config = function()
      require('illuminate').configure({})
    end
  },

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

  -- {'nvim-treesitter/nvim-treesitter-context',
  --   config = function()
  --     require'treesitter-context'.setup {
  --       enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
  --       max_lines = 6, -- How many lines the window should span. Values <= 0 mean no limit.
  --       min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
  --       line_numbers = true,
  --       multiline_threshold = 20, -- Maximum number of lines to show for a single context
  --       trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  --       mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
  --       -- Separator between context and content. Should be a single character string, like '-'.
  --       -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
  --       -- separator = '-',
  --       zindex = 41,
  --       on_attach = function()
  --         -- print("new attach")

  --         if vim.bo.filetype == "swift"
  --           or vim.bo.filetype == "nim"
  --           or vim.bo.filetype == "vim"
  --           or vim.fn.bufname("%") == "[Command Line]" then
  --           -- vim.cmd("ContextEnable")
  --           return false
  --         end
  --       end, -- (fun(buf: integer): boolean) return false to disable attaching
  --     }
  --   end
  -- },

  -- {
  --   "folke/which-key.nvim",
  --   event = "VeryLazy",
  --   init = function()
  --     vim.o.timeout = true
  --     vim.o.timeoutlen = 1500
  --   end,
  --   opts = {
  --     -- your configuration comes here
  --     -- or leave it empty to use the default settings
  --     -- refer to the configuration section below
  --   }
  -- },

  -- allows you to open nvim from cmdline with line number
  -- {'wsdjeg/vim-fetch'},

  { 'sainttttt/flesh-and-blood',
    lazy=false,
    priority=1000 ,
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

  { dir = "~/code/yoke.vim",
    'sainttttt/yoke.vim',
    config = function()
      require('yoke').setup()
    end
  },

  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },

  -- {'cohama/lexima.vim'},
  --
  -- {
  --   'windwp/nvim-autopairs',
  --   event = "InsertEnter",
  --   opts = {} -- this is equalent to setup({}) function
  -- },

  {
    'altermo/ultimate-autopair.nvim',
    event={'InsertEnter','CmdlineEnter'},
    branch='v0.6', --recomended as each new version will have breaking changes
    config = function()
      require'nvim-treesitter.configs'.setup{}
      require('ultimate-autopair').setup{}
      local pair=[[([{"']]
      local end_pair=[[)]}"']]..'\29'
      local pair_insert
      local save={}
      local group=vim.api.nvim_create_augroup('test',{})
      vim.api.nvim_create_autocmd('InsertCharPre',{callback=function ()
        pair_insert=false
        for c in pair:gmatch'.' do
          if vim.v.char==c then
            local action=require'ultimate-autopair.core'.run(c)
            if action=='\aU\x80kr'--[[this is dont-new-undo + <right>]] then
              vim.api.nvim_feedkeys(action,'n',false)
              vim.v.char=''
              save={}
              return
            elseif #action>2 then
              table.insert(save,action:sub(3))
              pair_insert=true
              return
            end
          end
        end
        if not save[1] then return end
        local nsave=save
        save={}
        if end_pair:find(vim.v.char,1,true) then return end
        vim.api.nvim_feedkeys(table.concat(nsave),'n',false)
      end,group=group})
      vim.api.nvim_create_autocmd('CursorMovedI',{callback=function ()
        if pair_insert then return end
        save={}
      end,group=group})
      vim.api.nvim_create_autocmd('ModeChanged',{callback=function () save={} end,group=group})
      for c in pair:gmatch'.' do
        vim.keymap.del('i',c)
      end
    end
  },


  {'ojroques/nvim-osc52',
    config = function()
      vim.keymap.set('n', '<c-y>', require('osc52').copy_operator, {expr = true})
      vim.keymap.set('v', '<c-y>', require('osc52').copy_visual)

      require('osc52').setup {
        max_length = 0,           -- Maximum length of selection (0 for no limit)
        silent = false,           -- Disable message on successful copy
        trim = false,             -- Trim surrounding whitespaces before copy
        tmux_passthrough = true, -- Use tmux passthrough (requires tmux: set -g allow-passthrough on)
      }
    end
  },

  {
    "epwalsh/obsidian.nvim",
    lazy = false,
    event = {
      -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
      -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
      "BufReadPre " ..  vim.fn.expand "~" .. "/Library/Mobile Documents/iCloud~md~obsidian/Documents/Katarina/**.md",
      "BufNewFile " ..  vim.fn.expand "~" .. "/Library/Mobile Documents/iCloud~md~obsidian/Documents/Katarina/**.md",
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



  {
    'Vonr/align.nvim',
    config = function()
      local NS = { noremap = true, silent = true }

      vim.keymap.set('x', 'aa', function() require'align'.align_to_char(1, true)             end, NS) -- Aligns to 1 character, looking left
      -- vim.keymap.set('x', 'as', function() require'align'.align_to_char(2, true, true)       end, NS) -- Aligns to 2 characters, looking left and with previews
      vim.keymap.set('x', 'aw', function() require'align'.align_to_string(false, true, true) end, NS) -- Aligns to a string, looking left and with previews
      vim.keymap.set('x', 'ar', function() require'align'.align_to_string(true, true, true)  end, NS) -- Aligns to a Lua pattern, looking left and with previews
    end
  },


  {
    'tzachar/highlight-undo.nvim',
    config = function()
      require('highlight-undo').setup({
        duration = 300,
        undo = {
          hlgroup = 'HighlightUndo',
          mode = 'n',
          lhs = 'u',
          map = 'undo',
          opts = {}
        },
        redo = {
          hlgroup = 'HighlightUndo',
          mode = 'n',
          lhs = '<C-r>',
          map = 'redo',
          opts = {}
        },
        highlight_for_count = true,
      })
    end
  },

  'tpope/vim-commentary',

  -- 'kkharji/sqlite.lua',
  { "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function ()
      local function ts_disable(_, bufnr)
        return vim.fn.wordcount()['chars'] > 50000
      end
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = { "php",
          "swift",
          "nim",
          "python",
          "css",
          "c",
          "lua",
          "vim",
          "markdown",
          "markdown_inline",
          "vimdoc",
          "query",
          "javascript",
          "html"},


        sync_install = false,
        matchup = {
          enable = true,              -- mandatory, false will disable the whole extension
          -- disable = { "swift" },  -- optional, list of language that will be disabled
          -- [options]
        },
        highlight = {
          enable = true ,
          disable = function(lang, bufnr)
            -- return lang == "cmake" or lang == "swift" or ts_disable(lang, bufnr)
            return lang == "cmake"  or ts_disable(lang, bufnr)
          end,
          additional_vim_regex_highlighting = {"latex"},
        },
        indent = { enable = true },
      })

    end
  },

  --{'kevinhwang91/nvim-ufo',
  --  dependencies = {'kevinhwang91/promise-async','kkharji/sqlite.lua',},
  --  config = function()
  --    vim.o.foldcolumn = '0' -- '0' is not bad
  --    vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
  --    vim.o.foldlevelstart = 99
  --    vim.o.foldenable = true

  --    --
  --    require('ufo').setup({
  --      provider_selector = function(bufnr, filetype, buftype)
  --        return {'treesitter', 'indent'}
  --      end
  --    })

  --    -- require('ufo').setup({
  --    --     provider_selector = function(bufnr, filetype, buftype)
  --    --         return ''
  --    --     end
  --    -- })

  --    -- local capabilities = vim.lsp.protocol.make_client_capabilities()
  --    -- capabilities.textDocument.foldingRange = {
  --    --   dynamicRegistration = false,
  --    --   lineFoldingOnly = true
  --    -- }
  --    -- local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
  --    -- for _, ls in ipairs(language_servers) do
  --    --   require('lspconfig')[ls].setup({
  --    --     capabilities = capabilities
  --    --     -- you can add other fields for setting up lsp server in this table
  --    --   })
  --    -- end
  --    -- require('ufo').setup()
  --    -- vim.cmd("silent! loadview 1")

  --    local function readAll(file)
  --      local f = assert(io.open(file, "rb"))
  --      local content = f:read("*all")
  --      f:close()
  --      return content
  --    end

  --    local function getFoldsSavePath()
  --      local filepath = vim.fn.expand('%:p'):gsub("/", "_"):gsub("%.","_")
  --      return vim.fn.expand('$HOME/.local/state/nvim/view/') ..  filepath
  --    end

  --    local function readFoldsStatus ()
  --      local filename = getFoldsSavePath() .. "_status"

  --      local foldStatusFile = io.open (filename, 'r')
  --      if foldStatusFile == nil then
  --        local foldStatusFile = io.open (filename, 'w')
  --        if foldStatusFile ~= nil then
  --          foldStatusFile:write(vim.json.encode({ current = 0, start = 0, last = 0 }))
  --          foldStatusFile:close()
  --        end
  --      end

  --      local foldStatusFile = io.open (filename, 'r')
  --      return vim.json.decode(readAll(filename))
  --    end


  --    local function writeFoldsStatus(foldsStatus)
  --      local filename = getFoldsSavePath() .. "_status"

  --      local foldStatusFile = io.open (filename, 'w')
  --      if foldStatusFile ~= nil then
  --        foldStatusFile:write(vim.json.encode(foldsStatus))
  --        foldStatusFile:close()
  --      end
  --    end


  --    local function loadCurrentFoldsSave()
  --      local foldsStatus = readFoldsStatus()
  --      vim.cmd("silent! source " .. getFoldsSavePath().. foldsStatus.current)
  --    end

  --    local function undoFold()
  --      local foldsStatus = readFoldsStatus()
  --      if foldsStatus.current == foldsStatus.start then
  --        print("cannot undo")
  --        return
  --      end

  --      foldsStatus.current = foldsStatus.current - 1
  --      writeFoldsStatus(foldsStatus)
  --      loadCurrentFoldsSave()

  --    end

  --    local function redoFold()
  --      local foldsStatus = readFoldsStatus()
  --      if foldsStatus.current == foldsStatus.last then
  --        print("cannot redo")
  --        return
  --      end

  --      foldsStatus.current = foldsStatus.current + 1
  --      writeFoldsStatus(foldsStatus)
  --      loadCurrentFoldsSave()

  --    end

  --    vim.api.nvim_create_autocmd({"BufRead"}, {
  --      group = "folds",
  --      pattern = {"?*"},
  --      callback = loadCurrentFoldsSave
  --    })

  --    local function incrementViewNumber()

  --      -- if vim.g.VIEW_NUMBER == nil then
  --      --   vim.g.VIEW_NUMBER = 0
  --      -- end
  --      -- vim.g.VIEW_NUMBER = (vim.g.VIEW_NUMBER + 1 ) % 10

  --      local foldsStatus = readFoldsStatus()
  --      local maxSteps = 10

  --      foldsStatus.current =  (foldsStatus.current + 1) % maxSteps
  --      foldsStatus.last = foldsStatus.current
  --      if foldsStatus.last == foldsStatus.start then
  --        foldsStatus.start =  (foldsStatus.start + 1) % maxSteps
  --      end

  --      writeFoldsStatus(foldsStatus)
  --      vim.cmd("mkview! " .. getFoldsSavePath().. foldsStatus.current)

  --    end

  --    local function openAllFolds()
  --      require('ufo').openAllFolds()
  --      incrementViewNumber()
  --    end

  --    local function closeAllFolds()
  --      require('ufo').closeAllFolds()
  --      incrementViewNumber()
  --    end

  --    local function toggleFold()
  --      vim.cmd("normal 2a")
  --      incrementViewNumber()
  --    end

  --    vim.keymap.set('n', '22', toggleFold, { noremap = true, silent = true })
  --    vim.keymap.set({'n', 'x'}, 'E', toggleFold, { noremap = true, silent = true })

  --    vim.keymap.set('n', '2u', undoFold, { noremap = true, silent = true })
  --    vim.keymap.set('n', '2U', redoFold, { noremap = true, silent = true })

  --    vim.keymap.set('n', '2r', openAllFolds, { noremap = true, silent = true })

  --    vim.keymap.set('n', '2m', closeAllFolds,{ noremap = true, silent = true })


  --    -- vim.keymap.set('n', 'zr', require('ufo').openAllFolds, { noremap = true, silent = true })
  --    vim.keymap.set('n', '2R', require('ufo').openAllFolds, { noremap = true, silent = true })
  --    vim.keymap.set('n', '2M', require('ufo').closeAllFolds,{ noremap = true, silent = true })
  --  end
  --},

  -- { 'Vonr/foldcus.nvim',
  --   dependencies = { 'nvim-treesitter/nvim-treesitter' },
  --   config = function()
  --     local foldcus = require('foldcus')
  --     local NS = { noremap = true, silent = true }

  --     local numFolds = 3

  --     -- Fold multiline comments longer than or equal to 4 lines
  --     vim.keymap.set('n', 'z;', function() foldcus.fold(numFolds)   end, NS)

  --     -- Fold multiline comments longer than or equal to the number of lines specified by args
  --     -- e.g. Foldcus 4
  --     vim.api.nvim_create_user_command('Foldcus', function(args) foldcus.fold(tonumber(args.args))   end, { nargs = '*' })

  --     -- Delete folds of multiline comments longer than or equal to 4 lines
  --     vim.keymap.set('n', 'z\'', function() foldcus.unfold(4) end, NS)

  --     -- Delete folds of multiline comments longer than or equal to the number of lines specified by args
  --     -- e.g. Unfoldcus 4
  --     vim.api.nvim_create_user_command('Unfoldcus', function(args) foldcus.unfold(tonumber(args.args)) end, { nargs = '*' })
  --   end
  -- },

  -- { "chrisgrieser/nvim-origami",
  --   event = "BufReadPost", -- later or on keypress would prevent saving folds
  --   opts = true, -- needed even when using default config
  --   config = function ()
  --     require("origami").setup ({}) -- setup call needed
  --   end,
  -- },

  -- {
  --   'norcalli/nvim-colorizer.lua',
  --   config = function()
  --     require'colorizer'.setup()
  --   end
  -- },


  { "lukas-reineke/indent-blankline.nvim",
    main = "ibl", opts = {
      indent = { char = "│" },
      scope = {enabled = false},
    }
  },

  {'alaviss/nim.nvim'},
  {"ericvw/vim-nim"},
  { 'jakemason/ouroboros',
    dependencies = { {'nvim-lua/plenary.nvim'} },
    config = function()
      vim.cmd("autocmd! Filetype c,cpp noremap<buffer> 3 :Ouroboros<CR>")
    end
  },

  { "sainttttt/zen-mode.nvim",
    -- "folke/zen-mode.nvim",
    config = function()
      vim.keymap.set('n', 'vf', function()
        vim.cmd("ZenMode")
        -- vim.cmd("TSContextDisable")
        -- vim.cmd("TSContextEnable")
        -- vim.cmd("redraw")
        -- vim.cmd("exec 'normal l'")
        -- vim.cmd("redraw")
      end)


      require('zen-mode').setup {
        window = {
          backdrop = 1, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
          -- height and width can be:
          -- * an absolute number of cells when > 1
          -- * a percentage of the width / height of the editor when <= 1
          -- * a function that returns the width or the height
          width = 120, -- width of the Zen window
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
    dependencies = {'nvim-telescope/telescope.nvim'},
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

  { "utilyre/sentiment.nvim",
    version = "*",
    event = "VeryLazy", -- keep for lazy loading
    opts = {
      -- config
    },
    init = function()
      -- `matchparen.vim` needs to be disabled manually in case of lazy loading
      vim.g.loaded_matchparen = 1
    end,
  },

  --{ "nvim-treesitter/nvim-treesitter-textobjects",
  --  config = function()
  --    require'nvim-treesitter.configs'.setup {
  --      textobjects = {
  --        move = {
  --          enable = true,
  --          set_jumps = true, -- whether to set jumps in the jumplist
  --          goto_next_start = {
  --            ["]m"] = "@function.outer",
  --            ["]]"] = { query = "@class.outer", desc = "Next class start" },
  --            --
  --            -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queires.
  --            ["]o"] = "@loop.*",
  --            -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
  --            --
  --            -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
  --            -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
  --            ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
  --            ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
  --          },
  --          goto_next_end = {
  --            ["]M"] = "@function.outer",
  --            ["]["] = "@class.outer",
  --          },
  --          goto_previous_start = {
  --            ["[m"] = "@function.outer",
  --            ["[["] = "@class.outer",
  --          },
  --          goto_previous_end = {
  --            ["[M"] = "@function.outer",
  --            ["[]"] = "@class.outer",
  --          },
  --          -- Below will go to either the start or the end, whichever is closer.
  --          -- Use if you want more granular movements
  --          -- Make it even more gradual by adding multiple queries and regex.
  --          goto_next = {
  --            ["]d"] = "@conditional.outer",
  --          },
  --          goto_previous = {
  --            ["[d"] = "@conditional.outer",
  --          }
  --        },
  --        select = {
  --          enable = true,

  --          -- Automatically jump forward to textobj, similar to targets.vim
  --          lookahead = true,

  --          keymaps = {
  --            -- You can use the capture groups defined in textobjects.scm
  --            ["af"] = "@function.outer",
  --            ["if"] = "@function.inner",
  --            ["ac"] = "@class.outer",
  --            -- You can optionally set descriptions to the mappings (used in the desc parameter of
  --            -- nvim_buf_set_keymap) which plugins like which-key display
  --            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
  --            -- You can also use captures from other query groups like `locals.scm`
  --            ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
  --          },
  --          -- You can choose the select mode (default is charwise 'v')
  --          --
  --          -- Can also be a function which gets passed a table with the keys
  --          -- * query_string: eg '@function.inner'
  --          -- * method: eg 'v' or 'o'
  --          -- and should return the mode ('v', 'V', or '<c-v>') or a table
  --          -- mapping query_strings to modes.
  --          selection_modes = {
  --            ['@parameter.outer'] = 'v', -- charwise
  --            ['@function.outer'] = 'V', -- linewise
  --            ['@class.outer'] = '<c-v>', -- blockwise
  --          },
  --          -- If you set this to `true` (default is `false`) then any textobject is
  --          -- extended to include preceding or succeeding whitespace. Succeeding
  --          -- whitespace has priority in order to act similarly to eg the built-in
  --          -- `ap`.
  --          --
  --          -- Can also be a function which gets passed a table with the keys
  --          -- * query_string: eg '@function.inner'
  --          -- * selection_mode: eg 'v'
  --          -- and should return true of false
  --          include_surrounding_whitespace = true,
  --        },
  --      },
  --    }
  --  end
  --},



  'hood/popui.nvim',
  "sindrets/diffview.nvim",

  { "sainttttt/vim-searchx",
    branch = "mod",
    config = function()
      vim.keymap.set("n", "as", "<cmd>call searchx#start({ 'dir': 1 })<CR>")
      vim.keymap.set("n", "m", "<cmd>call searchx#start({ 'dir': 1 })<CR>")
      -- vim.keymap.set("n", "<leader>m", "<cmd>call searchx#start({ 'dir': 1 })<CR>")
      vim.keymap.set("n", "/", "<Esc>")

    end
  },

  'prichrd/netrw.nvim',

  -- { 'https://gitlab.com/madyanov/svart.nvim',

  --   config = function()
  --     vim.keymap.set({ "n", "x", "o" }, "'", "<Cmd>Svart<CR>")        -- begin exact search
  --     vim.keymap.set({ "n", "x", "o" }, "\"", "<Cmd>SvartRegex<CR>")   -- begin regex search
  --     vim.keymap.set({ "n", "x", "o" }, "g'", "<Cmd>SvartRepeat<CR>") -- repeat with last accepted query
  --   end
  -- },

  {'akinsho/toggleterm.nvim',
    config = function()
      require("toggleterm").setup({
        shell = vim.o.shell, -- change the default shell
        auto_scroll = true, -- automatically scroll to the bottom on terminal output

        direction = 'float',
        start_in_insert = true,
        close_on_exit = false,

        on_open = function(term)
          vim.keymap.set('n', 'q', '<cmd>q<CR>', {silent = true, buffer = true})
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
        local ft = vim.api.nvim_get_option_value("filetype", {buf = buf})

        if ft == "swift" or ft == "xclog" then
          local logger = require "xbase.logger"
          logger.toggle()
        else
          -- if true then
          vim.cmd("ToggleTerm")
          -- require("FTerm").toggle()
        end
      end

      -- note: have to check init.lua for another mapping if you want to change
      -- the termtoggle mapping key
      vim.keymap.set('n', '<m-c>', TermToggle, { noremap = true, silent = false })

      local Terminal  = require('toggleterm.terminal').Terminal
      local gitui = Terminal:new({ cmd = "gitui",
        -- hidden = true ,
        on_open = function(term)
          vim.cmd("startinsert!")
          -- vim.keymap.del('t', '<esc>')
        end,
        start_in_insert = true })

      function _gitui_toggle()
        gitui:toggle()
      end

      vim.api.nvim_set_keymap("n", "gi", "<cmd>lua _gitui_toggle()<CR>", {noremap = true, silent = true})

    end
  },

  { 'haya14busa/vim-asterisk',
    config = function()
      vim.keymap.set('n', '*', '<Plug>(asterisk-z*)', { noremap = true, silent = false })
      vim.keymap.set('n', '#', '<Plug>(asterisk-z#)', { noremap = true, silent = false })

      vim.keymap.set('n', 'g*', '<Plug>(asterisk-gz*)', { noremap = true, silent = false })
      vim.keymap.set('n', 'g#', '<Plug>(asterisk-gz#)', { noremap = true, silent = false })
      vim.g["asterisk#keeppos"] = 1
    end
  },

  -- {'airblade/vim-rooter'},
  -- {'azabiong/vim-highlighter',
  --   config = function()

  --     vim.cmd([[
  --       unmap f<CR>
  --       exe 'xnoremap <silent> ff :<C-U>if highlighter#Command("+x") \| noh \| endif \| silent! Hi save <CR> '

  --       exe 'nnoremap <silent> f<CR> :<C-U>if highlighter#Command("clear") \| noh \| endif \| silent! Hi save <CR> '
  --     nmap f~ f<C-L> \| <cmd>silent! Hi save<CR>

  --     autocmd BufRead * silent! Hi load
  --     " autocmd BufUnload * silent! Hi save
  -- ]])

  --     -- vim.keymap.set('v', 'ff', 'f<CR>', { noremap = false, silent = true })
  --     -- vim.keymap.set('n', 'f~', 'f<C-L>', { noremap = true, silent = true })
  --     end
  --     },

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

  {"miversen33/sunglasses.nvim",
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


  { dir = "~/code/lucy.nvim",
    config = function()
      require("lucy").setup()
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
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("xcodebuild").setup()

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

  {'windwp/nvim-ts-autotag',
    config = function()
      require('nvim-ts-autotag').setup()
    end
  },

  {'nvim-tree/nvim-tree.lua',
    config = function()
      vim.keymap.set('n', '<C-a>', function()
        local nvimtree = require'nvim-tree.view'
        if not nvimtree.is_visible() then
          vim.cmd("NvimTreeFindFile")
        else
          vim.cmd("NvimTreeClose")
        end
      end)

      local HEIGHT_RATIO = 0.5 -- You can change this
      local WIDTH_RATIO = 0.2  -- You can change this too
      require("nvim-tree").setup({
        on_attach = function(bufnr)

          local api = require('nvim-tree.api')
          vim.keymap.set('n', 's', api.node.open.vertical, {buffer = bufnr})
          vim.keymap.set('n', '<C-v>', api.node.open.vertical, {buffer = bufnr})
          vim.keymap.set('n', '<C-v>', api.node.open.vertical, {buffer = bufnr})
          vim.keymap.set('n', '<CR>', api.node.open.edit, {buffer = bufnr})
          vim.keymap.set('n', 'l', api.node.open.edit, {buffer = bufnr})
          vim.keymap.set('n', 'h', api.node.navigate.parent_close, {buffer = bufnr})
          vim.keymap.set('n', 'o',   api.tree.change_root_to_node, {buffer = bufnr})
          vim.keymap.set('n', 'D',   api.fs.trash, {buffer = bufnr})
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
            return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
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

  'keith/swift.vim',
  -- 'michaeljsmith/vim-indent-object',

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

  {'folke/noice.nvim',
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
          -- cmdline_popup = {
          --   border = {
          --     style = "none",
          --     padding = { 2, 3 },
          --   },
          --   filter_options = {},
          --   win_options = {
          --     winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
          --   },
          -- },
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
          message = {
            -- Messages shown by lsp servers
            enabled = false,
          },
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          -- command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = false, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- add a border to hover docs and signature help
        },

        messages = {
          -- NOTE: If you enable messages, then the cmdline is enabled automatically.
          -- This is a current Neovim limitation.
          enabled = false, -- enables the Noice messages UI
          view = "mini", -- default view for messages
          view_error = "mini", -- view for errors
          view_warn = "mini", -- view for warnings
          view_history = "messages", -- view for :messages
          view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
        },
      }
    end
  },
}
