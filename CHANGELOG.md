# Changelog

主要记录自己配置的插件与LazyVim同步的修改

## 2024-11-11

- 全量升级插件
- 已知冲突：
  - nvim-cmp：lua/cmp/utils/keymap.lua中的t#10和normalize#19方法缺少对`/`的处理

## 2024-08-05

- LazyVim取消mason-nvim-dap关于python的dap默认配置，修改位置：extras/lang/python.lua#142，恢复配置nvim-dap-python
