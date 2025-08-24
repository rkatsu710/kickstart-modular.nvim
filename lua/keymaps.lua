-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Neo-tree keymaps
vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle<CR>', { desc = 'Toggle Neo-tree' })
vim.keymap.set('n', '<leader>o', '<cmd>Neotree focus<CR>', { desc = 'Focus Neo-tree' })

-- mini.bufremove キーマップ
-- 現在のバッファを閉じる（ウィンドウレイアウトを保持）
vim.keymap.set('n', '<leader>w', function()
  require('mini.bufremove').delete(0, false)
end, { desc = 'バッファ閉じる' })

-- 現在のバッファを強制的に閉じる
vim.keymap.set('n', '<leader>W', function()
  require('mini.bufremove').delete(0, true)
end, { desc = 'バッファ強制閉じる' })

-- 他のすべてのバッファを閉じる
vim.keymap.set('n', '<leader>Q', ':%bd|e#|bd#<CR>', { desc = '他のバッファを全部閉じる' })

-- バッファナビゲーション
vim.keymap.set('n', '<Tab>', '<cmd>bnext<CR>', { desc = '次のバッファに切り替え' })
vim.keymap.set('n', '<S-Tab>', '<cmd>bprevious<CR>', { desc = '前のバッファに切り替え' })
vim.keymap.set('n', '<S-h>', '<cmd>bprevious<CR>', { desc = 'バッファを左に移動' })
vim.keymap.set('n', '<S-l>', '<cmd>bnext<CR>', { desc = 'バッファを右に移動' })

-- タブナビゲーション
-- === Tabs: <leader>t で操作、gt/gT は従来通り使える ===
vim.keymap.set('n', '<leader>tn', ':tabnew<CR>', { desc = 'New tab' })
vim.keymap.set('n', '<leader>tc', ':tabclose<CR>', { desc = 'Close tab' })
vim.keymap.set('n', '<leader>to', ':tabonly<CR>', { desc = 'Keep only this tab' })
vim.keymap.set('n', '<leader>tl', ':tabnext<CR>', { desc = 'Next tab' })
vim.keymap.set('n', '<leader>th', ':tabprevious<CR>', { desc = 'Previous tab' })
-- タブの並び替え（左/右へ移動）
vim.keymap.set('n', '<leader>tH', ':-tabmove<CR>', { desc = 'Move tab left' })
vim.keymap.set('n', '<leader>tL', ':+tabmove<CR>', { desc = 'Move tab right' })

-- 1〜4番タブへジャンプ（lualine の tabs 表示と相性◎）
for i = 1, 4 do
  vim.keymap.set('n', '<leader>' .. i, ':tabn ' .. i .. '<CR>', { desc = 'Go to tab ' .. i })
end

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Neovimにフォーカスが移ったときに日本語入力を自動的にオフにする
vim.api.nvim_create_autocmd({ 'FocusGained', 'VimEnter' }, {
  desc = 'Neovimフォーカス時に日本語入力をオフ',
  group = vim.api.nvim_create_augroup('auto-ime-off', { clear = true }),
  callback = function()
    -- ノーマルモードの場合のみ実行
    if vim.fn.mode() == 'n' then
      vim.fn.system('macism com.google.inputmethod.Japanese.Roman')
    end
  end,
})

-- vim: ts=2 sts=2 sw=2 et
