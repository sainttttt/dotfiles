if vim.g.firstload == nil then
  require("float")
  require("comment")
  -- require("todo")

  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

  vim.g.firstload = true

  vim.g.neovide_input_macos_option_is_meta = true

  function _G.dump(o)
    if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
        if type(k) ~= 'number' then k = '"'..k..'"' end
        s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
    else
      return tostring(o)
    end
  end

  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end


  function _G.zen()
    require("zen-mode").toggle({
      window = {
        width = .5, -- width will be 85% of the editor width,
        height = .5 -- width will be 85% of the editor width
      }
    })
  end


  vim.opt.rtp:prepend(lazypath)
  vim.g.mapleader = "`" -- Make sure to set `mapleader` before lazy so your mappings are correct

  require("lazy").setup("plugins", {
    change_detection = {
      notify = false,
    },
  })


  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1


  function _G.set_terminal_keymaps()
    local opts = {buffer = 0}

    local map = vim.fn.maparg("<C-j>", "t")
    if map == "" then
      vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
    end

    map = vim.fn.maparg("<C-k>", "t")
    if map == "" then
      vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
    end

    -- vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
    -- vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
    -- vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
    -- vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
    vim.keymap.set('t', '<C-]>', '<C-\\><C-n>', opts)
    vim.keymap.set('t', '<leader>rr', '<C-c>', opts)
    vim.keymap.set('t', '<leader>re',  "<cmd>lua codeRun({fileRun = true})<CR>", opts)
    if require'toggleterm' then
      vim.keymap.set('t', '<m-Z>', TermToggle, opts)
    end
  end

  vim.keymap.set("n",    "<leader>cc",
    function()
      local result = vim.treesitter.get_captures_at_cursor(0)
      print(vim.inspect(result))
    end,
    { noremap = true, silent = false }
  )

  vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

  -- You will likely want to reduce updatetime which affects CursorHold
  -- note: this setting is global and should be set only once
  vim.o.updatetime = 750
  -- vim.cmd [[autocmd! CursorHold,CursorHoldI * Lspsaga show_cursor_diagnostics ++unfocus]]

  -- Mappings.
  -- See `:help vim.diagnostic.*` for documentation on any of the below functions
  local opts = { noremap=true, silent=true }

  -- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  -- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)


  function show_line_diagnostics()
    if vim.g.lsp_enabled then
      vim.cmd [[Lspsaga show_cursor_diagnostics ++unfocus]]
    end
  end

  vim.g.lsp_enabled = true
  function _G.LspSwap()
    vim.cmd [[lua close_floating()]]
    vim.g.lsp_enabled = not vim.g.lsp_enabled
  end

  vim.keymap.set("n", "<leader>lq", "<cmd>lua LspSwap()<CR>", {noremap=true})
  vim.keymap.set("n", "<leader>lm", "<cmd>lua LspSwap()<CR>", {noremap=true})

  --require'lspconfig'.clangd.setup{}

  -- local check_function = function(bufnr, _)
  --     local ok, result = pcall(vim.api.nvim_buf_get_var, bufnr, 'lsp_enabled')
  --     -- No buffer local variable set, so just enable by default
  --     if not ok then
  --         return true
  --     end

  --     return result
  -- end
  --
  -- function _G.luaReload(name)
  --   require("plenary.reload").reload_module(name)
  --   require(name)
  --   print ('reloaded: ' .. name)
  -- end

  vim.keymap.set("n", "<leader>qq", "<cmd>Lazy reload plugin lucy.nvim<CR>", {noremap=true})

  -- local bufopts = { noremap=true, silent=true }
  -- vim.keymap.set('n', '<leader>l', ':LspRestart<CR>', bufopts)


  vim.diagnostic.config({
    virtual_text = false, -- Turn off inline diagnostics
    underline = true,
    update_in_insert = false,
    signs = false, -- Turn off inline diagnostics
    float = false,
  })

  -- -- Use this if you want it to automatically show all diagnostics on the
  -- -- current line in a floating window. Personally, I find this a bit
  -- -- distracting and prefer to manually trigger it (see below). The
  -- -- CursorHold event happens when after `updatetime` milliseconds. The
  -- -- default is 4000 which is much too long
  -- vim.cmd('autocmd CursorHold * lua vim.diagnostic.open_float()')
  -- vim.o.updatetime = 300

  -- -- Show all diagnostics on current line in floating window
  -- vim.api.nvim_set_keymap(
  --   'n', '<Leader>d', ':lua vim.diagnostic.open_float()<CR>',
  --   { noremap = true, silent = true }
  -- )
  -- -- Go to next diagnostic (if there are multiple on the same line, only shows
  -- -- one at a time in the floating window)
  -- vim.api.nvim_set_keymap(
  --   'n', '<Leader>n', ':lua vim.diagnostic.goto_next()<CR>',
  --   { noremap = true, silent = true }
  -- )
  -- -- Go to prev diagnostic (if there are multiple on the same line, only shows
  -- -- one at a time in the floating window)
  -- vim.api.nvim_set_keymap(
  --   'n', '<Leader>p', ':lua vim.diagnostic.goto_prev()<CR>',
  --   { noremap = true, silent = true }
  -- )


  function _G.close_floating()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local config = vim.api.nvim_win_get_config(win)
      if config.relative ~= "" then
        vim.api.nvim_win_close(win, false)
      end
    end
  end


  -- require('mini.sessions').write('default')

  -- vim.ui.select = require"popui.ui-overrider"
  -- vim.ui.input = require"popui.input-overrider"
  -- vim.api.nvim_set_keymap("n", ",d", ':lua require"popui.diagnostics-navigator"()<CR>', { noremap = true, silent = true })
  -- vim.api.nvim_set_keymap("n", ",m", ':lua require"popui.marks-manager"()<CR>', { noremap = true, silent = true })
  -- vim.api.nvim_set_keymap("n", ",tr", ':lua require"popui.references-navigator"()<CR>', { noremap = true, silent = true })
  --
  --
  -- vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>",
  -- {silent = true, noremap = true}
  -- )
  -- vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>",
  -- {silent = true, noremap = true}
  -- )
  -- vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>",
  -- {silent = true, noremap = true}
  -- )
  -- vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>",
  -- {silent = true, noremap = true}
  -- )
  -- vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",
  -- {silent = true, noremap = true}
  -- )
  -- vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>",
  -- {silent = true, noremap = true}
  -- )

  ---
  --
  Last_coderun = ""
  function _G.codeRun(opts)
    vim.cmd ("up")
    local buf = vim.api.nvim_get_current_buf()
    local ft = vim.api.nvim_get_option_value("filetype", {buf = buf})

    if ft == "swift" or ft == "xclog" then
      XbaseBuildDefault()
    else
      local proj_cmd = require("code_runner.commands").get_project_command()
      local file_cmd = require("code_runner.commands").get_filetype_command()
      local command_to_run = ""

      if Last_coderun ~= "" then
        -- print("here")
        vim.cmd('TermExec cmd=""')
      end

      if opts['fileRun'] then
        command_to_run = file_cmd
      elseif proj_cmd ~= nil then
        -- vim.cmd("RunProject")
        command_to_run = proj_cmd["command"]
      elseif file_cmd ~= "" then
        command_to_run = file_cmd
      elseif Last_coderun ~= "" then
        -- print(Last_coderun)
        command_to_run = Last_coderun
      else
        return
      end
      Last_coderun = command_to_run
      -- print(command_to_run)
      vim.cmd(string.format('TermExec cmd="%s"', command_to_run))

    end
  end

  function _G.codeRunFile()
    local file_cmd = require("code_runner.commands").get_filetype_command()
    vim.cmd('TermExec cmd=""')
    vim.cmd(string.format('TermExec cmd="%s"', command_to_run))
  end


  vim.keymap.set("n", "<leader>rr", "<cmd>lua codeRun()<CR>", {silent = true, noremap = true})
  vim.keymap.set("n", "<leader>re", "<cmd>lua codeRun({fileRun = true})<CR>", {silent = true, noremap = true})



  vim.api.nvim_set_hl(0, "StatusLine", {reverse = false})
  vim.api.nvim_set_hl(0, "StatusLineNC", {reverse = false})

