#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")" || exit 1

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${BLUE}[*] $1${NC}"
}

log_success() {
    echo -e "${GREEN}[+] $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}[!] $1${NC}"
}

log_error() {
    echo -e "${RED}[×] $1${NC}"
}

# 检查是否以root权限运行
check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "必须以root权限运行"
        exit 1
    fi
}

qiuchenly=../tool/CoreInject.dylib

# 安装文件
install_files() {
    log_info "正在安装文件..."

    xattr -cr ./macOSGod
    xattr -cr $qiuchenly
    codesign -fs - --all-architectures --deep $qiuchenly
    
    # 复制可执行文件
    cp ./macOSGod /usr/local/bin/
    cp $qiuchenly /usr/local/lib/
    chmod +x /usr/local/bin/macOSGod
 
    # 复制LaunchDaemon配置
    cp com.qiuchenly.macos.god.plist /Library/LaunchDaemons/
    chmod 644 /Library/LaunchDaemons/com.qiuchenly.macos.god.plist
    
    # 创建日志文件
    touch /var/log/macos_god.log
    touch /var/log/macos_god_error.log
    chmod 644 /var/log/macos_god.log
    chmod 644 /var/log/macos_god_error.log
    
    log_success "文件安装成功"
}

# 启动服务
start_service() {
    log_info "正在启动服务..."
    
    # 加载LaunchDaemon
    launchctl load /Library/LaunchDaemons/com.qiuchenly.macos.god.plist
    
    # 启动服务
    launchctl start com.qiuchenly.macos.god
    
    log_success "服务启动成功"
}

# 显示状态
show_status() {
    log_info "服务状态:"
    
    if launchctl list | grep -q com.qiuchenly.macos.god; then
        log_success "服务正在运行"
    else
        log_warning "服务未运行"
    fi
    
    echo ""
    log_info "查看日志:"
    echo "  tail -f /var/log/macos_god*.log"

    echo ""
    log_info "停止服务:"
    echo "  sudo launchctl unload /Library/LaunchDaemons/com.qiuchenly.macos.god.plist"
    
    echo ""
    log_info "重启服务:"
    echo "  sudo launchctl unload /Library/LaunchDaemons/com.qiuchenly.macos.god.plist"
    echo "  sudo launchctl load /Library/LaunchDaemons/com.qiuchenly.macos.god.plist"
}

# 主函数
main() {
    log_info "正在安装上帝之眼..."
    
    check_root
    install_files
    start_service
    show_status
    
    log_success "安装上帝之眼完成!"
}

# 运行主函数
main "$@" 