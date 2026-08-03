-- ==============================================================================
-- 1. Bootstrap lazy.nvim (Plugin Manager)
-- ==============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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

-- Set mapleader before lazy so plugins use the correct key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ==============================================================================
-- 2. Plugin Declarations
-- ==============================================================================
require("lazy").setup({
  -- Git integration
  { "tpope/vim-fugitive" },

  -- Treesitter for advanced syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },

  -- HTML expansion
  { "rstacruz/sparkup", rtp = "vim/" },

  -- Modern Auto-pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end
  },

  -- High-contrast dark mode theme (Molokai successor)
  {
    "loctvl842/monokai-pro.nvim",
    config = function()
      require("monokai-pro").setup({
        transparent_background = true, -- Forces pure black terminal background
        terminal_colors = true,
        devicons = true,
        filter = "pro", -- 'classic', 'machine', 'octagon', 'pro', 'ristretto', 'spectrum'
      })
      vim.cmd([[colorscheme monokai-pro]])
    end
  },

  -- Jupyter Notebook support
  { "goerz/jupytext.vim" },

  -- Undo history visualizer
  { 
    "mbbill/undotree",
    keys = {
      -- Toggles the undotree window with Shift+U
      { "U", "<cmd>UndotreeToggle<CR>", desc = "Toggle UndoTree" }
    },
    init = function()
      -- Width of the undotree history (vertical) pane
      vim.g.undotree_SplitWidth = 40
      -- Height of the undotree diff (horizontal) pane
      vim.g.undotree_DiffpanelHeight = 15
    end
  },

  -- Modern Rainbow Delimiters
  { "HiPhish/rainbow-delimiters.nvim" },

  -- Autocompletion Engine (Replaces AutoComplPop)
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'buffer' },
          { name = 'path' }
        })
      })
    end
  },

  -- AI Terminal Coding Harness (Replaces Kite)
  -- {
  --   "David-Kunz/gen.nvim",
  --   opts = {
  --     model = "llama3", -- Swap this for whatever local model you are serving
  --     host = "localhost",
  --     port = "11434",   -- Default Ollama port
  --     display_mode = "split",
  --   }
  -- }
})

-- ==============================================================================
-- 3. Core Color Settings & Syntax Highlighting
-- ==============================================================================

-- Enable 24-bit RGB colors in the terminal (crucial for Alacritty and modern themes)
vim.opt.termguicolors = true

-- Force the background to dark mode (matches your previous setting)
vim.opt.background = "dark"

-- ------------------------------------------------------------------------------
-- Treesitter Configuration (Replaces legacy 'syntax on')
-- ------------------------------------------------------------------------------
-- We use pcall (protected call) to ensure Neovim doesn't crash if Treesitter 
-- hasn't finished installing yet on the first boot.
local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if status_ok then
  configs.setup({
    -- Automatically install parsers for these languages
    ensure_installed = { "c", "lua", "vim", "vimdoc", "python", "javascript", "typescript", "html", "css", "bash" },
    
    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,
    
    -- Automatically install missing parsers when entering buffer
    auto_install = true,

    highlight = {
      enable = true, -- Replaces 'syntax on'
      
      -- Disable traditional regex highlighting (can cause visual artifacts when mixed with Treesitter)
      additional_vim_regex_highlighting = false,
    },
  })
end

-- ==============================================================================
-- 4. Core Editor Settings
-- ==============================================================================

-- Search & Match
vim.opt.ignorecase = true       -- Ignore case when searching
vim.opt.smartcase = true        -- Override ignorecase if search contains capitals
vim.opt.hlsearch = true         -- Highlight search results
vim.opt.incsearch = true        -- Show search matches as you type
vim.opt.matchpairs:append("<:>")-- Allow % to jump between angle brackets

-- UI & Display
vim.opt.number = true           -- Show line numbers
vim.opt.relativenumber = true   -- Relative line numbers for jumping (e.g., 5j, 4k)
vim.opt.cursorline = true       -- Highlight the current line
vim.opt.wrap = true             -- Wrap long lines
vim.opt.scrolloff = 8           -- Keep 8 lines of context above/below the cursor when scrolling
vim.opt.errorbells = false      -- Disable annoying terminal bells
vim.opt.mouse = "a"             -- Enable mouse support

