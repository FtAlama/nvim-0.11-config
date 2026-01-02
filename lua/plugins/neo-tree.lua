return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	lazy = false,
	config = function()
		event_handlers = {
					{
						event = "neo_tree_buffer_enter",
						handler = function(arg)
							vim.cmd [[setlocal relativenumber]]
						end,
					}
				},
				vim.keymap.set('n', '<leader>e', ':Neotree filesystem reveal left<CR>', {})
	end
}
