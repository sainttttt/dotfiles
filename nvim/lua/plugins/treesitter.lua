return {

  { "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function ()
      local function ts_disable(_, bufnr)
        return vim.fn.wordcount()['chars'] > 10000
      end
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = { "php",
          "swift",
          "nim",
          "python",
          "css",
          "c",
          "lua",
          "vim",
          "javascript",
          "markdown",
          "markdown_inline",
          "vimdoc",
          "query",
          "html"},


        sync_install = false,
        matchup = {
          enable = true,              -- mandatory, false will disable the whole extension
          -- disable = { "swift" },  -- optional, list of language that will be disabled
          -- [options]
        },

        highlight = {
          enable = true ,
          disable = { "cmake" },
          additional_vim_regex_highlighting = {"latex"},
        },
        indent = { enable = true, disable = { "swift", "text" } },
      })

      require 'vim.treesitter.query'.set("markdown", "highlights", [[
;From MDeiml/tree-sitter-markdown
(atx_heading (inline) @text.title)
(setext_heading (paragraph) @text.title)
[
  (atx_h1_marker)
  (atx_h2_marker)
  (atx_h3_marker)
  (atx_h4_marker)
  (atx_h5_marker)
  (atx_h6_marker)
  (setext_h1_underline)
  (setext_h2_underline)
] @punctuation.special
[
  (link_title)
  (indented_code_block)
  (fenced_code_block)
] @text.literal
[
  (fenced_code_block_delimiter)
] @punctuation.delimiter
(code_fence_content) @none
[
  (link_destination)
] @text.uri
[
  (link_label)
] @text.reference
[
  (list_marker_plus)
  (list_marker_minus)
  (list_marker_star)
  (list_marker_dot)
  (list_marker_parenthesis)
  (thematic_break)
] @punctuation.special
[
  (block_continuation)
  (block_quote_marker)
] @punctuation.special
[
  (backslash_escape)
] @string.escape
]])

      require 'vim.treesitter.query'.set("markdown_inline", "highlights", [[
; From MDeiml/tree-sitter-markdown
(code_span) @markup.raw @nospell

(emphasis) @markup.italic

(strong_emphasis) @markup.strong

(strikethrough) @markup.strikethrough

(shortcut_link
  (link_text) @nospell)

[
  (backslash_escape)
  (hard_line_break)
] @string.escape



[
  (link_label)
  (link_text)
  (link_title)
  (image_description)
] @markup.link.label

(inline_link
  (link_text) @_label
  (link_destination) @_url
  (#set! @_label "url" @_url))




[
  (link_destination)
  (uri_autolink)
] @markup.link.url @nospell


]])


    end
  },

   { "kiyoon/treesitter-indent-object.nvim",
    keys = {
      {
        "ai",
        function() require'treesitter_indent_object.textobj'.select_indent_outer() end,
        mode = {"x", "o"},
        desc = "Select context-aware indent (outer)",
      },
      {
        "aI",
        function() require'treesitter_indent_object.textobj'.select_indent_outer(true) end,
        mode = {"x", "o"},
        desc = "Select context-aware indent (outer, line-wise)",
      },
      {
        "ii",
        function() require'treesitter_indent_object.textobj'.select_indent_inner() end,
        mode = {"x", "o"},
        desc = "Select context-aware indent (inner, partial range)",
      },
      {
        "iI",
        function() require'treesitter_indent_object.textobj'.select_indent_inner(true, 'V') end,
        mode = {"x", "o"},
        desc = "Select context-aware indent (inner, entire range) in line-wise visual mode",
      },
    },
  },

  {'nvim-treesitter/nvim-treesitter-context',
    config = function()
      require'treesitter-context'.setup {
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        max_lines = 6, -- How many lines the window should span. Values <= 0 mean no limit.
        min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        line_numbers = true,
        multiline_threshold = 20, -- Maximum number of lines to show for a single context
        trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
        -- Separator between context and content. Should be a single character string, like '-'.
        -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
        -- separator = '-',
        zindex = 41,
        on_attach = function()
          -- print("new attach")

          if vim.bo.filetype == "swift"
            or vim.bo.filetype == "nim"
            or vim.bo.filetype == "vim"
            or vim.fn.bufname("%") == "[Command Line]" then
            -- vim.cmd("ContextEnable")
            return false
          end
        end, -- (fun(buf: integer): boolean) return false to disable attaching
      }
    end
  },

  { "nvim-treesitter/nvim-treesitter-textobjects",
    config = function()
      require'nvim-treesitter.configs'.setup {
        textobjects = {
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = { query = "@class.outer", desc = "Next class start" },
              --
              -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queires.
              ["]o"] = "@loop.*",
              -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
              --
              -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
              -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
              ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
              ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
            -- Below will go to either the start or the end, whichever is closer.
            -- Use if you want more granular movements
            -- Make it even more gradual by adding multiple queries and regex.
            goto_next = {
              ["]d"] = "@conditional.outer",
            },
            goto_previous = {
              ["[d"] = "@conditional.outer",
            }
          },
          select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              -- You can optionally set descriptions to the mappings (used in the desc parameter of
              -- nvim_buf_set_keymap) which plugins like which-key display
              ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
              -- You can also use captures from other query groups like `locals.scm`
              ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
            },
            -- You can choose the select mode (default is charwise 'v')
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * method: eg 'v' or 'o'
            -- and should return the mode ('v', 'V', or '<c-v>') or a table
            -- mapping query_strings to modes.
            selection_modes = {
              ['@parameter.outer'] = 'v', -- charwise
              ['@function.outer'] = 'V', -- linewise
              ['@class.outer'] = '<c-v>', -- blockwise
            },
            -- If you set this to `true` (default is `false`) then any textobject is
            -- extended to include preceding or succeeding whitespace. Succeeding
            -- whitespace has priority in order to act similarly to eg the built-in
            -- `ap`.
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * selection_mode: eg 'v'
            -- and should return true of false
            include_surrounding_whitespace = true,
          },
        },
      }
    end
  },

}
