# 💤 LazyVim

个人定制版[LazyVim](https://github.com/LazyVim/LazyVim)

## 安装

```sh
git clone git@github.com:EasonMo/MozyVim.git  ~/.config/nvim
```

## 说明

LazyVim官方文档： [https://www.lazyvim.org](https://www.lazyvim.org)

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

## 寄存器宏分配

宏分配：

1. 搜索替换：搜索a，替换为b，宏为m
2. 粘贴：p
3. 整词粘贴：o

nvim启动时把宏设置到寄存器里：

1. hex编辑register_micro文件：`:%!xxd`
2. `的ascii码为：60，定位宏的位置
3. 把数据复制出来，以字节数据的方式给寄存器赋值：`"\x00\xFF\xAB\xCD"`
