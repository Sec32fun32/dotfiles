-----------------------------------
-- Options
-----------------------------------

vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

vim.opt.wrap = false

-- show whitespace chars
vim.opt.list       = true
vim.opt.listchars  = 'tab:»-,trail:_,eol:↲,extends:»,precedes:«,nbsp:･'
-- search
vim.opt.ignorecase = true
vim.opt.smartcase  = true
vim.opt.incsearch  = true
vim.opt.hlsearch   = true

-- clipboard
vim.opt.clipboard = 'unnamedplus'

-- indent
vim.opt.autoindent  = true
vim.opt.smartindent = true
vim.opt.expandtab   = true
vim.opt.tabstop     = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth  = 2
vim.opt.shiftround  = true

-- split
vim.opt.splitbelow = true
vim.opt.splitright = true

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-----------------------------------
-- Keymaps
-----------------------------------
vim.g.mapleader = ' '
-- clear search highlights
vim.api.nvim_set_keymap('n', '<Esc><Esc>', ':nohlsearch<CR><Esc>', { noremap = true })

-- https://github.com/neovim/nvim-lspconfig/tree/v0.1.5#suggested-configuration
-- vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, { noremap = true, silent = true })
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { noremap = true, silent = true })
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { noremap = true, silent = true })
-- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, { noremap = true, silent = true })

-----------------------------------
-- Plugins
-----------------------------------
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- LSP
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',
  'neovim/nvim-lspconfig',
  'kkharji/lspsaga.nvim',
  'jose-elias-alvarez/null-ls.nvim',
  'jayp0521/mason-null-ls.nvim',
  -- Completion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/vim-vsnip',
    },
    config = function()
      local cmp = require('cmp')

      cmp.setup({
        enabled = true,
        snippet = {
          expand = function(args)
            vim.fn['vsnip#anonymous'](args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
        }, {
          { name = 'buffer' },
          { name = 'path' },
        }),
      })

      -- for nvim-autopairs
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )
    end,
  },
  -- Treesitter
  'nvim-treesitter/nvim-treesitter',
  'nvim-treesitter/nvim-treesitter-context',
  'nvim-treesitter/nvim-treesitter-textobjects', -- required by nvim-surround
  'mrjones2014/nvim-ts-rainbow',
  {
    'haringsrob/nvim_context_vt',
    config = function ()
      require('nvim_context_vt').setup({
        min_rows = 3,
      })
    end
  },
  -- Fuzzy finder
  'nvim-lua/plenary.nvim',
  'nvim-telescope/telescope.nvim',
  -- Apperance
  { 'cocopon/iceberg.vim', cond = not vim.g.vscode },
  { 'kyazdani42/nvim-web-devicons', cond = not vim.g.vscode },
  {
    'nvim-tree/nvim-tree.lua',
    cond = not vim.g.vscode,
    config = function ()
      require("nvim-tree").setup({
        sort_by = 'case_sensitive',
        view = {
          adaptive_size = true,
          float = {
            enable = true,
          }
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = false,
          custom = { "^.git$" },
        },
      })
      vim.api.nvim_set_keymap("n", "<C-h>", ":NvimTreeFindFileToggle<cr>" ,{silent = true, noremap = true})
    end
  },
  {
    'nvim-lualine/lualine.nvim',
    cond = not vim.g.vscode,
    config = function ()
      require('lualine').setup({
        options = {
          icons_enabled = false,
          theme = 'iceberg',
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {'filename'},
          lualine_x = {'encoding'},
          lualine_y = {'progress'},
          lualine_z = {'location'},
        },
      })
    end
  },
  {
    'j-hui/fidget.nvim',
    cond = not vim.g.vscode,
    config = function ()
      require('fidget').setup()
    end,
  },
  {
    'petertriho/nvim-scrollbar',
    cond = not vim.g.vscode,
    config = function ()
      require('scrollbar').setup({
        marks = {
          Search = { color_nr = '3', color = '#c57339' },
          Error = { color_nr = '9', color = '#cc3768' },
          Warn = { color_nr = '11', color = '#b6662d' },
        },
        handlers = {
          cursor = true,
          diagnostic = true,
          gitsigns = true,
          handle = true,
          search = true,
        }
      })
    end
  },
  {
    'kevinhwang91/nvim-hlslens',
    cond = not vim.g.vscode,
    config = function ()
      require('scrollbar.handlers.search').setup({
        override_lens = function() end,
      })
    end
  },
  {
    'lewis6991/gitsigns.nvim',
    cond = not vim.g.vscode,
    config = function ()
      require('gitsigns').setup()
      require('scrollbar.handlers.gitsigns').setup()
    end,
  },
  -- Editor
  {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup()
    end,
  },
  {
   'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup({
        toggler = {
          line = '<Leader>/',
        },
        opleader = {
          line = '<Leader>/',
        },
      })
    end,
  },
  {
    'kylechui/nvim-surround',
    config = function()
      require('nvim-surround').setup()
    end,
  },
  {
    'folke/todo-comments.nvim',
    config = function ()
      require('todo-comments').setup()
    end,
  },
  {
    'RRethy/vim-illuminate',
    config = function ()
      require('illuminate').configure()
    end,
  },
  -- misc
  {
    'alexghergh/nvim-tmux-navigation',
    cond = not vim.g.vscode,
    config = function()
      local nvim_tmux_nav = require('nvim-tmux-navigation')

      nvim_tmux_nav.setup({ disable_when_zoomed = true })

      vim.keymap.set('n', '<C-w>h', nvim_tmux_nav.NvimTmuxNavigateLeft)
      vim.keymap.set('n', '<C-w>j', nvim_tmux_nav.NvimTmuxNavigateDown)
      vim.keymap.set('n', '<C-w>k', nvim_tmux_nav.NvimTmuxNavigateUp)
      vim.keymap.set('n', '<C-w>l', nvim_tmux_nav.NvimTmuxNavigateRight)
      vim.keymap.set('n', '<C-w>\\', nvim_tmux_nav.NvimTmuxNavigateLastActive)
      vim.keymap.set('n', '<C-w>Space', nvim_tmux_nav.NvimTmuxNavigateNext)
    end,
  },
})

