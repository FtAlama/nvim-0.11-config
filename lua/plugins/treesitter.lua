return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local has_tree_sitter_cli = vim.fn.executable("tree-sitter") == 1

		local parsers = {
			tpp = { "cpp" },
			c = { "c" },
			cpp = { "cpp" },
			lua = { "lua", "luadoc" },
			vim = { "vim" },
			help = { "vimdoc" },
			query = { "query" },
			markdown = { "markdown", "markdown_inline" },
			html = { "html" },
			css = { "css" },
			javascript = { "javascript" },
			javascriptreact = { "javascript", "tsx" },
			typescript = { "typescript", "tsx" },
			typescriptreact = { "typescript", "tsx" },
			json = { "json" },
			yaml = { "yaml" },
			sh = { "bash" },
		}

		local parser_languages = {
			tpp = "cpp",
			javascriptreact = "tsx",
			typescriptreact = "tsx",
		}
		local parser_filetypes = {
			tpp = "cpp",
			javascriptreact = "typescriptreact",
		}

		local installing, installed = {}, {}
		local function start_treesitter(buf, filetype)
			local lang = parser_languages[filetype] or vim.treesitter.language.get_lang(filetype)
			if not lang then
				return
			end

			if pcall(vim.treesitter.start, buf, lang) then
				vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				for _, win in ipairs(vim.fn.win_findbuf(buf)) do
					vim.wo[win].foldmethod = "expr"
					vim.wo[win].foldexpr = "v:lua.vim.treesitter.foldexpr()"
				end
				return
			end

			local parser_filetype = parser_filetypes[filetype] or filetype
			local required = parsers[parser_filetype]
			if not required or installing[parser_filetype] or installed[parser_filetype] then
				return
			end
			if not has_tree_sitter_cli then
				vim.notify(
					"Treesitter nécessite tree-sitter-cli (>= 0.26.1) et un compilateur C. Installe-les puis relance Neovim.",
					vim.log.levels.WARN
				)
				return
			end

			installing[parser_filetype] = true
			require("nvim-treesitter").install(required):await(function(err, success)
				installing[parser_filetype] = nil
				if err or not success then
					vim.notify(("Échec installation parser Treesitter pour %s"):format(filetype), vim.log.levels.WARN)
					return
				end
				installed[parser_filetype] = true
				for _, target in ipairs(vim.api.nvim_list_bufs()) do
					if vim.api.nvim_buf_is_valid(target) then
						local target_filetype = vim.bo[target].filetype
						local target_parser_filetype = parser_filetypes[target_filetype] or target_filetype
						if target_parser_filetype == parser_filetype then
							start_treesitter(target, target_filetype)
						end
					end
				end
			end)
		end

		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				start_treesitter(args.buf, vim.bo[args.buf].filetype)
			end,
		})
	end,
}
