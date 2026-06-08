# ChatGPT Profile Manager

一个本地 ChatGPT 多账号独立浏览器环境管理台。每个账号使用独立 Chrome `user-data-dir`，方便分别登录、打开官网、打开授权链接、保存备注状态。

## 功能

- 新建独立账号环境，不需要先输入邮箱
- 选择打开官方登录、Auth 授权、注册入口
- 账号列表只保存本地状态，浏览器 Profile 数据不会进入 Git
- 每行保留四个操作：打开 ChatGPT 官网、打开授权链接、保存现有信息、删除账号
- 支持批量预创建账号文件夹

## 启动

Windows 双击：

```powershell
启动管理台.bat
```

或运行：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\start.ps1
```

默认地址：

```text
http://127.0.0.1:8765
```

## 本地私有数据

以下目录只保留空文件夹占位，不会提交账号内容：

```text
chatgpt-profiles/
deleted-profiles/
```

这些目录里会生成 Chrome 登录状态、Cookie、缓存、auth.json 等敏感文件。不要手动提交它们。

`auth-links.json` 是本地链接配置，也不会提交。需要示例时参考 `auth-links.example.json`。
