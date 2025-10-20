function reverse_in_place(list)
    local n = #list
    for i = 1, math.floor(n / 2) do
        list[i], list[n - i + 1] = list[n - i + 1], list[i]
    end
end

function create_blank_if_not_exists(filename)
    local f = io.open(filename, "r")
    if not f then
        -- File doesn't exist, so create it:
        f = io.open(filename, "w")
        if f then f:close() end
    else
        -- File exists, just close the handle
        f:close()
    end
end

create_blank_if_not_exists("somefile.txt")

local function insert_at_final_match_or_add_missing(string_list, new_line, filename)
  -- Read the file into lines
  local lines = {}
  for line in io.lines(filename) do
    table.insert(lines, line)
  end

  local cursor = 1
  local missing = {}
  local last_match = #lines

  -- Step through each search string, updating "cursor"
  for _, search_str in ipairs(string_list) do
    local found = false
    while cursor <= #lines do
      if lines[cursor]:find(search_str, 1, true) then
        found = true
        last_match = cursor
        break
      end
      cursor = cursor + 1
    end
    if found then
      cursor = cursor + 1 -- Move cursor past the match
    else
      table.insert(missing, search_str)
      -- Don't advance cursor if not found, so inserted lines will be together
    end
  end

  cursor = last_match + 1


  print("here")
  print(cursor)
  -- print(#lines + 1)
  print("here2")

  if cursor == (#lines + 1) and cursor ~= 1 then
    print("hereeeee")
    table.insert(lines, cursor, "\n")
    cursor = cursor + 1
  end

  -- Insert any missing lines right before new_line
  for i, str in ipairs(missing) do
    table.insert(lines, cursor + i - 1, str)
  end
  table.insert(lines, cursor + #missing, new_line)

  -- Write modified lines back to file
  local file = io.open(filename, "w")
  if not file then error("Cannot open file for writing: " .. filename) end
  for _, line in ipairs(lines) do
    file:write(line .. "\n")
  end
  file:close()
end

local function insert_at_final_match(string_list, new_line, filename)
  -- Read the file into a lines table
  local lines = {}
  for line in io.lines(filename) do
    table.insert(lines, line)
  end

  -- Start from beginning, searching for each string in order
  local cursor = 1
  for _, search_str in ipairs(string_list) do
    local found = false
    while cursor <= #lines do
      if lines[cursor]:find(search_str, 1, true) then
        found = true
        break
      end
      cursor = cursor + 1
    end
    if not found then
      error("String not found: " .. search_str)
    end
    -- move cursor to the line after the match for next search
    cursor = cursor + 1
  end

  -- Insert new_line at cursor position
  table.insert(lines, cursor, new_line)

  -- Write back to file
  local file = io.open(filename, "w")
  if not file then error("Cannot open file for writing: " .. filename) end
  for _, line in ipairs(lines) do
    file:write(line .. "\n")
  end
  file:close()
end


local dailies_root = "/Users/saint/Library/Mobile Documents/iCloud~md~obsidian/Documents/DAY"


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
  reverse_in_place(headers)



  local daily_filename = string.format("%s/%s-daily.md", dailies_root, os.date("%Y-%m-%d"))
  create_blank_if_not_exists(daily_filename)
  insert_at_final_match_or_add_missing(headers, lineText, daily_filename)
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

