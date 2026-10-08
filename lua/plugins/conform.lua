return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		local function find_clang_format()
			local found = vim.fn.exepath("clang-format")
			if found ~= "" then
				return found
			end
			local candidates = {
				"/Library/Developer/CommandLineTools/usr/bin/clang-format",
				"/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang-format",
			}
			for _, path in ipairs(candidates) do
				if vim.uv.fs_stat(path) then
					return path
				end
			end
			return nil
		end

		local clang_format = find_clang_format()

		conform.setup({
			formatters = clang_format and {
				["clang-format"] = { command = clang_format },
			} or {},
			formatters_by_ft = {
				lua = { "stylua" },
				cpp = { "clang-format" },
				c = { "clang-format" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				eruby = { "erb_format" },
			},
		})
		vim.keymap.set({ "n", "v" }, "<leader>f", function()
			conform.format({
				lsp_format = "fallback",
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
