
-- local function disable_comment()
--   local MiniComment = require('mini.comment')
--   local original = vim.bo.commentstring
--
--   -- Create new commentstring with '_' before %s
--   print(original)
--   local modified = original:gsub(" %%s", "_ %%s")
--   print(modified)
--   vim.bo.commentstring = modified
--   MiniComment.config.options.custom_commentstring = function() return modified end
--
--   vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(MiniComment.operator(), true, false, true), 'n', false)
--   vim.schedule(function()
--     -- This runs after the mapped command is executed
--     vim.bo.commentstring = original
--     MiniComment.config.options.custom_commentstring = function() return original end
--   end)
-- end

local function disable_comment()
  local MiniComment = require('mini.comment')
  local original = vim.bo.commentstring

  -- Create new commentstring with '_' before %s
  local modified = original:gsub(" %%s", "_ %%s")
  vim.bo.commentstring = modified
  MiniComment.config.options.custom_commentstring = function() return modified end

  -- Check if we're in visual mode
  local mode = vim.fn.mode()
  if mode == 'v' or mode == 'V' or mode == '\22' then  -- \22 is Ctrl-V (visual block)
    -- Get visual range
    local start_pos = vim.fn.getpos('v')[2]
    local end_pos = vim.fn.getpos('.')[2]

    -- Ensure start is before end
    local start_line = math.min(start_pos, end_pos)
    local end_line = math.max(start_pos, end_pos)

    -- Comment with modified commentstring
    MiniComment.toggle_lines(start_line, end_line)

    -- Restore original
    vim.bo.commentstring = original
  else
    -- Not in visual mode, use current line
    local current_line = vim.fn.line('.')
    MiniComment.toggle_lines(current_line, current_line)

    -- Restore original
    vim.bo.commentstring = original
    MiniComment.config.options.custom_commentstring = function() return original end

  end

  -- exit visual mode
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
end


local function convert_to_disabled_comment()
  local MiniComment = require('mini.comment')
  local original = vim.bo.commentstring

  -- Get visual range while still in visual mode
  local start_pos = vim.fn.getpos('v')[2]  -- line number from position
  local end_pos = vim.fn.getpos('.')[2]

  -- Ensure start is before end (selection can go backwards)
  local start_line = math.min(start_pos, end_pos)
  local end_line = math.max(start_pos, end_pos)

  print(start_line, end_line)
  -- First uncomment with normal commentstring
  MiniComment.toggle_lines(start_line, end_line)

  -- Then comment with modified commentstring
  local modified = original:gsub(" %%s", "_ %%s")
  vim.bo.commentstring = modified

  MiniComment.config.options.custom_commentstring = function() return modified end
  MiniComment.toggle_lines(start_line, end_line)

  vim.bo.commentstring = original
  MiniComment.config.options.custom_commentstring = function() return original end


  -- exit visual mode
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)

end

vim.keymap.set({"x"}, "f", disable_comment, {silent = false, noremap = true})
vim.keymap.set({"x"}, "F", disable_comment, {silent = false, noremap = true})

vim.keymap.set({"x"}, "av", disable_comment, {silent = false, noremap = true})
vim.keymap.set({"n"}, "av", disable_comment, {silent = false, noremap = true})

vim.cmd([[
  nn aV gc
  xn aV gc
]])

-- vim.keymap.set({"x"}, "gc", disable_comment, {silent = false, noremap = false})
-- vim.keymap.set({"n"}, "gc", disable_comment, {silent = false, noremap = false})

vim.keymap.set({"x"}, "B", convert_to_disabled_comment, {silent = false, noremap = true})
