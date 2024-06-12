return {

  {'kevinhwang91/nvim-ufo',
    dependencies = {'kevinhwang91/promise-async','kkharji/sqlite.lua',},
    config = function()
      vim.o.foldcolumn = '0' -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = false


       require('ufo').setup({
         provider_selector = function(bufnr, filetype, buftype)
           return {'treesitter', 'indent'}
         end
       })


      -- require('ufo').setup({
      --     provider_selector = function(bufnr, filetype, buftype)
      --         return ''
      --     end
      -- })

      -- local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- capabilities.textDocument.foldingRange = {
      --   dynamicRegistration = false,
      --   lineFoldingOnly = true
      -- }
      -- local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
      -- for _, ls in ipairs(language_servers) do
      --   require('lspconfig')[ls].setup({
      --     capabilities = capabilities
      --     -- you can add other fields for setting up lsp server in this table
      --   })
      -- end
      -- require('ufo').setup()
      -- vim.cmd("silent! loadview 1")

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

      local function openAllFolds()
        require('ufo').openAllFolds()
        incrementViewNumber()
      end

      local function closeAllFolds()
        require('ufo').closeAllFolds()
        incrementViewNumber()
      end

      local function toggleFold()
        vim.cmd("normal! za")
        incrementViewNumber()
      end

      vim.keymap.set('n', '22', toggleFold, { noremap = true, silent = true })
      vim.keymap.set({'n', 'x'}, 'R', toggleFold, { noremap = true, silent = true })

      vim.keymap.set('n', '2u', undoFold, { noremap = true, silent = true })
      vim.keymap.set('n', '2U', redoFold, { noremap = true, silent = true })

      -- vim.keymap.set('n', '2r', openAllFolds, { noremap = true, silent = true })

      -- vim.keymap.set('n', '2m', closeAllFolds,{ noremap = true, silent = true })


      -- vim.keymap.set('n', 'zr', require('ufo').openAllFolds, { noremap = true, silent = true })
      vim.keymap.set('n', '2r', require('ufo').openAllFolds, { silent = true })
      vim.keymap.set('n', '2m', require('ufo').closeAllFolds,{ silent = true })
    end
  },

  -- { 'Vonr/foldcus.nvim',
  --   dependencies = { 'nvim-treesitter/nvim-treesitter' },
  --   config = function()
  --     local foldcus = require('foldcus')
  --     local NS = { noremap = true, silent = true }

  --     local numFolds = 3

  --     -- Fold multiline comments longer than or equal to 4 lines
  --     vim.keymap.set('n', 'z;', function() foldcus.fold(numFolds)   end, NS)

  --     -- Fold multiline comments longer than or equal to the number of lines specified by args
  --     -- e.g. Foldcus 4
  --     vim.api.nvim_create_user_command('Foldcus', function(args) foldcus.fold(tonumber(args.args))   end, { nargs = '*' })

  --     -- Delete folds of multiline comments longer than or equal to 4 lines
  --     vim.keymap.set('n', 'z\'', function() foldcus.unfold(4) end, NS)

  --     -- Delete folds of multiline comments longer than or equal to the number of lines specified by args
  --     -- e.g. Unfoldcus 4
  --     vim.api.nvim_create_user_command('Unfoldcus', function(args) foldcus.unfold(tonumber(args.args)) end, { nargs = '*' })
  --   end
  -- },

  -- { "chrisgrieser/nvim-origami",
  --   event = "BufReadPost", -- later or on keypress would prevent saving folds
  --   opts = true, -- needed even when using default config
  --   config = function ()
  --     require("origami").setup ({
  --       -- keepFoldsAcrossSessions = false,
  --     }) -- setup call needed
  --   end,
  -- },

}

