local js_fts = {
  "javascript",
  "javascriptreact",
  "javascript.jsx",
  "typescript",
  "typescriptreact",
  "typescript.tsx",
  "vue",
}

local css_fts = {
  "css",
  "less",
  "scss",
  "sass",
  "vue",
}

local web_format_fts = vim.list_extend(vim.deepcopy(js_fts), {
  "json",
  "jsonc",
  "html",
  "markdown",
  "markdown.mdx",
  "yaml",
  "graphql",
  "handlebars",
})

local eslint_configs = {
  "eslint.config.js",
  "eslint.config.mjs",
  "eslint.config.cjs",
  "eslint.config.ts",
  "eslint.config.mts",
  "eslint.config.cts",
  ".eslintrc",
  ".eslintrc.js",
  ".eslintrc.cjs",
  ".eslintrc.json",
  ".eslintrc.yaml",
  ".eslintrc.yml",
}

local prettier_configs = {
  ".prettierrc",
  ".prettierrc.json",
  ".prettierrc.json5",
  ".prettierrc.yaml",
  ".prettierrc.yml",
  ".prettierrc.toml",
  ".prettierrc.js",
  ".prettierrc.cjs",
  ".prettierrc.mjs",
  "prettier.config.js",
  "prettier.config.cjs",
  "prettier.config.mjs",
  "prettier.config.ts",
}

local biome_configs = { "biome.json", "biome.jsonc" }
local oxfmt_configs = { ".oxfmtrc.json", ".oxfmtrc.jsonc" }
local oxlint_configs = { ".oxlintrc.json", "oxlint.json", "oxlint.jsonc", ".oxlint.json", ".oxlint.jsonc" }
local vite_configs = {
  "vite.config.js",
  "vite.config.mjs",
  "vite.config.cjs",
  "vite.config.ts",
  "vite.config.mts",
  "vite.config.cts",
}
local stylelint_configs = {
  ".stylelintrc",
  ".stylelintrc.json",
  ".stylelintrc.yaml",
  ".stylelintrc.yml",
  ".stylelintrc.js",
  ".stylelintrc.cjs",
  ".stylelintrc.mjs",
  "stylelint.config.js",
  "stylelint.config.cjs",
  "stylelint.config.mjs",
  "stylelint.config.ts",
}

local package_keys = {
  prettier = "prettier",
  eslint = "eslintConfig",
  stylelint = "stylelint",
}

local function search_path(path)
  if not path or path == "" then
    return vim.uv.cwd()
  end

  local stat = vim.uv.fs_stat(path)
  return stat and stat.type == "directory" and path or vim.fs.dirname(path)
end

local function package_json_has(path, key)
  local package = vim.fs.find("package.json", { path = search_path(path), upward = true })[1]
  if not package then
    return false
  end

  local ok, data = pcall(vim.json.decode, table.concat(vim.fn.readfile(package), "\n"))
  return ok and type(data) == "table" and data[key] ~= nil
end

local function package_json_has_dependency(path, names)
  local package = vim.fs.find("package.json", { path = search_path(path), upward = true })[1]
  if not package then
    return false
  end

  local ok, data = pcall(vim.json.decode, table.concat(vim.fn.readfile(package), "\n"))
  if not ok or type(data) ~= "table" then
    return false
  end

  for _, section in ipairs({ "dependencies", "devDependencies", "peerDependencies", "optionalDependencies" }) do
    local deps = data[section]
    if type(deps) == "table" then
      for _, name in ipairs(names) do
        if deps[name] ~= nil then
          return true
        end
      end
    end
  end

  return false
end

local function has_root_file(path, names)
  return vim.fs.find(names, { path = search_path(path), upward = true })[1] ~= nil
end

local function has_vite_plus_config(path)
  for _, file in ipairs(vim.fs.find(vite_configs, { path = search_path(path), upward = true })) do
    local ok, lines = pcall(vim.fn.readfile, file)
    if ok and table.concat(lines, "\n"):find("vite%-plus") then
      return true
    end
  end

  return false
end

local function has_vite_plus_project(path)
  return package_json_has_dependency(path, { "vite-plus", "@voidzero-dev/vite-plus-core" })
    or has_vite_plus_config(path)
    or has_root_file(path, oxfmt_configs)
    or has_root_file(path, oxlint_configs)
