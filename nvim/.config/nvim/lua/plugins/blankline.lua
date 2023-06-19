vim.opt.list = true
vim.opt.listchars:append "eol:↴"
vim.opt.listchars:append "space:⋅"


require("indent_blankline").setup {
  -- turn on context
  show_current_context = true,
  show_current_context_start = true
}
