# zRam 调度模块
[![License](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![GitHub release](https://img.shields.io/github/v/release/bao-ku/swappiness_webui)](https://github.com/bao-ku/swappiness_webui/releases)
[![KernelSU](https://img.shields.io/badge/KernelSU-Support-green)](https://kernelsu.org/)

一个强大的内核参数 swappiness 调节器，提供直观的 WebUI 界面，让您能精细地控制内存回收策略，优化 zRAM 使用效率，平衡后台保活与前台应用性能。

![WebUI 预览](https://github.com/bao-ku/swappiness_webui/blob/main/assets/preview.png.png?raw=true)

✨ 功能特点

· 直观的 WebUI 控制：通过简洁的滑块，轻松调节 swappiness 值（范围 1-200）。
· 双模式生效：
  · 临时生效：立即测试不同值对系统的影响，重启后失效。
  · 保存永久：将设定值写入配置文件，每次开机自动应用。
· 实时状态显示：在模块卡片和 WebUI 界面中，实时显示当前系统的运行值。
· 轻量高效：基于 Shell 脚本，不常驻内存，仅在设置和开机时执行任务。
· 自动更新：支持通过 GitHub Releases 检查并自动更新模块。

🧠 核心原理：Swappiness 与 zRAM

· swappiness：这是一个内核参数，控制系统在回收内存时，是倾向于压缩匿名内存（如后台应用数据）到 zRAM，还是倾向于清理文件缓存（如已加载的资源）。值越高（最大 200），系统越“积极”地使用 zRAM 来压缩数据，从而为前台应用腾出更多物理内存。
· zRAM：它利用物理内存的一部分，创建出一个高速的“压缩块设备”。将不活跃的内存页压缩后存入 zRAM，能有效增加内存的“等效容量”。

本模块让您能自由调整这个“积极性”，找到最适合您使用习惯的平衡点。

⚙️ 兼容性

· 本模块不局限于 KernelSU，理论上任何获取了 root 权限并启用了 zRAM 的 Android 系统均可使用。
· 通过在 KernelSU、Magisk 或 APatch 中刷入即可。

🚀 快速开始：与 Action-Build 自编译内核配合使用

本模块特别适合配合使用通过 Numbersf/Action-Build 项目自编译的内核，以获得最佳的内存性能体验。

推荐工作流

1. **Fork 并自编译内核**：
    *   访问 [**Numbersf/Action-Build 项目 (KernelSU 分支)**](https://github.com/Numbersf/Action-Build/tree/KernelSU)，按照说明 Fork 仓库并配置 GitHub Actions。
   · 在构建工作流中，您可以灵活地配置 zRAM 参数，例如：
     · ZRAM=1 (启用 zRAM)
     · ZRAM_ALGORITHM=lz4 或 lz4kd (推荐使用 lz4 系列快速算法)
     · ZRAM_SIZE=8589934592 (设置 zRAM 大小为 8GB，根据您的设备内存调整)
   · 等待 Actions 构建完成，刷入您专属的、已启用 zRAM 的内核。
2. 刷入本模块：
   · 在您刷入自编译内核并重启后，从 Releases 页面下载最新版本的 swappiness_webui.zip。
   · 在 KernelSU / Magisk / APatch 管理器中刷入此模块。
3. 开始调校：
   · 重启后，在模块管理页面点击本模块的“WebUI”图标，即可通过滑块自由调整 swappiness 值，探索 zRAM 给您设备带来的性能提升。

📥 安装方法

1. 从 Releases 页面下载最新版本的模块 ZIP 文件。
2. 在您的 KernelSU、Magisk 或 APatch 管理器中，选择“从本地安装”，并找到下载的 ZIP 文件。
3. 确认安装并重启手机。

🛠️ 使用方法

1. 重启后，打开 KernelSU (或 Magisk) 管理器，找到本模块。
2. 点击模块卡片上的 “WebUI” 图标（通常是一个类似窗口的按钮），打开控制面板。
3. 界面操作：
   · 屏幕上方会显示系统当前的 swappiness 值。
   · 滑动滑块选择您想要设置的数值 (1-200)。
   · 点击 “临时生效”：立即应用当前滑块值，但不保存，重启后失效。
   · 点击 “永久生效”：立即应用当前滑块值，并将其保存到配置文件中，确保每次开机后自动应用。
4. 修改后，您可以回到模块列表页面，会看到模块描述已更新为 ... [当前:您设置的值]。

🔄 手动更新

当有新版发布时，KernelSU 管理器通常会提示更新。您也可以：

1. 前往 Releases 页面下载最新 ZIP。
2. 在管理器中直接安装新版本（无需卸载旧版），重启即可。

🤝 贡献与反馈

如果您在使用过程中遇到任何问题，或有好的建议，欢迎在 Issues 页面提出。

如果您是开发者，欢迎fork后自行开发
