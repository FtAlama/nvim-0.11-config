-- return {
-- 	{
-- 		"mason-org/mason.nvim",
-- 		opt = {},
-- 		config = function()
-- 			require("mason").setup()
-- 		end,
-- 	},
-- 	{
-- 		"mason-org/mason-lspconfig.nvim",
-- 		config = function()
-- 			require("mason-lspconfig").setup({
-- 				ensure_installed = {
-- 					"lua_ls",
-- 					"clangd",
-- 					"vimls",
-- 					"ast-grep",
-- 				},
-- 			})
-- 		end,
-- 	},
-- 	{
-- 		"neovim/nvim-lspconfig",
-- 		config = function()
-- 			local capabilities = require("cmp_nvim_lsp").default_capabilities()
-- 			-- local lspconfig = require("lspconfig")
-- 			-- lspconfig.lua_ls.setup({
-- 			-- 	capabilities = capabilities
-- 			-- })
-- 			-- lspconfig.clangd.setup({
-- 			-- 	capabilities = capabilities
-- 			-- })
-- 			-- lspconfig.vimls.setup({
-- 			-- 	capabilities = capabilities
-- 			-- })
-- 			-- lspconfig.ast_grep.setup({
-- 			-- 	capabilities = capabilities
-- 			-- })
--
--
-- 			vim.keymap.set("n", "D", vim.lsp.buf.hover, {})
-- 			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
-- 			vim.keymap.set("n", "I", vim.lsp.buf.implementation, {})
-- 			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
-- 			vim.keymap.set("n", "<leader>l", vim.lsp.buf.references, {})
-- 		end,
-- 	},
-- }
--
return {
	-- Mason (plugin principal pour gérer les serveurs LSP)
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},

	-- Mason LSPConfig (mason-lspconfig pour gérer les configurations LSP)
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			local mason_lspconfig = require("mason-lspconfig")

			-- Install LSP (serveurs à installer)
			mason_lspconfig.setup({
				ensure_installed = {
					"lua_ls",
					"clangd",
					"vimls",
					"html",
					"cssls",
				},
			})

			-- Capabilities de nvim-cmp pour autocomplétion
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Utiliser lspconfig (le bon module de configuration des LSP)
			local lspconfig = require("lspconfig")

			-- Configurer les serveurs LSP installés
			for _, server in ipairs(mason_lspconfig.get_installed_servers()) do
				-- Vérifie si le serveur existe dans lspconfig et le configure
				if lspconfig[server] then
					lspconfig[server].setup({
						capabilities = capabilities,
						on_attach = function(client, bufnr)
							local map = function(mode, lhs, rhs)
								vim.keymap.set(mode, lhs, rhs, { buffer = bufnr })
							end

							-- Raccourcis clavier pour lsp
							map("n", "D", vim.lsp.buf.hover)
							map("n", "gd", vim.lsp.buf.definition)
							map("n", "I", vim.lsp.buf.implementation)
							map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action)
							map("n", "<leader>l", vim.lsp.buf.references)
						end,
					})
				else
					-- Si le serveur n'est pas dans lspconfig, l'ignorer (ou afficher un message)
					vim.notify("Serveur LSP non trouvé dans lspconfig: " .. server, vim.log.levels.WARN)
				end
			end
		end,
	},

	-- Plugin de base pour nvim-lspconfig (requis pour gérer l'interface LSP)
	{
		"neovim/nvim-lspconfig",
	},
}
