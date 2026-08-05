return {
	{
		"mason-org/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()

			local tools = {
				{ "stylua" },
				{ "clang-format" },
				{ "prettier", "npm" },
			}

			local registry = require("mason-registry")
			registry.refresh(function()
				for _, entry in ipairs(tools) do
					local name, requires = entry[1], entry[2]
					if not requires or vim.fn.executable(requires) == 1 then
						local ok, pkg = pcall(registry.get_package, name)
						if ok and not pkg:is_installed() then
							pkg:install()
						end
					end
				end
			end)
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

			local servers = {
				{ "lua_ls" },
				{ "clangd" },
				{ "vimls", "npm" },
				{ "html", "npm" },
				{ "cssls", "npm" },
			}

			local ensure_installed, skipped = {}, {}
			for _, entry in ipairs(servers) do
				local name, requires = entry[1], entry[2]
				if not requires or vim.fn.executable(requires) == 1 then
					table.insert(ensure_installed, name)
				else
					table.insert(skipped, name)
				end
			end

			if #skipped > 0 then
				vim.schedule(function()
					vim.notify(
						("LSP ignores (npm introuvable) : %s\nInstalle node/npm puis relance :MasonInstall"):format(
							table.concat(skipped, ", ")
						),
						vim.log.levels.WARN
					)
				end)
			end

			require("mason-lspconfig").setup({
				ensure_installed = ensure_installed,
			})
		end,
	},
}
