-- [[ オプション設定 ]]
-- `:help vim.o` を参照
-- NOTE: ここに挙げている設定は自由に変更できます。
--  その他の項目は `:help option-list` を参照してください。
--
vim.o.hidden = true

-- デフォルトで行番号を表示
vim.o.number = true
-- 相対行番号を併用するとジャンプがしやすくなります。
--  試して自分に合うか確認してみてください。
-- vim.o.relativenumber = true

-- マウス操作を有効化（分割のサイズ変更などに便利）
vim.o.mouse = 'a'

-- ステータスラインに表示するためモードは非表示にする
vim.o.showmode = false

-- OS と Neovim のクリップボードを同期
--  起動時間が延びる可能性があるため `UiEnter` 後に設定しています。
--  クリップボードを共有したくない場合はこの設定を削除してください。
--  `:help 'clipboard'` を参照
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- 折り返し行でもインデントを維持
vim.o.breakindent = true

-- Undo 履歴をファイル保存
vim.o.undofile = true

-- 検索語に大文字が含まれるか \C が付く場合を除き、小文字・大文字を区別しない
vim.o.ignorecase = true
vim.o.smartcase = true

-- サインカラムを常時表示
vim.o.signcolumn = 'yes'

-- 更新間隔を短くする
vim.o.updatetime = 250

-- マッピング待機時間を短くする
vim.o.timeoutlen = 300

-- 新しい分割ウィンドウの開き方を設定
vim.o.splitright = true
vim.o.splitbelow = true

-- エディタで空白文字などをどのように表示するかを設定
--  `:help 'list'`
--  および `:help 'listchars'` を参照
--
--  `listchars` は `vim.o` ではなく `vim.opt` で設定している点に注意してください。
--  `vim.o` とほぼ同じですが、テーブルを扱いやすいインターフェースを提供します。
--   詳細は `:help lua-options`
--   と `:help lua-options-guide` を参照
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- 置換結果を入力しながらプレビュー
vim.o.inccommand = 'split'

-- カーソル行をハイライト
vim.o.cursorline = true

-- カーソル上下に確保する最小行数
vim.o.scrolloff = 10

-- 未保存の変更がある状態で `:q` などを実行した場合に保存確認ダイアログを表示
-- `:help 'confirm'` を参照
vim.o.confirm = true

-- vim: ts=2 sts=2 sw=2 et
