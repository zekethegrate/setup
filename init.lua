local function oil_icon_callback(name, icon, highlight)
    local devicons = require('nvim-web-devicons')
    local icon, icon_highlight = devicons.get_icon(name, vim.fn.fnamemodify(name, ':e'))
    if icon then
        return icon .. ' ' .. name, icon_highlight
    else
        return name, highlight
    end
end
vim.wo.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.bo.softtabstop = 4
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
-- Example using a list of specs with the default options
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.maplocalleader = "\\" -- Same for `maplocalleader`
require("lazy").setup({
  "folke/which-key.nvim",
  { "folke/neoconf.nvim", cmd = "Neoconf" },
  "folke/neodev.nvim",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/vim-vsnip",
  {
      "nvim-treesitter/nvim-treesitter",
      opts = {
          ensure_installed = {"lua", "python", "vimdoc", "markdown"}
      },
  },
  {
      "Zeioth/compiler.nvim", -- Compiler
      cmd = {"CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
      dependencies = {
          "stevearc/overseer.nvim",
           "nvim-telescope/telescope.nvim",
           "nvim-lua/plenary.nvim"
      },
      opts = {},
  },
  {
      "stevearc/overseer.nvim",
      cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
      opts = {
          task_list = {
              direction = "bottom",
              min_height = 25,
              max_height = 25,
              default_detail = 1
          },
      },
  },
  "L3MON4D3/LuaSnip",
  "hrsh7th/cmp-vsnip",
  "m4xshen/autoclose.nvim",
  "neovim/nvim-lspconfig",
  "ellisonleao/gruvbox.nvim",
  { "ellisonleao/gruvbox.nvim", priority = 100 },
  "tjdevries/colorbuddy.nvim",
  {
  'stevearc/oil.nvim',
  opts = {},
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
}
})
require("nvim-web-devicons").setup({
})
require("nvim-web-devicons").get_icons()
require("oil").setup({ --File Explorer

  view_options = {
    show_hidden = true,
    get_icon = oil_icon_callback
}
})

require("nvim-treesitter.configs").setup({
        ensured_installed = {
                    "bash",
                    "comment",
                    "css",
                    "html",
                    "javascript",
                    "jsdoc",
                    "jsonc",
                    "lua",
                    "markdown",
                    "regex",
        },
})

require('nvim-web-devicons').setup{}

local cmp = require'cmp'

cmp.setup({
      sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' }, -- For luasnip users.
          -- { name = 'ultisnips' }, -- For ultisnips users.
          -- { name = 'snippy' }, -- For snippy users.
        }, {
          { name = 'buffer' },
          { name = 'vsnip' }
        }),
      snippet = {
     -- REQUIRED - you must specify a snippet engine
         expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
         end,
            },
    mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
})
require("autoclose").setup()

local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require('lspconfig')['clangd'].setup {
    capabilities = capabilities
}

-- Language servers
require'lspconfig'.pylsp.setup{}
require'lspconfig'.rust_analyzer.setup{}
require'lspconfig'.lua_ls.setup {
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
      return
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT'
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
          -- Depending on the usage, you might want to add additional paths here.
          -- "${3rd}/luv/library"
          -- "${3rd}/busted/library",
        }
        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
        -- library = vim.api.nvim_get_runtime_file("", true)
      }
    })
  end,
  settings = {
    Lua = {}
  }
}
-- mappings


vim.api.nvim_set_keymap('n', '<F5>', "<cmd>CompilerOpen<cr>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<F9>', "<cmd>CompilerStop<cr>", {noremap = true, silent = true})
-- Colorscheme settings
vim.api.nvim_set_keymap('n', '<C-o>', ':Oil<CR>', { noremap = true, silent = true })
vim.o.background = "dark"
vim.cmd([[colorscheme gruvbox]])








-- file: colors/my-colorscheme-name.lua

--local colorbuddy = require('colorbuddy')
--
---- Set up your custom colorscheme if you want
--colorbuddy.colorscheme("my-colorscheme-name")
--
---- And then modify as you like
--local Color = colorbuddy.Color
--local colors = colorbuddy.colors
--local Group = colorbuddy.Group
--local groups = colorbuddy.groups
--local styles = colorbuddy.styles
--
---- Use Color.new(<name>, <#rrggbb>) to create new colors
---- They can be accessed through colors.<name>
--Color.new('background',  '#282c34')
--Color.new('red',         '#cc6666')
--Color.new('green',       '#99cc99')
--Color.new('yellow',      '#f0c674')
--
---- Define highlights in terms of `colors` and `groups`
--Group.new('Function'        , colors.yellow      , colors.background , styles.bold)
--Group.new('luaFunctionCall' , groups.Function    , groups.Function   , groups.Function)
--
---- Define highlights in relative terms of other colors
--Group.new('Error'           , colors.red:light() , nil               , styles.bold)
--
---- If you want multiple styles, just add them!
--Group.new('italicBoldFunction', colors.green, groups.Function, styles.bold + styles.italic)
--
---- If you want the same style as a different group, but without a style: just subtract it!
--Group.new('boldFunction', colors.yellow, colors.background, groups.italicBoldFunction - styles.italic)





