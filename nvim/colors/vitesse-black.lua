-- vitesse-black 主题（自制版，零依赖）
-- 配色取自 shiki vitesse-black.json，纯黑底 + Vitesse 标志绿
-- 用法：在 lua/plugins/colorscheme.lua 里 { "LazyVim", opts = { colorscheme = "vitesse-black" } }

-- 是否透明背景（true = 透出终端，需终端背景设为 #000000）
local transparent = false

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end
vim.g.colors_name = "vitesse-black"
vim.o.termguicolors = true

------------------------------------------------------------------
-- 调色板
------------------------------------------------------------------
local p = {
  bg       = "#000000",
  bg1      = "#121212", -- 选中 / 光标行 / hover
  bg2      = "#181818", -- 浮动列表 / 调试
  visual   = "#262626",
  fg       = "#dbd7ca",
  fg1      = "#bfbaaa", -- 活动前景（状态栏 / 侧栏）
  fg2      = "#959da5", -- 次要 / 非活动
  fg3      = "#6e6e6e", -- 忽略 / 行号
  border   = "#191919",
  border1  = "#2f363d", -- 更淡的边框 / 缩进线

  comment  = "#758575",
  string   = "#c98a7d",
  variable = "#bd976a",
  keyword  = "#4d9375",
  number   = "#4c9a91",
  boolean  = "#4d9375",
  operator = "#cb7676",
  func     = "#80a665",
  constant = "#c99076",
  type     = "#5da994",
  interface= "#5d99a9",
  class    = "#6872ab",
  property = "#b8a965",
  namespace= "#db889a",
  punct    = "#444444",
  decorator= "#bd8f8f",
  regex    = "#c4704f",
  tag      = "#4d9375",
  attribute= "#bd976a",
  builtin  = "#cb7676",

  green    = "#4d9375",
  cyan     = "#5eaab5",
  blue     = "#6394bf",
  red      = "#cb7676",
  orange   = "#d4976c",
  yellow   = "#e6cc77",
  magenta  = "#d9739f",
  purple   = "#7f8ac7",
}

local function hi(name, spec)
  vim.api.nvim_set_hl(0, name, spec)
end
local function link(name, target)
  hi(name, { link = target })
end

-- 透明模式下这些组不设背景
local bg = transparent and "NONE" or p.bg
local bg_float = transparent and "NONE" or p.bg

------------------------------------------------------------------
-- 编辑器核心
------------------------------------------------------------------
hi("Normal", { fg = p.fg, bg = bg })
hi("NormalNC", { fg = p.fg, bg = bg })
hi("NormalFloat", { fg = p.fg, bg = bg_float })
hi("FloatBorder", { fg = p.border1, bg = bg_float })
hi("FloatTitle", { fg = p.fg1, bg = bg_float, bold = true })
hi("ColorColumn", { bg = p.bg1 })
hi("CursorColumn", { bg = p.bg1 })
hi("CursorLine", { bg = p.bg1 })
hi("CursorLineNr", { fg = p.fg1, bold = true })
hi("LineNr", { fg = p.fg3 })
hi("SignColumn", { bg = bg })
hi("Folded", { fg = p.fg2, bg = p.bg1 })
hi("FoldColumn", { fg = p.fg2 })
hi("VertSplit", { fg = p.border1 })
hi("WinSeparator", { fg = p.border1 })
hi("Visual", { bg = p.visual })
hi("VisualNOS", { bg = p.bg2 })
hi("MatchParen", { bg = p.bg1, bold = true })
hi("MatchWord", { underline = true, sp = p.blue })
hi("NonText", { fg = p.fg3, bold = true })
hi("Whitespace", { fg = p.border1 })
hi("Conceal", { fg = p.blue })
hi("EndOfBuffer", { fg = bg })
hi("MsgArea", { fg = p.fg, bg = bg })
hi("MoreMsg", { fg = p.blue })
hi("ModeMsg", { fg = p.blue })
hi("Question", { fg = p.cyan, bold = true })
hi("Title", { fg = p.orange, bold = true })
hi("Directory", { fg = p.blue })
hi("ErrorMsg", { fg = p.red, bold = true })
hi("WarningMsg", { fg = p.orange })
hi("QuickFixLine", { bg = p.bg1, bold = true })
hi("WildMenu", { fg = p.fg, bg = p.bg2 })

