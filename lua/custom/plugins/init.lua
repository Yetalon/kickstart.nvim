-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)

-- See the kickstart.nvim README for more information
return {
  {
    'windwp/nvim-ts-autotag',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  },
}
