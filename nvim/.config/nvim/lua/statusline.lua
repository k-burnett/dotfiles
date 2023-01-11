local M = {}

M.trunc_width = setmetatable({
  -- these values can be adjusted to whatever we see fits...
  mode = 80,
  git_status = 105,
  filename = 140,
  line_col = 60,
}, {
  __index = function()
    return 80 -- for edge cases, I suppose...
  end
})

M.is_truncated = function(_, width)
  local current_width = vim.api.nvim_win_get_width(0)
  return current_width < width
end

-- for setting colors!

local set_hl = function(group, options)
  local bg = options.bg == nil and '' or 'guibg=' .. options.bg
  local fg = options.fg == nil and '' or 'guifg=' .. options.fg
  local gui = options.gui == nil and '' or 'gui=' .. options.gui

  vim.cmd(string.format('hi %s %s %s %s', group, bg, fg, gui))
end

-- these highlight settings should correspond to gruvbox...
local highlights = {
  { 'StatusLine', { fg = '#3C3836', bg = '#EBDBB2' }},
  { 'StatusLineNC', { fg = '#3C3836', bg = '#928374' }},
  { 'LineCol', { bg = '#928374', fg = '#1D2021', gui="bold" }},
  { 'Git', { bg = '#45403d', fg = '#EBDBB2' }},
  { 'Filetype', { bg = '#504945', fg = '#EBDBB2' }},
  { 'NormalMode', { bg = '#928374', fg = '#1D2021', gui="bold" }},
  { 'InsertMode', { bg = '#7daea3', fg = '#1D2021', gui="bold" }},
  { 'VisualMode', { bg = '#e78a4e', fg = '#1D2021', gui="bold" }},
  { 'ReplaceMode', { bg = '#ea6962', fg = '#1D2021', gui="bold" }},
  { 'TerminalMode', { bg = '#89b482', fg = '#1D2021', gui="bold" }},
  { 'CmdMode', { bg = '#a9b665', fg = '#1D2021', gui="bold" }},
}

for _, highlight in ipairs(highlights) do
  set_hl(highlight[1], highlight[2])
end

M.colors = {
  active        = '%#StatusLine#',
  inactive      = '%#StatuslineNC#',
  mode          = '%#Mode#',
  git           = '%#Git#',
  filetype      = '%#Filetype#',
  line_col      = '%#LineCol#',
}

local function get_mode_color()
  local current_mode = vim.api.nvim_get_mode().mode
  local mode_color = "%#NormalMode#"
  if current_mode == "n" then
      mode_color = "%#NormalMode#"
  elseif current_mode == "i" or current_mode == "ic" then
      mode_color = "%#InsertMode#"
  elseif current_mode == "v" or current_mode == "V" or current_mode == "" then
      mode_color = "%#VisualMode#"
  elseif current_mode == "R" then
      mode_color = "%#ReplaceMode#"
  elseif current_mode == "c" then
      mode_color = "%#CmdMode#"
  elseif current_mode == "t" then
      mode_color = "%#TerminalMode#"
  end
  return mode_color
end

M.separators = {
  arrow = { '', '' },
  rounded = { '', '' },
  blank = { '', '' },
}

local active_sep = 'blank'

M.modes = setmetatable({
  ['n']  = {'Normal', 'N'};
  ['no'] = {'N·Pending', 'N·P'} ;
  ['v']  = {'Visual', 'V' };
  ['V']  = {'V·Line', 'V·L' };
  [''] = {'V·Block', 'V·B'};
  ['s']  = {'Select', 'S'};
  ['S']  = {'S·Line', 'S·L'};
  [''] = {'S·Block', 'S·B'};
  ['i']  = {'Insert', 'I'};
  ['ic'] = {'Insert', 'I'};
  ['R']  = {'Replace', 'R'};
  ['Rv'] = {'V·Replace', 'V·R'};
  ['c']  = {'Command', 'C'};
  ['cv'] = {'Vim·Ex ', 'V·E'};
  ['ce'] = {'Ex ', 'E'};
  ['r']  = {'Prompt ', 'P'};
  ['rm'] = {'More ', 'M'};
  ['r?'] = {'Confirm ', 'C'};
  ['!']  = {'Shell ', 'S'};
  ['t']  = {'Terminal ', 'T'};
}, {
  __index = function()
    return {'Unknown', 'U'} -- handle edge cases
  end
})

