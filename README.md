# search-replace.nvim

![a](https://user-images.githubusercontent.com/226654/210119753-8951db87-e7e1-48c7-a75d-e3c5f222d702.gif)

A simple search/replace plugin that uses native vim search and replace.

Neovim has super-powerful search and replace, however, it can be slow to use due to the
number of key-strokes required to use it.

This plugin provides commands that references the different built-in special selections
along with a command which shows the values of each selection at any time.

## Usage

### Plugin Management

#### Lazy.nvim

``` lua
{
  "roobert/search-replace.nvim",
  config = function()
   require("search-replace").setup()
  end,
}
```

### Key Bindings

#### Lunarvim / Which-Key

``` lua
lvim.builtin.which_key.mappings["r"] = { name = "SearchReplace" }
lvim.builtin.which_key.mappings["r"]["s"] = { "<CMD>SearchReplaceSelections<CR>", "SearchReplace [s]elction list" }
lvim.builtin.which_key.mappings["r"]["w"] = { "<CMD>SearchReplaceCWord<CR>", "SearchReplace [w]ord" }
lvim.builtin.which_key.mappings["r"]["W"] = { "<CMD>SearchReplaceCWORD<CR>", "SearchReplace [W]ORD" }
lvim.builtin.which_key.mappings["r"]["v"] = { "<CMD>SearchReplaceVisual<CR>", "SearchReplace [v]isual" }
lvim.builtin.which_key.mappings["r"]["e"] = { "<CMD>SearchReplaceCExpr<CR>", "SearchReplace [e]xpr" }
lvim.builtin.which_key.mappings["r"]["f"] = { "<CMD>SearchReplaceCFile<CR>", "SearchReplace [f]ile" }

lvim.builtin.which_key.mappings["r"]["b"] = { name = "SearchReplaceMultiBuffer" }
lvim.builtin.which_key.mappings["r"]["b"]["s"] =
 { "<CMD>SearchReplaceMultiBufferSelections<CR>", "SearchReplace [s]elction list" }
lvim.builtin.which_key.mappings["r"]["b"]["w"] = { "<CMD>SearchReplaceMultiBufferCWord<CR>", "SearchReplace [w]ord" }
lvim.builtin.which_key.mappings["r"]["b"]["W"] = { "<CMD>SearchReplaceMultiBufferCWORD<CR>", "SearchReplace [W]ORD" }
lvim.builtin.which_key.mappings["r"]["b"]["v"] = { "<CMD>SearchReplaceMultiBufferVisual<CR>", "SearchReplace [v]isual" }
lvim.builtin.which_key.mappings["r"]["b"]["e"] = { "<CMD>SearchReplaceMultiBufferCExpr<CR>", "SearchReplace [e]xpr" }
lvim.builtin.which_key.mappings["r"]["b"]["f"] = { "<CMD>SearchReplaceMultiBufferCFile<CR>", "SearchReplace [f]ile" }
```
