return {
  "nvim-tree/nvim-tree.lua",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()

    -- disable netrw at the very start of your init.lua
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- setup with some options
    local api = require("nvim-tree.api")

    require("nvim-tree").setup({
      on_attach = function (bufnr)
        local opts = { buffer = bufnr }
        api.config.mappings.default_on_attach(bufnr)

        local lefty = function ()
          local node_at_cursor = api.tree.get_node_under_cursor()
          -- node_at_cursor.nodes to checks if has nodes (is a folder) and .open to check it's open
          if node_at_cursor.nodes and node_at_cursor.open then
            -- .open.edit() toggles the node (folder) from open to closed
            api.node.open.edit()
          else
            -- if instead node_at_cursor is a file or a closed folder, jump to the parent node (folder)
            api.node.navigate.parent()
          end
        end

        vim.keymap.set("n", "h", lefty , opts )
        vim.keymap.set("n", "<Left>", lefty , opts )
        vim.keymap.set("n", "<Right>", api.node.open.edit , opts )
        vim.keymap.set("n", "l", api.node.open.edit , opts )

        -- other on_attach stuff
      end,
      sort = {
        sorter = "case_sensitive",
      },
      view = {
        width = 40,
        relativenumber = true,
        number = true,
        -- side = "left,
      },
      -- change folder arrow icons
      renderer = {
        indent_markers = {
          enable = true,
        },
        icons = {
          glyphs = {
            folder = {
              arrow_closed = "", -- arrow when folder is closed
              arrow_open = "", -- arrow when folder is open
            },
          },
        },
      },
      -- disable window_picker for
      -- explorer to work well with
      -- window splits
      actions = {
        open_file = {
          window_picker = {
            enable = false,
          },
        },
      },
      filters = {
        custom = { ".DS_Store" },
      },
      git = {
        ignore = false,
      },
    })

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    -- keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
    keymap.set("n", "<leader>e", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" }) -- toggle file explorer on current file
    -- keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
    -- keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) 



  end
}
