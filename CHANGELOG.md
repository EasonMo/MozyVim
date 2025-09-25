# Changelog

主要记录自己配置的插件与LazyVim同步的修改

## 2025-09-25

- LazyVim自15.0.0使用nvim-treesitter的main分支，该分支是重写分支，不支持incremental selection。注意：`<tab>`与`ctrl-i`一样，incremental selection不能由`<tab>`键触发。flash.nvim改用`<Enter>`触发时会出现各种冲突。故删除nvim-treesitter相关配置，删除由`<Enter>`触发增量选择的功能。该功能可以用flash.nvim的`S`+`;`/`,`实现

## 2025-09-18

- cmdline补全不能使用noice.nvim的ui，原因是打开了blink.nvim的cmdline补全。blink比原生的更方便

## 2024-12-16

- 升级LazyVim到14.x
- 删除indent-blankline，设置snacks.indent的缩进线颜色
- 删除nvim-cmp，适配blink.cmp的dap补全，删除原来为了解决nvim.cmp补全内容过多而增加的snippets别名，注：原来cppdbg的补全bug被blink消除了
- 删除telescope，同时删除用选中文本搜索buffer和全局的命令

## 2024-11-11

- 全量升级插件
- 已知冲突：
  - nvim-cmp：lua/cmp/utils/keymap.lua中的t#10和normalize#19方法缺少对`/`的处理

## 2024-08-05

- LazyVim取消mason-nvim-dap关于python的dap默认配置，修改位置：extras/lang/python.lua#142，恢复配置nvim-dap-python
