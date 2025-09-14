return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    -- IMEステータス表示用の関数
    local function imselect_status()
      return require("imselect").input_method()
    end
    
    -- IMEステータス表示用のハイライト設定
    vim.api.nvim_command('highlight IME_Japanese guifg=#f7768e')
    vim.api.nvim_command('highlight IME_Roman guifg=#9ece6a')
    
    require('lualine').setup {
      options = {
        theme = 'auto', -- colorschemeに合わせる
        icons_enabled = true,
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { { 'filename', path = 1 } }, -- path=1: 相対パス表示
        lualine_x = { imselect_status, 'encoding', 'fileformat', 'filetype' },
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
      extensions = { 'fugitive', 'lazy', 'nvim-tree', 'quickfix' },
    }
  end,
}
