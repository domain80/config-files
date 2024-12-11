return {
	"windwp/nvim-autopairs",
	event = { "InsertEnter" },
	dependencies = {
		"hrsh7th/nvim-cmp",
	},
	config = function()
		-- import nvim-autopairs
		local autopairs = require("nvim-autopairs")
		local Rule = require("nvim-autopairs.rule")

		local ts_conds = require("nvim-autopairs.ts-conds")

		-- -- import nvim-autopairs completion functionality
		-- local cmp_autopairs = require("nvim-autopairs.completion")

		-- import nvim-cmp plugin (completions plugin)
		local cmp = require("cmp")

		-- press % => %% only while inside a comment or string
		-- autopairs.add_rules({
		-- 	Rule("%", "%", "lua"):with_pair(ts_conds.is_ts_node({ "string", "comment" })),
		-- 	Rule("$", "$", "lua"):with_pair(ts_conds.is_not_ts_node({ "function" })),
		-- })

		-- configure autopairs
		autopairs.setup({
			check_ts = true, -- enable treesitter
			ts_config = {
				lua = { "string" }, -- don't add pairs in lua string treesitter nodes
				javascript = { "template_string" }, -- don't add pairs in javscript template_string treesitter nodes
				java = false, -- don't check treesitter on java
			},
			enable_check_bracket_line = false,
			ignored_next_char = "[%w%.]", -- will ignore alphanumeric and `.` symbol
		})

		-- make autopairs and completion work together
		-- cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
	end,
}
