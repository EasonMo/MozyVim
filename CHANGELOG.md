# Changelog

主要记录自己配置的插件与LazyVim同步的修改

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
