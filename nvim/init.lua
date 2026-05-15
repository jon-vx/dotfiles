print("hello")

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = false
vim.g.python3_host_prog = vim.fn.expand("~/.config/nvim/venv/nvim-python/bin/python3")

vim.o.autoread = true

-- Actually trigger autoread when focus/buffer changes
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
	command = "checktime",
})

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.softtabstop = 2
vim.opt.autoindent = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.mouse = "a"

vim.opt.showmode = false
vim.opt.clipboard = "unnamed"

vim.opt.breakindent = true

vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = "yes"

vim.opt.updatetime = 250

vim.opt.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.list = false
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.opt.inccommand = "split"

vim.opt.cursorline = false

vim.opt.scrolloff = 10

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	"tpope/vim-sleuth",

	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},

	{
		"folke/which-key.nvim",
		event = "VimEnter",
		opts = {
			icons = {
				mappings = vim.g.have_nerd_font,
				keys = vim.g.have_nerd_font and {} or {
					Up = "<Up> ",
					Down = "<Down> ",
					Left = "<Left> ",
					Right = "<Right> ",
					C = "<C-…> ",
					M = "<M-…> ",
					D = "<D-…> ",
					S = "<S-…> ",
					CR = "<CR> ",
					Esc = "<Esc> ",
					ScrollWheelDown = "<ScrollWheelDown> ",
					ScrollWheelUp = "<ScrollWheelUp> ",
					NL = "<NL> ",
					BS = "<BS> ",
					Space = "<Space> ",
					Tab = "<Tab> ",
					F1 = "<F1>",
					F2 = "<F2>",
					F3 = "<F3>",
					F4 = "<F4>",
					F5 = "<F5>",
					F6 = "<F6>",
					F7 = "<F7>",
					F8 = "<F8>",
					F9 = "<F9>",
					F10 = "<F10>",
					F11 = "<F11>",
					F12 = "<F12>",
				},
			},

			spec = {
				{ "<leader>c", group = "[C]ode", mode = { "n", "x" } },
				{ "<leader>d", group = "[D]ocument" },
				{ "<leader>r", group = "[R]ename" },
				{ "<leader>s", group = "[S]earch" },
				{ "<leader>w", group = "[W]orkspace" },
				{ "<leader>t", group = "[T]oggle" },
				{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
			},
		},
	},

	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})

			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
			vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
			vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
			vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
			vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
			vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
			vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

			vim.keymap.set("n", "<leader>/", function()
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, { desc = "[/] Fuzzily search in current buffer" })

			vim.keymap.set("n", "<leader>s/", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end, { desc = "[S]earch [/] in Open Files" })

			vim.keymap.set("n", "<leader>sn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[S]earch [N]eovim files" })
		end,
	},

	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("nvim-tree").setup({
				view = { side = "right", width = 22 },
			})

			local api = require("nvim-tree.api")
			vim.keymap.set("n", "<leader>tt", api.tree.toggle, { desc = "Toggle NvimTree" })
		end,
	},

	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{ "Bilal2453/luvit-meta", lazy = true },
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
					map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
					map(
						"<leader>ws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			local servers = {
				clangd = {},
				coq_lsp = {},
				pyright = {},
				html = {
					filetypes = { "html", "htmldjango" },
				},
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
			}

			require("mason").setup()

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua",
			})

			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
			require("mason-lspconfig").setup({
				automatic_installation = false,
				automatic_setup = false,
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},

	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				local disable_filetypes = { c = true, cpp = true }
				local lsp_format_opt
				if disable_filetypes[vim.bo[bufnr].filetype] then
					lsp_format_opt = "never"
				else
					lsp_format_opt = "fallback"
				end
				return {
					timeout_ms = 500,
					lsp_format = lsp_format_opt,
				}
			end,
			formatters_by_ft = {
				lua = { "stylua" },
			},
		},
	},

	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				build = (function()
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {},
			},
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			luasnip.config.setup({})

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},

				completion = { completeopt = "menu,menuone,noinsert" },

				window = {
					completion = cmp.config.window.bordered(),
				},

				mapping = cmp.mapping.preset.insert({
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
					["<C-Space>"] = cmp.mapping.complete({}),
					["<C-l>"] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { "i", "s" }),
					["<C-h>"] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { "i", "s" }),
				}),
				sources = {
					{
						name = "lazydev",
						group_index = 0,
					},
					{ name = "nvim_lsp", max_item_count = 5 },
					{ name = "luasnip", max_item_count = 3 },
					{ name = "path", max_item_count = 3 },
				},
			})
		end,
	},

	-- Domino Still Life palette is applied inline at the bottom of this file

	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},

	{
		"echasnovski/mini.nvim",
		config = function()
			require("mini.ai").setup({ n_lines = 500 })
			require("mini.surround").setup()

			local statusline = require("mini.statusline")
			statusline.setup({ use_icons = vim.g.have_nerd_font })

			---@diagnostic disable-next-line: duplicate-set-field
			statusline.section_location = function()
				return "%2l:%-2v"
			end
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		main = "nvim-treesitter.configs",
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"diff",
				"html",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"query",
				"vim",
				"vimdoc",
			},
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = { "ruby" },
			},
			indent = { enable = true, disable = { "ruby" } },
		},
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
}, {
	ui = {
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})

