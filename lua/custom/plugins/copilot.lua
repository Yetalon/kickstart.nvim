return {
  'github/copilot.vim',
  config = function()
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true

    local opts = { expr = true, silent = true, replace_keycodes = false, desc = 'Copilot Accept' }
    local accept = 'copilot#Accept("<CR>")'

    -- 1) Try common Ctrl+Enter representations up-front
    for _, lhs in ipairs {
      '<C-CR>',
      '<C-Return>',
      '<C-M>',
      '<C-j>', -- editor side
      vim.keycode '<Esc>[13;5u', -- CSI-u (Alacritty binding)
    } do
      pcall(vim.keymap.set, 'i', lhs, accept, opts)
    end

    -- 2) Add an interactive binder to catch weird encodings like the one you saw (<80><fc>^D)
    vim.api.nvim_create_user_command('CopilotAcceptBind', function()
      vim.notify('Press the key you want for Copilot Accept…', vim.log.levels.INFO)
      local ok, raw = pcall(vim.fn.getcharstr)
      if not ok or not raw or raw == '' then
        vim.notify('No key captured.', vim.log.levels.WARN)
        return
      end
      -- Translate to a lhs Neovim understands (e.g., <C-CR> or <Esc>[13;5u), then map it
      local lhs = vim.fn.keytrans(raw)
      local lhs_tc = vim.keycode(lhs)
      vim.keymap.set('i', lhs_tc, accept, opts)
      vim.notify(('Mapped %s to Copilot Accept'):format(lhs), vim.log.levels.INFO)
    end, {})

    -- Optional: expose a normal-mode shortcut to run the binder quickly
    vim.keymap.set('n', '<leader>ca', ':CopilotAcceptBind<CR>', { silent = true, desc = 'Bind Copilot Accept' })
  end,
}
