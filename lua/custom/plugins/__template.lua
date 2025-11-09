-- 雛形ファイル（コピーしてリネームして使用）
-- 目的: 次回以降のプラグイン追加を簡単にする
-- 注意: 本ファイル自体はNeovimの動作に影響しないよう、空テーブルを返します。

-- 使用例（コメントを外して別名ファイルで使用）:
-- return {
--   'numToStr/Comment.nvim',
--   event = 'VeryLazy',      -- 遅延読み込みの例（任意）
--   -- enabled = true,       -- 条件で有効/無効を切り替えたい場合
--   -- dependencies = { '依存/プラグイン' },
--   -- build = 'make',
--   opts = {                 -- `require('Comment').setup(opts)` に渡す設定
--   },
--   config = function(_, opts)
--     require('Comment').setup(opts)
--   end,
--   -- keys = {
--   --   { '<leader>c', function()
--   --       require('Comment.api').toggle.linewise.current()
--   --     end, desc = 'Toggle comment' },
--   -- },
-- }

return {}

