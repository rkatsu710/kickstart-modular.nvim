# Neovim カスタマイズ記録

## 概要
kickstart-modular.nvim環境に対して実施したカスタマイズの記録です。

## 環境情報
- **ベース設定**: kickstart-modular.nvim
- **プラグインマネージャー**: lazy.nvim
- **設定ディレクトリ**: `~/.config/nvim` → `~/dotfiles/.config/nvim` (シンボリックリンク)
- **カスタマイズ日**: 2025-08-24

## 実施したカスタマイズ

### 1. lualine プラグインの導入

#### ファイル: `lua/custom/plugins/lualine.lua`
```lua
return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup {
      options = {
        theme = 'auto', -- colorschemeに合わせる
        icons_enabled = true,
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { { 'filename', path = 1 } }, -- path=1: 相対パス表示
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      -- タブラインの設定を強化（バッファとタブの管理）
      tabline = {
        lualine_a = { 
          {
            'buffers',
            show_filename_only = false, -- ファイル名のみ表示
            hide_filename_extension = false, -- 拡張子を表示
            show_modified_status = true, -- 変更状態を表示
            mode = 2, -- 0: バッファ番号のみ, 1: バッファ名のみ, 2: バッファ番号 + バッファ名
            max_length = vim.o.columns * 2 / 3, -- 最大長を画面幅の2/3に設定
            filetype_names = {
              TelescopePrompt = 'Telescope',
              dashboard = 'Dashboard',
              packer = 'Packer',
              fzf = 'FZF',
              alpha = 'Alpha'
            },
            buffers_color = {
              active = 'lualine_a_normal',
              inactive = 'lualine_a_inactive',
            },
          }
        },
        lualine_z = { 
          {
            'tabs',
            max_length = vim.o.columns / 3,
            mode = 2, -- 0: タブ番号のみ, 1: タブ名のみ, 2: タブ番号 + タブ名
            tabs_color = {
              active = 'lualine_a_normal',
              inactive = 'lualine_a_inactive',
            },
          }
        },
      },
      extensions = { 'fugitive', 'lazy', 'neo-tree', 'quickfix' },
    }
  end,
}
```

#### 導入時の問題と解決
- **問題**: `lua/custom/plugins/init.lua`が空のテーブル`{}`を返していたため、lualine.luaが読み込まれない
- **解決**: `init.lua`ファイルを削除して、ディレクトリ内の個別ファイルが自動読み込みされるようにした

### 2. mini.bufremove プラグインの導入

#### ファイル: `lua/kickstart/plugins/mini.lua` (修正)
```lua
return {
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      require('mini.surround').setup()

      -- Buffer remove with layout preservation
      -- バッファ削除時にウィンドウレイアウトを保持
      require('mini.bufremove').setup()

      -- Simple and easy statusline.
      -- lualineを使用するため、mini.statuslineは無効化
      -- local statusline = require 'mini.statusline'
      -- statusline.setup { use_icons = vim.g.have_nerd_font }
      -- statusline.section_location = function()
      --   return '%2l:%-2v'
      -- end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
}
```

#### 変更点
- `require('mini.bufremove').setup()`を追加
- `mini.statusline`を無効化（lualineと競合するため）

### 3. キーマップの追加

#### ファイル: `lua/keymaps.lua` (追加部分)
```lua
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
```

### 4. neotree設定の強化

#### ファイル: `lua/kickstart/plugins/neo-tree.lua` (修正部分)

##### event_handlersの追加
```lua
-- バッファを閉じたときのレイアウト維持設定
event_handlers = {
  {
    event = "file_opened",
    handler = function(file_path)
      -- ファイルを開いた後もneotreeを開いたままにする
      require("neo-tree.command").execute({ action = "show" })
    end
  },
  {
    event = "neo_tree_buffer_enter",
    handler = function()
      -- neotreeにフォーカスが移った時の処理
      vim.cmd 'highlight! Cursor blend=100'
    end
  },
  {
    event = "neo_tree_buffer_leave",
    handler = function()
      -- neotreeからフォーカスが離れた時の処理
      vim.cmd 'highlight! Cursor guibg=#5f87af blend=0'
    end
  }
},
```

