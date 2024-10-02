# 💤 LazyVim

个人定制版[LazyVim](https://github.com/LazyVim/LazyVim)

## 安装

```sh
git clone git@github.com:EasonMo/MozyVim.git  ~/.config/nvim
```

## 说明

主要的定制说明：

- 修改缩进线的样式
- 修改treesitter区块选择的按键映射
- 修改状态栏的样式，采用vscode的主题
- 禁止自动格式化
- 禁止非代码文件的拼写检查
- 添加系统剪贴板的支持，支持tmux、ssh
- 添加可视化选择搜索
- 添加补全支持tab
- 添加alt+Enter执行命令
- 添加插件：
  - nvim-surround
  - vim-tmux-navigator
- 等等...

官方文档： [https://www.lazyvim.org](https://www.lazyvim.org)

与官方同步的修改记录：

- [x] LazyVim取消mason-nvim-dap关于python的dap默认配置，修改位置：extras/lang/python.lua#142，恢复配置nvim-dap-python

需额外安装的依赖：

- curl.nvim

```sh
# mac
brew install jq
# linux
sudo apt install jq
```
