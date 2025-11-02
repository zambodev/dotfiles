require("config.lazy")

-- Config
vim.opt.clipboard = 'unnamedplus'
vim.wo.number = true
vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])
vim.opt.signcolumn = "yes"
vim.opt.expandtab = true  
vim.opt.tabstop = 4      
vim.opt.shiftwidth = 4   
vim.opt.smartindent = true

-- diagnostics
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    vim.keymap.set('n', '<leader>i', function()
      vim.lsp.buf.hover {
        border = 'rounded',
      }
    end, { buffer = event.buf })
  end,
})

vim.diagnostic.config({
  virtual_text = false,      -- no inline text
  virtual_lines = false,     -- no virtual lines
  underline = true,          -- optional: underline problematic code
  update_in_insert = false,  -- don't show diagnostics while typing
  severity_sort = true,
})

vim.o.updatetime = 250  -- how long in ms before CursorHold triggers
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    -- Show diagnostics only if there are any
    local opts = {
      focusable = false,
      border = "rounded",
      source = "always",    -- show source (like linter)
      prefix = "● ",        -- optional bullet
    }
    vim.diagnostic.open_float(nil, opts)
  end,
})

-- Remaps
vim.g.leader = " "
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float )
vim.keymap.set("n", "<leader>w", ":w<cr>")
vim.keymap.set("n", "<leader>o", ":noh")
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "[R]e[n]ame" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "[C]ode [A]ction" })
vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "[G]oto [D]efinition" })
vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "[G]oto [D]eclaration" })
vim.keymap.set("n", "<leader>gI", vim.lsp.buf.implementation, { buffer = bufnr, desc = "[G]oto [I]mplementation" })

-- LSP
vim.lsp.enable({
	-- C/C++
	"clangd"
})

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files)
vim.keymap.set('n', '<leader>gf', builtin.git_files)
vim.keymap.set('n', '<leader>gr', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
vim.keymap.set("n", "<leader>j", "<C-w>j")
vim.keymap.set("n", "<leader>k", "<C-w>k")
vim.keymap.set("n", "<leader>h", "<C-w>h")
vim.keymap.set("n", "<leader>l", "<C-w>l")
vim.keymap.set("n", "<leader>J", "<C-w>J")
vim.keymap.set("n", "<leader>K", "<C-w>K")
vim.keymap.set("n", "<leader>H", "<C-w>H")
vim.keymap.set("n", "<leader>L", "<C-w>L")

vim.keymap.set("n", "<S-h>", "gt")
vim.keymap.set("n", "<S-l>", "gT")

-- Autocomplete
local cmp = require("cmp")
local luasnip = require("luasnip")
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-n>"] = cmp.mapping.scroll_docs(-4),
    ["<C-p>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- enter to confirm
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
    { name = "luasnip" },
  }),
})