##### buffersセクションの強化
```lua
buffers = {
  follow_current_file = {
    enabled = true,
    leave_dirs_open = false,
  },
  group_empty_dirs = true,
  show_unloaded = true,
  window = {
    mappings = {
      ['bd'] = function(state)
        -- mini.bufremoveを使用してバッファを削除（レイアウト保持）
        local node = state.tree:get_node()
        if node.type == "file" then
          local bufnr = vim.fn.bufnr(node.path)
          if bufnr ~= -1 then
            require('mini.bufremove').delete(bufnr, false)
            -- neotreeの表示を更新
            require("neo-tree.sources.buffers").refresh(state)
          end
        end
      end,
      ['<bs>'] = 'navigate_up',
      ['.'] = 'set_root',
      -- バッファを強制削除（mini.bufremoveを使用）
      ['BD'] = function(state)
        local node = state.tree:get_node()
        if node.type == "file" then
          local bufnr = vim.fn.bufnr(node.path)
          if bufnr ~= -1 then
            require('mini.bufremove').delete(bufnr, true)
            require("neo-tree.sources.buffers").refresh(state)
          end
        end
      end,
    }
  },
},
```

## キーマップ一覧

### バッファ管理
| キー | 動作 | 説明 |
|------|------|------|
| `<leader>w` | バッファ削除（安全） | ウィンドウレイアウトを保持して削除 |
| `<leader>W` | バッファ強制削除 | 未保存の変更があっても削除 |
| `<leader>Q` | 他のバッファを全て閉じる | 現在のバッファ以外を削除 |

### バッファナビゲーション
| キー | 動作 | 説明 |
|------|------|------|
| `<Tab>` | 次のバッファに切り替え | バッファを順番に移動 |
| `<S-Tab>` | 前のバッファに切り替え | バッファを逆順に移動 |
| `<S-h>` | 前のバッファに移動 | 左方向のバッファ移動 |
| `<S-l>` | 次のバッファに移動 | 右方向のバッファ移動 |

### neotree内でのバッファ操作
| キー | 動作 | 説明 |
|------|------|------|
| `bd` | バッファ削除（安全） | neotree内でのバッファ削除 |
| `BD` | バッファ強制削除 | neotree内での強制バッファ削除 |

## 機能と利点

### 1. lualine
- **ステータスライン**: モード、ブランチ、診断情報、ファイル情報を表示
- **タブライン**: バッファとタブを効率的に管理
- **バッファ表示**: ファイル名、拡張子、変更状態を詳細表示
- **レスポンシブ**: 画面幅に応じた表示調整

### 2. mini.bufremove
- **ウィンドウレイアウト保持**: バッファ削除時にウィンドウ分割が維持される
- **スマートな削除**: 最後のバッファを削除する際は空のバッファに切り替わる
- **安全な削除**: 未保存の変更がある場合は警告が表示される
- **一貫した動作**: キーマップとneotree操作で同じ動作を実現

### 3. neotree強化
- **レイアウト維持**: ファイルを開いてもneotreeが開いたまま
- **バッファ管理**: neotree内でのバッファ削除操作
- **視覚的フィードバック**: フォーカス状態に応じたカーソル表示

