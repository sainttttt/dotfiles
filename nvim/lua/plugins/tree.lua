return {
  {'b0o/nvim-tree-preview.lua',
    dependencies = {
      'nvim-lua/plenary.nvim',
      '3rd/image.nvim', -- Optional, for previewing images
    },
    config = function()
      -- Default config:
      require('nvim-tree-preview').setup {
        -- Keymaps for the preview window (does not apply to the tree window).
        -- Keymaps can be a string (vimscript command), a function, or a table.
        --
        -- If a function is provided:
        --   When the keymap is invoked, the function is called.
        --   It will be passed a single argument, which is a table of the following form:
        --     {
        --       node: NvimTreeNode|NvimTreeRootNode, -- The tree node under the cursor
        --     }
        --   See the type definitions in `lua/nvim-tree-preview/types.lua` for a description
        --   of the fields in the table.
        --
        -- If a table, it must contain either an 'action' or 'open' key:
        --   Actions:
        --     { action = 'close', unwatch? = false, focus_tree? = true }
        --     { action = 'toggle_focus' }
        --     { action = 'select_node', target: 'next'|'prev' }
        --
        --   Open modes:
        --     { open = 'edit' }
        --     { open = 'tab' }
        --     { open = 'vertical' }
        --     { open = 'horizontal' }
        --
        -- To disable a default keymap, set it to false.
        -- All keymaps are set in normal mode. Other modes are not currently supported.
        keymaps = {
          ['<Esc>'] = { action = 'close', unwatch = true },
          ['<Tab>'] = { action = 'toggle_focus' },
          ['<CR>'] = { open = 'edit' },
          ['<C-t>'] = { open = 'tab' },
          ['<C-v>'] = { open = 'vertical' },
          ['<C-x>'] = { open = 'horizontal' },
          ['<C-n>'] = { action = 'select_node', target = 'next' },
          ['<C-p>'] = { action = 'select_node', target = 'prev' },
        },
        min_width = 10,
        min_height = 5,
        max_width = 85,
        max_height = 25,
        wrap = false, -- Whether to wrap lines in the preview window
        border = 'rounded', -- Border style for the preview window
        zindex = 100, -- Stacking order. Increase if the preview window is shown below other windows.
        show_title = true, -- Whether to show the file name as the title of the preview window
        title_pos = 'top-left', -- top-left|top-center|top-right|bottom-left|bottom-center|bottom-right
        title_format = ' %s ',
        follow_links = true, -- Whether to follow symlinks when previewing files
        -- win_position: { row?: number|function, col?: number|function }
        -- Position of the preview window relative to the tree window.
        -- If not specified, the position is automatically calculated.
        -- Functions receive (tree_win, size) parameters and must return a number, where:
        --   tree_win: number - tree window handle
        --   size: {width: number, height: number} - dimensions of the preview window
        -- Example:
        --   win_position = {
        --    col = function(tree_win, size)
        --      local view_side = require('nvim-tree').config.view.side
        --      return view_side == 'left' and vim.fn.winwidth(tree_win) + 1 or -size.width - 3
        --    end,
        --   },
        win_position = {},
        image_preview = {
          enable = false, -- Whether to preview images (for more info see Previewing Images section in README)
          patterns = { -- List of Lua patterns matching image file names
            '.*%.png$',
            '.*%.jpg$',
            '.*%.jpeg$',
            '.*%.gif$',
            '.*%.webp$',
            '.*%.avif$',
            -- Additional patterns:
            -- '.*%.svg$',
            -- '.*%.bmp$',
            -- '.*%.pdf$', (known to have issues)
          },
        },
        on_open = nil, -- fun(win: number, buf: number) called when the preview window is opened
        on_close = nil, -- fun() called when the preview window is closed
        watch = {
          event = 'CursorMoved' -- 'CursorMoved'|'CursorHold'. Event to use to update the preview in watch mode
        },
      }
    end
  },



  { 'nvim-tree/nvim-tree.lua',
    config = function()
      local show_tree = function()
        local nvimtree = require 'nvim-tree.view'
        if not nvimtree.is_visible() then
          vim.cmd("NvimTreeFindFile")
        else
          vim.cmd("NvimTreeClose")
        end
      end

      vim.keymap.set('n', '<C-a>', show_tree)
      vim.keymap.set('n', '<D-a>', show_tree)

      local HEIGHT_RATIO = 0.5 -- You can change this
      local WIDTH_RATIO = 0.2  -- You can change this too
      require("nvim-tree").setup({
        on_attach = function(bufnr)
          local api = require('nvim-tree.api')
          vim.keymap.set('n', 's', api.node.open.vertical, { buffer = bufnr })
          vim.keymap.set('n', 'aa', api.fs.create, { buffer = bufnr })
          vim.keymap.set('n', '<C-v>', api.node.open.vertical, { buffer = bufnr })
          vim.keymap.set('n', '<C-v>', api.node.open.vertical, { buffer = bufnr })
          vim.keymap.set('n', '<CR>', api.node.open.edit, { buffer = bufnr })
          vim.keymap.set('n', 'l', api.node.open.edit, { buffer = bufnr })
          vim.keymap.set('n', 'h', api.node.navigate.parent_close, { buffer = bufnr })
          vim.keymap.set('n', 'o', api.tree.change_root_to_node, { buffer = bufnr })
          vim.keymap.set('n', 'D', api.fs.trash, { buffer = bufnr })
          vim.keymap.set('n', 'M', api.fs.rename, { buffer = bufnr })
          vim.keymap.set('n', '<2-LeftMouse>', api.node.open.edit, { buffer = bufnr })

          local function opts(desc)
            return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end

          local preview = require('nvim-tree-preview')



          vim.keymap.set('n', 'P', preview.watch, opts 'Preview (Watch)')
          vim.keymap.set('n', '<Esc>', preview.unwatch, opts 'Close Preview/Unwatch')
          vim.keymap.set('n', '<C-f>', function() return preview.scroll(4) end, opts 'Scroll Down')
          vim.keymap.set('n', '<C-b>', function() return preview.scroll(-4) end, opts 'Scroll Up')

          -- Option A: Smart tab behavior: Only preview files, expand/collapse directories (recommended)
          vim.keymap.set('n', '<Tab>', function()
            local ok, node = pcall(api.tree.get_node_under_cursor)
            if ok and node then
              if node.type == 'directory' then
                api.node.open.edit()
              else
                preview.node(node, { toggle_focus = true })
              end
            end
          end, opts 'Preview')



        end,
        actions = {
          open_file = {
            window_picker = {
              enable = false
            }
          }
        },
        filters = {
          dotfiles = true,
        },
        view = {
          relativenumber = true,
          float = {
            enable = false,
            open_win_config = function()
              local screen_w = vim.opt.columns:get()
              local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
              local window_w = screen_w * WIDTH_RATIO
              local window_h = screen_h * HEIGHT_RATIO
              local window_w_int = math.floor(window_w)
              local window_h_int = math.floor(window_h)
              local center_x = (screen_w - window_w) / 2
              local center_y = ((vim.opt.lines:get() - window_h) / 2)
              - vim.opt.cmdheight:get()
              return {
                border = "rounded",
                relative = "editor",
                row = center_y,
                col = center_x,
                width = window_w_int,
                height = window_h_int,
              }
            end,
          },
          width = function()
            return math.max(35, math.floor(vim.opt.columns:get() * WIDTH_RATIO))
          end,
        },
        renderer = {
          icons = {
            show = {
              file = false
            }
          }
        }

      })
    end
  },
}

