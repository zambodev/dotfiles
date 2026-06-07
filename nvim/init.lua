-- Settings --------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
vim.opt.updatetime = 250

-- Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4

-- lazy --------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Colorscheme: One Dark Pro
  {
    "olimorris/onedarkpro.nvim",
    priority = 1000,
    config = function()
      require("onedarkpro").setup({
        options = {
          highlight_inactive_windows = true,
        }
      })
      vim.cmd("colorscheme onedark")
    end,
  },

  -- blink
  {
    'Saghen/blink.cmp',
    dependencies = 'rafamadriz/friendly-snippets',
    version = '*',
    opts = {
      keymap = { preset = 'default' },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
    },
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { 
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("telescope").setup({})
    end,
  },

  -- File tree
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = {
          width = 30,
          side = "left",
        },
      })
    end,
  },

  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    config = true,
  },

  -- Git diff
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
  },

  -- Git
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("neogit").setup({
        kind = "vsplit",
        integrations = { diffview = true },
      })
    end,
  },

  -- Multi-cursor Support
  {
    "mg979/vim-visual-multi",
    lazy = false,
    init = function()
      -- Configure custom multi-cursor trigger keys
      vim.g.VM_maps = {
        ["Find Under"]         = "gb",       -- Swap "gb" with "<leader>n" if you prefer space+n
        ["Visual Find Under"]  = "gb",       -- For selecting matches while in visual mode
      }
    end,
  },
})

-- Native Treesitter Highlighting (Built into Neovim 0.12+) ----------------
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "rust", "lua", "vim", "vimdoc", "query" },
  callback = function()
    vim.treesitter.start()
  end,
})

-- LSP --------------------------------
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Rust
vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  callback = function(args)
    local bufnr = args.buf
    vim.lsp.start({
      name = "rust-analyzer",
      cmd = { "rust-analyzer" },
      capabilities = capabilities,
      root_dir = vim.fs.root(0, { "Cargo.toml", ".git" }),
      settings = {
        ["rust-analyzer"] = {
          checkOnSave = true,
          check = {
            command = "clippy",
          },
        },
      },
    })
  end,
})

-- C++
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "h", "hpp" },
  callback = function(args)
    local bufnr = args.buf
    vim.lsp.start({
      name = "clangd",
      cmd = { 
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders",
        "--fallback-style=llvm"
      },
      capabilities = capabilities,
      init_options = {
        fallbackFlags = { "-std=c++26" },
      },
      root_dir = vim.fs.root(0, { 
        "compile_commands.json", 
        "compile_flags.txt", 
        ".clangd", 
        ".clang-tidy", 
        ".clang-format", 
        ".git" 
      }),
    })
  end,
})

-- Diagnostics --------------------------------
vim.diagnostic.config({
  virtual_text = { prefix = "●" },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Error popup shortcut
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show line diagnostics popup" })

-- Error popup hover
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = false, scope = "cursor" })
  end,
})

-- LSP hover docs
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "LSP Hover Documentation" })
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to Definition" })
  end,
})

-- Keybinds --------------------------------
local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "Telescope Find Files" })
vim.keymap.set("n", "<leader>g", builtin.live_grep, { desc = "Telescope Live Grep (Search Text)" })

-- File Tree
vim.keymap.set("n", "<leader>t", ":NvimTreeToggle<CR>", { desc = "Toggle File Tree" })

-- Git
vim.keymap.set("n", "<leader>gs", ":Neogit<CR>", { desc = "Git: Open Source Control Sidebar Status" })
vim.keymap.set("n", "<leader>gd", ":DiffviewOpen<CR>", { desc = "Git: View File Diff Splits" })
vim.keymap.set("n", "<leader>gh", ":DiffviewFileHistory %<CR>", { desc = "Git: View Current File History" })
vim.keymap.set("n", "<leader>gc", ":DiffviewClose<CR>", { desc = "Git: Close Diff View Windows" })

-- Keymap legend
vim.keymap.set("n", "<leader>?", builtin.keymaps, { desc = "Search Keyboard Shortcuts" })

