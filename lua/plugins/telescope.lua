return {
	{
		"nvim-telescope/telescope.nvim",
		version = "*",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
		},
		config = function()
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")
			telescope.setup({
				extensions = {
					["ui-select"] = require("telescope.themes").get_dropdown({}),
				},
			})
			telescope.load_extension("ui-select")

			local map = function(lhs, rhs, desc)
				vim.keymap.set("n", lhs, rhs, { desc = desc })
			end

			map("<leader>p", builtin.find_files, "Fichiers")
			map("<leader>fg", builtin.live_grep, "Recherche live")
			map("<leader>s", builtin.lsp_document_symbols, "Symboles du fichier")
			map("<leader>S", builtin.lsp_dynamic_workspace_symbols, "Symboles du projet")
			map("<leader>D", builtin.diagnostics, "Tous les diagnostics")
			map("<leader>b", builtin.buffers, "Buffers ouverts")
			map("<leader>*", builtin.grep_string, "Chercher le mot sous le curseur")
		end,
	},
}
