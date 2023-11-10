vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.o.foldlevelstart = -1
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"

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

vim.keymap.set('n', 'z;', function() foldcus.fold(4)   end, NS)

vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = "," -- Make sure to set `mapleader` before lazy so your mappings are correct

require("lazy").setup("plugins")


vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

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
    vim.keymap.set('t', '<m-b>', TermToggle, opts)
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

local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
parser_configs.nim = {
  install_info = {
    url = "~/code/tree-sitter-nim", -- or where ever you cloned the repo to
    files = { "src/parser.c", "src/scanner.cc"}
  },
}

-- vim.treesitter.language.add('nim', { path = "/Users/saint/code/tree-sitter-nim/scanner.so"})
-- vim.treesitter.language.add('nim', { path = "/Users/saint/code/alaviss-tree-sitter-nim/parser.so"})


-- function _G.searchXForward()
--   local succ = pcall(
--   function()
--     vim.api.nvim_command("call searchx#start({ 'dir': 1 })")
--   end)
--   if not succ then
--     vim.api.nvim_feedkeys("/", 'n', false)
--   end
-- end

-- function _G.searchXBackward()
--   local succ = pcall(function()
--     vim.api.nvim_command("call searchx#start({ 'dir': 0 })")
--   end)
--   if not succ then
--     vim.api.nvim_feedkeys("?", 'n', false)
--   end
-- end


-- require('mini.sessions').setup({
--   autoread = false,
--   autowrite = true,
--   directory = "~/.local/share/nvim/sessions",
-- })

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
