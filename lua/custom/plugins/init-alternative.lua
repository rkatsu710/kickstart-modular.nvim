-- Alternative approach: explicitly require individual plugin files
-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

return {
  -- Explicitly load lualine configuration
  require('custom.plugins.lualine'),
  
  -- Add other plugins here as needed
  -- require('custom.plugins.other-plugin'),
}