-- Splitting & Navigation
vim.opt.splitbelow = true       -- Horizontal splits open below
vim.opt.splitright = true       -- Vertical splits open to the right
vim.opt.virtualedit = "block"   -- Allow cursor to move past end of line in visual block mode
vim.opt.whichwrap:append("<,>,[,]") -- Allow arrow keys to wrap to the next line

-- Indentation (Set to 2 spaces)
vim.opt.expandtab = true        -- Convert tabs to spaces
vim.opt.shiftwidth = 4          -- Number of spaces to use for each step of (auto)indent
vim.opt.softtabstop = 2         -- Number of spaces that a <Tab> counts for
vim.opt.tabstop = 2             -- Number of spaces that a <Tab> in the file counts for
vim.opt.smarttab = true         -- Insert 'shiftwidth' spaces when hitting <Tab>
vim.opt.autoindent = true       -- Copy indent from current line when starting a new line

-- Undo History & Clipboard
vim.opt.undofile = true         -- Save undo history to a file (crucial for undotree)
vim.opt.clipboard = { "unnamedplus", "unnamed" } -- Sync with system clipboard

-- Timings (Optimized for tmux and async plugins)
vim.opt.timeoutlen = 300        -- Time in milliseconds to wait for a mapped sequence (snappier leader key)
vim.opt.updatetime = 250        -- Faster completion and swap file writes


-- ==============================================================================
-- 5. Auto Commands
-- ==============================================================================
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Auto-resize splits when the terminal window is resized (e.g., resizing Tmux panes)
autocmd("VimResized", {
  group = augroup("ResizeSplits", { clear = true }),
  command = "wincmd =",
})

-- Ensure Makefiles strictly use tabs instead of spaces (crucial for execution)
autocmd("FileType", {
  group = augroup("FixMakefiles", { clear = true }),
  pattern = "make",
  command = "setlocal noexpandtab",
})

-- Map requirements files to python syntax
autocmd({ "BufNewFile", "BufRead" }, {
  group = augroup("RequirementsSyntax", { clear = true }),
  pattern = "requirements*.txt",
  command = "set ft=python",
})

-- Map alias files to bash syntax
autocmd({ "BufNewFile", "BufRead" }, {
  group = augroup("AliasSyntax", { clear = true }),
  pattern = ".*aliases*",
  command = "set ft=sh",
})

-- Only show the cursorline in the active window (cleaner UI in split views)
local cursorline_grp = augroup("CursorLineActiveWindow", { clear = true })
autocmd({ "VimEnter", "WinEnter", "BufWinEnter" }, {
  group = cursorline_grp,
  pattern = "*",
  command = "setlocal cursorline",
})
autocmd("WinLeave", {
  group = cursorline_grp,
  pattern = "*",
  command = "setlocal nocursorline",
})

-- ==============================================================================
-- 6. Custom Commands
-- ==============================================================================

-- Save session and preserve fixed window dimensions (winfixheight / winfixwidth)
vim.api.nvim_create_user_command("Mks", function(opts)
  -- 1. Determine session file name (defaults to 'Session.vim')
  local session_file = (opts.args == "") and "Session.vim" or opts.args
  local bang = opts.bang and "!" or ""
  
  -- 2. Execute original mksession command
  vim.cmd("mksession" .. bang .. " " .. session_file)
  
  -- 3. Collect windows with fixed dimensions
  local restore_commands = {}
  
  -- Iterate through all windows in the current tab
  for _, win_id in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local settings_to_apply = {}
    
    -- Check Neovims window options api
    if vim.wo[win_id].winfixheight then
      table.insert(settings_to_apply, "setlocal winfixheight")
    end
    if vim.wo[win_id].winfixwidth then
      table.insert(settings_to_apply, "setlocal winfixwidth")
    end
    
    -- If settings exist, format the restore command
    if #settings_to_apply > 0 then
      local win_nr = vim.api.nvim_win_get_number(win_id)
      local settings_string = table.concat(settings_to_apply, " | ")
      table.insert(restore_commands, win_nr .. "wincmd w | " .. settings_string)
    end
  end
  
  -- 4. Append restore commands to the session file using standard Lua I/O
  if #restore_commands > 0 then
    local file = io.open(session_file, "a")
    if file then
      file:write("\n\" --- Custom: Restore fixed dimension settings ---\n")
      for _, cmd in ipairs(restore_commands) do
        file:write(cmd .. "\n")
      end
      file:close()
    end
  end
  
  -- Display a clean notification message
  vim.notify("Session saved to " .. session_file .. " with fixed dimensions preserved.", vim.log.levels.INFO)
end, { 
  bang = true, 
  nargs = "?", 
  complete = "file",
  desc = "Save Session.vim while preserving winfixheight and winfixwidth"
})