-- LSP
local lspconfig = require('lspconfig')
local mason = require('mason')
local mason_lspconfig = require('mason-lspconfig')
local mason_null_ls = require('mason-null-ls')
local null_ls = require('null-ls')

require('lspsaga').setup()
mason_null_ls.setup({
  ensure_installed = { 'prettier' },
  automatic_installation = true,
})
null_ls.setup({
  sources = { null_ls.builtins.formatting.prettier },
})

-- https://github.com/neovim/nvim-lspconfig/tree/v0.1.5#suggested-configuration
local on_attach_lsp = function(client, bufnr)
  local telescope_builtin = require('telescope.builtin')

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gt', telescope_builtin.lsp_definitions, bufopts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', telescope_builtin.lsp_definitions, bufopts)
  -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'K', require('lspsaga.hover').render_hover_doc, bufopts)
  -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', 'gi', telescope_builtin.lsp_implementations, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  -- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>D', telescope_builtin.lsp_type_definitions, bufopts)
  -- vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>rn', require('lspsaga.rename').rename, bufopts)
  -- vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', '<space>ca', require('lspsaga.codeaction').code_action, bufopts)
  -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', 'gr', telescope_builtin.lsp_references, bufopts)
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)

  vim.keymap.set('n', '<space>e', telescope_builtin.diagnostics, bufopts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, bufopts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, bufopts)
  vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, bufopts)
end

vim.keymap.set({ 'n' }, '<Plug>(lsp)n', require('lspsaga.diagnostic').navigate('next'))
vim.keymap.set({ 'n' }, '<Plug>(lsp)p', require('lspsaga.diagnostic').navigate('prev'))

vim.api.nvim_create_autocmd({ 'CursorHold' }, {
  pattern = { '*' },
  callback = function()
    require('lspsaga.diagnostic').show_cursor_diagnostics()
  end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = { '*.go', '*.rs' },
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = {
    '*.js', '*.jsx', '*.cjs', '*.mjs',
    '*.ts', '*.tsx', '*.cts', '*.mts',
    '*.vue'
  },
  callback = function()
    vim.cmd('EslintFixAll')
    vim.lsp.buf.format({ name = 'null-ls', async = false })
  end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = { '*.go' },
  callback = function()
    -- https://github.com/golang/tools/blob/gopls/v0.11.0/gopls/doc/vim.md#imports
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { 'source.organizeImports' } }
    local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, 3000)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or 'utf-16'
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
  end,
})


