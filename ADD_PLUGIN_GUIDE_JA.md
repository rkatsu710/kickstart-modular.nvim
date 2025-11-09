# Neovim 新規プラグイン導入手順（lazy.nvim）

- 本設定は `lazy.nvim` を使用しています。
- 既に `lua/lazy-plugins.lua` 内で `{ import = 'custom.plugins' }` が有効化済みです。
- 追加は「モジュール方式（推奨）」か「直書き方式」のどちらでも可能です。

## 推奨: `lua/custom/plugins/*.lua` に追加
1) 追加したいプラグインのリポジトリ名を確認（例: `numToStr/Comment.nvim`）
2) `nvim/lua/custom/plugins/` 配下に新規ファイルを作成（例: `comment.lua`）
3) 以下のような仕様テーブルを返すLuaを記述

```lua
-- nvim/lua/custom/plugins/comment.lua
return {
  'numToStr/Comment.nvim',
  event = 'VeryLazy', -- 遅延読み込み例（任意）
  config = function()
    require('Comment').setup()
  end,
}
```

4) Neovimを起動すると自動でインストールされます。必要に応じて `:Lazy` で状態確認、`u` で更新、`q` で閉じます。

補足:
- 依存関係がある場合は `dependencies = { '依存/プラグイン' }` を追記します。
- ビルドが必要な場合は `build = 'make'` のように指定します。
- キーマップはプラグイン定義内に `keys = { ... }` を書くか、`lua/keymaps.lua` に追加します。

## 代替: `lua/lazy-plugins.lua` に直書き
- `require('lazy').setup({ ... })` のリストにエントリを追加します。
- 例（テーブル形式）:

```lua
{
  'numToStr/Comment.nvim',
  config = function()
    require('Comment').setup()
  end,
}
```

## よく使うコマンド
- `:Lazy`          プラグインUIを開く（状態/操作）
- `:Lazy sync`     追加/削除/更新を同期
- `:Lazy update`   更新のみ実行
- `:Lazy clean`    不要プラグインの削除
- `:Lazy lock`     `lazy-lock.json` を更新
- `:Lazy restore`  `lazy-lock.json` にロールバック
- `:checkhealth`   トラブルシュート用ヘルスチェック

## 本設定の流れ（参考）
- `init.lua` → `lazy-bootstrap.lua`（lazy.nvim導入）→ `lazy-plugins.lua`（プラグイン一覧）→ `{ import = 'custom.plugins' }` で `lua/custom/plugins/*.lua` を自動読込
- Nerd Font 利用は `vim.g.have_nerd_font = true`（必要に応じて変更）

## 追加のヒント
- 追加前に `:help lazy.nvim-🔌-plugin-spec` 参照（Telescope: `<space>sh` → `lazy.nvim-plugin`）
- 不要になったプラグインは該当ファイルを削除し、`:Lazy clean` を実行

