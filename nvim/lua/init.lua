vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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

vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = "," -- Make sure to set `mapleader` before lazy so your mappings are correct

require('plugins')

-- vim.g.flow_strength = 0.7 -- low: 0.3, middle: 0.5, high: 0.7 (default)
-- vim.api.nvim_set_hl(0, "FSPrefix", { fg = "#cdd6f4" })
-- vim.api.nvim_set_hl(0, "FSSuffix", { fg = "#6C7086" })

vim.keymap.set("n", "gp", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", {noremap=true})


require('code_runner').setup({
  mode = "term",
  focus = false,
  startinsert = true,
  term = {
		position = "vert",
		size = 50,
	},
  filetype_path = vim.fn.expand('~/.config/nvim/code_runner.json'),
	project_path = vim.fn.expand('~/.config/nvim/projects.json')
})

-- vim.keymap.set('n', '<leader>r', ':RunCode<CR>', { noremap = true, silent = false })
vim.keymap.set('n', '<leader>rf', ':RunFile<CR>', { noremap = true, silent = false })
vim.keymap.set('n', '<leader>rp', ':RunProject<CR>', { noremap = true, silent = false })
vim.keymap.set('n', '<leader>rc', ':RunClose<CR>', { noremap = true, silent = false })
--vim.keymap.set('n', '<leader>crf', ':CRFiletype<CR>', { noremap = true, silent = false })
--vim.keymap.set('n', '<leader>crp', ':CRProjects<CR>', { noremap = true, silent = false })

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
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

-- You will likely want to reduce updatetime which affects CursorHold
-- note: this setting is global and should be set only once
vim.o.updatetime = 750
-- vim.cmd [[autocmd! CursorHold,CursorHoldI * Lspsaga show_cursor_diagnostics ++unfocus]]

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)


-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  -- vim.cmd [[autocmd! CursorHold,CursorHoldI * lua show_line_diagnostics()]]

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

-- require'lspconfig'.nimls.setup{
--     on_attach = on_attach,
-- }

require'lspconfig'.nim_langserver.setup{
    on_attach = on_attach,
}

require'lspconfig'.lua_ls.setup {
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
        disable = { "redefined-local", "missing-parameter", "redundant-parameter" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },

  },
}

local lsp_config = require('lspconfig')
require'lspconfig'.sourcekit.setup {
  on_attach = on_attach,
  -- capabilities = capabilities,
  -- cmd = { "sourcekit-lsp" },
  -- filetypes = { "swift", "c", "cpp", "objective-c", "objective-cpp" },
  -- root_dir = lsp_config.util.root_pattern("Package.swift", ".git", "*.xcodeproj")
}

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
    require("plenary.reload").reload_module(name)
    require(name)
end

-- local bufopts = { noremap=true, silent=true }
vim.keymap.set('n', '<leader>qq', ':lua luaReload("init")<CR>', bufopts)
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


local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.nim = {
  install_info = {
    url = "~/code/tree-sitter-nim", -- local path or git repo
    files = {"src/parser.c"}, -- note that some parsers also require src/scanner.c or src/scanner.cc
    -- optional entries:
    branch = "main", -- default branch in case of git repo if different from master
    generate_requires_npm = false, -- if stand-alone parser without npm dependencies
    requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
  },
  filetype = "nim", -- if filetype does not match the parser name
}


function _G.searchXForward()
  local succ = pcall(
  function()
    vim.api.nvim_command("call searchx#start({ 'dir': 1 })")
  end)
  if not succ then
    vim.api.nvim_feedkeys("/", 'n', false)
  end
end

function _G.searchXBackward()
  local succ = pcall(function()
    vim.api.nvim_command("call searchx#start({ 'dir': 0 })")
  end)
  if not succ then
    vim.api.nvim_feedkeys("?", 'n', false)
  end
end