mason.setup()
mason_lspconfig.setup({
  ensure_installed = {
    'bashls',
    'bufls',
    'dockerls',
    'graphql',
    'rust_analyzer',
    -- Ruby
    'solargraph',
    -- JS
    'eslint',
    'tsserver',
    'volar',
    -- Go
    'gopls',
    'golangci_lint_ls',
    -- Lua
    'sumneko_lua',
  },
  automatic_installation = true,
})
mason_lspconfig.setup_handlers({
  function(server_name)
    lspconfig[server_name].setup({
      on_attach = on_attach_lsp,
      capabilities = require('cmp_nvim_lsp').default_capabilities(),
    })
  end,
})

-- Completion
vim.opt.completeopt = 'menu,menuone,noselect'

-- treesitter
require('nvim-treesitter.configs').setup({
  ensure_installed = {
    'bash',
    'css',
    'dockerfile',
    'gitignore',
    'go',
    'gomod',
    'gowork',
    'graphql',
    'html',
    'javascript',
    'json',
    'json5',
    'lua',
    'markdown',
    'proto',
    'ruby',
    'rust',
    'scss',
    'sql',
    'terraform',
    'toml',
    'typescript',
    'tsx',
    'vim',
    'vue',
    'yaml',
  },
  -- indent = {
  --   enable = true,
  -- },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = 1500,
    colors = {
      "#e27878", -- red
      "#e2a478", -- yellow
      "#b4be82", -- green
      "#84a0c6", -- blue
    }, -- table of hex strings
    termcolors = {
      'Red',
      'Yellow',
      'Green',
      'Blue',
    }
  }
})

require('treesitter-context').setup()

-- Fuzzy finder
require('telescope').setup({
  defaults = {
    layout_strategy = 'vertical',
    layout_config = {
    },
    mappings = {
      i = {
        ['<esc>'] = require('telescope.actions').close,
        ['<C-u>'] = false
      },
    },
  },
})
local telescope_builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader><leader>', telescope_builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep, {})
vim.keymap.set('n', '<leader>fs', telescope_builtin.git_status, {})
vim.keymap.set('n', '<leader>fb', telescope_builtin.buffers, {})
vim.keymap.set('n', '<leader>fb', telescope_builtin.buffers, {})


-- Apperance
if not vim.g.vscode then
  vim.opt.signcolumn = 'yes';

  -- clear bg
  vim.api.nvim_create_autocmd('Colorscheme', {
    pattern = '*',
    command = 'highlight Normal ctermbg=none guibg=none'
  })
  vim.api.nvim_create_autocmd('Colorscheme', {
    pattern = '*',
    command = 'highlight NonText ctermbg=none guibg=none'
  })
  vim.api.nvim_create_autocmd('Colorscheme', {
    pattern = '*',
    command = 'highlight LineNr ctermbg=none guibg=none'
  })
  vim.api.nvim_create_autocmd('Colorscheme', {
    pattern = '*',
    command = 'highlight Folded ctermbg=none guibg=none'
  })
  vim.api.nvim_create_autocmd('Colorscheme', {
    pattern = '*',
    command = 'highlight EndOfBuffer ctermbg=none guibg=none'
  })
  -- clear sign column bg
  vim.api.nvim_create_autocmd('Colorscheme', {
    pattern = '*',
    command = 'highlight SignColumn ctermbg=none guibg=none'
  })
  vim.api.nvim_create_autocmd('Colorscheme', {
    pattern = '*',
    command = 'highlight GitGutterAdd ctermbg=none guibg=none'
  })
  vim.api.nvim_create_autocmd('Colorscheme', {
    pattern = '*',
    command = 'highlight GitGutterChange ctermbg=none guibg=none'
  })
  vim.api.nvim_create_autocmd('Colorscheme', {
    pattern = '*',
    command = 'highlight GitGutterDelete ctermbg=none guibg=none'
  })
  -- illuminate
  vim.api.nvim_create_autocmd('Colorscheme', {
    pattern = '*',
    command = 'highlight IlluminatedWordText ctermbg=238 guibg=#33374c'
  })
  vim.api.nvim_create_autocmd('Colorscheme', {
    pattern = '*',
    command = 'highlight IlluminatedWordRead ctermbg=238 guibg=#33374c'
  })
  vim.api.nvim_create_autocmd('Colorscheme', {
    pattern = '*',
    command = 'highlight IlluminatedWordWrite ctermbg=238 guibg=#33374c'
  })
  vim.o.termguicolors = true
  vim.cmd'colorscheme iceberg'
end
