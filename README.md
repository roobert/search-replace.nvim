# search-replace.nvim

![a](https://user-images.githubusercontent.com/226654/210119753-8951db87-e7e1-48c7-a75d-e3c5f222d702.gif)

A simple search/replace plugin that uses native vim search and replace.

Neovim has super-powerful search and replace, however, it can be slow to use due to the
number of key-strokes required to use it.

This plugin provides commands that references the different built-in special selections
along with a command which shows the values of each selection at any time.

## Features

* Allow pre-population of the search field using the values referenced by `special` keys (see: `:help cmdline-special`):
  * `<cword>`
  * `<cWORD>`
  * `<cfile>`
  * `<cexpr>`
* Allow previewing the values of the `special` keys via a pop-up buffer prior to making
  a substitution
* Allow searching/replacing over multiple buffers
* Allow using a visual-selection as the search string

## Usage

### Plugin Management

#### Lazy.nvim

``` lua
{
  "roobert/search-replace.nvim",
  config = function()
   require("search-replace").setup({
     -- optionally override defaults
     default_replace_single_buffer_options = "gcI",
     default_replace_multi_buffer_options = "egcI",
   })
  end,
}
```

### Key Bindings

#### Lunarvim / Which-Key

``` lua
lvim.builtin.which_key.mappings["r"] = { name = "SearchReplaceSingleBuffer" }
lvim.builtin.which_key.mappings["r"]["s"] =
 { "<CMD>SearchReplaceSingleBufferSelections<CR>", "SearchReplaceSingleBuffer [s]elction list" }
lvim.builtin.which_key.mappings["r"]["w"] =
 { "<CMD>SearchReplaceSingleBufferCWord<CR>", "SearchReplaceSingleBuffer [w]ord" }
lvim.builtin.which_key.mappings["r"]["W"] =
 { "<CMD>SearchReplaceSingleBufferCWORD<CR>", "SearchReplaceSingleBuffer [W]ORD" }
lvim.builtin.which_key.mappings["r"]["e"] =
 { "<CMD>SearchReplaceSingleBufferCExpr<CR>", "SearchReplaceSingleBuffer [e]xpr" }
lvim.builtin.which_key.mappings["r"]["f"] =
 { "<CMD>SearchReplaceSingleBufferCFile<CR>", "SearchReplaceSingleBuffer [f]ile" }
lvim.builtin.which_key.mappings["r"]["b"] =
 { "<CMD>SearchReplaceSingleBufferBlock<CR>", "SearchReplaceSingleBuffer [b]lock" }

lvim.builtin.which_key.mappings["r"]["b"] = { name = "SearchReplaceMultiBuffer" }
lvim.builtin.which_key.mappings["r"]["b"]["s"] =
 { "<CMD>SearchReplaceMultiBufferSelections<CR>", "SearchReplaceMultiBuffer [s]elction list" }
lvim.builtin.which_key.mappings["r"]["b"]["w"] =
 { "<CMD>SearchReplaceMultiBufferCWord<CR>", "SearchReplaceMultiBuffer [w]ord" }
lvim.builtin.which_key.mappings["r"]["b"]["W"] =
 { "<CMD>SearchReplaceMultiBufferCWORD<CR>", "SearchReplaceMultiBuffer [W]ORD" }
lvim.builtin.which_key.mappings["r"]["b"]["e"] =
 { "<CMD>SearchReplaceMultiBufferCExpr<CR>", "SearchReplaceMultiBuffer [e]xpr" }
lvim.builtin.which_key.mappings["r"]["b"]["f"] =
 { "<CMD>SearchReplaceMultiBufferCFile<CR>", "SearchReplaceMultiBuffer [f]ile" }

lvim.keys.visual_block_mode["<C-b>"] = [[<CMD>SearchReplaceSingleBufferWithinBlock<CR>]]
lvim.keys.visual_block_mode["<C-r>"] = [[<CMD>SearchReplaceSingleBufferVisualSelection<CR>]]
```
