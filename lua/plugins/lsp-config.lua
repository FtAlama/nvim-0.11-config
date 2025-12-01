-- return {
-- 	{
-- 		"williamboman/mason.nvim",
-- 		lazy = false,
-- 		config = function()
-- 			require("mason").setup()
-- 		end,
-- 	},
-- 	{
-- 		"williamboman/mason-lspconfig.nvim",
-- 		lazy = false,
-- 		dependencies = { "williamboman/mason.nvim" },
-- 		config = function()
-- 			local mason_lspconfig = require("mason-lspconfig")
--
-- 			mason_lspconfig.setup({
-- 				ensure_installed = {
-- 					"lua_ls",
-- 					"clangd",
-- 					"vimls",
-- 					"html",
-- 					"cssls",
-- 				},
-- 			})
--
-- 			local capabilities = require("cmp_nvim_lsp").default_capabilities()
--
-- 			local on_attach = function(client, bufnr)
-- 				local map = function(mode, lhs, rhs)
-- 					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr })
-- 				end
--
-- 				map("n", "D", vim.lsp.buf.hover)
-- 				map("n", "gd", vim.lsp.buf.definition)
-- 				map("n", "I", vim.lsp.buf.implementation)
-- 				map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action)
-- 				map("n", "<leader>l", vim.lsp.buf.references)
-- 			end
--
-- 			vim.lsp.config("lua_ls", {
-- 				capabilities = capabilities,
-- 				on_attach = on_attach,
-- 				settings = {
-- 					Lua = {
-- 						diagnostics = {
-- 							globals = { "vim" }
-- 						}
-- 					}
-- 				}
-- 			})
--
-- 			vim.lsp.config("clangd", {
-- 				capabilities = capabilities,
-- 				on_attach = on_attach,
-- 			})
--
-- 			vim.lsp.config("vimls", {
-- 				capabilities = capabilities,
-- 				on_attach = on_attach,
-- 			})
--
-- 			vim.lsp.config("html", {
-- 				capabilities = capabilities,
-- 				on_attach = on_attach,
-- 			})
--
-- 			vim.lsp.config("cssls", {
-- 				capabilities = capabilities,
-- 				on_attach = on_attach,
-- 			})
--
-- 			vim.lsp.enable({ "lua_ls", "clangd", "vimls", "html", "cssls" })
-- 		end,
-- 	},
-- }
return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			local mason_lspconfig = require("mason-lspconfig")
			
			mason_lspconfig.setup({
				ensure_installed = {
					"lua_ls",
					"clangd",
					"vimls",
					"html",
					"cssls",
				},
			})
			
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			
			local on_attach = function(client, bufnr)
				local map = function(mode, lhs, rhs)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr })
				end
				
				map("n", "D", vim.lsp.buf.hover)
				map("n", "gd", vim.lsp.buf.definition)
				map("n", "I", vim.lsp.buf.implementation)
				map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action)
				map("n", "<leader>l", vim.lsp.buf.references)
			end
			
			local notify = vim.notify
			vim.notify = function(msg, ...)
				if msg:match("deprecated") or msg:match("lspconfig") then
					return
				end
				notify(msg, ...)
			end
			
			local lspconfig = require("lspconfig")
			
			for _, server in ipairs(mason_lspconfig.get_installed_servers()) do
				if lspconfig[server] then
					lspconfig[server].setup({
						capabilities = capabilities,
						on_attach = on_attach,
					})
				end
			end
		end,
	},
	{
		"neovim/nvim-lspconfig",
	},
}