end

local function has_tool_config(ctx, names, package_key)
  local path = ctx.filename ~= "" and ctx.filename or ctx.dirname
  return has_root_file(path, names) or (package_key and package_json_has(path, package_key))
end

local function only_when_configured(names, package_key)
  return function(_, ctx)
    return has_tool_config(ctx, names, package_key)
  end
end

local function lint_when_configured(names, package_key)
  return {
    condition = function(ctx)
      return has_tool_config(ctx, names, package_key)
    end,
  }
end

return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "biome",
        "eslint_d",
        "oxfmt",
        "oxlint",
        "prettier",
        "stylelint",
      })
    end,
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters = opts.formatters or {}

      for _, ft in ipairs(web_format_fts) do
        opts.formatters_by_ft[ft] = { "oxfmt", "biome", "prettier", stop_after_first = true }
      end

      opts.formatters_by_ft.css = { "stylelint", "oxfmt", "biome", "prettier", stop_after_first = true }
      opts.formatters_by_ft.less = { "stylelint", "oxfmt", "biome", "prettier", stop_after_first = true }
      opts.formatters_by_ft.scss = { "stylelint", "oxfmt", "biome", "prettier", stop_after_first = true }
      opts.formatters_by_ft.sass = { "stylelint", "oxfmt", "biome", "prettier", stop_after_first = true }

      opts.formatters.oxfmt = vim.tbl_deep_extend("force", opts.formatters.oxfmt or {}, {
        condition = function(_, ctx)
          local path = ctx.filename ~= "" and ctx.filename or ctx.dirname
          return has_vite_plus_project(path)
        end,
      })
      opts.formatters.biome = vim.tbl_deep_extend("force", opts.formatters.biome or {}, {
        condition = only_when_configured(biome_configs),
      })
      opts.formatters.prettier = vim.tbl_deep_extend("force", opts.formatters.prettier or {}, {
        condition = function(_, ctx)
          local path = ctx.filename ~= "" and ctx.filename or ctx.dirname
          return not has_vite_plus_project(path) and has_tool_config(ctx, prettier_configs, package_keys.prettier)
        end,
      })
      opts.formatters.stylelint = vim.tbl_deep_extend("force", opts.formatters.stylelint or {}, {
        condition = only_when_configured(stylelint_configs, package_keys.stylelint),
      })
    end,
  },

  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters = opts.linters or {}

      for _, ft in ipairs(js_fts) do
        opts.linters_by_ft[ft] = { "eslint_d", "oxlint", "biomejs" }
      end

      for _, ft in ipairs(css_fts) do
        opts.linters_by_ft[ft] = vim.list_extend(opts.linters_by_ft[ft] or {}, { "stylelint" })
      end

      opts.linters.eslint_d = vim.tbl_deep_extend(
        "force",
        opts.linters.eslint_d or {},
        lint_when_configured(eslint_configs, package_keys.eslint)
      )
      opts.linters.oxlint = vim.tbl_deep_extend("force", opts.linters.oxlint or {}, {
        condition = function(ctx)
          return has_vite_plus_project(ctx.filename)
        end,
      })
      opts.linters.biomejs =
        vim.tbl_deep_extend("force", opts.linters.biomejs or {}, lint_when_configured(biome_configs))
      opts.linters.stylelint = vim.tbl_deep_extend(
        "force",
        opts.linters.stylelint or {},
        lint_when_configured(stylelint_configs, package_keys.stylelint)
      )
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.eslint = vim.tbl_deep_extend("force", opts.servers.eslint or {}, {
        settings = {
          format = false,
          workingDirectories = { mode = "auto" },
        },
        root_dir = function(bufnr, on_dir)
          local file = vim.api.nvim_buf_get_name(bufnr)
          local config = vim.fs.find(eslint_configs, { path = search_path(file), upward = true })[1]
          local root = config and vim.fs.dirname(config) or nil

          if not root and package_json_has(file, package_keys.eslint) then
            local package = vim.fs.find("package.json", { path = search_path(file), upward = true })[1]
            root = package and vim.fs.dirname(package) or nil
          end

          if root then
            on_dir(root)
          end
        end,
      })
    end,
  },
}
