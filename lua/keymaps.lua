-- [[ 基本キーマップ ]]
--  `:help vim.keymap.set()` を参照

-- ノーマルモードで <Esc> を押したときに検索ハイライトをクリア
--  `:help hlsearch` を参照
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Ctrl+[ でインサートモードを抜けると同時に日本語入力をOFF
vim.keymap.set('i', '<C-[>', function()
  -- インサートモードを抜ける
  vim.cmd('stopinsert')
  -- 日本語入力をOFFにする
  vim.fn.system('macism com.apple.inputmethod.Kotoeri.RomajiTyping.Roman')
end, { desc = 'Exit insert mode and turn off Japanese input' })

-- jj でインサートモードを抜けると同時に日本語入力をOFF
vim.keymap.set('i', 'jj', function()
  -- インサートモードを抜ける
  vim.cmd('stopinsert')
  -- 日本語入力をOFFにする
  vim.fn.system('macism com.apple.inputmethod.Kotoeri.RomajiTyping.Roman')
end, { desc = 'Exit insert mode with jj and turn off Japanese input' })

-- っj でインサートモードを抜けると同時に日本語入力をOFF（日本語入力時）
vim.keymap.set('i', 'っj', function()
  -- インサートモードを抜ける
  vim.cmd('stopinsert')
  -- 日本語入力をOFFにする
  vim.fn.system('macism com.apple.inputmethod.Kotoeri.RomajiTyping.Romann')
end, { desc = 'Exit insert mode with っj and turn off Japanese input' })

-- IMEステータス表示のトグル
vim.keymap.set("n", "<leader>II", ":lua require'imselect'.toggle_ime_display()<CR>", { desc = 'Toggle IME status display' })

-- デバッグ用：現在のIME識別子を表示
vim.keymap.set("n", "<leader>Id", ":lua require'imselect'.show_current_ime()<CR>", { desc = 'Show current IME identifier' })

-- 診断一覧を開くキーマップ
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- 組み込みターミナルで使いやすいショートカットでノーマルモードへ戻る設定
-- 通常は <C-\><C-n> を押す必要があり、慣れないと気付きづらい組み合わせです。
--
-- NOTE: すべてのターミナルや tmux で動作するとは限りません。環境に合わせて別のマッピングを使うか、
-- 必要に応じて <C-\><C-n> を利用してください。
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Neo-tree 用キーマップ
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

-- TIP: ノーマルモードで矢印キーを無効化するサンプル
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- 分割ウィンドウ間の移動を簡単にするキーマップ
--  CTRL+<hjkl> でウィンドウを切り替えます
--
--  すべてのウィンドウコマンドは `:help wincmd` を参照
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: ターミナルによってはキーマップが衝突したり、固有のキーコードを送れない場合があります
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ 基本的なオートコマンド ]]
--  `:help lua-guide-autocommands` を参照

-- テキストをヤンク（コピー）したときにハイライトする
--  ノーマルモードで `yap` を試してみてください
--  `:help vim.hl.on_yank()` を参照
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
      vim.fn.system('macism com.apple.inputmethod.Kotoeri.RomajiTyping.Roman')
    end
  end,
})

-- === 削除操作でクリップボードを汚さない設定 ===
-- d, x, c, s 操作時にクリップボードに送らず、ブラックホールレジスタ("_)を使用
vim.keymap.set('n', 'd', '"_d', { desc = 'Delete without copying to clipboard' })
vim.keymap.set('v', 'd', '"_d', { desc = 'Delete without copying to clipboard' })
vim.keymap.set('n', 'x', '"_x', { desc = 'Delete character without copying to clipboard' })
vim.keymap.set('v', 'x', '"_x', { desc = 'Delete selection without copying to clipboard' })
vim.keymap.set('n', 'c', '"_c', { desc = 'Change without copying to clipboard' })
vim.keymap.set('v', 'c', '"_c', { desc = 'Change without copying to clipboard' })
vim.keymap.set('n', 's', '"_s', { desc = 'Substitute without copying to clipboard' })
vim.keymap.set('v', 's', '"_s', { desc = 'Substitute without copying to clipboard' })

-- 明示的にクリップボードに削除内容を送りたい場合のキーマップ
vim.keymap.set('n', '<leader>d', 'd', { desc = 'Delete and copy to clipboard' })
vim.keymap.set('v', '<leader>d', 'd', { desc = 'Delete and copy to clipboard' })
vim.keymap.set('n', '<leader>x', 'x', { desc = 'Delete character and copy to clipboard' })
vim.keymap.set('v', '<leader>x', 'x', { desc = 'Delete selection and copy to clipboard' })
vim.keymap.set('n', '<leader>c', 'c', { desc = 'Change and copy to clipboard' })
vim.keymap.set('v', '<leader>c', 'c', { desc = 'Change and copy to clipboard' })

-- dd（行削除）も同様に設定
vim.keymap.set('n', 'dd', '"_dd', { desc = 'Delete line without copying to clipboard' })
vim.keymap.set('n', '<leader>dd', 'dd', { desc = 'Delete line and copy to clipboard' })

-- vim: ts=2 sts=2 sw=2 et
