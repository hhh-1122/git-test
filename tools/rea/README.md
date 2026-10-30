# REA

逆向工程 MCP 服务器。通过 MCP 接入 agent，本地分析二进制、托管代码、Electron/JavaScript 应用、APK、固件和网页。

- 包：`rea-agents@6.8.0`（[npm](https://www.npmjs.com/package/rea-agents)）
- 源码：[github.com/morluto/rea](https://github.com/morluto/rea) · 文档：[rea.tools](https://rea.tools/)
- 授权：MIT
- 工具数：229

## 为什么仓库里只有脚本

`rea-agents` 的 npm 包解包后 47MB / 2398 个文件，直接提交会让仓库体积翻倍、克隆变慢。npm 本身是它的分发渠道，仓库只保留**可复现的安装步骤**。

## 安装

前置：Node.js **22.x >= 22.23.4**、24.x >= 24.22.1，或 26.12.1+。

双击 `setup-rea.bat`，或在终端运行：

```cmd
npx --yes rea-agents@6.8.0 setup --all-detected --yes
```

完成后重启 agent，在连接器管理页对新的 `rea` 服务器点「信任」。

检查状态：

```cmd
npx --yes rea-agents@6.8.0 doctor
```

## 手动注册

setup 未识别你的客户端时，把 `mcp.json` 的内容合并进客户端的 MCP 配置文件：

| 客户端 | 配置路径 |
|---|---|
| WorkBuddy | `~/.workbuddy/mcp.json` |
| Claude Code | `~/.claude.json` |
| Cursor | `~/.cursor/mcp.json` |

先 dry-run 看它打算改什么：

```cmd
npx --yes rea-agents@6.8.0 setup --dry-run --format json
```

## Node 版本踩坑

`setup` 对 Node 版本有硬性下限，低于要求会直接拒绝执行（报 `environment_healthy: false`）。若系统 Node 由其他软件托管、不便升级，装一份独立便携版即可，不覆盖原环境：

```cmd
curl -L -o node.zip https://registry.npmmirror.com/-/binary/node/v22.23.4/node-v22.23.4-win-x64.zip
tar -xf node.zip
:: 解压后把目录改名为 D:\nodejs，临时加入 PATH 再运行 setup
```

运行时并不强制该版本（实测 Node 22.22.2 也能正常启动 MCP），只有 setup 会拦截。

## 分析引擎（可选）

网页前端、Electron、.NET、JavaScript 静态分析**不需要**任何引擎，开箱可用。
原生二进制、APK、固件需要额外引擎：

| 引擎 | 适用 | 配置 |
|---|---|---|
| Ghidra（免费） | 原生二进制，多架构 | `GHIDRA_INSTALL_DIR` |
| IDA（付费） | 原生二进制 | `REA_IDA_MCP_CONFIG` |
| Hopper（付费） | macOS 为主 | 自动检测 |
| jadx | APK | `REA_JADX_MCP_JAR` |
| Kuna | 反编译 | `REA_KUNA_COMMAND` |

REA 不会替你下载安装这些引擎，只使用你已有的安装。

## 常用命令

```cmd
:: 版本
npx rea-agents@6.8.0 --version

:: 健康检查（含各引擎与客户端注册状态）
npx rea-agents@6.8.0 doctor

:: 查看将要做的改动，不落地
npx rea-agents@6.8.0 setup --dry-run

:: 更新到最新
npx rea-agents@latest setup
```

## 使用边界

公网可见的前端代码（JS bundle）任何人都能下载，分析它本身不违法。但以下行为不可为：

- 绕过登录、付费墙、授权校验
- 批量抓取他人私有数据
- 将他人的代码或资源直接商用

只分析你拥有或已获授权分析的样本。
