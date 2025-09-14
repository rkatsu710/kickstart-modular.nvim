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
