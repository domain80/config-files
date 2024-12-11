return {
	"numToStr/Comment.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	config = function()
		-- import comment plugin safely
		local comment = require("Comment")

		local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

		-- enable comment
		comment.setup({
			-- for commenting tsx, jsx, svelte, html files
			pre_hook = ts_context_commentstring.create_pre_hook(),
			---Add a space b/w comment and the line
		})

		local keymap = vim.keymap
		local commentApi = require("Comment.api")

		-- keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) -- go to next tab
		keymap.set("n", "<leader>/", function()
			commentApi.toggle.linewise.current()
		end, { desc = "Comment line(s)" })

		keymap.set(
			"v",
			"<leader>/",
			commentApi.call("toggle.linewise", "g@"),
			{ expr = true, desc = "Comment line(s)" }
		)
	end,
}
