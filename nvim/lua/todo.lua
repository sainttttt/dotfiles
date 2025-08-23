-- Place this in your init.lua or a related file

---Searches for a target string in a file. If found, it appends a new string
---after it. If not found, it appends both strings to the end of the file.
---All operations are performed on a background buffer.
---
---@param filename string The path to the file to modify.
---@param target_text string The text to search for.
---@param text_to_append string The text to append.
local function find_and_append_in_background(filename, target_text, text_to_append)
  -- 1. Get a buffer for the file, creating one if it doesn't exist.
  local bufnr = vim.fn.bufnr(filename, true)
  if bufnr == -1 then
    print("Error: Could not create or find a buffer for " .. filename)
    return
  end

  -- -- 2. Manually load the file's content into the buffer for compatibility.
  -- -- This replaces the nvim_buf_load() call.
  -- local file_content = vim.fn.readfile(filename)
  -- if file_content then
  --   -- The `false` argument means the lines are not followed by a newline.
  --   vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, file_content)
  -- end

  -- 3. Search for the target text within the now-loaded buffer.
  local pos = vim.fn.searchpos(target_text, 'nW', bufnr)
  local lnum = pos[1] -- Line number of the match (0 if not found)

  -- 4. Check if the target text was found and act accordingly.
  if lnum > 0 then
    -- CASE 1: Target text FOUND. Append the new text after the match.
    vim.api.nvim_buf_set_lines(bufnr, lnum, lnum, false, {text_to_append})
    print("Found '" .. target_text .. "'. Appended new text in " .. filename)
  else
    -- CASE 2: Target text NOT FOUND. Append both texts to the end.
    local last_line = vim.api.nvim_buf_line_count(bufnr)
    vim.api.nvim_buf_set_lines(bufnr, last_line, last_line, false, {target_text, text_to_append})
    print("'" .. target_text .. "' not found. Appended both texts to the end of " .. filename)
  end

  -- To save the changes to disk, you still need to explicitly write the buffer:
  -- vim.api.nvim_buf_call(bufnr, function() vim.cmd('write') end)
end

local function jump_to_less_indent()
  local lineText = vim.api.nvim_get_current_line()
  local headers = {}
  local prev_line = -1
  local current_line = -2
  while current_line ~= prev_line do
    if prev_line ~= -1 then
      local line = vim.api.nvim_get_current_line()
      table.insert(headers, line)
    end
    prev_line = vim.api.nvim_win_get_cursor(0)[1]
    require("vindent-core").Motion("prev", true, "less", "n", 1)
    current_line = vim.api.nvim_win_get_cursor(0)[1]
  end
  print(dump(headers))
  find_and_append_in_background("/Users/saint/foo.md", headers[1], lineText)
end

vim.keymap.set('n', '<leader>kk', jump_to_less_indent, { desc = "Jump to previous line with less indentation" })


vim.keymap.set('n', '<leader>kl', jump_to_less_indent, { desc = "Jump to previous line with less indentation" })
-- --- --- ---
-- Example Usage
-- --- --- ---

-- Imagine you have a file "config.txt" with the content:
-- setting_a = 1
-- setting_b = 2

-- Scenario 1: The target text exists.
-- find_and_append_in_background("config.txt", "setting_a", "# This is a comment for setting_a")
-- Resulting buffer content for "config.txt":
-- setting_a = 1
-- # This is a comment for setting_a
-- setting_b = 2

-- Scenario 2: The target text does NOT exist.
-- find_and_append_in_background("config.txt", "setting_c", "setting_c = 3")
-- Resulting buffer content for "config.txt" (assuming the previous change was saved):
-- setting_a = 1
-- # This is a comment for setting_a
-- setting_b = 2
-- setting_c
-- setting_c = 3

