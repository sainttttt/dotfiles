return {

  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/nvim-cmp',
  'hrsh7th/vim-vsnip',
  'onsails/lspkind.nvim',
  'lukas-reineke/cmp-under-comparator',

  {
    'hrsh7th/cmp-nvim-lsp',
    config = function()

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local feedkey = function(key, mode)
        print("here")
        print(key)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
      end

      local cmp = require('cmp')

      cmp.setup({
        --      snippet = {
        --        -- REQUIRED - you must specify a snippet engine
        --        expand = function(args)
        --          vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        --          -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        --          -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        --          -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        --        end,
        --      },
        --      window = {
        --        -- completion = cmp.config.window.bordered(),
        --        -- documentation = cmp.config.window.bordered(),
        --      },

        -- confirmation = { completeopt = 'menuone,menu,noinsert' },

        completion = {
          completeopt = 'noselect,menu'
        },

        -- performance = {
        --   debounce = 600,
        --   timeout = 2,
        -- },

        preselect = cmp.PreselectMode.None,

        mapping = {
          -- ... Your other mappings ...
          --
          ['`'] = cmp.mapping.complete({
            config = {
              sources = {
                { name = 'nvim_lsp', max_item_count = 15 },
              }
            }
          }),

          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif has_words_before() then
              cmp.complete()
              cmp.select_next_item()
              local next = 1
            else
              fallback()
              -- cmp.event:on ("complete_done", function(view)
              --   if next == 1 then
              --     print('callback scroll')
              --     next = 0
              --     cmp.select_next_item()
              --     -- view.my:select_next_item({})
              --   end
              -- end)
            end
            -- cmp.select_next_item()
            -- if cmp.visible() then
            --   cmp.select_next_item()
            -- elseif vim.fn["vsnip#available"](1) == 1 then
            --   feedkey("<Plug>(vsnip-expand-or-jump)", "")
            -- elseif has_words_before() then
            --   print('hs words before')
            --   cmp.complete()
            --   cmp.select_next_item()
            -- else
            --   -- fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.

            --   feedkey("<Tab>")
            -- end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_prev_item()
            elseif vim.fn["vsnip#jumpable"](-1) == 1 then
              feedkey("<Plug>(vsnip-jump-prev)", "")
            end
          end, { "i", "s" }),

          -- ... Your other mappings ...

        },
        -- completion = {
        --   autocomplete = {
        --     false
        --   },
        -- },


        sources = cmp.config.sources(
          {
            { name = 'nvim_lsp', max_item_count = 15 },
            {
              name = 'buffer', max_item_count = 15,
              -- get text from visible buffers
              --
              option = {
                get_bufnrs = function()
                  local bufs = {}
                  for _, win in ipairs(vim.api.nvim_list_wins()) do
                    bufs[vim.api.nvim_win_get_buf(win)] = true
                  end
                  return vim.tbl_keys(bufs)
                end
              }
              -- get text from all buffers
              -- option = {
              --   get_bufnrs = function()
              --     return vim.api.nvim_list_bufs()
              --   end
              -- }
            },
            -- { name = 'buffer', max_item_count = 15 },
            -- { name = 'vsnip' }, -- for vsnip users.
          }
        ),

        formatting = {
          fields = { 'abbr', 'kind', 'menu' },
          format = require('lspkind').cmp_format({
            mode = 'symbol',             -- show only symbol annotations
            maxwidth = 30,               -- prevent the popup from showing more than provided characters
            ellipsis_char = '...',       -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead
            symbol_map = {
              Value = "󰌋",
              Interface = "",
              Method = "󰊕",
              Class = "",
              Text = "",
              Snippet = "󰕣"
            }
          })
        },
        sorting = {
          comparators = {
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.offset,
            cmp.config.compare.kind,
            -- cmp.config.compare.exact,
            -- require("cmp-under-comparator").under,
          },
        },
      })

      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          {
            name = 'cmdline',
            option = {
              ignore_cmds = { 'Man', '!' }
            }
          },
          { name = 'path' },
          { name = 'buffer' }
        }),

        sorting = {
          comparators = {
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.offset,
            cmp.config.compare.kind,
            -- cmp.config.compare.exact,
            -- require("cmp-under-comparator").under,
          },
        },
      })

  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

    end
  }
}

--   -- Set configuration for specific filetype.
--   cmp.setup.filetype('gitcommit', {
--     sources = cmp.config.sources({
--       { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
--     }, {
--       { name = 'buffer' },
--     })
--   })

--   -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).

--   -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
--   -- cmp.completion.autocomplete  = false

--   -- -- Set up lspconfig.
--   -- local capabilities = require('cmp_nvim_lsp').default_capabilities()
--   -- -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
--   -- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
--   --   capabilities = capabilities
--   -- }