function _G.swallow_output(callback, ...)
  local old_print = print
  print = function(...) end

  pcall(callback, arg)

  print = old_print
end


  -- Array of file names indicating root directory. Modify to your liking.

  local override_root_names  = { '.proot'}

  local root_names = { '.root',
    '.git',
    'project.toml',
    ".clang-format",
    "pyproject.toml",
    "setup.py",
    "LICENSE",
    "README.md",
    'Makefile' }

  -- Cache to use for speed up (at cost of possibly outdated results)
  local root_cache = {}

  function string.starts(String,Start)
    return string.sub(String,1,string.len(Start))==Start
  end

  local set_root = function()
    if vim.bo.filetype == '' or vim.bo.filetype == 'oil' then
      return
    end
    -- Get directory path to start search from
    local path = vim.api.nvim_buf_get_name(0)
    path = vim.fs.dirname(path)

    -- Try cache and resort to searching upward for root directory
    local root = root_cache[path]

    local obsidian_root =  vim.fn.expand "~/Library/Mobile Documents/iCloud~md~obsidian/"
    if root == nil then
      if string.starts(path, obsidian_root) then
        root = vim.fs.dirname(path)
      else
        local root_file = vim.fs.find(root_names, { path = path, upward = true })[1]

        local override_root_file = vim.fs.find(override_root_names, { path = path, upward = true })[1]
        root_file = override_root_file or root_file
        if root_file == nil then
          root = path
        else
          root = vim.fs.dirname(root_file)
          root_cache[path] = root
        end
      end
    end

    -- Set current directory
    if root ~= nil and not string.starts(root, "term://") then
      vim.fn.chdir(root)
      -- vim.o.shadafile = root .. '/.vim/main.shada'
    end
  end

  local root_augroup = vim.api.nvim_create_augroup('MyAutoRoot', {})
  vim.api.nvim_create_autocmd({'BufReadPost', "BufEnter", "VimEnter"} , { group = root_augroup, callback = function() swallow_output(function() set_root() end) end})


  local pre_write = function()
    require('mini.trailspace').trim()
  end

  local bufwrite_augroup = vim.api.nvim_create_augroup('', {})
  vim.api.nvim_create_autocmd({'BufWrite'} , { group = bufwrite_augroup, callback = pre_write })


  function _G.duplicate(comment)
    local vstart = vim.fn.getpos('v')[2]
    local vend = vim.fn.getpos('.')[2]

    if vend == vstart then
      if comment then
        vim.cmd("normal YVgcp")
      else
        vim.cmd("normal! Yp")
      end
      return
    end

    if vend < vstart then
      vend, vstart = vstart, vend -- swap
    end

    vim.cmd("normal! y ")
    if comment then
      vim.cmd("normal! " .. vstart .. "G")
      vim.cmd("normal! V")
      vim.cmd("normal! " .. vend .. "G")
      vim.cmd("normal gc")
    end


    vim.cmd("normal! " .. vend .. "G")
    vim.cmd("normal! j")
    vim.cmd("normal! O")
    vim.cmd("normal! p")
  end

  vim.keymap.set({"n", "x"}, "vs", "<cmd>lua duplicate()<CR>", {silent = true, noremap = true})
  vim.keymap.set({"n", "x"}, "vd", "<cmd>lua duplicate(true)<CR>", {silent = true, noremap = true})


  ------------------------------------

  -- TODO: open config files in a dedicated split
  -- -- Variable to store the name of the shared split buffer
  -- local shared_split_buffer = ""

  -- -- Function to open a file in the shared split if open, or open the shared split if it's not open
  -- function _G.openInSharedSplit(filename)
  --     -- If the shared split buffer is not empty and the buffer is open, open the file in that split
  --     if shared_split_buffer ~= "" and vim.fn.bufwinnr(shared_split_buffer) ~= -1 then
  --         vim.cmd('buffer ' .. filename)
  --     else
  --         -- If the shared split buffer is empty or not open, open a new shared split
  --         shared_split_buffer = filename

  --         vim.cmd('vsp ' .. filename)
  --         -- vim.cmd('buffer ' .. filename)
  --     end
  -- end


  -- vim.keymap.set('n', "<leader>vv", function() openInSharedSplit(vim.fn.expand '~/.config/nvim/init.vim' ) end)
  -- vim.keymap.set('n', "<leader>vz", function() openInSharedSplit(vim.fn.expand '~/.config/nvim/lua/plugins/init.lua') end)
  -- noremap <Leader>vv :vsp ~/.config/nvim/init.vim<CR>
  -- noremap <Leader>va :vsp ~/.config/nvim/lua/init.lua<CR>
  -- " noremap <Leader>vc :vsp ~/.config/nvim/lua/plugins/<CR>
  -- noremap <Leader>vz :vsp ~/.config/nvim/lua/plugins/init.lua<CR>
  -- " noremap <Leader>vx :vsp ~/.config/nvim/lua/<CR>
  --
  -- get contents of visual selection
  -- handle unpack deprecation
  table.unpack = table.unpack or unpack
  function get_visual()
    local _, ls, cs = table.unpack(vim.fn.getpos('v'))
    local _, le, ce = table.unpack(vim.fn.getpos('.'))
    return vim.api.nvim_buf_get_text(0, ls-1, cs-1, le-1, ce, {})
  end

  vim.keymap.set("v", "<leader>tr", function()
    local pattern = table.concat(get_visual())
    -- escape regex and line endings
    pattern = vim.fn.substitute(vim.fn.escape(pattern, "^$.*\\/~[]"),'\n', '\\n', 'g')
    -- send parsed substitution command to command line
    vim.api.nvim_input("<Esc>:%s/" .. pattern .. "//<Left>")
  end)


  function split_multiline_string(str)
    local lines = {}
    for line in str:gmatch("[^\r\n]+") do
      table.insert(lines, line)
    end
    return lines
  end

  local lazy_format = function()
    local current_line = vim.api.nvim_get_current_line()

    local repo_name = current_line:match(".*/(.*/.*)$")  -- Extract repository name from URL
    local lua_string = string.format([[
{ '%s',
    config = function()
        -- Configuration for %s
    end
},
]], repo_name, repo_name)
    lua_string = split_multiline_string(lua_string)

    -- add extra line to end to string because split removes
    -- all trailing new lines
    table.insert(lua_string, "")
    local current_line = vim.api.nvim_win_get_cursor(0)[1]
    local current_buffer = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_lines(current_buffer, current_line - 1, current_line, false, lua_string)
  end

  vim.keymap.set({"x", "n"}, "<leader>ww", lazy_format)

  -- use command +/- to change font size in neovide
  function _G.changeGuiFontSize(decrease)
    local guifont = vim.o.guifont
    local currentFontSize = nil
    for v in string.gmatch(guifont, ":h(.*)") do
      currentFontSize = v
      break
    end
    if not decrease then
      currentFontSize = currentFontSize + 1
    else
      currentFontSize = currentFontSize - 1
    end
    vim.o.guifont = guifont:gsub(":h.*",":h"..currentFontSize)
  end

  function _G.saveSessionQuit(decrease)
    if vim.bo.filetype ~= "alpha" then
      require('mini.sessions').write('main')
    end
  end

  vim.keymap.set({"n", "x"}, "<D-=>", "<cmd>lua changeGuiFontSize()<CR>", {silent = true, noremap = true})
  vim.keymap.set({"n", "x"}, "<D-->", "<cmd>lua changeGuiFontSize(true)<CR>", {silent = true, noremap = true})


  -- vim.api.nvim_set_keymap('i', '<Esc>', 'd', { noremap = true, silent = true })

  -- Key:         Ctrl-e
  -- Action:      Show treesitter capture group for textobject under cursor.
  vim.keymap.set("n",    "<leader>tt",
    function()
      local result = vim.treesitter.get_captures_at_cursor(0)
      print(vim.inspect(result))
    end,
    { noremap = true, silent = false }
  )

  vim.keymap.set("n",    "<leader>we",
    function()
      print("i am here")
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
              row = "70%",
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
    end,
    { noremap = true, silent = false }
  )



  -- TSPlayground provided command. (Need to install the plugin.)
  -- bindkey("n",    "<C-e>",  ":TSHighlightCapturesUnderCursor<CR>",   opts)
  -- This was misbehaving a lot.
  -- Might be more stable now in recent treesitter versions.


  function _G.revert(decrease)
    local isMod = vim.api.nvim_buf_get_option(0, "mod")
    if isMod then
      vim.cmd([[earlier 1f]])
    end
  end

