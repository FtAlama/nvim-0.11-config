return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		if vim.fn.executable("tree-sitter") == 0 then
			vim.schedule(function()
				vim.notify(
					"nvim-treesitter : le CLI `tree-sitter` (>= 0.26.1) est introuvable, "
					.. "aucun parser ne peut etre compile.\n"
					.. "  macOS  : brew install tree-sitter-cli\n"
					.. "  Arch   : pacman -S tree-sitter-cli\n"
					.. "  Debian : cargo install --locked tree-sitter-cli\n"
					.. "(un compilateur C est aussi requis)",
					vim.log.levels.WARN
				)
			end)
		else
			require("nvim-treesitter").install({
				"c",
				"cpp",
				"lua",
				"luadoc",
				"vim",
				"vimdoc",
				"query",
				"markdown",
				"markdown_inline",
				"html",
				"css",
				"javascript",
				"typescript",
				"tsx",
				"json",
				"yaml",
				"bash",
			})
		end

		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
				if not lang then
					return
				end
				if not pcall(vim.treesitter.start, args.buf, lang) then
					return
				end
				vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				vim.wo[0][0].foldmethod = "expr"
				vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
			end,
		})
	end,
}
