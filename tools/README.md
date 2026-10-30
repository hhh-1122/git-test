# tools

Windows 下常用的命令行媒体工具，下载即用，无需安装。

## yt-dlp.exe

视频下载器，支持 1000+ 站点（B站、抖音、微博、TikTok、Twitter/X、YouTube 等）。

- 版本：2026.10.26
- 授权：Unlicense（公有领域）
- 官方仓库：https://github.com/yt-dlp/yt-dlp

### 常用命令

```cmd
:: 默认最高画质
yt-dlp.exe "视频链接"

:: 列出所有可用清晰度
yt-dlp.exe -F "视频链接"

:: 指定格式（137=1080p视频，140=音频）
yt-dlp.exe -f "137+140" "视频链接"

:: 最佳视频+最佳音频自动合并
yt-dlp.exe -f "bv*+ba/b" "视频链接"

:: 只提取音频转 mp3
yt-dlp.exe -x --audio-format mp3 "视频链接"

:: 指定保存目录
yt-dlp.exe -P "D:\Videos" "视频链接"

:: 下载需要登录的内容（读取浏览器 Cookie）
yt-dlp.exe --cookies-from-browser chrome "视频链接"

:: 更新自身
yt-dlp.exe -U
```

### 说明

- 国内站点（B站、抖音等）**不需要代理**；YouTube 等被墙站点需要可访问的网络环境。
- 合并音视频、音频转码需要同目录下的 `ffmpeg.exe`，见下。

## ffmpeg.exe / ffprobe.exe

音视频转码与合并工具。因体积较大（约 160MB）**未放入仓库**，需本地获取：

```cmd
get-ffmpeg.bat
```

双击运行即可，会通过镜像加速自动下载并解压到当前目录。

- 授权：LGPL / GPL，官方下载：https://www.gyan.dev/ffmpeg/builds/
- yt-dlp 与 ffmpeg 放在同一目录时会自动识别，无需额外配置。

## 为什么不把 ffmpeg 提交进仓库

GitHub 单文件硬限制为 100MB，ffmpeg 的 Windows 完整版约 160MB，无法推送。同时二进制文件会让仓库体积膨胀，克隆缓慢。改用脚本按需下载更合适。