-- 搜索
hi("Search", { fg = "#000000", bg = p.yellow })
hi("IncSearch", { fg = "#000000", bg = p.orange })
hi("Substitute", { fg = "#000000", bg = p.red })

-- 弹出菜单
hi("Pmenu", { fg = p.fg, bg = p.bg1 })
hi("PmenuSel", { fg = p.fg, bg = p.bg2, bold = true })
hi("PmenuSbar", { bg = p.bg1 })
hi("PmenuThumb", { bg = p.fg3 })
hi("PmenuMatch", { fg = p.keyword, bold = true })
hi("PmenuMatchSel", { fg = p.keyword, bg = p.bg2, bold = true })
hi("PmenuKind", { fg = p.fg2 })
hi("PmenuKindSel", { fg = p.fg2, bg = p.bg2 })

-- 状态栏 / 标签页（bufferline 会自动派生）
hi("StatusLine", { fg = p.fg1, bg = p.bg1 })
hi("StatusLineNC", { fg = p.fg3, bg = bg })
hi("TabLine", { fg = p.fg2, bg = p.bg1 })
hi("TabLineFill", { bg = bg })
hi("TabLineSel", { fg = p.fg, bg = p.bg2, bold = true })
hi("WinBar", { fg = p.fg2 })
hi("WinBarNC", { fg = p.fg3 })
hi("Cursor", { fg = p.bg, bg = p.fg2 })
hi("TermCursor", { fg = p.bg, bg = p.fg })
hi("TermCursorNC", { fg = p.bg, bg = p.fg3 })

-- 拼写
hi("SpellBad", { undercurl = true, sp = p.red })
hi("SpellCap", { undercurl = true, sp = p.blue })
hi("SpellRare", { undercurl = true, sp = p.cyan })
hi("SpellLocal", { undercurl = true, sp = p.yellow })

------------------------------------------------------------------
-- 内置语法
------------------------------------------------------------------
hi("Comment", { fg = p.comment, italic = true })
hi("Constant", { fg = p.constant })
hi("String", { fg = p.string })
hi("Character", { fg = p.string })
hi("Number", { fg = p.number })
hi("Boolean", { fg = p.boolean })
hi("Float", { fg = p.number })
hi("Identifier", { fg = p.variable })
hi("Function", { fg = p.func })
hi("Statement", { fg = p.keyword }) -- if/for/return 等
hi("Conditional", { fg = p.keyword })
hi("Repeat", { fg = p.keyword })
hi("Label", { fg = p.keyword })
hi("Operator", { fg = p.operator })
hi("Keyword", { fg = p.keyword })
hi("Exception", { fg = p.keyword })
hi("PreProc", { fg = p.red }) -- include/define/macro
link("Include", "PreProc")
link("Define", "PreProc")
link("Macro", "PreProc")
link("PreCondit", "PreProc")
hi("Type", { fg = p.type })
link("StorageClass", "Type")
link("Structure", "Type")
link("Typedef", "Type")
hi("Special", { fg = p.property })
link("SpecialChar", "Special")
hi("Tag", { fg = p.tag })
hi("Delimiter", { fg = p.punct })
link("SpecialComment", "Comment")
link("Debug", "Special")
hi("Underlined", { fg = p.red, underline = true })
hi("Ignore", { fg = p.comment })
hi("Todo", { fg = p.blue, bold = true })
hi("Error", { fg = p.red })

------------------------------------------------------------------
-- Treesitter
------------------------------------------------------------------
link("@variable", "Identifier")
hi("@variable.builtin", { fg = p.builtin }) -- self / this
hi("@variable.parameter", { fg = p.variable }) -- 参数：暖金色，与普通变量区分于正文
hi("@variable.member", { fg = p.property })
hi("@constant", { fg = p.constant })
hi("@constant.builtin", { fg = p.boolean })
hi("@module", { fg = p.namespace })
hi("@module.builtin", { fg = p.builtin })
hi("@label", { fg = p.property })

hi("@string", { fg = p.string })
hi("@string.documentation", { fg = p.comment })
hi("@string.escape", { fg = p.yellow })
hi("@string.special", { fg = p.string })
hi("@string.regexp", { fg = p.regex })
hi("@string.special.url", { fg = p.blue, underline = true })
hi("@character", { fg = p.string })
hi("@character.special", { fg = p.string })

