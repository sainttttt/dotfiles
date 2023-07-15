local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local cmp = require('cmp')



cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  -- confirmation = { completeopt = 'menuone,menu,noinsert' },
  completion = {
    completeopt = 'menu'
  },
  preselect = cmp.PreselectMode.Item,


  mapping = {
    -- ... Your other mappings ...

    ["<Tab>"] = cmp.mapping(function(fallback)

      if cmp.visible() then
        cmp.select_next_item()
      else
        cmp.complete()
        local next = 1
        cmp.event:on ("menu_opened", function(view)
          if next == 1 then
            next = 0
            view.my:select_next_item({})
          end
        end)
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
  completion = {
    autocomplete = {
      false
    },
  },


  sources = cmp.config.sources(

  {
    { name = 'buffer' },
    -- { name = 'nvim_lsp' },
    -- { name = 'vsnip' }, -- for vsnip users.
  }
  -- {
  --   { name = 'buffer' },
  --   { name = 'nvim_lsp' },
  --   { name = 'vsnip' }, -- for vsnip users.
  --   -- { name = 'luasnip' }, -- For luasnip users.
  --   -- { name = 'ultisnips' }, -- For ultisnips users.
  --   -- { name = 'snippy' }, -- For snippy users.
  -- }
  )
})


  cmp.setup {
    sources = {
      {
        name = 'buffer',
        option = {
          get_bufnrs = function()
            return vim.api.nvim_list_bufs()
          end
        }
      }
    }
  }

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- cmp.completion.autocomplete  = false

  -- -- Set up lspconfig.
  -- local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  -- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
  --   capabilities = capabilities
  -- }
