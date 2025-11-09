-- [[ プラグインの構成とインストール ]]
--
--  現在のプラグイン状況を確認するには
--    :Lazy
--  を実行します
--
--  このメニューで `?` を押すとヘルプを表示でき、`:q` でウィンドウを閉じます
--
--  プラグインを更新するには
--    :Lazy update
--  を実行します
--
-- NOTE: 使用したいプラグインはここで定義します。
require('lazy').setup({
  -- NOTE: プラグインはリンク（GitHub なら 'owner/repo' 形式）で追加できます。
  'NMAC427/guess-indent.nvim', -- タブ幅とシフト幅を自動検出

  -- NOTE: テーブルで追加することもでき、
  -- 最初の要素にリンクを指定し、残りのキーで読み込み条件や設定を制御します。
  --
  -- `opts = {}` を指定するとプラグインの `setup()` に同じテーブルが渡され、強制的に読み込まれます。
  --

  -- モジュール化の例: `require 'path.name'` と書くと
  -- lua/path/name.lua にあるプラグイン定義を読み込みます

  require 'kickstart.plugins.gitsigns',

  require 'kickstart.plugins.which-key',

  require 'kickstart.plugins.telescope',

  require 'kickstart.plugins.lspconfig',

  require 'kickstart.plugins.conform',

  require 'kickstart.plugins.blink-cmp',

  require 'kickstart.plugins.tokyonight',

  require 'kickstart.plugins.todo-comments',

  require 'kickstart.plugins.mini',

  require 'kickstart.plugins.treesitter',

  -- 以下のコメントは Kickstart リポジトリを取得している場合のみ有効です。
  -- init.lua をコピーしただけの場合はリポジトリから該当ファイルをダウンロードし、所定の場所へ配置してください。

  -- NOTE: Neovim をさらに活用するために、Kickstart 用のプラグインを追加・設定しましょう。
  --
  --  ここでは Kickstart リポジトリに含まれている例を紹介します。
  --  使いたい行のコメントを外すと有効になります（変更後は Neovim を再起動してください）。
  --
  -- require 'kickstart.plugins.debug',
  require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',
  -- require 'kickstart.plugins.autopairs',
  require 'kickstart.plugins.neo-tree',

  -- NOTE: 下記の import を使うと `lua/custom/plugins/*.lua` から自作プラグイン設定を読み込めます。
  --    設定をモジュール化する簡単な方法です。
  --
  --  この行のコメントを外し、`lua/custom/plugins/*.lua` にプラグイン定義を追加してみましょう。
  { import = 'custom.plugins' },
  --
  -- 読み込みや設定例については `:help lazy.nvim-🔌-plugin-spec` を参照してください。
  -- Telescope から検索することもできます。
  -- ノーマルモードで `<space>sh` を押し、`lazy.nvim-plugin` と入力します。
  -- 直前の検索を同じウィンドウで再開するには `<space>sr` を使います。
}, {
  ui = {
    -- Nerd Font を使っている場合は icons を空テーブルにすると lazy.nvim の既定アイコンを使用します。
    -- それ以外の場合は Unicode アイコンのテーブルを定義してください。
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- vim: ts=2 sts=2 sw=2 et