hi("@boolean", { fg = p.boolean })
hi("@number", { fg = p.number })
hi("@number.float", { fg = p.number })

hi("@function", { fg = p.func })
hi("@function.builtin", { fg = p.func })
hi("@function.call", { fg = p.func })
hi("@function.macro", { fg = p.func })
hi("@method", { fg = p.func })
hi("@method.call", { fg = p.func })
hi("@constructor", { fg = p.class })

hi("@keyword", { fg = p.keyword })
hi("@keyword.function", { fg = p.keyword })
hi("@keyword.operator", { fg = p.operator }) -- and / or / not / in
hi("@keyword.import", { fg = p.keyword })
hi("@keyword.storage", { fg = p.red })       -- const / let / var
hi("@keyword.repeat", { fg = p.keyword })
hi("@keyword.return", { fg = p.keyword })
hi("@keyword.debug", { fg = p.red })
hi("@keyword.exception", { fg = p.keyword })
hi("@keyword.conditional", { fg = p.keyword })
hi("@keyword.conditional.ternary", { fg = p.operator })
hi("@keyword.type", { fg = p.keyword })
hi("@keyword.modifier", { fg = p.red })
hi("@keyword.directive", { fg = p.red })     -- #define / pragma
hi("@keyword.export", { fg = p.keyword })

hi("@operator", { fg = p.operator })         -- 算术/逻辑运算符
hi("@assignment", { fg = p.punct })          -- = += 等（vitesse 里赋值是灰色）
hi("@punctuation.delimiter", { fg = p.punct })
hi("@punctuation.bracket", { fg = p.punct })
hi("@punctuation.special", { fg = p.punct })

hi("@type", { fg = p.type })
hi("@type.builtin", { fg = p.builtin })
hi("@type.definition", { fg = p.type })
hi("@type.class", { fg = p.class })
hi("@type.interface", { fg = p.interface })
hi("@type.qualifier", { fg = p.red })
hi("@property", { fg = p.property })

hi("@comment", { fg = p.comment, italic = true })
hi("@comment.error", { fg = p.red, bold = true })
hi("@comment.warning", { fg = p.orange, bold = true })
hi("@comment.note", { fg = p.blue, bold = true })
hi("@comment.todo", { fg = p.blue, bold = true })

-- markup（markdown 等）
hi("@markup.heading", { fg = p.keyword, bold = true })
hi("@markup.italic", { fg = p.fg, italic = true })
hi("@markup.bold", { fg = p.fg, bold = true })
hi("@markup.strikethrough", { fg = p.fg2, strikethrough = true })
hi("@markup.link", { fg = p.string })
hi("@markup.link.url", { fg = p.blue, underline = true })
hi("@markup.link.label", { fg = p.string })
hi("@markup.raw", { fg = p.keyword })        -- 行内代码
hi("@markup.list", { fg = p.orange })        -- 列表标记
hi("@markup.list.checked", { fg = p.green })
hi("@markup.list.unchecked", { fg = p.fg2 })
hi("@markup.quote", { fg = p.interface })

-- diff
hi("@diff.plus", { fg = p.green })
hi("@diff.minus", { fg = p.red })
hi("@diff.delta", { fg = p.orange })

-- tag（html / jsx）
hi("@tag", { fg = p.tag })
hi("@tag.attribute", { fg = p.attribute })
hi("@tag.delimiter", { fg = p.punct })

-- 旧版 @text.* 兼容
link("@text.literal", "@markup.raw")
link("@text.reference", "@markup.link")
link("@text.title", "@markup.heading")
link("@text.uri", "@markup.link.url")
link("@text.underline", "Underlined")
link("@text.todo", "@comment.todo")
link("@text.note", "@comment.note")
link("@text.warning", "@comment.warning")
link("@text.danger", "@comment.error")
link("@text.emphasis", "@markup.italic")
link("@text.strong", "@markup.bold")
link("@text.strike", "@markup.strikethrough")
link("@text.quote", "@markup.quote")

