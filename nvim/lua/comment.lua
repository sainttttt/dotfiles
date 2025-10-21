local function disable_comment()
  local original = vim.bo.commentstring

  -- Create new commentstring with 'x' before %s
  print(original)
  local modified = original:gsub(" %%s", "_ %%s")
  print(modified)
  vim.bo.commentstring = modified
  -- vim.cmd [[execute "\<Plug>Commentary"]]
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes("<Plug>Commentary", true, false, true),
    "n",
    false
  )
  vim.schedule(function()
    -- This runs after the mapped command is executed
    vim.bo.commentstring = original
  end)
end

vim.keymap.set({"x"}, "F", disable_comment, {silent = false, noremap = true})
