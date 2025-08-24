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
