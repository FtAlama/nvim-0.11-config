return {
	{
		"mason-org/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		lazy = false,
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			vim.lsp.config("*", {
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
			})
			local clangd_cmd = {
				"clangd",
				"--background-index",
				"--clang-tidy",
				"--header-insertion=never",
			}
			local query_drivers = {}
			for _, compiler in ipairs({ "clang++", "clang", "c++", "g++", "gcc" }) do
				local path = vim.fn.exepath(compiler)
				if path ~= "" and not vim.tbl_contains(query_drivers, path) then
					table.insert(query_drivers, path)
				end
			end
			if #query_drivers > 0 then
				table.insert(clangd_cmd, "--query-driver=" .. table.concat(query_drivers, ","))
			end
			vim.lsp.config("clangd", {
				cmd = clangd_cmd,
				filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
			})
			vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Probleme sous le curseur" })

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local map = function(mode, lhs, rhs, desc)
						vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, desc = desc })
					end

					map("n", "D", vim.lsp.buf.hover, "LSP hover")
					map("n", "gd", vim.lsp.buf.definition, "LSP definition")
					map("n", "<leader>i", vim.lsp.buf.implementation, "LSP implementation")
					map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "LSP code action")
					map("n", "<leader>l", vim.lsp.buf.references, "LSP references")

					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if not client then
						return
					end

					if client.name == "clangd" then
						map("n", "<leader>h", "<cmd>LspClangdSwitchSourceHeader<cr>", "Source <-> header")
					end

					if client:supports_method("textDocument/inlayHint") then
						map("n", "<leader>th", function()
							local on = vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf })
							vim.lsp.inlay_hint.enable(not on, { bufnr = args.buf })
						end, "Inlay hints on/off")
					end
				end,
			})

			require("mason-lspconfig").setup({
				automatic_enable = { "lua_ls", "clangd", "vimls", "html", "cssls" },
			})
		end,
	},
}
