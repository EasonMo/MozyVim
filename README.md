# 💤 MozyVim

## 说明

基于 [LazyVim](https://github.com/LazyVim/LazyVim) 进行深度定制

LazyVim官方文档： [https://www.lazyvim.org](https://www.lazyvim.org)

## 安装

```sh
git clone git@github.com:EasonMo/MozyVim.git ~/.config/nvim
```

## 寄存器宏分配

宏分配：

1. 搜索替换：搜索a，替换为b，宏为m
2. 选择后粘贴：p
3. 整词粘贴：o

nvim启动时把宏设置到寄存器里：

1. hex编辑register_micro文件：`:%!xxd`
2. 反引号`的ascii码为：60，查找60定位宏的开始位置和结束位置
3. 把数据复制出来，以字节数据的方式给寄存器赋值：`"\x00\xFF\xAB\xCD"`

## 妥协的配置

- 不需要设置markdown diagnostics的自动开关，因为enable/disable diagnostics是全局的，只能手动

## 插件调试

1. 启动一个nvim调试实例A：

```lua
lua require"osv".launch({port=8086})
```

2. 在另一个nvim实例B中启动DAP attach debug，并打上断点
3. 在实例A中进行操作，实例B就能进入断点，实际就是**远程调试**
