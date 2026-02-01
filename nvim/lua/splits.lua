-- Move current window to be the leftmost *editor* split, while keeping NvimTree on the far left.
local function find_nvim_tree_win()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "NvimTree" then
      return win
    end
  end
end

local function move_split_left_of_tree()
  local curwin = vim.api.nvim_get_current_win()
  local treewin = find_nvim_tree_win()

  -- If tree isn't open (or you're in it), just do the normal "move far left".
  if not treewin or curwin == treewin then
    vim.cmd("wincmd H")
    return
  end

  -- Move current split to far left...
  vim.cmd("wincmd H")

  -- ...then put the tree back on the far left.
  if vim.api.nvim_win_is_valid(treewin) then
    vim.api.nvim_set_current_win(treewin)
    vim.cmd("wincmd H")
  end

  -- Restore focus to your original window.
  if vim.api.nvim_win_is_valid(curwin) then
    vim.api.nvim_set_current_win(curwin)
  end
end

vim.keymap.set("n", "<leader>H", move_split_left_of_tree, {
  desc = "Move split left (keep NvimTree left)",
  silent = true,
})
