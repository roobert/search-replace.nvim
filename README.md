# :monocle_face: search-replace.nvim

![Screenshot](https://user-images.githubusercontent.com/226654/210175428-82e56d0c-0db2-418a-b74c-1ab5a03b3530.gif)

Supercharge the native Neovim search and replace experience!

## :sparkles: Features

* Quick opening of `:%s///gcI`
* Quick opening of `:%s/<special selection>//` where `<special selection>` refers to a
  predefined selection under the cursor. Please see: [What are Special Selections?](https://github.com/roobert/search-replace.nvim#zap-what-are-special-selections)
* A UI to preview the current special selections under the cursor
* Quick opening of `:%s/<visual selection>//gcI` where `<visual selection>` is a
  visual-charwise selection
* Configuration of the default flags passed to search and replace, e.g: `gcI` when
  searching across a buffer with `:%s///gcI`
* Support for search and replace over multiple buffers
* A command to search and replace over a visual-block/visual-linewise/visual-charwise
  selection
* Example key mappings

## :movie_camera: Demos

Most of the following examples use `which-key` and `leader` key bindings but the available plugin commands can
be bound to any keymapping, for example replacement opening is bound to `<leader>ro` but could
just as easily be mapped to `<C-r>` for faster access.

### Search and Replace

![Search and Replace](https://user-images.githubusercontent.com/226654/210173887-45b157ef-eb4b-4a6e-9442-29f7010d3084.gif)

``` lua
<leader>ro           # - open which-key 'replace' sub-menu, then 'open' a search
lvim                 # - term to search
example_replacement  # - term to replace with
yyyynnyy<esc>        # - since 'c' flag is supplied to search/replace, confirm which
                     #   matches to search and replace
uuuuuu               # - undo changes
<leader>h            # - finish by disabling search term highlighting
```

### Search and Replace with Special Keys

![Search and Replace with Special Keys](https://user-images.githubusercontent.com/226654/210173893-11f0189e-2971-4f23-93da-a915e8ede0dd.gif)

``` lua
<leader>rw           # - open which-key 'replace' sub-menu, then use '[w]ord' under
                     #   cursor as search term
example_replacement  # - term to replace with
yyyynnyy<esc>        # - since 'c' flag is supplied to search/replace, confirm which
                     #   matches to search and replace
uuuuuu               # - undo changes
<leader>h            # - finish by disabling search term highlighting
```

### Search and Replace with Special Keys and Search Hinting UI

![Search and Replace with Special Keys and Search Hinting UI
](https://user-images.githubusercontent.com/226654/210174276-5dd39c57-2ce7-4de0-bc2a-274cd5b4a677.gif)

``` lua
                     # - move to end of expression to replace
<leader>rs           # - open which-key 'replace' sub-menu, then 'selections' UI
e                    # - specify '[e]xpr' special key to use as search term
example.replacement  # - term to replace with
yyyy<esc>            # - since 'c' flag is supplied to search/replace, confirm which
                     #   matches to search and replace
uuuuuu               # - undo changes
<leader>h            # - finish by disabling search term highlighting
```

### Search and Replace Visual Charwise as Search String

![Search and Replace Visual Charwise as Search String
](https://user-images.githubusercontent.com/226654/210175020-aaa1a6fa-7fb8-4d87-ade6-20fa391e1a57.gif)

``` lua
v                    # - highlight the string to be replaced with visual-charwise mode
<ctrl-r>             # - key binding to replace with selection
example_replacement  # - term to replace with
yyyynnyy<esc>        # - since 'c' flag is supplied to search/replace, confirm which
                     #   matches to search and replace
uuuuuu               # - undo changes
<leader>h            # - finish by disabling search term highlighting
```

### Search and Replace Across Visual (Blockwise/Linewise) Selection

![Search and Replace Across Visual Selection](https://user-images.githubusercontent.com/226654/210175210-0da9063b-e933-451d-bc90-2405ad9e03f0.gif)

``` lua
V                    # - highlight multiple lines with a visual-linewise selection
<ctrl-b>             # - key binding to open search across block
                     # - move cursor to highlight search term
example_replacement  # - term to replace with
yynn<esc>            # - since 'c' flag is supplied to search/replace, confirm which
                     #   matches to search and replace
uu                   # - undo changes
<leader>h            # - finish by disabling search term highlighting
```

## :zap: What are Special Selections?

With the following example text:

``` lua
lvim.builtin.which_key.mappings["r"]["w"]
```

And the cursor position shown as `|`

The following examples are `true`.

### CWord

`CWord` is replaced with the `word` under the cursor (like `*`)

``` lua
# Selection:
lv|im.builtin.which_key.mappings["r"]["w"]
^^^^^
# Value:
lvim
```

``` lua
# Selection:
lvim.bui|ltin.which_key.mappings["r"]["w"]
     ^^^^^^^^
# Value:
builtin
```

``` lua
# Selection:
lvim.builtin.whi|ch_key.mappings["r"]["w"]
             ^^^^^^^^^^
# Value:
which_key
```

``` lua
# Selection:
lvim.builtin.which_key.mapp|ings["r"]["w"]
                       ^^^^^^^^^
# Value:
mappings
```

### CWORD

`CWORD` is replaced with the `WORD` under the cursor (like greedy `word`)

``` lua
# Selection:
lv|im.builtin.which_key.mappings["r"]["w"]
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# Value:
lvim.builtin.which_key.mappings["r"]["w"]
```

``` lua
# Selection:
lvim.builtin.whi|ch_key.mappings["r"]["w"]
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# Value:
lvim.builtin.which_key.mappings["r"]["w"]
```

### CExpr

`CExpr` is replaced with the `word` under the cursor, including more to form a C expression.

``` lua
# Selection:
lvim.bui|ltin.which_key.mappings["r"]["w"]
^^^^^^^^^^^^^
# Value:
lvim.builtin
```

``` lua
# Selection:
lvim.builtin.wh|ich_key.mappings["r"]["w"]
^^^^^^^^^^^^^^^^^^^^^^^
# Value:
lvim.builtin.which_key
```

``` lua
# Selection:
lvim.builtin.which_key.map|pings["r"]["w"]
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# Value:
lvim.builtin.which_key.mappings
```

### CFile

`CFile` is replaced with the path name under the cursor (like what `gf` uses)

``` lua
# Selection:
lvim.bui|ltin.which_key.mappings["r"]["w"]
^^^^^^^^^^^^^
# Value:
lvim.builtin
```

``` lua
# Selection:
lvim.builtin.wh|ich_key.mappings["r"]["w"]
^^^^^^^^^^^^^^^^^^^^^^^
# Value:
lvim.builtin.which_key
```

``` lua
# Selection:
lvim.builtin.which_key.map|pings["r"]["w"]
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# Value:
lvim.builtin.which_key.mappings
```

## :microscope: Available Commands

### Single Buffer - Open Search

* `SearchReplaceSingleBufferOpen`
* `SearchReplaceMultiBufferOpen`

### Single Buffer - Open Search with Special Key as Search Term

* `SearchReplaceSingleBufferCWord`
* `SearchReplaceSingleBufferCWORD`
* `SearchReplaceSingleBufferCExpr`
* `SearchReplaceSingleBufferCFile`

### Multi Buffer - Open Search with Special Key as Search Term

* `SearchReplaceMultiBufferCWord`
* `SearchReplaceMultiBufferCWORD`
* `SearchReplaceMultiBufferCExpr`
* `SearchReplaceMultiBufferCFile`

### Single/Multi Buffer UI - Show Special Key Values and Shortcuts to Open Search Replace

* `SearchReplaceSingleBufferSelections`
* `SearchReplaceMultiBufferSelections`

### Single Buffer - Visual Charwise as Search Term

* `SearchReplaceSingleBufferWithinBlock`

### Search over Visual (Blockwise/Linewise) Selection

* `SearchReplaceVisualSelection`
* `SearchReplaceVisualSelectionCWord`
* `SearchReplaceVisualSelectionCWORD`
* `SearchReplaceVisualSelectionCExpr`
* `SearchReplaceVisualSelectionCFile`

## :rocket: Usage

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

#### Packer.nvim

``` lua
use({
  "roobert/search-replace.nvim",
  config = function()
    require("search-replace").setup({
      -- optionally override defaults
      default_replace_single_buffer_options = "gcI",
      default_replace_multi_buffer_options = "egcI",
    })
  end,
})
```

### Key Bindings

#### Standard Neovim

``` lua
local opts = {}
vim.api.nvim_set_keymap("v", "<C-r>", "<CMD>SearchReplaceSingleBufferVisualSelection<CR>", opts)
vim.api.nvim_set_keymap("v", "<C-s>", "<CMD>SearchReplaceWithinVisualSelection<CR>", opts)
vim.api.nvim_set_keymap("v", "<C-b>", "<CMD>SearchReplaceWithinVisualSelectionCWord<CR>", opts)

vim.api.nvim_set_keymap("n", "<leader>rs", "<CMD>SearchReplaceSingleBufferSelections<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>ro", "<CMD>SearchReplaceSingleBufferOpen<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>rw", "<CMD>SearchReplaceSingleBufferCWord<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>rW", "<CMD>SearchReplaceSingleBufferCWORD<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>re", "<CMD>SearchReplaceSingleBufferCExpr<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>rf", "<CMD>SearchReplaceSingleBufferCFile<CR>", opts)

vim.api.nvim_set_keymap("n", "<leader>rbs", "<CMD>SearchReplaceMultiBufferSelections<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>rbo", "<CMD>SearchReplaceMultiBufferOpen<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>rbw", "<CMD>SearchReplaceMultiBufferCWord<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>rbW", "<CMD>SearchReplaceMultiBufferCWORD<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>rbe", "<CMD>SearchReplaceMultiBufferCExpr<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>rbf", "<CMD>SearchReplaceMultiBufferCFile<CR>", opts)
```

#### Lunarvim / Which-Key

``` lua
keymap = lvim.builtin.which_key.mappings

keymap["r"] = { name = "SearchReplaceSingleBuffer" }

keymap["r"]["s"] =
  { "<CMD>SearchReplaceSingleBufferSelections<CR>", "SearchReplaceSingleBuffer [s]elction list" }
keymap["r"]["o"] = { "<CMD>SearchReplaceSingleBufferOpen<CR>", "[o]pen" }
keymap["r"]["w"] = { "<CMD>SearchReplaceSingleBufferCWord<CR>", "[w]ord" }
keymap["r"]["W"] = { "<CMD>SearchReplaceSingleBufferCWORD<CR>", "[W]ORD" }
keymap["r"]["e"] = { "<CMD>SearchReplaceSingleBufferCExpr<CR>", "[e]xpr" }
keymap["r"]["f"] = { "<CMD>SearchReplaceSingleBufferCFile<CR>", "[f]ile" }

keymap["r"]["b"] = { name = "SearchReplaceMultiBuffer" }

keymap["r"]["b"]["s"] =
  { "<CMD>SearchReplaceMultiBufferSelections<CR>","SearchReplaceMultiBuffer [s]elction list" }
keymap["r"]["b"]["o"] = { "<CMD>SearchReplaceMultiBufferOpen<CR>", "[o]pen" }
keymap["r"]["b"]["w"] = { "<CMD>SearchReplaceMultiBufferCWord<CR>", "[w]ord" }
keymap["r"]["b"]["W"] = { "<CMD>SearchReplaceMultiBufferCWORD<CR>", "[W]ORD" }
keymap["r"]["b"]["e"] = { "<CMD>SearchReplaceMultiBufferCExpr<CR>", "[e]xpr" }
keymap["r"]["b"]["f"] = { "<CMD>SearchReplaceMultiBufferCFile<CR>", "[f]ile" }

lvim.keys.visual_block_mode["<C-r>"] = [[<CMD>SearchReplaceSingleBufferVisualSelection<CR>]]
lvim.keys.visual_block_mode["<C-s>"] = [[<CMD>SearchReplaceWithinVisualSelection<CR>]]
lvim.keys.visual_block_mode["<C-b>"] = [[<CMD>SearchReplaceWithinVisualSelectionCWord<CR>]]

```