------------------------------------------------------------------
-- LSP 语义高亮（链接到 treesitter）
------------------------------------------------------------------
link("@lsp.type.class", "@type.class")
link("@lsp.type.decorator", "@function")
link("@lsp.type.enum", "@type")
link("@lsp.type.enumMember", "@constant")
link("@lsp.type.function", "@function")
link("@lsp.type.interface", "@type.interface")
link("@lsp.type.macro", "@function.macro")
link("@lsp.type.method", "@method")
link("@lsp.type.namespace", "@module")
link("@lsp.type.parameter", "@variable.parameter")
link("@lsp.type.property", "@property")
link("@lsp.type.struct", "@type")
link("@lsp.type.type", "@type")
link("@lsp.type.typeParameter", "@type")
link("@lsp.type.variable", "@variable")
-- 让 @lsp.mod.* 的相关组保持低调
hi("@lsp.mod.deprecated", { fg = p.red, strikethrough = true })
hi("@lsp.mod.readonly", { fg = p.constant })

------------------------------------------------------------------
-- 诊断
------------------------------------------------------------------
hi("DiagnosticError", { fg = p.red })
hi("DiagnosticWarn", { fg = p.orange })
hi("DiagnosticInfo", { fg = p.blue })
hi("DiagnosticHint", { fg = p.cyan })
hi("DiagnosticOk", { fg = p.green })
hi("DiagnosticUnderlineError", { undercurl = true, sp = p.red })
hi("DiagnosticUnderlineWarn", { undercurl = true, sp = p.orange })
hi("DiagnosticUnderlineInfo", { undercurl = true, sp = p.blue })
hi("DiagnosticUnderlineHint", { undercurl = true, sp = p.cyan })
hi("DiagnosticVirtualTextError", { fg = p.red, bg = p.bg1 })
hi("DiagnosticVirtualTextWarn", { fg = p.orange, bg = p.bg1 })
hi("DiagnosticVirtualTextInfo", { fg = p.blue, bg = p.bg1 })
hi("DiagnosticVirtualTextHint", { fg = p.cyan, bg = p.bg1 })
link("DiagnosticSignError", "DiagnosticError")
link("DiagnosticSignWarn", "DiagnosticWarn")
link("DiagnosticSignInfo", "DiagnosticInfo")
link("DiagnosticSignHint", "DiagnosticHint")

-- LSP UI
hi("LspReferenceText", { bg = p.bg2, underline = true, sp = p.fg3 })
hi("LspReferenceRead", { bg = p.bg2, underline = true, sp = p.cyan })
hi("LspReferenceWrite", { bg = p.bg2, underline = true, sp = p.red })
hi("LspSignatureActiveParameter", { fg = p.keyword, underline = true, bold = true })
hi("LspInlayHint", { fg = p.fg3, bg = bg })
hi("@lsp.type.macro", { link = "@function" }) -- 占位，避免被覆盖

------------------------------------------------------------------
-- diff（内置）
------------------------------------------------------------------
hi("DiffAdd", { bg = "#16261c", fg = "NONE" })
hi("DiffChange", { bg = "#161e2b", fg = "NONE" })
hi("DiffText", { bg = "#26324a", fg = "NONE" })
hi("DiffDelete", { bg = "#2a1616", fg = "NONE" })
link("Added", "DiffAdd")
link("Removed", "DiffDelete")
link("Changed", "DiffChange")

------------------------------------------------------------------
-- blink.cmp
------------------------------------------------------------------
hi("BlinkCmpMenu", { fg = p.fg, bg = bg_float })
hi("BlinkCmpMenuBorder", { fg = p.border1, bg = bg_float })
hi("BlinkCmpMenuSelection", { fg = p.fg, bg = p.bg2, bold = true })
hi("BlinkCmpLabel", { fg = p.fg })
hi("BlinkCmpLabelMatch", { fg = p.keyword, bold = true })
hi("BlinkCmpLabelDetail", { fg = p.fg2 })
hi("BlinkCmpLabelDescription", { fg = p.fg2 })
hi("BlinkCmpLabelDeprecated", { fg = p.fg3, strikethrough = true })
hi("BlinkCmpCursorLine", { bg = p.bg2, bold = true })
hi("BlinkCmpCursor", { bg = p.fg, fg = p.bg })
hi("BlinkCmpGhostText", { fg = p.fg3 })
hi("BlinkCmpScrollBarThumb", { bg = p.fg3 })
hi("BlinkCmpScrollBarGutter", { bg = p.bg1 })
hi("BlinkCmpDoc", { fg = p.fg, bg = bg_float })
hi("BlinkCmpDocBorder", { fg = p.border1, bg = bg_float })
hi("BlinkCmpDocSeparator", { fg = p.border1 })
hi("BlinkCmpDocCursorLine", { bg = p.bg2, bold = true })
hi("BlinkCmpSignatureHelp", { fg = p.fg, bg = bg_float })
hi("BlinkCmpSignatureHelpBorder", { fg = p.border1, bg = bg_float })
hi("BlinkCmpSignatureHelpActiveParameter", { fg = p.keyword, bold = true })
hi("BlinkCmpSource", { fg = p.fg2 })

