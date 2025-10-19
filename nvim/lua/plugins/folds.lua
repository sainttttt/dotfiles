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


      local function get_comment_folds(bufnr)
        local comment_folds = {}
        local line_count = vim.api.nvim_buf_line_count(bufnr)
        local is_in_comment = false
        local comment_start = 0

        for i = 0, line_count - 1 do
          local line = vim.api.nvim_buf_get_lines(bufnr, i, i + 1, false)[1]
          if not is_in_comment and line:match('^%s*' .. vim.o.commentstring:sub(1, 1)) then
            is_in_comment = true
            comment_start = i
          elseif is_in_comment and not line:match('^%s*' .. vim.o.commentstring:sub(1, 1)) then
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
        local comment_folds = get_comment_folds(bufnr)

        local folds = getFolds(bufnr)
        for _, fold in ipairs(comment_folds) do
          table.insert(folds, fold)
        end
        return folds
      end

      require('ufo').setup({
        provider_selector = function(bufnr, filetype, buftype)
          -- return ftMap[filetype] or {'treesitter', 'indent'}
          return all_folds_and_comment_folding
        end
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
          hOnlyOpensOnFirstColumn = true
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
      vim.keymap.set({'n'}, 'vR',  require('fold-cycle').close_all, { noremap = true, silent = true })
      vim.keymap.set({'n'}, 've',  require('fold-cycle').open, { noremap = true, silent = true })
      vim.keymap.set({'n'}, 'vE',  require('fold-cycle').open_all, { noremap = true, silent = true })

      -- vim.keymap.set({'n'}, 'vj',  require('fold-cycle').close, { noremap = true, silent = true })
      -- vim.keymap.set({'n'}, 'vJ',  require('fold-cycle').close_all, { noremap = true, silent = true })
      -- vim.keymap.set({'n'}, 'vk',  require('fold-cycle').open, { noremap = true, silent = true })
      -- vim.keymap.set({'n'}, 'vK',  require('fold-cycle').open_all, { noremap = true, silent = true })
    end
  },
}