## 参考資料
- [nvim bufferlineでタブごとに表示するバッファを切り替える](07%20Knowledge/nvim%20bufferlineでタブごとに表示するバッファを切り替える.md)
- [mini.bufremoveの導入手順](06%20ProcedureNote/mini.bufremoveの導入手順.md)
- [kickstart-modular.nvim](https://github.com/dam9000/kickstart-modular.nvim)
- [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)
- [mini.nvim](https://github.com/echasnovski/mini.nvim)

### 5. 日本語入力自動切り替え機能

#### 概要
Neovimでの日本語入力を自動的に管理し、ノーマルモード時は英数入力、インサートモード時は前回の入力メソッドを復元する機能。

#### 前提条件
- macOS環境
- `macism`コマンドがインストール済み（`brew install macism`）
- Google日本語入力が設定済み

#### ファイル: `lua/custom/plugins/im-select.lua`
```lua
return {
  'keaising/im-select.nvim',
  event = { 'InsertEnter', 'FocusGained' }, -- FocusGainedイベントを追加
  config = function()
    require('im_select').setup({
      default_im_select = 'com.google.inputmethod.Japanese.Roman', -- 英数入力
      default_command = 'macism', -- macismを指定
      set_default_events = { 'VimEnter', 'FocusGained', 'InsertLeave', 'CmdlineLeave' },
      set_previous_events = { 'InsertEnter' },
    })
  end,
}
```

#### ファイル: `lua/keymaps.lua` (追加部分)
```lua
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
```

#### 機能詳細

##### 自動切り替えタイミング
| イベント | 動作 | 説明 |
|----------|------|------|
| `VimEnter` | 英数入力に切り替え | Neovim起動時 |
| `FocusGained` | 英数入力に切り替え（ノーマルモード時のみ） | Neovimにフォーカスが移った時 |
| `InsertLeave` | 英数入力に切り替え | インサートモードを抜ける時 |
| `CmdlineLeave` | 英数入力に切り替え | コマンドラインモードを抜ける時 |
| `InsertEnter` | 前回の入力メソッドを復元 | インサートモードに入る時 |

##### 利点
- **シームレスな日本語入力**: インサートモード時は日本語入力が可能
- **自動英数切り替え**: ノーマルモード時は自動的に英数入力になる
- **フォーカス管理**: 他のアプリから戻った時も適切に切り替わる
- **状態保持**: インサートモード時の入力メソッド状態を記憶

##### 設定されている入力メソッド
- **英数入力**: `com.google.inputmethod.Japanese.Roman`
- **日本語入力**: `com.google.inputmethod.Japanese.base`（自動検出）

#### トラブルシューティング

##### macismコマンドの確認
```bash
# macismがインストールされているか確認
which macism

# 現在の入力メソッドを確認
macism

# 利用可能な入力メソッド一覧
macism list
```

##### 動作確認方法
1. Neovimを起動して、現在の入力メソッドが英数になることを確認
2. インサートモードに入り、日本語入力に切り替えて文字を入力
3. Escキーでノーマルモードに戻り、自動的に英数入力になることを確認
4. 他のアプリに切り替えてからNeovimに戻り、英数入力になることを確認

### 6. ripgrep（高速検索ツール）のインストール

#### 概要
Telescope.nvimの検索機能を高速化するため、ripgrepをシステムにインストール。

#### インストール日時
2025-08-24T03:13:49.048Z

#### インストール方法
```bash
brew install ripgrep
```

#### インストール結果
- **バージョン**: 14.1.1
- **PCRE2サポート**: 有効（正規表現機能強化）
- **SIMD最適化**: NEON対応（Apple Silicon最適化）
- **JIT**: 利用可能（高速パターンマッチング）

#### 機能詳細

##### Telescope.nvimでの活用
| キーマップ | 動作 | 説明 |
|------------|------|------|
| `<leader>sg` | Live grep | プロジェクト全体での文字列検索 |
| `<leader>sw` | 現在のワード検索 | カーソル下の単語を検索 |
| `<leader>sr` | 検索履歴 | 最近の検索履歴を表示 |

##### コマンドライン使用例
```bash
# 基本的な検索
rg "検索文字列" ~/dotfiles/

# ファイルタイプを指定した検索
rg -t lua "function"          # Luaファイルのみ
rg -t js -t ts "component"    # JavaScriptとTypeScriptファイル

# 大文字小文字を区別しない検索
rg -i "CONFIG"

# 正規表現を使用した検索
rg "\d{3}-\d{4}-\d{4}"       # 電話番号パターン

# 特定のディレクトリを除外
rg "TODO" --glob "!node_modules/*"
```

##### パフォーマンス向上
- **従来のgrep**: 数秒〜数十秒
- **ripgrep**: 数百ミリ秒〜数秒
- **特に大きなプロジェクト**: 10倍〜100倍の高速化

#### Telescope.nvimとの連携
ripgrepがインストールされると、Telescope.nvimは自動的にripgrepを検索バックエンドとして使用し、以下の機能が大幅に高速化されます：

- ファイル内容の検索（Live grep）
- プロジェクト全体での文字列検索
- 正規表現を使った複雑な検索パターン
- 大量のファイルがあるプロジェクトでの検索

#### 利点
- **高速検索**: 従来のgrepより大幅に高速
- **スマートフィルタリング**: .gitignoreファイルを自動的に考慮
- **豊富なオプション**: ファイルタイプ、正規表現、除外パターンなど
- **Neovim統合**: Telescope.nvimとシームレスに連携

### 7. Telescope 徹底活用セット

#### 概要
Obsidianノート「Telescope 徹底活用セット」を基に、Telescopeを爆速＆万能な検索ツールにカスタマイズ。

#### カスタマイズ日時
2025-08-24T03:18:55.841Z

#### ファイル: `lua/custom/plugins/telescope.lua`
```lua
-- custom/plugins/telescope.lua
return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- 高速化: fzf ネイティブ
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    -- UI セレクトの置き換え（LSP などの選択UIが Telescope 化）
    "nvim-telescope/telescope-ui-select.nvim",
    -- 追加: grep を柔軟に（--hidden/-g/-t 等をその場で）
    "nvim-telescope/telescope-live-grep-args.nvim",
  },
  keys = {
    -- === Find ===
    { "<leader>ff", function() require("telescope.builtin").find_files({ hidden = true, no_ignore = true }) end, desc = "Find files (all)" },
    { "<leader>fp", function() require("telescope.builtin").find_files({ cwd = require("telescope.utils").buffer_dir() }) end, desc = "Find files (buffer dir)" },
    { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Buffers" },
    { "<leader>fo", function() require("telescope.builtin").oldfiles() end, desc = "Recent files" },

    -- === Grep ===
    { "<leader>fg", function() require("telescope").extensions.live_grep_args.live_grep_args() end, desc = "Live grep (args)" },
    { "<leader>fs", function() require("telescope.builtin").grep_string() end, desc = "Grep word under cursor" },
    { "<leader>fS", function() require("telescope.builtin").current_buffer_fuzzy_find() end, desc = "Search in current buffer" },

    -- === Git ===
    { "<leader>gc", function() require("telescope.builtin").git_commits() end, desc = "Git commits" },
    { "<leader>gs", function() require("telescope.builtin").git_status() end,  desc = "Git status" },

    -- === LSP ===
    { "gd", function() require("telescope.builtin").lsp_definitions() end, desc = "LSP: Definitions" },
    { "gr", function() require("telescope.builtin").lsp_references() end,  desc = "LSP: References" },
    { "gi", function() require("telescope.builtin").lsp_implementations() end, desc = "LSP: Implementations" },
    { "<leader>fd", function() require("telescope.builtin").diagnostics() end, desc = "Diagnostics" },

    -- === Session ===
    { "<leader>fr", function() require("telescope.builtin").resume() end, desc = "Resume last picker" },

    -- === Git ルートで検索 ===
    { "<leader>fG", function()
      local utils = require("telescope.utils")
      require("telescope").extensions.live_grep_args.live_grep_args({ cwd = utils.get_git_root() })
    end, desc = "Live grep (git root)" },

    -- === 既存のkickstartキーマップとの互換性 ===
    { "<leader>sh", function() require("telescope.builtin").help_tags() end, desc = "[S]earch [H]elp" },
    { "<leader>sk", function() require("telescope.builtin").keymaps() end, desc = "[S]earch [K]eymaps" },
    -- ... その他のキーマップ
  },
  opts = function()
    local lga_actions = require("telescope-live-grep-args.actions")
    return {
      defaults = {
        -- レイアウト・操作の標準
        layout_strategy = "flex",
        layout_config = { width = 0.95, height = 0.90, prompt_position = "top" },
        sorting_strategy = "ascending",
        path_display = { "smart" },
        mappings = {
          i = {
            -- よく使う操作: 候補の複数選択→Quickfixへ
            ["<C-q>"] = function(...)
              require("telescope.actions").smart_send_to_qflist(...); require("telescope.actions").open_qflist(...)
            end,
            -- 次/前へ
            ["<C-j>"] = require("telescope.actions").move_selection_next,
            ["<C-k>"] = require("telescope.actions").move_selection_previous,
            -- 選択トグル（複数選択）
            ["<Tab>"] = require("telescope.actions").toggle_selection,
          },
        },
        -- 大容量対策：巨大ファイルプレビュー抑制
        preview = { filesize_limit = 2, timeout = 250 },
        vimgrep_arguments = {
          "rg", "--color=never", "--no-heading", "--with-filename",
          "--line-number", "--column", "--smart-case", "--hidden", "--trim"
        },
        file_ignore_patterns = { ".git/", "node_modules/", ".venv/", "dist/", "build/" },
      },
      pickers = {
        find_files = {
          hidden = true, no_ignore = true,
        },
        buffers = {
          sort_mru = true, ignore_current_buffer = true,
          mappings = {
            i = { ["<C-d>"] = require("telescope.actions").delete_buffer },
            n = { ["d"] = require("telescope.actions").delete_buffer },
          },
        },
      },
      extensions = {
        fzf = { fuzzy = true, case_mode = "smart_case" },
        ["ui-select"] = { require("telescope.themes").get_dropdown({}) },
        live_grep_args = {
          auto_quoting = true,
          mappings = {
            i = {
              ["<C-k>"] = lga_actions.quote_prompt(),   -- 既存 + クォート
              ["<C-g>"] = lga_actions.quote_prompt({ postfix = " --iglob " }), -- -g 代わり
              ["<C-t>"] = lga_actions.quote_prompt({ postfix = " -t" }),       -- ripgrep -t
            },
          },
        },
      },
    }
  end,
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    telescope.load_extension("fzf")
    telescope.load_extension("ui-select")
    telescope.load_extension("live_grep_args")
  end,
}
```

#### ファイル: `lua/kickstart/plugins/telescope.lua` (無効化)
既存のkickstart telescope設定を無効化し、カスタム版を優先するように変更。

#### 機能詳細

##### 新規追加プラグイン
| プラグイン | 機能 | 説明 |
|------------|------|------|
| `telescope-fzf-native.nvim` | 高速化 | ネイティブfzfアルゴリズムで検索を爆速化 |
| `telescope-ui-select.nvim` | UI統一 | LSPのコードアクション等をTelescope UIに統一 |
| `telescope-live-grep-args.nvim` | 柔軟検索 | ripgrepオプションをその場で指定可能 |

##### 主要キーマップ（新規・強化版）
| キー | 動作 | 説明 |
|------|------|------|
| `<leader>ff` | 全ファイル検索 | 隠しファイル・無視ファイルも含めて検索 |
| `<leader>fp` | バッファディレクトリ検索 | 現在のバッファのディレクトリ内を検索 |
| `<leader>fb` | バッファ一覧 | 開いているバッファを一覧表示 |
| `<leader>fo` | 最近のファイル | 最近開いたファイルを検索 |
| `<leader>fg` | Live grep (引数付き) | ripgrepオプションを動的に指定可能 |
| `<leader>fs` | カーソル下の単語検索 | カーソル位置の単語をプロジェクト全体で検索 |
| `<leader>fS` | 現在バッファ内検索 | 現在のバッファ内をファジー検索 |
| `<leader>gc` | Git コミット履歴 | Gitコミット履歴を検索・表示 |
| `<leader>gs` | Git ステータス | Git変更ファイルを一覧表示 |
| `<leader>fd` | 診断情報 | LSP診断情報をワークスペース全体で表示 |
| `<leader>fr` | 前回の検索を再開 | 最後に使用したpickerを再表示 |
| `<leader>fG` | Git ルートで検索 | Gitルートディレクトリを基準に検索 |

##### LSP統合キーマップ
| キー | 動作 | 説明 |
|------|------|------|
| `gd` | 定義へジャンプ | Telescope UIで定義を表示・選択 |
| `gr` | 参照を表示 | Telescope UIで参照箇所を一覧表示 |
| `gi` | 実装を表示 | Telescope UIで実装を一覧表示 |

##### 高度な検索機能（live-grep-args）
| 検索例 | 説明 |
|--------|------|
| `error -g '!**/tests/**'` | testsディレクトリを除外してerrorを検索 |
| `"my func" -t go` | Goファイルのみで"my func"を検索 |
| `TODO --hidden` | 隠しファイルも含めてTODOを検索 |
| `function -t lua -t vim` | LuaとVimファイルでfunctionを検索 |

##### Telescope内操作キーマップ
| キー | 動作 | 説明 |
|------|------|------|
| `<C-q>` | Quickfixに送信 | 選択した候補をQuickfixリストに送信 |
| `<C-j>` | 次の候補 | 候補リストで下に移動 |
| `<C-k>` | 前の候補 | 候補リストで上に移動 |
| `<Tab>` | 選択トグル | 複数選択のトグル |
| `<C-d>` | バッファ削除 | バッファ一覧でバッファを削除 |

##### live-grep-args特殊キーマップ
| キー | 動作 | 説明 |
|------|------|------|
| `<C-k>` | クォート追加 | 現在の検索語をクォートで囲む |
| `<C-g>` | glob パターン | `--iglob` オプションを追加 |
| `<C-t>` | ファイルタイプ | `-t` オプションを追加 |

#### パフォーマンス最適化
- **fzf-native**: ネイティブfzfアルゴリズムで検索速度を大幅向上
- **ripgrep統合**: `--hidden`, `--trim`, `--smart-case`で効率的な検索
- **プレビュー制限**: 2MB以上のファイルはプレビューを制限
- **ファイル除外**: `.git/`, `node_modules/`等の不要ディレクトリを除外

#### UI/UX改善
- **レイアウト**: flexレイアウトで画面サイズに応じて最適化
- **プロンプト位置**: 上部配置で視認性向上
- **パス表示**: smartパス表示で冗長性を削減
- **UI統一**: LSPの選択UIもTelescope化で一貫性向上

#### 互換性
既存のkickstart.nvimキーマップ（`<leader>s*`系）も維持し、段階的な移行が可能。

#### 利点
- **爆速検索**: fzf-nativeとripgrepの組み合わせで従来比10倍以上高速
- **柔軟な検索**: live-grep-argsでripgrepの全機能を活用
- **統一UI**: 全ての検索・選択操作がTelescope UIで統一
- **複数選択**: Quickfixとの連携で効率的なファイル操作
- **Git統合**: Gitワークフローとシームレスに連携

### 9. Ctrl+[キーマップ強化（日本語入力自動OFF）

#### 概要
`Ctrl+[`キーを押した時にインサートモードを抜けると同時に日本語入力を自動的にOFFにする機能。Escapeキーと同等の機能に加えて、日本語入力の切り替えを自動化することで、より快適な日本語環境でのVim操作を実現します。

#### 追加日時
2025-08-24T05:28:11Z

#### ファイル: `lua/keymaps.lua` (追加部分)
```lua
-- Ctrl+[ でインサートモードを抜けると同時に日本語入力をOFF
vim.keymap.set('i', '<C-[>', function()
  -- インサートモードを抜ける
  vim.cmd('stopinsert')
  -- 日本語入力をOFFにする
  vim.fn.system('macism com.google.inputmethod.Japanese.Roman')
end, { desc = 'Exit insert mode and turn off Japanese input' })
```

#### 機能詳細
- **即座のモード切り替え**: `Ctrl+[`でインサートモードから即座にノーマルモードへ
- **自動日本語入力OFF**: モード切り替えと同時に英数入力に自動切り替え
- **macism連携**: macismコマンドを使用してGoogle日本語入力を制御
- **既存機能保持**: 従来の`Ctrl+[`機能（Escapeと同等）を維持

#### キーマップ
| キー | モード | 動作 | 説明 |
|------|--------|------|------|
| `<C-[>` | Insert | Exit insert mode + IME OFF | インサートモード終了と日本語入力OFF |

#### 使用シナリオ
1. **日本語文章入力中**: 日本語で文章を入力している最中
2. **`Ctrl+[`押下**: キーを押してノーマルモードに切り替え
3. **自動英数切り替え**: 日本語入力が自動的に英数入力に切り替わる
4. **Vimコマンド実行**: そのままVimコマンドを英数入力で実行可能

#### 既存のim-select.nvimとの連携
- **補完関係**: im-select.nvimの自動切り替え機能を補完
- **手動制御**: ユーザーが明示的に`Ctrl+[`を押した場合の即座な切り替え
- **一貫性**: 他の自動切り替えタイミングと同じ動作を実現

#### 利点
- **操作の一貫性**: `Ctrl+[`と`Esc`の両方で同じ動作を実現
- **効率的な入力**: モード切り替えと入力メソッド切り替えを一度に実行
- **筋肉記憶**: Vimユーザーに馴染みのある`Ctrl+[`キーを活用
- **即座の反応**: キー押下と同時に入力メソッドが切り替わる

#### 注意事項
- macismコマンドが必要（`brew install macism`でインストール）
- Google日本語入力環境での動作を前提
- 他のIMEを使用する場合は入力メソッドIDの変更が必要

#### 関連設定
- `lua/custom/plugins/im-select.lua`: 基本的な自動切り替え機能
- 既存のautocmd: フォーカス時の自動切り替え機能

### 10. telescope-frecency.nvim（頻度ベースファイル検索）

#### 概要
ファイルアクセスの頻度（frequency）と最近度（recency）を組み合わせて、よく使うファイルを優先的に表示するTelescope拡張プラグイン。SQLiteデータベースでファイル履歴を管理し、プロジェクト横断でのファイル検索を効率化します。

#### 追加日時
2025-08-24T05:18:20Z

#### ファイル: `lua/custom/plugins/telescope-frecency.lua`
```lua
return {
  "nvim-telescope/telescope-frecency.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "kkharji/sqlite.lua", -- SQLiteデータベースでファイル履歴を管理
  },
  config = function()
    require("telescope").load_extension("frecency")
  end,
  keys = {
    {
      "<leader>fr",
      function()
        require("telescope").extensions.frecency.frecency({
          workspace = "CWD", -- 現在のワーキングディレクトリを基準
        })
      end,
      desc = "Find files by frecency (current workspace)",
    },
    {
      "<leader>fR",
      function()
        require("telescope").extensions.frecency.frecency()
      end,
      desc = "Find files by frecency (all workspaces)",
    },
  },
}
```

#### 機能詳細
- **頻度ベース検索**: よく開くファイルほど上位に表示
- **最近度考慮**: 最近使ったファイルも優先表示
- **ワークスペース管理**: プロジェクトごとの履歴管理
- **SQLite履歴**: 永続的なファイルアクセス履歴の保存
- **プロジェクト横断**: 複数のプロジェクト間でのファイル検索

#### キーマップ
| キー | 動作 | 説明 |
|------|------|------|
| `<leader>fr` | frecency (current workspace) | 現在のワークスペース内でfrecencyベース検索 |
| `<leader>fR` | frecency (all workspaces) | 全ワークスペースでfrecencyベース検索 |

#### 依存関係
- `nvim-telescope/telescope.nvim`: ベースとなるTelescope
- `kkharji/sqlite.lua`: SQLiteデータベース操作用

#### 使用方法
1. `<leader>fr`: 現在のプロジェクト内でよく使うファイルを検索
2. `<leader>fR`: 全プロジェクト横断でよく使うファイルを検索
3. 使用頻度が高いファイルほど上位に表示される
4. 履歴はSQLiteデータベースに永続保存される

#### 注意事項
- 初回使用時はファイル履歴が空のため、通常のファイル検索と同様の結果
- 使用を重ねることで、個人の使用パターンに最適化される
- SQLiteデータベースは `~/.local/share/nvim/` 配下に作成される

#### 利点
- **学習機能**: 使用パターンを学習して検索結果を最適化
- **効率的なファイルアクセス**: よく使うファイルに素早くアクセス
- **プロジェクト横断**: 複数のプロジェクト間でのファイル履歴管理
- **永続化**: Neovim再起動後も履歴が保持される
- **スマートランキング**: 頻度と最近度の両方を考慮した賢いソート

## 今後の拡張案
- bufferlineプラグインの導入（タブごとのバッファ切り替え機能）
- カスタムテーマの適用
- 追加のmini.nvimモジュールの活用
- プロジェクト固有の設定管理
- 他のIME（ATOK、内蔵日本語入力）への対応
- fd（高速ファイル検索）の導入検討
- telescope-file-browserの有効化検討
- telescope-project.nvimの導入（プロジェクト管理機能）

### 4. IMEステータス表示機能の追加 (2025-08-24)

#### 概要
lualineのステータスラインに現在の日本語入力の状態を表示する機能を追加。

#### 追加ファイル: `lua/imselect.lua`
IMEの状態を取得してステータスラインに表示するためのLuaモジュール。

**主な機能:**
- `macism`コマンドを使用してIMEの状態を取得
- Google日本語入力、Mac標準IME、ATOKに対応
- 英数入力時: `[_A]` (緑色)
- 日本語入力時: `[あ]` (赤色)
- トグル機能でパフォーマンス考慮（初期状態はオフ）

```lua
-- 主要な関数
M.toggle_ime_display = function() -- IME表示のオン/オフ切り替え
M.input_method = function()       -- IME状態を取得してステータス文字列を返す
M.show_current_ime = function()   -- デバッグ用：現在のIME識別子を表示
```

#### 修正ファイル: `lua/custom/plugins/lualine.lua`
lualineの設定にIMEステータス表示機能を統合。

**変更点:**
- IMEステータス表示用の関数を追加
- ハイライト設定を追加（日本語: 赤、英数: 緑）
- `lualine_x`セクションにIMEステータスを追加

```lua
-- 追加された設定
local function imselect_status()
  return require("imselect").input_method()
end

vim.api.nvim_command('highlight IME_Japanese guifg=#f7768e')
vim.api.nvim_command('highlight IME_Roman guifg=#9ece6a')

-- lualine_xセクション
lualine_x = { imselect_status, 'encoding', 'fileformat', 'filetype' },
```

#### 追加キーマップ: `lua/keymaps.lua`

**IME関連キーマップ:**
- `<leader>II`: IMEステータス表示のオン/オフ切り替え
- `<leader>Id`: デバッグ用：現在のIME識別子を表示

**インサートモード脱出キーマップ:**
- `jj`: 英数入力時にインサートモードを抜けて日本語入力をOFF
- `っj`: 日本語入力時にインサートモードを抜けて日本語入力をOFF

```lua
-- IME関連
vim.keymap.set("n", "<leader>II", ":lua require'imselect'.toggle_ime_display()<CR>", { desc = 'Toggle IME status display' })
vim.keymap.set("n", "<leader>Id", ":lua require'imselect'.show_current_ime()<CR>", { desc = 'Show current IME identifier' })

-- インサートモード脱出
vim.keymap.set('i', 'jj', function()
  vim.cmd('stopinsert')
  vim.fn.system('macism com.google.inputmethod.Japanese.Roman')
end, { desc = 'Exit insert mode with jj and turn off Japanese input' })

vim.keymap.set('i', 'っj', function()
  vim.cmd('stopinsert')
  vim.fn.system('macism com.google.inputmethod.Japanese.Roman')
end, { desc = 'Exit insert mode with っj and turn off Japanese input' })
```

#### 使用方法
1. `<leader>II`でIMEステータス表示を有効化
2. ステータスラインに現在のIME状態が表示される
3. `jj`（英数）または`っj`（日本語）でインサートモードを脱出

#### 対応IME
- **Google日本語入力**: 
  - 英数: `com.google.inputmethod.Japanese.Roman`
  - 日本語: `com.google.inputmethod.Japanese.base`
- **Mac標準IME**:
  - 英数: `com.apple.keylayout.ABC`
  - 日本語: `com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese`
- **ATOK**:
  - 英数: `atok33.Roman`
  - 日本語: `atok33.Japanese`

#### トラブルシューティング
- 日本語入力時に「Unknown」が表示される場合は、`<leader>Id`でIME識別子を確認
- Google日本語入力の識別子が異なる場合は、`lua/imselect.lua`の判定ロジックを調整

### 11. 削除操作でクリップボードを汚さない設定

#### 概要
`d`、`x`、`c`、`s`コマンドを実行した際にクリップボードの内容が書き換えられる問題を解決。
削除操作はブラックホールレジスタ(`"_`)を使用し、明示的にクリップボードに送りたい場合は`<leader>`プレフィックスを使用する方式に変更。

#### 変更日時
2025-08-24T06:16:11.822Z

#### ファイル: `lua/keymaps.lua`
```lua
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
```

#### 機能詳細
- **ブラックホールレジスタ使用**: `"_`レジスタを使用して削除内容を破棄
- **クリップボード保護**: `vim.o.clipboard = 'unnamedplus'`設定下でもクリップボードが汚されない
- **明示的コピー**: `<leader>`プレフィックスで従来の動作（クリップボードにコピー）を実行可能
- **一貫性**: ノーマルモードとビジュアルモード両方で同じ動作

#### キーマップ
| キー | 動作 | 説明 |
|------|------|------|
| `d` | `"_d` | 削除（クリップボードに送らない） |
| `x` | `"_x` | 文字削除（クリップボードに送らない） |
| `c` | `"_c` | 変更（クリップボードに送らない） |
| `s` | `"_s` | 置換（クリップボードに送らない） |
| `dd` | `"_dd` | 行削除（クリップボードに送らない） |
| `<leader>d` | `d` | 削除してクリップボードにコピー |
| `<leader>x` | `x` | 文字削除してクリップボードにコピー |
| `<leader>c` | `c` | 変更してクリップボードにコピー |
| `<leader>dd` | `dd` | 行削除してクリップボードにコピー |

#### 変更理由
- 削除操作でクリップボードの内容が意図せず上書きされる問題を解決
- ヤンク操作（`y`）とは独立した削除操作を実現
- 必要に応じて明示的にクリップボードにコピーする選択肢を提供

#### 使用例
```vim
" 通常の削除（クリップボードに送らない）
dw          " 単語削除
dd          " 行削除
x           " 文字削除
cw          " 単語変更

" クリップボードにコピーしながら削除
<leader>dw  " 単語削除してクリップボードにコピー
<leader>dd  " 行削除してクリップボードにコピー
<leader>x   " 文字削除してクリップボードにコピー
```

#### 関連設定
- `lua/options.lua`: `vim.o.clipboard = 'unnamedplus'`設定
- ヤンク操作（`y`）は従来通りクリップボードにコピーされる

---
*最終更新: 2025-08-24*