-- ==============================================================================
-- 7. Keymaps & Smart Clipboard
-- ==============================================================================
local map = vim.keymap.set

-- ------------------------------------------------------------------------------
-- Basic Mappings
-- ------------------------------------------------------------------------------

-- Delete inner word and wrap it in double quotes (works in normal and visual mode)
map({ "n", "v" }, "Q", 'diwi""<esc>hp', { noremap = true, desc = "Wrap word in quotes" })

-- ------------------------------------------------------------------------------
-- Smart Cross-Platform & Headless Clipboard Synchronization
-- ------------------------------------------------------------------------------
-- Neovim automatically detects xclip, wl-copy, and pbcopy. 
-- This block forces Neovims native OSC 52 provider ONLY when you are on a headless server.

if os.getenv("DISPLAY") == nil and os.getenv("WAYLAND_DISPLAY") == nil then
  -- Headless Environment Detected: Route everything through OSC 52 terminal sequences
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
      ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
      ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
      ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
    },
  }
end

-- ------------------------------------------------------------------------------
-- Black Hole Register Mappings (Prevent clipboard pollution)
-- ------------------------------------------------------------------------------

-- Make 'x' delete a single character without copying it
vim.keymap.set({ "n", "v" }, "x", '"_x', { noremap = true, desc = "Delete char without copying" })

-- Pro-tip: You probably want to do the same for 'c' (change). 
-- Otherwise, doing 'cw' to change a word will copy the old word to your clipboard, 
-- preventing you from pasting a new word over it!
vim.keymap.set({ "n", "v" }, "c", '"_c', { noremap = true, desc = "Change without copying" })

-- ------------------------------------------------------------------------------
-- Moving Lines Up/Down (Normal and Visual modes)
-- ------------------------------------------------------------------------------
local move_opts = { noremap = true, silent = true }

-- Normal mode (Ctrl + j/k)
map("n", "<C-j>", ":m .+1<CR>==", move_opts)
map("n", "<C-k>", ":m .-2<CR>==", move_opts)

-- Visual mode (Ctrl + j/k) - Keeps the selection active after moving
map("v", "<C-j>", ":m '>+1<CR>gv=gv", move_opts)
map("v", "<C-k>", ":m '<-2<CR>gv=gv", move_opts)

-- Normal mode (Ctrl + Up/Down)
map("n", "<C-Down>", ":m .+1<CR>==", move_opts)
map("n", "<C-Up>", ":m .-2<CR>==", move_opts)

-- Visual mode (Ctrl + Up/Down)
map("v", "<C-Down>", ":m '>+1<CR>gv=gv", move_opts)
map("v", "<C-Up>", ":m '<-2<CR>gv=gv", move_opts)
-- ==============================================================================
-- 8. Code Folding & Execution Mappings
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- Modern Treesitter Code Folding (Replaces foldmethod=syntax)
-- ------------------------------------------------------------------------------
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false -- Dont automatically fold everything when opening a file

-- ------------------------------------------------------------------------------
-- Compile and Run Keymaps
-- ------------------------------------------------------------------------------
local run_group = vim.api.nvim_create_augroup("CompileAndRun", { clear = true })

-- Helper function to generate compile/run keymaps dynamically
local function map_runner(filetypes, key, command_string)
  vim.api.nvim_create_autocmd("FileType", {
    group = run_group,
    pattern = filetypes,
    callback = function(opts)
      -- Map for both Normal ("n") and Insert ("i") modes
      vim.keymap.set({ "n", "i" }, key, function()
        vim.cmd("write") -- Save the file
        
        -- Execute the shell command. The "%:p" automatically expands to the 
        -- full path of the current file, wrapped in quotes for safety.
        vim.cmd("!clear && " .. command_string)
      end, { buffer = opts.buf, desc = "Save and execute file" })
    end,
  })
end

-- Python: Run script
map_runner("python", "<F9>", 'uv run "%:p"')

-- C: Compile with math library and run
map_runner("c", "<F9>", 'gcc "%:p" -lm && ./a.out')

-- C++: Compile and run
map_runner("cpp", "<F9>", 'g++ "%:p" && ./a.out')

-- Make: Trigger make command in C and Header files
map_runner({ "c", "cpp", "h" }, "<F8>", "make")
