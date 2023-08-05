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

  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require'colorizer'.setup()
    end
  },

  'tpope/vim-commentary',

  { 'bkad/CamelCaseMotion' },

{
  "HampusHauffman/block.nvim",
  config = function()
    require("block").setup({
      percent = 0.95,
      depth = 4,
      colors = nil,
      automatic = false,
      --      bg = nil,
      --      colors = {
      --          "#ff0000"
      --          "#00ff00"
      --          "#0000ff"
      --      },
    })
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
  
  {
    'nvimdev/lspsaga.nvim',
  event = "LspAttach",
  config = function()
    require("lspsaga").setup({
      lightbulb = {
        enable = false,
      },
      finder = {
        max_height = 0.6,
        keys = {
          vsplit = 'v'
        }
      }
    })

    vim.keymap.set("n", "gp", "<cmd>Lspsaga peek_definition<CR>", {noremap=true})
    vim.keymap.set("n", "ga", "<cmd>Lspsaga peek_definition<CR>", {noremap=true})


    local keymap = vim.keymap.set

    -- LSP finder - Find the symbol's definition
    -- If there is no definition, it will instead be hidden
    -- When you use an action in finder like "open vsplit",
    -- you can use <C-t> to jump back
    keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>")

    -- Code action
    keymap({"n","v"}, "<leader>ca", "<cmd>Lspsaga code_action<CR>")

    -- Rename all occurrences of the hovered word for the entire file
    keymap("n", "gr", "<cmd>Lspsaga rename<CR>")

    -- Rename all occurrences of the hovered word for the selected files
    keymap("n", "gr", "<cmd>Lspsaga rename ++project<CR>")

    -- Peek definition
    -- You can edit the file containing the definition in the floating window
    -- It also supports open/vsplit/etc operations, do refer to "definition_action_keys"
    -- It also supports tagstack
    -- Use <C-t> to jump back
    keymap("n", "gp", "<cmd>Lspsaga peek_definition<CR>")

    -- Go to definition
    keymap("n","gd", "<cmd>Lspsaga goto_definition<CR>")

    -- Peek type definition
    -- You can edit the file containing the type definition in the floating window
    -- It also supports open/vsplit/etc operations, do refer to "definition_action_keys"
    -- It also supports tagstack
    -- Use <C-t> to jump back
    keymap("n", "gt", "<cmd>Lspsaga peek_type_definition<CR>")

    -- Go to type definition
    keymap("n","gt", "<cmd>Lspsaga goto_type_definition<CR>")


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
    keymap("n","<leader>o", "<cmd>Lspsaga outline<CR>")


    -- Call hierarchy
    keymap("n", "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>")
    keymap("n", "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>")

    -- Floating terminal
    keymap({"n", "t"}, "<A-d>", "<cmd>Lspsaga term_toggle<CR>")

  end,

  dependencies = {
    {"nvim-tree/nvim-web-devicons"},
    --Please make sure you install markdown and markdown_inline parser
    {"nvim-treesitter/nvim-treesitter"}
  }
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

  vim.keymap.set('n', '<Tab>', ':ToggleTerm<CR>', { noremap = true, silent = false })



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

      local args = require('xbase.pickers.util').generate_entries(proj_root, 'Run')[1]
      local xbase = require("xbase.pickers.util")
      require('xbase.logger').clear() -- clear scrollback
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

  -- {'akinsho/bufferline.nvim', version = "v3.*", dependencies = 'nvim-tree/nvim-web-devicons'},
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
  stages = "fade",
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


  { "jake-stewart/jfind.nvim", branch = "1.0" },
  { 'ibhagwan/fzf-lua',
  config = function()
    require("fzf-lua").setup({
      winopts = { height = 0.8,
      preview = {
        layout = "vertical",
        vertical = "up"
      }

    }
  })
end
  },

  {
    'rmagatti/goto-preview',
    config = function()
      require('goto-preview').setup {

        width = 120; -- Width of the floating window
        height = 15; -- Height of the floating window
        border = {"↖", "─" ,"┐", "│", "┘", "─", "└", "│"}; -- Border characters of the floating window
        default_mappings = true; -- Bind default mappings
        debug = false; -- Print debug information
        opacity = nil; -- 0-100 opacity level of the floating window where 100 is fully transparent.
        resizing_mappings = false; -- Binds arrow keys to resizing the floating window.
        post_open_hook = nil; -- A function taking two arguments, a buffer and a window to be ran as a hook.
        references = { -- Configure the telescope UI for slowing the references cycling window.
        telescope = require("telescope.themes").get_dropdown({ hide_preview = false })
      };
      -- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
      focus_on_open = true; -- Focus the floating window when opening it.
      dismiss_on_move = false; -- Dismiss the floating window when moving the cursor.
      force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
      bufhidden = "wipe", -- the bufhidden option to set on the floating window. See :h bufhidden
      stack_floating_preview_windows = true, -- Whether to nest floating windows
      preview_window_title = { enable = true, position = "left" }, -- Whether to set the preview window title as the filename

    }
  end
},

--'ervandew/supertab',
--{ "lukas-reineke/indent-blankline.nvim" },
}
