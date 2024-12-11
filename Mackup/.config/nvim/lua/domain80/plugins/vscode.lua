-- don't do anything in non-vscode instances
if not vim.g.vscode then
	return {}
end

-- a list of known working plugins with vscode-neovim, update with your own plugins
local plugins = {
	"lazy.nvim",
	-- "AstroNvim",
	-- "astrocore",
	-- "astroui",
	"Comment.nvim",
	"nvim-autopairs",
	"nvim-treesitter",
	"nvim-ts-autotag",
	"nvim-treesitter-textobjects",
	"nvim-ts-context-commentstring",
}

local Config = require("lazy.core.config")
-- disable plugin update checking
Config.options.checker.enabled = false
Config.options.change_detection.enabled = false
-- replace the default `cond`
Config.options.defaults.cond = function(plugin)
	return vim.tbl_contains(plugins, plugin.name)
end

---@type LazySpec
return {
	-- add a few keybindings ,
	-- disable colorscheme setting
	-- disable treesitter highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { highlight = { enable = false } },
	},
}
