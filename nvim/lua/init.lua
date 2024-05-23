vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.o.foldlevelstart = -1
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"

vim.g.neovide_input_macos_alt_is_meta = true

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


-- require('portion')
-- portionSetup()

vim.api.nvim_create_augroup('folds', {
  clear = true
})


-- vim.api.nvim_create_autocmd({"BufWinLeave"}, {
--   group = "folds",
--   pattern = {"?*"},
--   callback = function()
--     vim.cmd("mkview " .. getViewNumber())
--   end
-- })

-- vim.cmd([[
-- augroup remember_folds
--   autocmd!
--   au BufWinLeave ?* mkview 1
--   au BufWinEnter ?* silent! loadview 1
-- augroup END
-- ]])


function _G.zen()
  require("zen-mode").toggle({
    window = {
      width = .5, -- width will be 85% of the editor width,
      height = .5 -- width will be 85% of the editor width
    }
  })
end


vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = "," -- Make sure to set `mapleader` before lazy so your mappings are correct

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
  if require'toggleterm' then
    vim.keymap.set('t', '<m-c>', TermToggle, opts)
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
function _G.luaReload(name)
  name  = 'yoke'
  require("plenary.reload").reload_module(name)
  require(name)
end

vim.keymap.set("n", "<leader>qq", luaReload, {noremap=true})

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
function _G.codeRun()
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
    if proj_cmd ~= nil then
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

vim.keymap.set("n", "<leader>rr", "<cmd>lua codeRun()<CR>", {silent = true, noremap = true})

vim.cmd [[colorscheme flesh-and-blood]]


-- Array of file names indicating root directory. Modify to your liking.
local root_names = { '.git',
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
  -- Get directory path to start search from
  local path = vim.api.nvim_buf_get_name(0)
  if path == '' then
    path = vim.loop.cwd()
  else
    path = vim.fs.dirname(path)
  end

  -- Try cache and resort to searching upward for root directory
  local root = root_cache[path]

  local obsidian_root =  vim.fn.expand "~/Library/Mobile Documents/iCloud~md~obsidian/"
  if root == nil then
    if string.starts(path, obsidian_root) then
      root = obsidian_root
    else
      local root_file = vim.fs.find(root_names, { path = path, upward = true })[1]
      if root_file == nil then
        root = vim.loop.cwd()
      else
        root = vim.fs.dirname(root_file)
        root_cache[path] = root
      end
    end
  end

  -- Set current directory
  vim.fn.chdir(root)
  vim.o.shadafile = root .. '/.vim/main.shada'
end

local root_augroup = vim.api.nvim_create_augroup('MyAutoRoot', {})
vim.api.nvim_create_autocmd({'BufReadPost', "BufEnter", "VimEnter"} , { group = root_augroup, callback = set_root })


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

-- vim.keymap.set({"x", "n"}, "<leader>qq", lazy_format)

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

vim.keymap.set({"n", "x"}, "<D-=>", "<cmd>lua changeGuiFontSize()<CR>", {silent = true, noremap = true})
vim.keymap.set({"n", "x"}, "<D-->", "<cmd>lua changeGuiFontSize(true)<CR>", {silent = true, noremap = true})