M.get_current_mode = function(self)
  local current_mode = vim.api.nvim_get_mode().mode
  if self:is_truncated(self.trunc_width.mode) then
    return string.format(' %s ', self.modes[current_mode][2]:upper())
  end

  return string.format(' %s ', self.modes[current_mode][1]:upper())
end

M.get_git_status = function(self)
  -- use fallback becase it doesn't set this variable on the initial 'BufEnter'
  local signs = vim.b.gitsigns_status_dict or { head = '', added = 0, changed = 0, removed = 0 }
  local is_head_empty = signs.head ~= ''

  if self:is_truncated(self.trunc_width.git_status) then
    -- if  truncated, we don't want to show anything...
    return ''
      -- return is_head_empty and string.format('  %s ', signs.head or '') or ''
  end

  -- signs.added = '%#GitSignsAdd#' .. signs.added
  -- signs.changed = '%#GitSignsChange#' .. signs.changed
  -- signs.removed = '%#GitSignsDelete#' .. signs.removed

  return is_head_empty
    and string.format(
      ' %%#HintFloat#+%s %%#OctoBlueFloat#~%s %%#ErrorFloat#-%s %%#OctoGreyFloat#|%%#OctoPurpleFloat#  %s', 
      signs.added, signs.removed, signs.changed, signs.head
    )
    or ''
end

-- not in use...
M.get_filename = function(self)
  if self:is_truncated(self.trunc_width.filename) then return " %<%f " end
  return " %<%F "
end


M.get_filetype = function()
  local file_name, file_ext = vim.fn.expand('%:t'), vim.fn.expand('%:e')
  local icon = require'nvim-web-devicons'.get_icon(file_name, file_ext, { default = true })
  local filetype = vim.bo.filetype
  
  if filetype == '' then return '' end
  return string.format(' %s %s ', icon, filetype:lower())
end

M.get_line_col = function(self)
  if self:is_truncated(self.trunc_width.line_col) then return ' %l:%c ' end
  return ' Ln %l, Col %c '
end

M.get_lsp_diagnostic = function(self)
  local result = {}
  local levels = {
    errors = 'Error',
    warnings = 'Warning',
    info = 'Information',
    hints = 'Hint'
  }

  for k, level in pairs(levels) do 
    result[k] = vim.lsp.diagnostic.get_cound(0, level)
  end

  if self:is_truncated(self.trunc_width.diagnostic) then
    return ''
  else
    return string.format(
      "| :%s :%s :%s :%s ",
      result['errors'] or 0, result['warnings'] or 0,
      result['info'] or 0, result['hints'] or 0
    )
  end
end

M.set_active = function(self)
  local colors = self.colors

  local mode = get_mode_color() .. self:get_current_mode()
  local git = colors.git .. self:get_git_status()
  -- local filename = colors.inactive .. self:get_filename()
  local filetype = colors.filetype .. self:get_filetype()
  local line_col = colors.line_col .. self:get_line_col()

  return table.concat({
    colors.active,
    mode,
    git,
    '%=',
    filetype,
    line_col,
  })
end

M.set_explorer = function(self)
  local title = self.colors.mode .. '   '
  local title_alt = self.colors.mode_alt .. self.separators[active_sep][2]

  return table.concat({ self.colors.active, title, title_alt })
end

M.set_inactive = function(self)
  return self.colors.inactive .. '%= %F %='
end

Statusline = setmetatable(M, {
  __call = function(statusline, mode)
    if mode == "active" then return statusline:set_active() end
    if mode == "inactive" then return statusline:set_inactive() end
    if mode == "explorer" then return statusline:set_explorer() end
  end
})


vim.api.nvim_exec([[
  augroup Statusline
  au!
  au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline('active')
  " au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline('inactive')
  " au WinEnter,BufEnter,FileType NvimTree setlocal statusline=%!v:lua.Statusline('explorer')
  augroup END
]], false)