-- 补全项 kind 颜色
local kinds = {
  Variable = p.variable, Function = p.func, Method = p.func,
  Constructor = p.class, Field = p.property, Class = p.class,
  Interface = p.interface, Module = p.namespace, Property = p.property,
  Unit = p.number, Value = p.constant, Enum = p.type,
  Keyword = p.keyword, Snippet = p.fg2, Color = p.magenta,
  File = p.blue, Reference = p.fg2, Folder = p.blue,
  EnumMember = p.constant, Constant = p.constant, Struct = p.type,
  Event = p.magenta, Operator = p.operator, TypeParameter = p.type,
}
for name, color in pairs(kinds) do
  hi("BlinkCmpKind" .. name, { fg = color })
end

------------------------------------------------------------------
-- bufferline / 标签页
------------------------------------------------------------------
-- bufferline 会自动从 colorscheme 派生，这里给关键项加强
hi("BufferLineFill", { bg = bg })
hi("BufferLineBackground", { fg = p.fg2, bg = bg })
hi("BufferLineBufferVisible", { fg = p.fg2, bg = bg })
hi("BufferLineBufferSelected", { fg = p.fg, bg = bg, bold = true })
hi("BufferLineTab", { fg = p.fg2, bg = bg })
hi("BufferLineTabSelected", { fg = p.fg, bg = p.bg1, bold = true })
hi("BufferLineTabClose", { fg = p.red })
hi("BufferLineCloseButton", { fg = p.fg2 })
hi("BufferLineCloseButtonSelected", { fg = p.red })
hi("BufferLineModified", { fg = p.green, bg = bg })
hi("BufferLineModifiedSelected", { fg = p.green, bg = bg })
hi("BufferLineSeparator", { fg = p.border1, bg = bg })
hi("BufferLineSeparatorSelected", { fg = p.border1, bg = bg })
hi("BufferLineIndicatorSelected", { fg = p.keyword, bg = bg })
hi("BufferLineError", { fg = p.red, bg = bg })
hi("BufferLineErrorSelected", { fg = p.red, bg = bg, bold = true })

------------------------------------------------------------------
-- gitsigns
------------------------------------------------------------------
hi("GitSignsAdd", { fg = p.green })
hi("GitSignsChange", { fg = p.blue })
hi("GitSignsDelete", { fg = p.red })
hi("GitSignsAddCul", { fg = p.green, bold = true })
hi("GitSignsChangeCul", { fg = p.blue, bold = true })
hi("GitSignsDeleteCul", { fg = p.red, bold = true })
link("GitSignsAddLn", "DiffAdd")
link("GitSignsChangeLn", "DiffChange")
link("GitSignsDeleteLn", "DiffDelete")
hi("GitSignsAddInline", { bg = p.green, fg = p.bg })
hi("GitSignsDeleteInline", { bg = p.red, fg = p.bg })
hi("GitSignsChangeInline", { bg = p.blue, fg = p.bg })
hi("GitSignsCurrentLineBlame", { fg = p.fg3 })

------------------------------------------------------------------
-- flash
------------------------------------------------------------------
hi("FlashBackdrop", { fg = p.fg3 })
hi("FlashMatch", { fg = p.blue, bold = true })
hi("FlashCurrent", { fg = p.keyword, bold = true })
hi("FlashLabel", { fg = "#000000", bg = p.orange, bold = true })
hi("FlashCursor", { reverse = true })
hi("FlashPrompt", { fg = p.fg1 })
hi("FlashPromptIcon", { fg = p.keyword })

