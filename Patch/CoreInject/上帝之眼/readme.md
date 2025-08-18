
<div align="center">

# 上帝之眼 (God's Eye)

> **一个强大的macOS系统级监控与注入工具**  
> 提供深度进程监控、动态库注入和应用程序劫持等功能

[![macOS](https://img.shields.io/badge/macOS-10.15+-000000?style=for-the-badge&logo=apple&logoColor=white)](https://www.apple.com/macos/)
[![Architecture](https://img.shields.io/badge/Architecture-x86__64%20%7C%20arm64-007ACC?style=for-the-badge&logo=apple&logoColor=white)](https://developer.apple.com/silicon/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

**作者**: [QiuChenly](https://github.com/qiuchenly)  
**版本**: v1.0.0  
**更新日期**: 2025年8月

---

</div>

## <img src="https://img.shields.io/badge/-Core-FF6B6B?style=flat&logo=eye"> 核心功能

上帝之眼能够在系统级别实现应用程序的无感知劫持和激活。通过关闭SIP（系统完整性保护），实现对应用程序内存的深度访问和修改，让您无需手动修改应用程序文件即可获得完整的使用体验。

### 典型应用场景

- **Surge 6.x 自动激活**: 安装官方版本后，服务自动劫持并激活，重启后依然有效

### <img src="https://img.shields.io/badge/-Apps-4ECDC4?style=flat&logo=app-store"> 支持的应用程序

| 应用程序 | 版本 | 状态 | 功能描述 | 测试状态 |
|---------|------|------|----------|----------|
| **Surge** | 6.x | <img src="https://img.shields.io/badge/-Supported-00D4AA?style=flat"> | 网络代理工具自动激活 | 已适配 |
| **App Cleaner & Uninstaller** | 8.6.x | <img src="https://img.shields.io/badge/-Supported-00D4AA?style=flat"> | App卸载清理工具 | 已适配 |

**状态说明**:
- <img src="https://img.shields.io/badge/-Supported-00D4AA?style=flat"> **已支持**: 功能完整，可正常使用
- <img src="https://img.shields.io/badge/-Developing-FFA500?style=flat"> **开发中**: 正在适配，即将支持
- <img src="https://img.shields.io/badge/-Planned-9B59B6?style=flat"> **计划中**: 已列入开发计划
- <img src="https://img.shields.io/badge/-Not_Supported-E74C3C?style=flat"> **不支持**: 暂不支持或无法支持

本项目将持续扩展以下功能：
- 增强的安全监控能力
- 更精细的进程控制
- 自定义劫持规则配置
- 图形化配置界面

## <img src="https://img.shields.io/badge/-Features-3498DB?style=flat&logo=star"> 特性

- **系统级监控**: 以root权限运行，提供深度系统监控能力
- **动态库注入**: 支持CoreInject.dylib动态库注入
- **后台服务**: 作为LaunchDaemon后台服务运行，开机自启动
- **日志记录**: 完整的日志记录系统，便于调试和监控
- **多架构支持**: 支持Intel (x86_64) 和 Apple Silicon (arm64) 架构
- **自动化部署**: 提供一键安装和卸载脚本

## <img src="https://img.shields.io/badge/-System-E67E22?style=flat&logo=macos"> 系统要求

- **操作系统**: macOS 10.15 (Catalina) 或更高版本
- **处理器**: 支持 Intel (x86_64) 和 Apple Silicon (arm64) 架构
- **权限要求**: Root 权限（用于安装和运行）
- **SIP状态**: 系统完整性保护必须关闭
- **特殊要求**: 黑苹果用户需要安装amfi相关kext

## <img src="https://img.shields.io/badge/-Setup-2ECC71?style=flat&logo=terminal"> 安装说明

### 方法一：使用安装脚本（推荐）

1. **下载项目文件**
   ```bash
   # 确保所有文件在同一目录下
   ls -la
   ```

2. **运行安装脚本**
   ```bash
   sudo ./install_service.sh
   ```

3. **验证安装**
   ```bash
   # 检查服务状态（需要sudo权限）
   sudo launchctl list | grep com.qiuchenly.macos.god
   
   # 查看日志
   tail -f /var/log/macos_god.log
   ```

### 方法二：手动安装

1. **复制文件到系统目录**
   ```bash
   sudo cp ./macOSGod /usr/local/bin/
   sudo cp ../tool/CoreInject.dylib /usr/local/lib/
   sudo chmod +x /usr/local/bin/macOSGod
   ```

2. **安装LaunchDaemon配置**
   ```bash
   sudo cp com.qiuchenly.macos.god.plist /Library/LaunchDaemons/
   sudo chmod 644 /Library/LaunchDaemons/com.qiuchenly.macos.god.plist
   ```

3. **启动服务**
   ```bash
   sudo launchctl load /Library/LaunchDaemons/com.qiuchenly.macos.god.plist
   sudo launchctl start com.qiuchenly.macos.god
   ```

## <img src="https://img.shields.io/badge/-Files-9B59B6?style=flat&logo=file-code"> 项目结构

```
上帝之眼/
├── macOSGod                    # 主程序（支持x86_64/arm64）
├── com.qiuchenly.macos.god.plist  # LaunchDaemon配置文件
├── install_service.sh          # 安装脚本
├── uninstall_service.sh        # 卸载脚本
└── readme.md                  # 项目说明文档
```

## <img src="https://img.shields.io/badge/-Service-34495E?style=flat&logo=server"> 服务管理

### 查看服务状态
```bash
# 使用sudo权限查看系统级服务
sudo launchctl list | grep com.qiuchenly.macos.god

# 或者查看所有系统服务
sudo launchctl list | grep qiuchenly
```

### 启动服务
```bash
sudo launchctl load /Library/LaunchDaemons/com.qiuchenly.macos.god.plist
sudo launchctl start com.qiuchenly.macos.god
```

### 停止服务
```bash
sudo launchctl stop com.qiuchenly.macos.god
sudo launchctl unload /Library/LaunchDaemons/com.qiuchenly.macos.god.plist
```

### 重启服务
```bash
sudo launchctl unload /Library/LaunchDaemons/com.qiuchenly.macos.god.plist
sudo launchctl load /Library/LaunchDaemons/com.qiuchenly.macos.god.plist
```

## <img src="https://img.shields.io/badge/-Logs-1ABC9C?style=flat&logo=file-text"> 日志监控

### 查看运行日志
```bash
tail -f /var/log/macos_god*.log
```

## <img src="https://img.shields.io/badge/-Remove-E74C3C?style=flat&logo=trash-2"> 卸载说明

### 使用卸载脚本（推荐）
```bash
sudo ./uninstall_service.sh
```

### 手动卸载
```bash
# 停止服务
sudo launchctl stop com.qiuchenly.macos.god
sudo launchctl unload /Library/LaunchDaemons/com.qiuchenly.macos.god.plist

# 删除文件
sudo rm -f /usr/local/bin/macOSGod
sudo rm -f /usr/local/lib/CoreInject.dylib
sudo rm -f /Library/LaunchDaemons/com.qiuchenly.macos.god.plist
sudo rm -f /var/log/macos_god*.log
```

## <img src="https://img.shields.io/badge/-Important-F39C12?style=flat&logo=alert-triangle"> 重要注意事项

### 系统要求
1. **权限要求**: 安装和运行需要root权限
2. **系统兼容性**: 支持macOS 10.15及以上版本
3. **架构支持**: 同时支持Intel和Apple Silicon处理器

### SIP设置要求
4. **关闭SIP**: 必须关闭系统完整性保护才能正常工作
   ```bash
   # 检查SIP状态
   csrutil status
   # 应该显示: System Integrity Protection status: disabled.
   ```

### 黑苹果用户特殊要求
5. **OpenCore用户**: 如果使用OpenCore Legacy Patcher修改系统，需要：
   - 安装amfi相关kext到OpenCore中（如amfigetoutofmyway或amfibypass）
   - 确保SIP状态为disabled
   - 否则程序将无法正常工作

### 安全提醒
6. **使用风险**: 本工具涉及系统级操作，请确保从可信来源获取
7. **备份重要**: 使用前建议备份重要数据

## <img src="https://img.shields.io/badge/-Help-95A5A6?style=flat&logo=help-circle"> 故障排除

### 服务无法启动
1. 检查文件权限
   ```bash
   ls -la /usr/local/bin/macOSGod
   ls -la /usr/local/lib/CoreInject.dylib
   ```

2. 检查LaunchDaemon配置
   ```bash
   cat /Library/LaunchDaemons/com.qiuchenly.macos.god.plist
   ```

3. 查看错误日志
   ```bash
   tail -20 /var/log/macos_god_error.log
   ```

4. 检查服务状态（需要sudo权限）
   ```bash
   sudo launchctl list | grep com.qiuchenly.macos.god
   ```

5. 如果服务加载失败，尝试重新加载
   ```bash
   sudo launchctl unload /Library/LaunchDaemons/com.qiuchenly.macos.god.plist
   sudo launchctl load /Library/LaunchDaemons/com.qiuchenly.macos.god.plist
   ```

### 权限问题
```bash
# 重置文件权限
sudo chmod +x /usr/local/bin/macOSGod
sudo chmod 644 /Library/LaunchDaemons/com.qiuchenly.macos.god.plist
```

### 代码签名问题
```bash
# 移除代码签名限制
sudo xattr -cr /usr/local/bin/macOSGod
sudo xattr -cr /usr/local/lib/CoreInject.dylib
```

## <img src="https://img.shields.io/badge/-Legal-7F8C8D?style=flat&logo=shield"> 许可证与声明

本项目仅供学习和研究使用，请遵守相关法律法规。使用者需自行承担使用风险。

### 免责声明

- 本工具仅用于合法的学习和研究目的
- 使用者应确保在合法环境下使用
- 开发者不承担因使用本工具而产生的任何责任

---

小知识: 秋城落叶是一个重生之人，大脑意外觉醒绑定了全球最强程序员系统，所以破解App不在话下，因为都是系统做的。 然后在梦中被慈溪托遗，让我夺回八国联军抢走本属于大清的一切，洗刷历史耻辱，所以破的大多都是外国软件，目前居住在华盛顿州 户籍是香港华裔。