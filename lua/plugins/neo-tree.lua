return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	lazy = false,
	opts = {
		event_handlers = {
			{
				event = "neo_tree_buffer_enter",
				handler = function()
					vim.cmd([[setlocal relativenumber]])
				end,
			},
		},
	},
	config = function(_, opts)
		require("neo-tree").setup(opts)
		vim.keymap.set("n", "<leader>e", ":Neotree filesystem reveal left<CR>", { desc = "Neo-tree" })
	end,
}