------------------------------------------------------------------
-- glance
------------------------------------------------------------------
hi("GlanceListNormal", { fg = p.fg, bg = bg_float })
hi("GlanceListCursorLine", { bg = p.bg1 })
hi("GlancePreviewNormal", { fg = p.fg, bg = bg_float })
hi("GlancePreviewCursorLine", { bg = p.bg1 })
hi("GlancePreviewMatch", { bg = p.bg2 })
hi("GlancePreviewLineNr", { fg = p.fg3 })
hi("GlanceBorderTop", { fg = p.border1 })
hi("GlanceMatch", { fg = p.keyword, bold = true })
hi("GlanceWinbarFilename", { fg = p.fg1, bold = true })
hi("GlanceWinbarFileCount", { fg = p.fg2 })
hi("GlanceWinbarTitle", { fg = p.keyword })
hi("GlanceButton", { fg = p.fg2 })
hi("GlanceButtonActive", { fg = p.keyword })

------------------------------------------------------------------
-- noice
------------------------------------------------------------------
hi("NoiceFormatProgressDone", { fg = p.bg, bg = p.keyword })
hi("NoiceFormatProgressTodo", { fg = p.fg2, bg = p.bg1 })
link("NoiceFormatTitle", "Title")
hi("NoiceCmdlineIcon", { fg = p.keyword })
hi("NoiceCmdlinePopupBorder", { fg = p.border1 })
hi("NoiceCmdlinePopupTitle", { fg = p.fg1, bold = true })
hi("NoiceConfirmBorder", { fg = p.border1 })
hi("NoicePopupBorder", { fg = p.border1 })
hi("NoiceSplitBorder", { fg = p.border1 })
hi("NoiceLspProgressClient", { fg = p.keyword })
hi("NoiceLspProgressSpinner", { fg = p.cyan })
hi("NoiceLspProgressTitle", { fg = p.fg1 })
link("NoiceFormatLevelError", "DiagnosticError")
link("NoiceFormatLevelWarn", "DiagnosticWarn")
link("NoiceFormatLevelInfo", "DiagnosticInfo")
link("NoiceFormatLevelDebug", "DiagnosticHint")

------------------------------------------------------------------
-- trouble
------------------------------------------------------------------
hi("TroubleNormal", { fg = p.fg, bg = bg })
hi("TroubleNormalNC", { fg = p.fg, bg = bg })
hi("TroubleText", { fg = p.fg })
hi("TroubleSource", { fg = p.fg2 })
hi("TroubleCode", { fg = p.fg2 })
hi("TroubleCount", { fg = p.keyword, bold = true })
hi("TroubleFilename", { fg = p.blue, bold = true })
hi("TroubleDirectory", { fg = p.blue })
hi("TroubleIndent", { fg = p.border1 })
hi("TroublePos", { fg = p.fg3 })
hi("TroubleIconDirectory", { fg = p.blue })
hi("TroublePreview", { bg = p.bg2, underline = true })

------------------------------------------------------------------
-- which-key
------------------------------------------------------------------
hi("WhichKeyNormal", { fg = p.fg, bg = bg_float })
hi("WhichKeyBorder", { fg = p.border1, bg = bg_float })
hi("WhichKey", { fg = p.cyan })
hi("WhichKeyDesc", { fg = p.fg })
hi("WhichKeyGroup", { fg = p.keyword, bold = true })
hi("WhichKeySeparator", { fg = p.fg3 })
hi("WhichKeyValue", { fg = p.fg2 })
hi("WhichKeyTitle", { fg = p.fg1, bold = true })
hi("WhichKeyIcon", { fg = p.blue })
hi("WhichKeyIconAzure", { fg = p.blue })
hi("WhichKeyIconBlue", { fg = p.blue })
hi("WhichKeyIconCyan", { fg = p.cyan })
hi("WhichKeyIconGreen", { fg = p.green })
hi("WhichKeyIconGrey", { fg = p.fg2 })
hi("WhichKeyIconOrange", { fg = p.orange })
hi("WhichKeyIconPurple", { fg = p.purple })
hi("WhichKeyIconRed", { fg = p.red })
hi("WhichKeyIconYellow", { fg = p.yellow })

