return {
	"VonHeikemen/lsp-zero.nvim",
	branch = "v4.x",
	dependencies = {
		{ "williamboman/mason.nvim" },
		{ "williamboman/mason-lspconfig.nvim" },
		{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
		{ "neovim/nvim-lspconfig" },
		{ "L3MON4D3/LuaSnip" },
		{ "hrsh7th/nvim-cmp" },
		{ "hrsh7th/cmp-nvim-lsp" },
		{ "hrsh7th/cmp-buffer" },
		{ "hrsh7th/cmp-path" },
		{ "saadparwaiz1/cmp_luasnip" },
		{ "rafamadriz/friendly-snippets" },
		{ "lewis6991/hover.nvim" },
	},
	config = function()
		local lsp_zero = require("lsp-zero")

		---@diagnostic disable-next-line: unused-local
		local lsp_attach = function(client, bufnr)
			local opts = { buffer = bufnr }
			--vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
			vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
			vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
			vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
			vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
			vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
			vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
			vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
			vim.keymap.set({ "n", "x" }, "<leader>cf", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
			vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
		end

		lsp_zero.extend_lspconfig({
			sign_text = true,
			lsp_attach = lsp_attach,
			float_border = "rounded",
			capabilities = require("cmp_nvim_lsp").default_capabilities(),
		})

		require("mason").setup({
			ensure_installed = {
				"cssls",
				"html",
				"lua_ls",
				"tsserver",
				"volar",
				"pyright",
				"eslint_d",
				"tailwindcss",
				"cssls",
				"html",
			},
		})
		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					require("lspconfig")[server_name].setup({})
				end,
				volar = function()
					require("lspconfig").volar.setup({})
				end,
				tsserver = function()
					local vue_typescript_plugin = require("mason-registry")
						.get_package("vue-language-server")
						:get_install_path() .. "/node_modules/@vue/language-server" .. "/node_modules/@vue/typescript-plugin"

					require("lspconfig").tsserver.setup({
						init_options = {
							plugins = {
								{
									name = "@vue/typescript-plugin",
									location = vue_typescript_plugin,
									languages = { "javascript", "typescript", "vue" },
								},
							},
						},
						filetypes = {
							"javascript",
							"javascriptreact",
							"javascript.jsx",
							"typescript",
							"typescriptreact",
							"typescript.tsx",
							"vue",
						},
					})
				end,
			},
		})
		require("mason-tool-installer").setup({
			ensure_installed = {
				"eslint",
				"eslint_d",
				"prettier",
				"stylua",
				"black",
				"tailwindcss",
				"cssls",
				"html",
			},
			handlers = {
				lsp_zero.default_setup,
			},
		})

		-- HOVER
		require("hover").setup({
			init = function()
				-- Require providers
				require("hover.providers.lsp")
				-- require("hover.providers.gh")
				-- require("hover.providers.gh_user")
				-- require("hover.providers.jira")
				-- require("hover.providers.man")
				-- require("hover.providers.dictionary")
			end,
			preview_opts = {
				border = "single",
			},
			-- Whether the contents of a currently open hover window should be moved
			-- to a :h preview-window when pressing the hover keymap.
			preview_window = true,
			title = true,
			mouse_providers = {
				"LSP",
			},
			mouse_delay = 1000,
		})

		-- Setup keymaps
		vim.keymap.set("n", "K", require("hover").hover, { desc = "hover.nvim" })

		-- CMP
		local cmp = require("cmp")
		local luasnip = require("luasnip")

		-- this is the function that loads the extra snippets
		-- from rafamadriz/friendly-snippets
		require("luasnip.loaders.from_vscode").lazy_load()

		cmp.setup({
			sources = {
				{ name = "path" },
				{ name = "nvim_lsp" },
				{ name = "luasnip", keyword_length = 2 },
				{ name = "buffer", keyword_length = 3 },
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			completion = {
				autocomplete = false,
				completeopt = "menu,menuone,noinsert",
			},
			mapping = cmp.mapping.preset.insert({
				["<C-j>"] = cmp.mapping.select_next_item(),
				["<C-k>"] = cmp.mapping.select_prev_item(),
				["<C-Space>"] = cmp.mapping.complete({}),
				["<C-e>"] = cmp.mapping.close(),
				["<C-n>"] = cmp.mapping.scroll_docs(1),
				["<C-p>"] = cmp.mapping.scroll_docs(-1),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<CR>"] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = true,
				}),
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.locally_jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			-- note: if you are going to use lsp-kind (another plugin)
			-- replace the line below with the function from lsp-kind
			formatting = lsp_zero.cmp_format({ details = true }),
		})
	end,
}
