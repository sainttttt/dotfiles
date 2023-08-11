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

  -- {
  --   'norcalli/nvim-colorizer.lua',
  --   config = function()
  --     require'colorizer'.setup()
  --   end
  -- },

  { 'rktjmp/lush.nvim'},
  {
    "folke/zen-mode.nvim",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  },
  'tpope/vim-commentary',
  'tpope/vim-fugitive',

  {
    'renerocksai/telekasten.nvim',
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
    end
  },

  { 'bkad/CamelCaseMotion' },

  -- {
  --   "HampusHauffman/block.nvim",
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
  { 'andymass/vim-matchup' },
  { "nvim-treesitter/nvim-treesitter-textobjects",
    config = function()
      require'nvim-treesitter.configs'.setup {
        textobjects = {
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = { query = "@class.outer", desc = "Next class start" },
              --
              -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queires.
              ["]o"] = "@loop.*",
              -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
              --
              -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
              -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
              ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
              ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
            -- Below will go to either the start or the end, whichever is closer.
            -- Use if you want more granular movements
            -- Make it even more gradual by adding multiple queries and regex.
            goto_next = {
              ["]d"] = "@conditional.outer",
            },
            goto_previous = {
              ["[d"] = "@conditional.outer",
            }
          },
          select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              -- You can optionally set descriptions to the mappings (used in the desc parameter of
              -- nvim_buf_set_keymap) which plugins like which-key display
              ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
              -- You can also use captures from other query groups like `locals.scm`
              ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
            },
            -- You can choose the select mode (default is charwise 'v')
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * method: eg 'v' or 'o'
            -- and should return the mode ('v', 'V', or '<c-v>') or a table
            -- mapping query_strings to modes.
            selection_modes = {
              ['@parameter.outer'] = 'v', -- charwise
              ['@function.outer'] = 'V', -- linewise
              ['@class.outer'] = '<c-v>', -- blockwise
            },
            -- If you set this to `true` (default is `false`) then any textobject is
            -- extended to include preceding or succeeding whitespace. Succeeding
            -- whitespace has priority in order to act similarly to eg the built-in
            -- `ap`.
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * selection_mode: eg 'v'
            -- and should return true of false
            include_surrounding_whitespace = true,
          },
        },
      }
    end
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function () 
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = { "c", "swift", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },  
      })
    end
  },


  'hood/popui.nvim',
  "sindrets/diffview.nvim",
  'zah/nim.vim',
  {'hrsh7th/vim-searchx',
    config = function()
      vim.keymap.set("n", "?", "<cmd>call searchx#start({ 'dir': 0 })<CR>")
      vim.keymap.set("n", "/", "<cmd>call searchx#start({ 'dir': 1 })<CR>")
    end

  },

  'prichrd/netrw.nvim',
  -- 'preservim/nerdtree',
  -- 'https://gitlab.com/madyanov/svart.nvim',

  {'akinsho/toggleterm.nvim',
    config = function()
      require("toggleterm").setup({
        shell = vim.o.shell, -- change the default shell
        auto_scroll = true, -- automatically scroll to the bottom on terminal output

        direction = 'float',
        start_in_insert = false,

        on_open = function(term)
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
          vim.cmd("ToggleTerm")
        end
      end


      vim.keymap.set('n', '<Tab>', TermToggle, { noremap = true, silent = false })

      function _G.quitTerm()
        local feedkey = function(key, mode)
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
        end

        if vim.bo.buftype == "terminal" then
          vim.cmd("q")
        else
          feedkey("%", "n")
        end
      end

      vim.keymap.set('n', 'q', ':lua quitTerm()<CR>', {silent = true})

      local Terminal  = require('toggleterm.terminal').Terminal
      local gitui = Terminal:new({ cmd = "gitui",
        hidden = true ,
        on_open = function(term)
          vim.cmd("startinsert!")
          -- vim.keymap.del('t', '<esc>')
        end,
        start_in_insert = true })

      function _gitui_toggle()
        gitui:toggle()
      end

      vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua _gitui_toggle()<CR>", {noremap = true, silent = true})




    end
  },

  -- { 'CRAG666/betterTerm.nvim' ,

  -- config = function()

  --   require('betterTerm').setup {
  --     prefix = "Term_",
  --     startInserted = true,
  --     position = "vert",
  --     size = 18
  --   }

  --   vim.keymap.set("n", "<leader>rf", function()
  --     require("betterTerm").send(require("code_runner.commands").get_filetype_command(), 1, { clean = true, interrupt = true })
  --   end, { desc = "Excute File"})

  -- end

  -- },

  'mfussenegger/nvim-lint',

  { 
    'CRAG666/code_runner.nvim', 
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

  'tpope/vim-scriptease',
  -- { 'JellyApple102/easyread.nvim' },

  { 'echasnovski/mini.nvim', version = false, },

  'neovim/nvim-lspconfig',

  {
    'xbase-lab/xbase',
    build = 'make install', -- or "make install && make free_space" (not recommended, longer build time)
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim", -- optional
      "nvim-lua/plenary.nvim", -- optional/requirement of telescope.nvim
      -- "stevearc/dressing.nvim", -- optional (in case you don't use telescope but something else)
    },
    config = function()
      require'xbase'.setup({
        sourcekit = {
          on_attach = function(client, bufnr)
            -- Enable completion triggered by <c-x><c-o>
            vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

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
        },
        simctl = {
          iOS = {
            "iPhone 14"
          },
          watchOS = {}, -- all available devices
          tvOS = {}, -- all available devices
        },
        mappings = {
          --- Whether xbase mapping should be disabled.
          enable = true,
          --- Open build picker. showing targets and configuration.
          build_picker = "<leader>rt", --- set to 0 to disable
          --- Open run picker. showing targets, devices and configuration
          run_picker = "<leader>rf", --- set to 0 to disable
          --- Open watch picker. showing run or build, targets, devices and configuration
          watch_picker = "<leader>ry", --- set to 0 to disable
          --- A list of all the previous pickers
          all_picker = "<leader>re", --- set to 0 to disable
          --- horizontal toggle log buffer
          toggle_split_log_buffer = "<leader>ll",
          --- vertical toggle log buffer
          toggle_vsplit_log_buffer = "<leader>lp",
        },
      })


      function _G.XbaseBuildDefault()
        local xbase_proj = require("xbase.state").project_info
        local next = pairs(xbase_proj)
        local proj_root = next(xbase_proj)
        local logger = require "xbase.logger"

        local args = require('xbase.pickers.util').generate_entries(proj_root, 'Run')[1]
        local xbase = require("xbase.pickers.util")
        require('xbase.logger').clear() -- clear scrollback
        logger.open()
        xbase.run_command(args)
      end

      vim.api.nvim_set_keymap("n", "<M-r>", [[<cmd>lua XbaseBuildDefault()<cr>]], {})

    end
  },

  'AndrewRadev/undoquit.vim',
  {'nvim-tree/nvim-tree.lua',
    config = function()

      local HEIGHT_RATIO = 0.5 -- You can change this
      local WIDTH_RATIO = 0.5  -- You can change this too
      require("nvim-tree").setup({
        actions = {
          open_file = {
            window_picker = {
              enable = false
            }
          }
        },
        view = {
          relativenumber = true,
          float = {
            enable = true,
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

  { "strash/everybody-wants-that-line.nvim",
    config = function()
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
      level = 2,
      minimum_width = 50,
      render = "default",
      stages = "static",
      timeout = 5000,
      top_down = true

    },

  },

  {'folke/noice.nvim', dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
    -- enabled = false,
    config = function()
      require("noice").setup {

        -- views = {
        --   cmdline_popup = {
        --     border = {
        --       style = "none",
        --       padding = { 2, 3 },
        --     },
        --     filter_options = {},
        --     win_options = {
        --       winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
        --     },
        --   },
        -- },
        lsp = {
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
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- add a border to hover docs and signature help
        },

        messages = {
          -- NOTE: If you enable messages, then the cmdline is enabled automatically.
          -- This is a current Neovim limitation.
          enabled = false, -- enables the Noice messages UI
          view = "notify", -- default view for messages
          view_error = "notify", -- view for errors
          view_warn = "notify", -- view for warnings
          view_history = "messages", -- view for :messages
          view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
        },
      }
    end
  },


  --'ervandew/supertab',
  --{ "lukas-reineke/indent-blankline.nvim" },
}