------------------------------------------------------------------
-- todo-comments
------------------------------------------------------------------
hi("Todo", { fg = p.blue, bold = true })
hi("TodoFgTODO", { fg = p.blue, bold = true })
hi("TodoFgFIX", { fg = p.red, bold = true })
hi("TodoFgHACK", { fg = p.orange, bold = true })
hi("TodoFgWARN", { fg = p.orange, bold = true })
hi("TodoFgNOTE", { fg = p.cyan, bold = true })
hi("TodoFgPERF", { fg = p.keyword, bold = true })
hi("TodoFgTEST", { fg = p.magenta, bold = true })
hi("TodoBgTODO", { fg = p.bg, bg = p.blue, bold = true })
hi("TodoBgFIX", { fg = p.bg, bg = p.red, bold = true })
hi("TodoBgHACK", { fg = p.bg, bg = p.orange, bold = true })
hi("TodoBgWARN", { fg = p.bg, bg = p.orange, bold = true })
hi("TodoBgNOTE", { fg = p.bg, bg = p.cyan, bold = true })
hi("TodoBgPERF", { fg = p.bg, bg = p.keyword, bold = true })
hi("TodoBgTEST", { fg = p.bg, bg = p.magenta, bold = true })
hi("TodoSignTODO", { fg = p.blue })
hi("TodoSignFIX", { fg = p.red })
hi("TodoSignHACK", { fg = p.orange })
hi("TodoSignWARN", { fg = p.orange })
hi("TodoSignNOTE", { fg = p.cyan })
hi("TodoSignPERF", { fg = p.keyword })
hi("TodoSignTEST", { fg = p.magenta })

------------------------------------------------------------------
-- snacks
------------------------------------------------------------------
-- dashboard
hi("SnacksDashboardNormal", { fg = p.fg, bg = bg })
hi("SnacksDashboardHeader", { fg = p.keyword })
hi("SnacksDashboardIcon", { fg = p.blue })
hi("SnacksDashboardKey", { fg = p.constant })
hi("SnacksDashboardDesc", { fg = p.fg1 })
hi("SnacksDashboardFooter", { fg = p.fg3 })
hi("SnacksDashboardSpecial", { fg = p.orange })
hi("SnacksDashboardDir", { fg = p.blue })
hi("SnacksDashboardTerminal", { fg = p.fg })
-- picker
hi("SnacksPicker", { fg = p.fg, bg = bg })
hi("SnacksPickerBorder", { fg = p.border1, bg = bg })
hi("SnacksPickerTitle", { fg = p.fg1, bg = bg, bold = true })
hi("SnacksPickerListCursorLine", { bg = p.bg1, bold = true })
hi("SnacksPickerBox", { fg = p.fg, bg = bg })
hi("SnacksPickerBoxTitle", { fg = p.fg1, bold = true })
hi("SnacksPickerInput", { fg = p.fg, bg = bg })
hi("SnacksPickerDir", { fg = p.blue })
hi("SnacksPickerDirectory", { fg = p.blue })
hi("SnacksPickerFile", { fg = p.fg })
hi("SnacksPickerComment", { fg = p.comment })
hi("SnacksPickerDimmed", { fg = p.fg3 })
hi("SnacksPickerDesc", { fg = p.fg2 })
hi("SnacksPickerDelim", { fg = p.punct })
hi("SnacksPickerCode", { fg = p.fg })
hi("SnacksPickerCol", { fg = p.fg3 })
hi("SnacksPickerBufFlags", { fg = p.fg2 })
hi("SnacksPickerBufNr", { fg = p.keyword })
hi("SnacksPickerCmd", { fg = p.keyword })
hi("SnacksPickerGitStatusAdded", { fg = p.green })
hi("SnacksPickerGitStatusModified", { fg = p.blue })
hi("SnacksPickerGitStatusDeleted", { fg = p.red })
hi("SnacksPickerGitStatusUntracked", { fg = p.cyan })
hi("SnacksPickerGitStatusRenamed", { fg = p.orange })
hi("SnacksPickerGitStatusStaged", { fg = p.yellow })
hi("SnacksPickerGitBranch", { fg = p.magenta })
hi("SnacksPickerGitBranchCurrent", { fg = p.keyword, bold = true })
hi("SnacksPickerGitCommit", { fg = p.constant })
hi("SnacksPickerGitMsg", { fg = p.fg1 })
hi("SnacksPickerGitDate", { fg = p.fg2 })
hi("SnacksPickerGitAuthor", { fg = p.property })
hi("SnacksPickerDiagnosticCode", { fg = p.red })
hi("SnacksPickerDiagnosticSource", { fg = p.fg2 })
hi("SnacksPickerAuEvent", { fg = p.keyword })
hi("SnacksPickerAuGroup", { fg = p.func })
hi("SnacksPickerAuPattern", { fg = p.string })
-- notifier
hi("SnacksNotifierError", { fg = p.red, bg = bg_float })
hi("SnacksNotifierWarn", { fg = p.orange, bg = bg_float })
hi("SnacksNotifierInfo", { fg = p.blue, bg = bg_float })
hi("SnacksNotifierDebug", { fg = p.cyan, bg = bg_float })
hi("SnacksNotifierTrace", { fg = p.magenta, bg = bg_float })
hi("SnacksNotifierBorderError", { fg = p.red, bg = bg_float })
hi("SnacksNotifierBorderWarn", { fg = p.orange, bg = bg_float })
hi("SnacksNotifierBorderInfo", { fg = p.blue, bg = bg_float })
hi("SnacksNotifierBorderDebug", { fg = p.cyan, bg = bg_float })
hi("SnacksNotifierBorderTrace", { fg = p.magenta, bg = bg_float })
hi("SnacksNotifierIconError", { fg = p.red })
hi("SnacksNotifierIconWarn", { fg = p.orange })
hi("SnacksNotifierIconInfo", { fg = p.blue })
hi("SnacksNotifierIconDebug", { fg = p.cyan })
hi("SnacksNotifierIconTrace", { fg = p.magenta })
hi("SnacksNotifierTitle", { fg = p.fg1, bold = true })
-- indent
hi("SnacksIndent", { fg = p.border })
hi("SnacksIndentChunk", { fg = p.border1 })
hi("SnacksIndentScope", { fg = p.fg3 })
-- input / rename
hi("SnacksInputNormal", { fg = p.fg, bg = bg_float })
hi("SnacksInputBorder", { fg = p.border1, bg = bg_float })
hi("SnacksInputTitle", { fg = p.keyword, bg = bg_float, bold = true })
hi("SnacksInputIcon", { fg = p.keyword })

