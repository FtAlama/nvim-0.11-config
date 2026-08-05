if vim.fn.has("nvim-0.12") == 0 then
	vim.schedule(function()
		vim.notify(
			"Cette configuration requiert Neovim 0.12 ou superieur.\n"
				.. "Version detectee : "
				.. tostring(vim.version())
				.. "\nLe LSP et treesitter ne fonctionneront pas correctement.",
			vim.log.levels.ERROR
		)
	end)
end

vim.filetype.add({
	extension = {
		tpp = "cpp",
	},
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("vim-options")

require("lazy").setup("plugins")
