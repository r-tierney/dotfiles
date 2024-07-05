vim.cmd('syntax on')
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- start scrolling the screen when i reach 8 lines from the bottom
vim.o.scrolloff = 8

-- Set wildmode ( allows you to tab complete cmds )
vim.o.wildmode = 'longest,list,full'

-- Set autoindent and expand tabs to spaces with width 4
vim.o.autoindent = true
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4

-- Center screen on insert mode
vim.api.nvim_exec([[
  autocmd InsertEnter * norm zz
]], false)


-- Remaps:

-- Set leader key to \
vim.g.mapleader = '\\'
vim.g.maplocalleader = '\\'

-- Clean search highlighting
vim.api.nvim_set_keymap('n', '<leader>c', ':noh<CR>', { noremap = true, silent = true })

-- Map leader key followed by 's' to toggle spell check
vim.api.nvim_set_keymap('n', '<leader>s', ':setlocal spell! spelllang=en_au<CR>', { noremap = true, silent = true })

-- Map leader key followed by 'ba' to insert bash shebang
vim.api.nvim_set_keymap('n', '<leader>ba', 'ggi#!/usr/bin/env bash<CR><CR>', { noremap = true, silent = true })

-- Map leader key followed by 'py' to insert python3 shebang
vim.api.nvim_set_keymap('n', '<leader>py', 'ggi#!/usr/bin/env python3<CR><CR>', { noremap = true, silent = true })

-- Map visual mode '<' and '>' to maintain selection after shifting ( allows you to indent selected lines multiple times )
vim.api.nvim_set_keymap('v', '<', '<gv', { noremap = true })
vim.api.nvim_set_keymap('v', '>', '>gv', { noremap = true })

-- toggle line numbers and git gutter on and off
vim.api.nvim_set_keymap('n', '<leader>n', ':set relativenumber!<CR>:Gitsigns toggle_signs<CR>:set number!<CR>', {noremap = true})


-- Map F4 to toggle mouse support ( allows us to hit f4 then select text with mouse & copy/paste, then hit f4 again to go back to normal vim mouse mode)
vim.api.nvim_set_keymap('n', '<F4>', ':lua toggle_mouse()<CR>', { noremap = true, silent = true })
function toggle_mouse()
    if vim.o.mouse == '' then
        vim.o.mouse = 'a'
    else
        vim.o.mouse = ''
    end
end

-- Map F1 to toggle cursorcolumn ( allows us to hit f1 and ensure indentation is correct, hit f1 again to turn it off )
vim.api.nvim_set_keymap('n', '<F1>', ':lua toggle_cursorcolumn()<CR>', { noremap = true, silent = true })
function toggle_cursorcolumn()
    vim.wo.cursorcolumn = not vim.wo.cursorcolumn
end


-- Plugins

-- lazy nvim package manager install
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


-- lazy.nvim plugins
local plugins = {
    { "catppuccin/nvim", name = "catppuccin", priority = 1000, opts = { flavour = "mocha", background = {dark = "mocha",},},},
    { 'nvim-telescope/telescope.nvim', tag = '0.1.6', dependencies = { 'nvim-lua/plenary.nvim' }},
    { "christoomey/vim-tmux-navigator",
      cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
        "TmuxNavigatePrevious",
      },
      keys = {
        { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
        { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
        { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
        { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
        { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
      },
      config = function () end,
      opts = {lazy = false},
    },
    { 'rodjek/vim-puppet', opts = {}, config = function () end, },
    {'romgrk/barbar.nvim',
	    dependencies = {
	      'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
	      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
	    },
	    init = function() vim.g.barbar_auto_setup = false end,
	    opts = {
	      -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
	      -- animation = true,
	      -- insert_at_start = true,
	      -- …etc.
		  sidebar_filetypes = {
		    -- Use the default values: {event = 'BufWinLeave', text = '', align = 'left'}
		    NvimTree = true,
		  },
	    },
	    version = '^1.0.0', -- optional: only update when a new 1.x version is released
    },
    
    { 'nvim-tree/nvim-tree.lua', opts = {
            sort = {
              sorter = "case_sensitive",
            },
            view = {
              width = 30,
            },
            renderer = {
              group_empty = true,
            },
            filters = {
              dotfiles = true,
            },
        },
    },
    { 'lewis6991/gitsigns.nvim', -- gitutter 
        opts = {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
        },
    },
    { 'neovim/nvim-lspconfig',
      dependencies = {
          'williamboman/mason.nvim',
          'williamboman/mason-lspconfig.nvim',
          { 'j-hui/fidget.nvim', opts = {} },
          { 'folke/neodev.nvim', opts = {} },
      },
    },
    {'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' }, opts = {}},
    -- Auto Completion
    { 'hrsh7th/nvim-cmp', event = 'InsertEnter', dependencies = {{ 'L3MON4D3/LuaSnip', build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {},},
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-b>'] = cmp.mapping.select_prev_item(),
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-y>'] = cmp.mapping.confirm { select = true },
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
      }
    end,
  },
}





-- install plugins
require("lazy").setup(plugins, opts)
require("mason").setup()

-- automatically install these LSP's
local servers = {
    gopls = {},
}
-- broadcast what neovim capabilities has to the LSP
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

-- install Mason LSP's automatically without having to add setup() config or reload neovim
require('mason-lspconfig').setup {
    handlers = {
      function(server_name)
        local server = servers[server_name] or {}
        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
        require('lspconfig')[server_name].setup(server)
      end,
    },
}



-- set theme
vim.cmd.colorscheme "catppuccin"

-- configure telescope ( requires ripgrep for \fg )
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})


-- nvimtree
vim.api.nvim_set_keymap("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Nvimtree Toggle window" })
vim.api.nvim_set_keymap("n", "<leader>w", "<cmd>NvimTreeFocus<CR>", { desc = "Nvimtree Focus window" })


-- barbar <C-,> for means CTRL key + comma )
-- Move to previous/next
vim.api.nvim_set_keymap('n', '<leader>,', '<Cmd>BufferPrevious<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>.', '<Cmd>BufferNext<CR>', { noremap = true, silent = true })
-- Re-order to previous/next
vim.api.nvim_set_keymap('n', '<C-,>', '<Cmd>BufferMovePrevious<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-.>', '<Cmd>BufferMoveNext<CR>', { noremap = true, silent = true })
-- close
vim.api.nvim_set_keymap('n', '<leader>x', '<Cmd>BufferClose<CR>', { noremap = true, silent = true })
-- Goto buffer in position...
vim.api.nvim_set_keymap('n', '<leader>1', '<Cmd>BufferGoto 1<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>2', '<Cmd>BufferGoto 2<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>3', '<Cmd>BufferGoto 3<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>4', '<Cmd>BufferGoto 4<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>5', '<Cmd>BufferGoto 5<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>6', '<Cmd>BufferGoto 6<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>7', '<Cmd>BufferGoto 7<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>8', '<Cmd>BufferGoto 8<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>9', '<Cmd>BufferGoto 9<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>10', '<Cmd>BufferLast<CR>', { noremap = true, silent = true })





-- LSP Functions ( Credit to TJ DeVries https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua#L457 )
vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- Find references for the word under your cursor.
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

          -- Opens a popup that displays documentation about the word under your cursor
          --  See `:help K` for why this keymap.
          map('K', vim.lsp.buf.hover, 'Hover Documentation')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end

          -- The following autocommand is used to enable inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled())
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })
