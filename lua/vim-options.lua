vim.cmd("set relativenumber")
vim.g.mapleader = " "

vim.cmd("set tabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set noexpandtab")

vim.cmd("set foldlevel=99")
vim.cmd("set foldlevelstart=99")

vim.keymap.set("n", "<leader>z", function()
	if vim.fn.foldlevel(".") == 0 then
		return
	end
	vim.cmd("normal! za")
end, { desc = "Plier/deplier la fonction sous le curseur" })

vim.keymap.set("n", "<leader>Z", function()
	local closed = false
	for l = 1, vim.fn.line("$") do
		if vim.fn.foldclosed(l) ~= -1 then
			closed = true
			break
		end
	end
	vim.cmd(closed and "normal! zR" or "normal! zM")
end, { desc = "Plier/deplier toutes les fonctions" })
