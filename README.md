# search-replace.nvim

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
lvim.builtin.which_key.mappings["r"]["s"] = { "<CMD>SearchReplaceSelections<CR>", "SearchReplace show [s]elctions" }
lvim.builtin.which_key.mappings["r"]["w"] = { "<CMD>SearchReplaceCWord<CR>", "SearchReplace [w]ord" }
lvim.builtin.which_key.mappings["r"]["W"] = { "<CMD>SearchReplaceCWORD<CR>", "SearchReplace [W]ORD" }
lvim.builtin.which_key.mappings["r"]["v"] = { "<CMD>SearchReplaceVisual<CR>", "SearchReplace [v]isual selection" }
lvim.builtin.which_key.mappings["r"]["e"] = { "<CMD>SearchReplaceCExpr<CR>", "SearchReplace c[e]xpr" }
lvim.builtin.which_key.mappings["r"]["f"] = { "<CMD>SearchReplaceCFile<CR>", "SearchReplace [f]ile" }
```
