return {
  { 'kevinhwang91/nvim-ufo',
    -- dir = '~/code/nvim-ufo',
    lazy = false,
    dependencies = {'kevinhwang91/promise-async','kkharji/sqlite.lua',},
    config = function()
      vim.o.foldcolumn = '0' -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      -- this loadview function is used to preserve line jumps when you open a file
      -- through ripgrep in fzf lua or something similar. it saves the line position of the
      -- file when it is opened if it is not the first line and restores it
      function _G.loadView()
        local curpos = vim.fn.getpos('.')[2]
        vim.cmd([[ silent! loadview 3 ]])

        if curpos ~= 1 then
          vim.cmd("norm! " .. curpos .. "G")
        end

        print("cat")
      end

      vim.cmd([[
       " I always have weird issues with this
       " But I hope that the timer thing works
       augroup remember_folds
       autocmd!

       " this loadview function is used to preserve line jumps when you open a file
       " through ripgrep in fzf lua or something similar. it saves the line position of the
       " file when it is opened if it is not the first line and restores it
       au BufWinEnter ?* call timer_start(500, { tid -> execute(['silent! lua loadView()'])})

       " au BufWinEnter ?* call timer_start(500, { tid -> execute(["norm! m'" , 'silent! loadview 3'])})
       augroup END
       ]])


      local function get_comment_prefix()
        local commentstring = vim.bo.commentstring

        -- Handle empty commentstring
        if commentstring == "" then
          return ""
        end

        -- Split on %s and take the first part (the prefix)
        local prefix = commentstring:match("^(.-)%%s")

        -- If no %s found, use the whole string
        if not prefix then
          prefix = commentstring
        end

        -- Trim trailing whitespace
        prefix = prefix:match("^(.-)%s*$")

        return prefix
      end

      local function get_comment_folds(bufnr)
        local comment_folds = {}
        local line_count = vim.api.nvim_buf_line_count(bufnr)
        local is_in_comment = false
        local comment_start = 0

        local comment_prefix = get_comment_prefix()
        for i = 0, line_count - 1 do
          local line = vim.api.nvim_buf_get_lines(bufnr, i, i + 1, false)[1]
          if not is_in_comment and line:match('^%s*' .. comment_prefix) then
            is_in_comment = true
            comment_start = i
          elseif is_in_comment and not line:match('^%s*' .. comment_prefix) then
            is_in_comment = false
            table.insert(comment_folds, {startLine = comment_start, endLine = i - 1})
          end
        end

        if is_in_comment then
          table.insert(comment_folds, {startLine = comment_start, endLine = line_count - 1})
        end

        return comment_folds
      end

      local function getFolds(bufnr)
        local function handleFallbackException(err, providerName)
          if type(err) == 'string' and err:match('UfoFallbackException') then
            return require('ufo').getFolds(bufnr, providerName)
          else
            return require('promise').reject(err)
          end
        end

        return require('ufo').getFolds(bufnr, 'lsp'):catch(function(err)
          return handleFallbackException(err, 'treesitter')
        end):catch(function(err)
          return handleFallbackException(err, 'indent')
        end)
      end


      local function all_folds_and_comment_folding(bufnr)

        return getFolds(bufnr)

        --_ local treesitterFolds = getFolds(bufnr)
        --_   :thenCall( function(lspFolds)
        --_   if lspFolds ~= nil then
        --_     --_ print(dump(lspFolds[1]))
        --_     return lspFolds
        --_   end
        --_
        --_
        --_     -- lspFolds might be an array of promises, not actual fold objects
        --_
        --_     -- Resolve all fold promises
        --_     --_ if not lspFolds or #lspFolds == 0 then
        --_     --_   return get_comment_folds(bufnr)
        --_     --_ end
        --_
        --_
        --_   local promise = require('promise')

            --_ -- Check if first element is a promise
            --_ if type(lspFolds[1]) == 'table' and lspFolds[1].queue then
            --_   -- Array of promises - resolve them all
            --_   return promise.all(lspFolds):thenCall(function(resolvedFolds)
            --_     vim.print("Resolved LSP fold structure:")
            --_     vim.print(resolvedFolds[1])
            --_
            --_     --_ local customFolds = getCustomCommentFolds(bufnr)
            --_     --_ local merged = vim.list_extend(resolvedFolds, customFolds)
            --_     --_
            --_     --_ table.sort(merged, function(a, b)
            --_     --_   return a.startLine < b.startLine
            --_     --_ end)
            --_
            --_     return resolvedFolds
            --_   end)
            --_ else
            --_   -- Already resolved
            --_   vim.print("LSP fold structure:")
            --_   vim.print(lspFolds[1])
            --_
            --_   --_ local customFolds = getCustomCommentFolds(bufnr)
            --_   --_ local merged = vim.list_extend(lspFolds, customFolds)
            --_   --_
            --_   --_ table.sort(merged, function(a, b)
            --_   --_   return a.startLine < b.startLine
            --_   --_ end)
            --_   --_
            --_   return lspFolds
            --_ end
          --_ end)
      end

      --_ require('ufo').setup({
      --_   provider_selector = function(bufnr, filetype, buftype)
      --_     -- return ftMap[filetype] or {'treesitter', 'indent'}
      --_     return all_folds_and_comment_folding
      --_   end
      --_ })

local ufo = require('ufo')

-- Function to detect consecutive comment blocks
local function getCommentBlockFolds(bufnr)
  local folds = {}
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  local commentstring = vim.bo[bufnr].commentstring or "# %s"
  local prefix = commentstring:match("^(.-)%%s") or commentstring
  prefix = prefix:match("^(.-)%s*$")

  local pattern = "^%s*" .. vim.pesc(prefix)
  local commentStart = nil

  for i, line in ipairs(lines) do
    local isComment = line:match(pattern) ~= nil

    if isComment then
      if not commentStart then
        commentStart = i - 1
      end
    else
      if commentStart then
        local numLines = (i - 1) - commentStart
        if numLines >= 2 then
          table.insert(folds, {
            startLine = commentStart,
            endLine = i - 2,
            kind = 'comment',
          })
        end
        commentStart = nil
      end
    end
  end

  if commentStart then
    local numLines = #lines - commentStart
    if numLines >= 2 then
      table.insert(folds, {
        startLine = commentStart,
        endLine = #lines - 1,
        kind = 'comment',
      })
    end
  end

  return folds
end

-- Handle the fallback exception
local function handleFallback(err, providerName)
  if type(err) == 'string' and err:match('UfoFallbackException') then
    return require('promise').reject(err)
  end
  return require('promise').resolve({})
end

-- Custom provider with proper fallback handling
local function customFoldProvider(bufnr)
  local commentFolds = getCommentBlockFolds(bufnr)

  -- Try LSP first
  return ufo.getFolds(bufnr, 'lsp')
    :catch(function(err)
      -- LSP not available, try treesitter
      if type(err) == 'string' and err:match('UfoFallbackException') then
        return ufo.getFolds(bufnr, 'treesitter')
      end
      return require('promise').reject(err)
    end)
    :catch(function(err)
      -- Treesitter not available, try indent
      if type(err) == 'string' and err:match('UfoFallbackException') then
        return ufo.getFolds(bufnr, 'indent')
      end
      return require('promise').reject(err)
    end)
    :thenCall(function(baseFolds)
      -- Merge with comment folds
      local allFolds = vim.list_extend(baseFolds or {}, commentFolds)

      table.sort(allFolds, function(a, b)
        return a.startLine < b.startLine
      end)

      return allFolds
    end)
    :catch(function(err)
      -- All providers failed, just use comment folds
      return commentFolds
    end)
end

-- Setup
ufo.setup({
  provider_selector = function(bufnr, filetype, buftype)
    return customFoldProvider
  end,
})


      local function lspProviderSetup()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true
        }
        local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
        for _, ls in ipairs(language_servers) do
          require('lspconfig')[ls].setup({
            capabilities = capabilities
            -- you can add other fields for setting up lsp server in this table
          })
        end
        require('ufo').setup()
      end

      -- lspProviderSetup()

      local function readAll(file)
        local f = assert(io.open(file, "rb"))
        local content = f:read("*all")
        f:close()
        return content
      end

      local function getFoldsSavePath()
        local filepath = vim.fn.expand('%:p'):gsub("/", "_"):gsub("%.","_")
        return vim.fn.expand('$HOME/.local/state/nvim/view/') ..  filepath
      end

      local function foldsUndoPath()
        local filepath = vim.fn.expand('%:p'):gsub("/", "_"):gsub("%.","_")
        return vim.fn.expand('$HOME/.local/state/nvim/view/') ..  filepath .. "_undo"
      end

      local function readFoldsStatus ()
        local filename = getFoldsSavePath() .. "_status"

        local foldStatusFile = io.open (filename, 'r')
        if foldStatusFile == nil then
          local foldStatusFile = io.open (filename, 'w')
          if foldStatusFile ~= nil then
            foldStatusFile:write(vim.json.encode({ current = 0, start = 0, last = 0 }))
            foldStatusFile:close()
          end
        end

        local foldStatusFile = io.open (filename, 'r')
        return vim.json.decode(readAll(filename))
      end

      local function writeFoldsStatus(foldsStatus)
        local filename = getFoldsSavePath() .. "_status"

        local foldStatusFile = io.open (filename, 'w')
        if foldStatusFile ~= nil then
          foldStatusFile:write(vim.json.encode(foldsStatus))
          foldStatusFile:close()
        end
      end

      local function loadCurrentFoldsSave()
        local foldsStatus = readFoldsStatus()
        vim.cmd("silent! source " .. getFoldsSavePath().. foldsStatus.current)
      end

      local function undoFold()
        local foldsStatus = readFoldsStatus()
        if foldsStatus.current == foldsStatus.start then
          print("cannot undo")
          return
        end

        foldsStatus.current = foldsStatus.current - 1
        writeFoldsStatus(foldsStatus)
        loadCurrentFoldsSave()
      end

      local function redoFold()
        local foldsStatus = readFoldsStatus()
        if foldsStatus.current == foldsStatus.last then
          print("cannot redo")
          return
        end

        foldsStatus.current = foldsStatus.current + 1
        writeFoldsStatus(foldsStatus)
        loadCurrentFoldsSave()
      end

      -- vim.api.nvim_create_autocmd({"BufRead"}, {
      --   group = "folds",
      --   pattern = {"?*"},
      --   callback = loadCurrentFoldsSave
      -- })

      local function incrementViewNumber()

        -- if vim.g.VIEW_NUMBER == nil then
        --   vim.g.VIEW_NUMBER = 0
        -- end
        -- vim.g.VIEW_NUMBER = (vim.g.VIEW_NUMBER + 1 ) % 10

        local foldsStatus = readFoldsStatus()
        local maxSteps = 10

        foldsStatus.current =  (foldsStatus.current + 1) % maxSteps
        foldsStatus.last = foldsStatus.current
        if foldsStatus.last == foldsStatus.start then
          foldsStatus.start =  (foldsStatus.start + 1) % maxSteps
        end

        writeFoldsStatus(foldsStatus)
        vim.cmd("mkview! " .. getFoldsSavePath().. foldsStatus.current)
      end

      local function saveUndo()
        vim.cmd("mkview! " .. foldsUndoPath())
      end

      local function openAllFolds()
        require('ufo').openAllFolds()
        -- incrementViewNumber()
      end

      local function closeAllFolds()
        require('ufo').closeAllFolds()
        -- incrementViewNumber()
      end

      local function toggleFold()
        vim.cmd("normal! za")
        -- incrementViewNumber()
      end

      local function openFoldRec()
        -- saveUndo()
        -- saveUndo()
        vim.cmd("normal! zA")
      end

      local function closeFoldsRec()
        vim.cmd("normal! zxzc")
      end
      local function deleteViewFolder()
        local view_folder = vim.opt.viewdir:get()
        pcall(vim.fn.delete, view_folder, "rf")
        print("Cleared View Folder")
      end

      -- vim.keymap.set('n', '22', toggleFold, { noremap = true, silent = true })
      -- vim.keymap.set({'n'}, 've', openFoldRec, { noremap = true, silent = true })
      vim.keymap.set({'x'}, 'T', function() vim.cmd('normal! zf') end, { noremap = true, silent = true })

      vim.keymap.set({'n'}, '<C-d>', function() vim.cmd('normal! za') end, { noremap = true, silent = true })
      -- vim.keymap.set({'n'}, 'T', function() vim.cmd('normal! zC') end, { noremap = true, silent = true })

      -- vim.keymap.set('n', '2e', undoFold, { noremap = true, silent = true })
      -- vim.keymap.set('n', '<leader><leader>2', deleteViewFolder, { noremap = true, })
      vim.keymap.set('n', '<leader>dv', deleteViewFolder, { noremap = true, })
      -- vim.keymap.set('n', '2E', redoFold, { noremap = true, silent = true })


      -- vim.keymap.set('n', '2r', require('ufo').openAllFolds, { silent = true })
      -- vim.keymap.set('n', '2j', require('ufo').closeFoldsWith, { silent = true })
      -- vim.keymap.set('n', '2k', require('ufo').openFoldsExceptKinds, { silent = true })

      vim.keymap.set('n', 'gj', require('ufo').closeAllFolds, { silent = true })
      vim.keymap.set('n', 'gk', require('ufo').openAllFolds, { silent = true })
      -- vim.keymap.set('n', '2m', require('ufo').closeAllFolds,{ silent = true })
    end
  },

  { "chrisgrieser/nvim-origami",
    tag = "v1.9",
    pin = true,
    event = "BufReadPost", -- later or on keypress would prevent saving folds
    opts = true, -- needed even when using default config
    config = function ()
      require("origami").setup ({
        keepFoldsAcrossSessions = false,
        foldKeymaps = {
          setup = false,
          --_ hOnlyOpensOnFirstColumn = true
        },
        setupFoldKeymaps = false,

      }) -- setup call needed
      -- vim.keymap.set("n", "<Right>", function() require("origami").l() end)
      --
      vim.keymap.set("n", "l", function() require("origami").l() end)
    end,
  },

  { 'jghauser/fold-cycle.nvim',
    config = function()
      require('fold-cycle').setup()

      vim.keymap.set({'n'}, 'vr',  require('fold-cycle').close, { noremap = true, silent = true })
      vim.keymap.set({'n'}, '<Up>',  require('fold-cycle').close_all, { noremap = true, silent = true })
      vim.keymap.set({'n'}, 've',  require('fold-cycle').open, { noremap = true, silent = true })
      vim.keymap.set({'n'}, '<Down>',  require('fold-cycle').toggle_all, { noremap = true, silent = true })

      -- vim.keymap.set({'n'}, 'vj',  require('fold-cycle').close, { noremap = true, silent = true })
      -- vim.keymap.set({'n'}, 'vJ',  require('fold-cycle').close_all, { noremap = true, silent = true })
      -- vim.keymap.set({'n'}, 'vk',  require('fold-cycle').open, { noremap = true, silent = true })
      -- vim.keymap.set({'n'}, 'vK',  require('fold-cycle').open_all, { noremap = true, silent = true })
    end
  },
}