-- Editor colors: Domino Still Life
local C = {
	bg = "#0c0c0c",
	fg = "#e6e6e6",

	shadow = "#17160f",
	shadow_bright = "#4a4634",

	wood = "#7b3428",
	wood_bright = "#c05a3e",

	olive = "#687244",
	olive_bright = "#a0aa6b",

	brass = "#9b7632",
	brass_bright = "#d0aa56",

	stone = "#58675f",
	stone_bright = "#8aa09a",

	wine = "#74515a",
	wine_bright = "#b27a86",

	oxid = "#6f7f69",
	oxid_bright = "#a3b89b",

	paper = "#c8bd98",
	bone = "#f3ead0",

	selection = "#2f3549",
	comment = "#7f8466",
	muted = "#6f6a52",
	panel = "#15140f",
	panel_soft = "#1d1b13",
}

local function hl(group, opts)
	vim.api.nvim_set_hl(0, group, opts)
end

local function apply_editor_highlights()
	local transparent_groups = {
		"Normal",
		"NormalNC",
		"NormalFloat",
		"SignColumn",
		"EndOfBuffer",
		"LineNr",
		"FoldColumn",
		"StatusLine",
		"StatusLineNC",
	}

	for _, group in ipairs(transparent_groups) do
		hl(group, { bg = "NONE" })
	end

	hl("Normal", { fg = C.fg, bg = "NONE" })
	hl("NormalNC", { fg = C.fg, bg = "NONE" })
	hl("NormalFloat", { fg = C.fg, bg = "NONE" })
	hl("FloatBorder", { fg = C.brass, bg = "NONE" })
	hl("WinBar", { fg = C.paper, bg = "NONE" })
	hl("WinBarNC", { fg = C.muted, bg = "NONE" })
	hl("StatusLine", { fg = C.paper, bg = "NONE" })
	hl("StatusLineNC", { fg = C.muted, bg = "NONE" })

	hl("CursorLine", { bg = "#15140f" })
	hl("CursorLineNr", { fg = C.brass_bright, bold = true })
	hl("LineNr", { fg = C.shadow_bright })
	hl("SignColumn", { bg = "NONE" })
	hl("ColorColumn", { bg = C.panel })

	hl("Visual", { fg = C.bone, bg = C.selection })
	hl("Search", { fg = C.shadow, bg = C.brass_bright })
	hl("IncSearch", { fg = C.shadow, bg = C.wood_bright })

	hl("Pmenu", { fg = C.fg, bg = C.panel })
	hl("PmenuSel", { fg = C.bone, bg = C.selection, bold = true })
	hl("PmenuSbar", { bg = C.panel_soft })
	hl("PmenuThumb", { bg = C.brass })

	hl("TermNormal", { fg = C.fg, bg = "#1a1811" })
	hl("TermNormalNC", { fg = C.fg, bg = "#1a1811" })

	hl("Comment", { fg = C.comment, italic = true })
	hl("String", { fg = C.olive_bright })
	hl("Character", { fg = C.olive_bright })
	hl("Number", { fg = C.brass_bright })
	hl("Boolean", { fg = C.wood_bright, bold = true })
	hl("Float", { fg = C.brass_bright })
	hl("Function", { fg = C.stone_bright, bold = true })
	hl("Identifier", { fg = C.fg })
	hl("Keyword", { fg = C.brass_bright, bold = true, italic = true })
	hl("Statement", { fg = C.brass_bright, bold = true })
	hl("Conditional", { fg = C.brass_bright, bold = true })
	hl("Repeat", { fg = C.brass_bright, bold = true })
	hl("Operator", { fg = C.paper })
	hl("Type", { fg = C.oxid_bright, italic = true })
	hl("Constant", { fg = C.paper })
	hl("Special", { fg = C.wine_bright })
	hl("PreProc", { fg = C.wine_bright })
	hl("Todo", { fg = C.shadow, bg = C.brass_bright, bold = true })

	hl("DiagnosticError", { fg = C.wood_bright })
	hl("DiagnosticWarn", { fg = C.brass_bright })
	hl("DiagnosticInfo", { fg = C.stone_bright })
	hl("DiagnosticHint", { fg = C.oxid_bright })
	hl("DiagnosticOk", { fg = C.olive_bright })

	local syntax_groups = {
		["@comment"] = { fg = C.comment, italic = true },
		["@keyword"] = { fg = C.brass_bright, bold = true, italic = true },
		["@keyword.function"] = { fg = C.brass_bright, bold = true },
		["@keyword.return"] = { fg = C.wood_bright, bold = true },
		["@keyword.conditional"] = { fg = C.brass_bright, bold = true },
		["@keyword.repeat"] = { fg = C.brass_bright, bold = true },
		["@function"] = { fg = C.stone_bright, bold = true },
		["@function.call"] = { fg = C.stone_bright },
		["@function.method"] = { fg = C.stone_bright },
		["@method"] = { fg = C.stone_bright },
		["@constructor"] = { fg = C.brass_bright, bold = true },
		["@type"] = { fg = C.oxid_bright },
		["@type.builtin"] = { fg = C.oxid_bright, italic = true },
		["@string"] = { fg = C.olive_bright },
		["@string.escape"] = { fg = C.brass_bright },
		["@number"] = { fg = C.brass_bright },
		["@boolean"] = { fg = C.wood_bright, bold = true },
		["@constant"] = { fg = C.paper },
		["@constant.builtin"] = { fg = C.wood_bright, bold = true },
		["@variable"] = { fg = C.fg },
		["@variable.builtin"] = { fg = C.wine_bright, italic = true },
		["@variable.member"] = { fg = C.wine_bright },
		["@property"] = { fg = C.wine_bright },
		["@operator"] = { fg = C.paper },
		["@punctuation.delimiter"] = { fg = C.muted },
		["@punctuation.bracket"] = { fg = C.paper },
		["@punctuation.special"] = { fg = C.brass },
		["@tag"] = { fg = C.wood_bright },
		["@tag.attribute"] = { fg = C.brass_bright, italic = true },
		["@tag.delimiter"] = { fg = C.muted },
		["@markup.heading"] = { fg = C.brass_bright, bold = true },
		["@markup.link"] = { fg = "#88c0d0", underline = true },
		["@markup.raw"] = { fg = C.olive_bright },
		["@markup.list"] = { fg = C.wood_bright },

		RainbowDelimiterRed = { fg = C.wood_bright },
		RainbowDelimiterOrange = { fg = C.brass },
		RainbowDelimiterYellow = { fg = C.brass_bright },
		RainbowDelimiterGreen = { fg = C.olive_bright },
		RainbowDelimiterCyan = { fg = C.oxid_bright },
		RainbowDelimiterBlue = { fg = C.stone_bright },
		RainbowDelimiterViolet = { fg = C.wine_bright },
	}

	for group, opts in pairs(syntax_groups) do
		hl(group, opts)
	end

	hl("TelescopeNormal", { fg = C.fg, bg = "NONE" })
	hl("TelescopeBorder", { fg = C.brass, bg = "NONE" })
	hl("TelescopePromptBorder", { fg = C.brass_bright, bg = "NONE" })
	hl("TelescopePromptTitle", { fg = C.shadow, bg = C.brass_bright, bold = true })
	hl("TelescopeSelection", { fg = C.bone, bg = C.selection, bold = true })
	hl("TelescopeMatching", { fg = C.brass_bright, bold = true })

	local tree_groups = {
		NvimTreeNormal = { fg = C.fg, bg = "NONE" },
		NvimTreeNormalNC = { fg = C.fg, bg = "NONE" },
		NvimTreeEndOfBuffer = { fg = C.shadow, bg = "NONE" },
		NvimTreeWinSeparator = { fg = C.shadow_bright, bg = "NONE" },
		NvimTreeCursorLine = { bg = C.panel },
		NvimTreeLineNr = { fg = C.shadow_bright },
		NvimTreeRootFolder = { fg = C.brass_bright, bold = true },
		NvimTreeFolderName = { fg = C.oxid_bright },
		NvimTreeOpenedFolderName = { fg = C.stone_bright, bold = true },
		NvimTreeEmptyFolderName = { fg = C.muted, italic = true },
		NvimTreeFolderIcon = { fg = C.oxid_bright },
		NvimTreeOpenedFolderIcon = { fg = C.stone_bright },
		NvimTreeFileIcon = { fg = C.fg },
		NvimTreeSymlink = { fg = C.oxid_bright, italic = true },
		NvimTreeExecFile = { fg = C.stone_bright, bold = true },
		NvimTreeSpecialFile = { fg = C.wine_bright, italic = true },
		NvimTreeImageFile = { fg = C.wine_bright },
		NvimTreeMarkdownFile = { fg = C.olive_bright },
		NvimTreeIndentMarker = { fg = C.shadow_bright },
		NvimTreeGitDirty = { fg = C.brass_bright },
		NvimTreeGitStaged = { fg = C.olive_bright },
		NvimTreeGitMerge = { fg = C.wine_bright },
		NvimTreeGitRenamed = { fg = C.oxid_bright },
		NvimTreeGitNew = { fg = C.olive_bright },
		NvimTreeGitDeleted = { fg = C.wood_bright },
		NvimTreeGitIgnored = { fg = C.muted, italic = true },
		NvimTreeDiagnosticError = { fg = C.wood_bright },
		NvimTreeDiagnosticWarn = { fg = C.brass_bright },
		NvimTreeDiagnosticInfo = { fg = C.stone_bright },
		NvimTreeDiagnosticHint = { fg = C.oxid_bright },
	}

	for group, opts in pairs(tree_groups) do
		hl(group, opts)
	end

	hl("AlphaHeader", { fg = C.brass })
	hl("AlphaButtons", { fg = C.paper })
	hl("AlphaShortcut", { fg = C.wood_bright, bold = true })
	hl("AlphaFooter", { fg = C.olive_bright, italic = true })
end

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = apply_editor_highlights,
})
apply_editor_highlights()
