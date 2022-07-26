language en_US

call plug#begin()
	Plug 'sainnhe/everforest'
	Plug 'preservim/nerdtree'
	Plug 'kyazdani42/nvim-web-devicons'
	Plug 'nvim-lua/plenary.nvim' "Dependency
	Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
	Plug 'nvim-lualine/lualine.nvim'
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
	Plug 'neovim/nvim-lspconfig'
	Plug 'rmagatti/goto-preview'
	Plug 'neovim/nvim-lspconfig'
	Plug 'hrsh7th/cmp-nvim-lsp'
	Plug 'hrsh7th/cmp-buffer'
	Plug 'hrsh7th/cmp-path'
	Plug 'hrsh7th/cmp-cmdline'
	Plug 'hrsh7th/nvim-cmp'
	" For luasnip users.
	Plug 'L3MON4D3/LuaSnip'
	Plug 'saadparwaiz1/cmp_luasnip'
call plug#end()

set number
set tabstop=4
set shiftwidth=4
set signcolumn=number
set updatetime=300
set completeopt=menu,menuone,noselect

set termguicolors
set background=dark

let g:everforest_background = 'hard'


"Nerdtree binds
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

colorscheme everforest

lua << END
	require('lualine').setup()
	require'nvim-treesitter.configs'.setup {
	  highlight = {
	    enable = true,
	    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
	    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
	    -- Using this option may slow down your editor, and you may see some duplicate highlights.
	    -- Instead of true it can also be a list of languages
	    additional_vim_regex_highlighting = false,
	  },
	}

-- Setup nvim-cmp.
    local cmp = require'cmp'

    cmp.setup({
      snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
          require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
      },
      window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' }, -- For luasnip users.
      }, {
        { name = 'buffer' },
      })
    })

    -- Set configuration for specific filetype.
    cmp.setup.filetype('gitcommit', {
      sources = cmp.config.sources({
        { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
      }, {
        { name = 'buffer' },
      })
    })

    -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline('/', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }
      }
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      })
    })

	-- Setup lspconfig.
  	local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
	-- local opts = { noremap=true, silent=true }
	-- vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
	-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
	-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
	-- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
	--
	-- local on_attach = function(client, bufnr)
	--   -- Enable completion triggered by <c-x><c-o>
	--   vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
	--
	--   -- Mappings.
	--   -- See `:help vim.lsp.*` for documentation on any of the below functions
	--   local bufopts = { noremap=true, silent=true, buffer=bufnr }
	--   vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
	--   vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
	--   vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
	--   vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
	--   vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
	--   vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
	--   vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
	--   vim.keymap.set('n', '<space>wl', function()
	--     print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	--   end, bufopts)
	--   vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
	--   vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
	--   vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
	--   vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
	--   vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
	-- end
	require'lspconfig'.gopls.setup{
		-- on_attach = on_attach
		capabilities = capabilities
	}
END


"Hard mode
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>

vnoremap <Up> <Nop>
vnoremap <Down> <Nop>
vnoremap <Left> <Nop>
vnoremap <Right> <Nop>
