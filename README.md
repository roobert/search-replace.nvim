# :monocle_face: search-replace.nvim

![a](https://user-images.githubusercontent.com/226654/210119753-8951db87-e7e1-48c7-a75d-e3c5f222d702.gif)

A Neovim search and replace plugin that builds on the native search and replace experience.

Neovim has an excellent search and replace system, however it can be slow to use due to the
number of key-strokes required to use it.

## Features

* Quick opening of `:%s///gcI`
* Quick opening of `:%s/<special selection>//` where `<special selection>` refers to a
  predefined selection under the cursor. Please see: [What are Special Selections?](https://github.com/roobert/search-replace.nvim#what-are-special-selection)
* A UI to preview the current special selections under the cursor
* Quick opening of `:%s/<visual selection>//gcI` where `<visual selection>` is a
  visual-charwise selection
* Configuration of the default flags passed to search and replace, e.g: `gcI` when
  searching across a buffer with `:%s///gcI`
* Support for search and replace over multiple buffers
* A command to search and replace over a visual-block/visual-linewise/visual-charwise
  selection
* Example key mappings

## What are Special Selections?

### CWord

### CWORD

### CExpr

### CFile

## Demos

## Available Commands

### Single Buffer Empty Search

* `SearchReplaceSingleBuffer`
* `SearchReplaceMultiBufferCWord`

### Single Buffer Special Key Search

* `SearchReplaceSingleBufferCWord`
* `SearchReplaceSingleBufferCWORD`
* `SearchReplaceSingleBufferCExpr`
* `SearchReplaceSingleBufferCFile`

### Multi Buffer Special Key Search

* `SearchReplaceMultiBufferCWord`
* `SearchReplaceMultiBufferCWORD`
* `SearchReplaceMultiBufferCExpr`
* `SearchReplaceMultiBufferCFile`

### Single/Multi Buffer UI Special Key Search Hinting

* `SearchReplaceSingleBufferSelections`
* `SearchReplaceMultiBufferSelections`

### Visual Charwise As Search

* `SearchReplaceSingleBufferWithinBlock`

### Visual (Blockwise/Linewise) Selection Search

* `SearchReplaceVisualSelection`
* `SearchReplaceVisualSelectionCWord`
* `SearchReplaceVisualSelectionCWORD`
* `SearchReplaceVisualSelectionCExpr`
* `SearchReplaceVisualSelectionCFile`

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

lvim.keys.visual_block_mode["<C-r>"] = [[<CMD>SearchReplaceSingleBufferVisualSelection<CR>]]
lvim.keys.visual_block_mode["<C-b>"] = [[<CMD>SearchReplaceWithinVisualSelectionCWord<CR>]]
```
