return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	config = function()
		local keymap = vim.keymap -- for conciseness
		require("bufferline").setup({})

		keymap.set("n", "<leader>1", "<Cmd>BufferLineGoToBuffer 1<CR>", { desc = "Go to buffer 1" })

		keymap.set("n", "<leader>1", "<Cmd>BufferLineGoToBuffer 1<CR>", { desc = "BufferLineGoToBuffer 1" })
		keymap.set("n", "<leader>2", "<Cmd>BufferLineGoToBuffer 2<CR>", { desc = "BufferLineGoToBuffer 2" })
		keymap.set("n", "<leader>3", "<Cmd>BufferLineGoToBuffer 3<CR>", { desc = "BufferLineGoToBuffer 3" })
		keymap.set("n", "<leader>4", "<Cmd>BufferLineGoToBuffer 4<CR>", { desc = "BufferLineGoToBuffer 4" })
		keymap.set("n", "<leader>5", "<Cmd>BufferLineGoToBuffer 5<CR>", { desc = "BufferLineGoToBuffer 5" })
		keymap.set("n", "<leader>6", "<Cmd>BufferLineGoToBuffer 6<CR>", { desc = "BufferLineGoToBuffer 6" })
		keymap.set("n", "<leader>7", "<Cmd>BufferLineGoToBuffer 7<CR>", { desc = "BufferLineGoToBuffer 7" })
		keymap.set("n", "<leader>8", "<Cmd>BufferLineGoToBuffer 8<CR>", { desc = "BufferLineGoToBuffer 8" })
		keymap.set("n", "<leader>9", "<Cmd>BufferLineGoToBuffer 9<CR>", { desc = "BufferLineGoToBuffer 9" })
		keymap.set("n", "<leader>$", "<Cmd>BufferLineGoToBuffer -1<CR>", { desc = "BufferLineGoToBuffer -1" })

		keymap.set("n", "<leader>bn", "<Cmd>BufferLineCycleNext<CR>", { desc = "Bufferline go to next buffer" })
		keymap.set("n", "<leader>bp", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Bufferline go to next buffer" })
		keymap.set("n", "<leader>bc]", "<Cmd>BufferLineCloseRight<CR>", { desc = "Bufferline close right buffers" })
		keymap.set("n", "<leader>bc[", "<Cmd>BufferLineCloseLeft<CR>", { desc = "Bufferline close left buffers" })
		keymap.set("n", "<leader>bco", "<Cmd>BufferLineCloseOthers<CR>", { desc = "Bufferline close other buffers" })
		keymap.set("n", "<leader>bx", "<Cmd>bd<CR>", { desc = "Close current buffer" })
	end,

	opts = {
		options = {
			mode = "buffers",
			indicator = {
				style = "underline",
			},
		},
	},
}