end

local function saveFile()
  vim.cmd("mkview 3")
  print("Saved")
  vim.cmd("update")
end


local function reloadFile()
  vim.cmd("edit!")
  vim.cmd("silent! loadview 3")
end

local function reloadColorScheme()
  vim.cmd("Lazy reload plugin flesh-and-blood")
  vim.cmd("Lazy reload plugin indent-blankline.nvim")
end


vim.keymap.set({"n"}, "s", saveFile, {silent = false, noremap = true})
vim.keymap.set({"n"}, "<C-r>", reloadFile, {silent = false, noremap = true})
vim.keymap.set({"n"}, "<C-n>", "<C-r>", {silent = false, noremap = true})
vim.keymap.set({"n"}, "E", "<C-r>", {silent = false, noremap = true})
vim.keymap.set({"n"}, "<leader>cs", reloadColorScheme, {silent = false, noremap = true})

local function addText(opts)
  local vstart = vim.fn.getpos('v')[2]
  local vend = vim.fn.getpos('.')[2]
  if vend < vstart then
    vend, vstart = vstart, vend -- swap
  end
  print(vend, vstart)

  -- leave visual mode
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', false, true, true), 'nx', false)
  vim.cmd("normal! ".. vstart ..'G')
  vim.cmd([[exe "norm! \<C-v>"]])
  vim.cmd("norm! " .. vend ..'G')
  if opts.dir == "pre" then
    vim.api.nvim_feedkeys("I", 'n', true)
  else
    vim.api.nvim_feedkeys("$A", 'n', true)
  end
