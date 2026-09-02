# ⚙️ Profile

> 个人开发环境配置集合 —— 记录各编辑器 / IDE 的设置、代码片段及格式化规则，方便跨设备同步与快速恢复。

## 📂 目录结构

```
profile/
├── nvim/             # Neovim (LazyVim) 配置
├── vscode/           # Visual Studio Code 配置
├── trae/             # Trae 配置
├── zed/              # Zed 配置
├── snippets/         # 通用代码片段
├── .prettierrc       # Prettier 格式化规则
└── .prettierignore   # Prettier 忽略规则
```

## 🖥️ 编辑器配置

### Neovim

基于 [LazyVim](https://github.com/LazyVim/LazyVim) 的配置方案，包含：

- Lua 插件配置（`lua/`）
- 自定义配色方案（`colors/`）
- StyLua 格式化配置
- [Git Merge 速查表](nvim/git-merge-cheatsheet.md)

### VS Code

| 文件 | 说明 |
| --- | --- |
| `settings.json` | 编辑器核心配置 |
| `plugins.json` | 推荐扩展列表 |
| `install-extensions.js` | 扩展一键安装脚本 |
| `profiles/` | 多 Profile 配置 |
| `debug/` | 调试配置 |

**常用扩展**：Volar · UnoCSS · Prettier · ESLint · Error Lens · Git Graph · Rust Analyzer

### Trae

基于 VS Code 设置微调，额外配置了 `AI.toolcall.confirmMode: autoRun`。

### Zed

Zed 原生配置，启用了 Vim 模式，使用 Copilot Chat 作为 AI 后端。

## ✂️ 代码片段

| 文件 | 前缀 | 说明 |
| --- | --- | --- |
| `csl.json` | `csl` | 快速插入 `console.log()` |
| `vue.json` | `vue` | Vue 3 SFC 模板（`<script setup>` + `<template>` + `<style>`） |

## 🎨 偏好一览

| 项目 | 配置 |
| --- | --- |
| 字体 | Maple Mono NF |
| 深色主题 | Tokyo Night Storm / GitHub Dark |
| 浅色主题 | Tokyo Night Light |
| 图标主题 | Material Icon Theme |
| Tab 宽度 | 2 spaces |
| 格式化 | Prettier（无分号 · 单引号） |
| 自动保存 | 延迟 5 秒 |

## 🚀 快速使用

### VS Code 扩展一键安装

```bash
node vscode/install-extensions.js
```

### Neovim 配置

```bash
# 备份现有配置
mv ~/.config/nvim ~/.config/nvim.bak

# 链接本仓库的 nvim 配置
ln -s $(pwd)/nvim ~/.config/nvim
```

## 📄 License

[MIT](LICENSE) © Carl Chen