return {

 { 'saadparwaiz1/cmp_luasnip' },

 'hrsh7th/cmp-buffer',
 'hrsh7th/cmp-path',
 'hrsh7th/cmp-cmdline',
 'hrsh7th/nvim-cmp',

 'onsails/lspkind.nvim',
 'lukas-reineke/cmp-under-comparator',
 {
   "L3MON4D3/LuaSnip",
   -- follow latest release.
   version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
   -- install jsregexp (optional!).
   build = "make install_jsregexp",
   dependencies = { "rafamadriz/friendly-snippets" },
   config = function()
     vim.cmd([[
     imap <silent><expr> <M-n> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Esc>'
     " -1 for jumping backwards.
     inoremap <silent> <M-N> <cmd>lua require'luasnip'.jump(-1)<Cr>

     snoremap <silent> <M-n> <cmd>lua require('luasnip').jump(1)<Cr>
     snoremap <silent> <M-N> <cmd>lua require('luasnip').jump(-1)<Cr>
     ]])

     -- require("luasnip.loaders.from_vscode").lazy_load()
     -- require("luasnip.loaders.from_snipmate").lazy_load()
     require("luasnip.loaders.from_snipmate").lazy_load({ paths = "./snippets" })
   end


 },

 {
   'hrsh7th/cmp-nvim-lsp',
   config = function()
     local has_words_before = function()
       unpack = unpack or table.unpack
       local line, col = unpack(vim.api.nvim_win_get_cursor(0))
       return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
     end

     local cmp = require('cmp')
     local luasnip = require("luasnip")

     -- cmp.setup.filetype({'python'}, {
     --   window = {
     --     documentation = cmp.config.disable
     --   }
     -- })


     cmp.setup({
       snippet = {
         expand = function(args)
           require 'luasnip'.lsp_expand(args.body)
         end
       },
       window = {
         documentation = cmp.config.disable
       },
       completion = {
         completeopt = 'noselect,menu',
       },


       performance = {
         timeout = 2,
       },

       preselect = cmp.PreselectMode.None,

       view = {
         docs = {
           auto_open = false,
         },
       },

       mapping = {
         ["<Tab>"] = cmp.mapping(function(fallback)
           -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
           -- that way you will only jump inside the snippet region
           if cmp.visible() then
             cmp.select_next_item()
           elseif has_words_before() then
             cmp.complete()
           else
             fallback()
           end
         end, { "i", "s" }),

         ["<S-Tab>"] = cmp.mapping(function(fallback)
           if cmp.visible() then
             cmp.select_prev_item()
           else
             fallback()
           end
         end, { "i", "s" }),

         -- ["<Tab>"] = cmp.mapping(function(fallback)
         --   if cmp.visible() then
         --     cmp.select_next_item()
         --   elseif has_words_before() then
         --     cmp.complete()
         --     cmp.select_next_item()
         --     local next = 1
         --   else
         --     fallback()
         --     -- cmp.event:on ("complete_done", function(view)
         --     --   if next == 1 then
         --     --     print('callback scroll')
         --     --     next = 0
         --     --     cmp.select_next_item()
         --     --     -- view.my:select_next_item({})
         --     --   end
         --     -- end)
         --   end
         --   -- cmp.select_next_item()
         --   -- if cmp.visible() then
         --   --   cmp.select_next_item()
         --   -- elseif vim.fn["vsnip#available"](1) == 1 then
         --   --   feedkey("<Plug>(vsnip-expand-or-jump)", "")
         --   -- elseif has_words_before() then
         --   --   print('hs words before')
         --   --   cmp.complete()
         --   --   cmp.select_next_item()
         --   -- else
         --   --   -- fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.

         --   --   feedkey("<Tab>")
         --   -- end
         -- end, { "i", "s" }),

         -- ["<S-Tab>"] = cmp.mapping(function()
         --   if cmp.visible() then
         --     cmp.select_prev_item()
         --   elseif vim.fn["vsnip#jumpable"](-1) == 1 then
         --     feedkey("<Plug>(vsnip-jump-prev)", "")
         --   end
         -- end, { "i", "s" }),

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
             name = 'buffer',
             max_item_count = 15,
             { name = 'luasnip' },
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
           mode = 'symbol',       -- show only symbol annotations
           maxwidth = 30,         -- prevent the popup from showing more than provided characters
           ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead
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
           cmp.config.compare.offset,
           cmp.config.compare.recently_used,
           cmp.config.compare.locality,
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