------------------------------------------------------------------
-- incline
------------------------------------------------------------------
hi("InclineNormal", { fg = p.fg1, bg = p.bg1 })
hi("InclineNormalNC", { fg = p.fg3, bg = p.bg1 })

------------------------------------------------------------------
-- 杂项：lazy / mason / markdown
------------------------------------------------------------------
hi("LazyNormal", { fg = p.fg, bg = bg })
hi("LazyButton", { fg = p.fg1, bg = p.bg1 })
hi("LazyButtonActive", { fg = p.bg, bg = p.keyword, bold = true })
hi("LazySpecial", { fg = p.keyword })
hi("LazyH1", { fg = p.keyword, bold = true })
hi("LazyProp", { fg = p.property })
hi("LazyReason", { fg = p.fg2 })
hi("LazyValue", { fg = p.string })
hi("MasonNormal", { fg = p.fg, bg = bg })
hi("MasonHeader", { fg = p.bg, bg = p.keyword, bold = true })
hi("MasonHighlight", { fg = p.keyword })
hi("MasonHighlightBlock", { fg = p.bg, bg = p.keyword })
hi("MasonHighlightBlockBold", { fg = p.bg, bg = p.keyword, bold = true })
hi("MasonMuted", { fg = p.fg2 })
hi("MasonMutedBlock", { fg = p.fg, bg = p.bg1 })
hi("markdownCode", { fg = p.keyword })
link("markdownUrl", "@markup.link.url")
link("markdownError", "Error")

------------------------------------------------------------------
-- 终端颜色（让 :terminal 也对齐）
------------------------------------------------------------------
vim.g.terminal_color_0 = p.bg
vim.g.terminal_color_1 = p.red
vim.g.terminal_color_2 = p.green
vim.g.terminal_color_3 = p.yellow
vim.g.terminal_color_4 = p.blue
vim.g.terminal_color_5 = p.magenta
vim.g.terminal_color_6 = p.cyan
vim.g.terminal_color_7 = p.fg
vim.g.terminal_color_8 = p.fg3
vim.g.terminal_color_9 = p.red
vim.g.terminal_color_10 = p.green
vim.g.terminal_color_11 = p.yellow
vim.g.terminal_color_12 = p.blue
vim.g.terminal_color_13 = p.magenta
vim.g.terminal_color_14 = p.cyan
vim.g.terminal_color_15 = p.fg
