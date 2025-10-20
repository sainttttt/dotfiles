-- dailies root path
local dailies_root = "/Users/saint/Library/Mobile Documents/iCloud~md~obsidian/Documents/DAY"

-- the filename of the daily filename
local daily_filename = string.format("%s/%s-daily.md", dailies_root, os.date("%Y-%m-%d"))


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

  if cursor == (#lines + 1) and cursor ~= 1 then
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

local function complete_todo()
  -- this is the line that we're gonna insert as the task done
  -- todo: can we expand this for multi line tasks?
  -- for the time let's just stick to one line tasks
  local line_text = vim.api.nvim_get_current_line()

  local orig_line = vim.api.nvim_win_get_cursor(0)
  print("orign lne")
  print(orig_line)

  -- the list of sub headers of the tasks which we will
  -- insert into the daily file
  local headers = {}

  local prev_line = -1
  local current_line = -2
  while current_line ~= prev_line do
    if prev_line ~= -1 then
      local line = vim.api.nvim_get_current_line()
      table.insert(headers, line)
    end
    prev_line = vim.api.nvim_win_get_cursor(0)[1]

    -- This is the vindent.nvim dependecy, maybe this can be
    -- deprecated in the future, like rip it out of the library
    -- or write our own? Not sure
    require("vindent-core").Motion("prev", true, "less", "n", 1)
    current_line = vim.api.nvim_win_get_cursor(0)[1]
  end

  -- we have to reverse the list of headers we get to write it properly
  -- nothing weird really lol
  reverse_in_place(headers)

  create_blank_if_not_exists(daily_filename)
  insert_at_final_match_or_add_missing(headers, line_text, daily_filename)

  vim.api.nvim_win_set_cursor(0, orig_line)

  vim.api.nvim_feedkeys("dd", "n", false)
end

vim.keymap.set('n', '<leader>kk', complete_todo, { desc = "Jump to previous line with less indentation" })