end

vim.keymap.set({"x"}, "<Left>", function() addText({dir='pre'}) end, {silent = false, noremap = true})
vim.keymap.set({"x"}, "<Right>", function() addText({dir='post'}) end, {silent = false, noremap = true})


local function karaSearch()
  local fzf_lua = require'fzf-lua'
  local keySearch = vim.fn.input("Key: ", "", "file")
  local searchString = '"key_code": "' .. keySearch .. '"'

  fzf_lua.live_grep({ cmd = "rg2() { rg  --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e  \"$@\"; }; rg2", query = searchString })
end

vim.keymap.set({"n"}, "<leader>as", function() karaSearch() end, {silent = false, noremap = true})


-- change text object with repeat number in front of it
-- this is for when you want to use a change text object but it's not the
-- first one on the line, and you want to repeat it
-- todo: I need to extend this for all the text object shortcuts
-- that I'm currently using
vim.keymap.set('n', 'cj', function()
  local count = vim.v.count
  print(count)
  if count == 0 then count = 1 end -- default to 1 if no count given
  vim.cmd([[norm! f"]])
  for i=2,count do
    print(i)
    vim.cmd([[norm! f"]])
    vim.cmd([[norm! f"]])
  end
  vim.cmd([[norm! "_ci"]])
  vim.cmd([[stopinsert ]])
  vim.cmd([[norm! l]])
  vim.cmd([[startinsert ]])
end)

function find_buffer_by_prefix(prefix)
  -- Get a list of all window handles in the current tab
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    -- Get the buffer number displayed in the current window
    local bufnr = vim.api.nvim_win_get_buf(win)

    -- Check if the buffer is valid and loaded
    if vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_is_loaded(bufnr) then
      -- Get the name (file path) of the buffer
      local name = vim.api.nvim_buf_get_name(bufnr)

      -- Check if the buffer name starts with the given prefix
      if name and name:find(prefix, 1, true) == 1 then
        return win -- Return the window handle if it matches
      end
    end
  end
  return false -- Return false if no match is found
end

-- Example usage:
local path_prefix = "/Users/saint/code/dotfiles/nvim/"

function find_buffer()
  return find_buffer_by_prefix(path_prefix)
end

function open_file_in_window(win_id, file_path)
  -- Set the focus to the specified window
  vim.api.nvim_set_current_win(win_id)
  vim.cmd('e ' .. file_path)
end

function open_config_file_in_same_win(config_file)
  local buff_res = find_buffer()
  if buff_res then
    open_file_in_window(buff_res, config_file)
  else
    vim.cmd('vsplit ' .. config_file)
  end
end



--_ vim.keymap.set({"n"}, "<leader>vz", function() open_config_file_in_same_win(vim.fn.expand("~/.config/nvim/lua/plugins/init.lua")) end, {silent = false, noremap = true})

vim.keymap.set({"n"}, "<leader>va", function() open_config_file_in_same_win(vim.fn.expand("~/.config/nvim/lua/init.lua")) end, {silent = false, noremap = true})

vim.keymap.set({"n"}, "<leader>vv", function() open_config_file_in_same_win(vim.fn.expand("~/.config/nvim/init.vim")) end, {silent = false, noremap = true})


vim.g.markdown_folding = 1

--_ vim.api.nvim_create_autocmd("FileType", {
--_   pattern = "*",
--_   callback = function()
--_     vim.opt_local.formatoptions:remove({ "r", "o" })
--_   end,
--_ })

local function insert_newline_without_comment()
  -- Save current formatoptions
  local save_fo = vim.opt.formatoptions:get()

  -- Remove 'r' and 'o' to disable auto comment continuation temporarily
  vim.opt.formatoptions = vim.opt.formatoptions - "r" - "o"

  -- Insert a new line below the current line without entering insert mode
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("O", true, false, true), "n", false)

  -- Restore original formatoptions

  vim.schedule(function()
    vim.opt.formatoptions = save_fo
  end)
end


local function insert_newline_with_comment()
  -- Get comment leader for the current filetype
  local commentstring = vim.bo.commentstring
  if commentstring == '' then
    commentstring = '-- %s'  -- default fallback comment string
  end
  -- Extract just the leader before the %s
  local leader = commentstring:gsub('%%s*', ''):gsub('%s*$', '') .. ' '

  local save_fo = vim.opt.formatoptions:get()

  -- Remove 'r' and 'o' to disable auto comment continuation temporarily
  vim.opt.formatoptions = vim.opt.formatoptions - "r" - "o"


  -- Insert a new line and prepend leader
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("O" .. leader, true, false, true), "n", false)

  vim.schedule(function()
    vim.opt.formatoptions = save_fo
  end)
end

vim.keymap.set({"n"}, "O", insert_newline_without_comment, {silent = false, noremap = true})
vim.keymap.set({"n"}, "<M-O>", insert_newline_with_comment, {silent = false, noremap = true})
