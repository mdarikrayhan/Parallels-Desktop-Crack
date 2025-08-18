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

# 停止服务
stop_service() {
    log_info "正在停止服务..."
    
    # 停止并卸载LaunchDaemon
    if launchctl list | grep -q com.qiuchenly.macos.god; then
        launchctl stop com.qiuchenly.macos.god
        launchctl unload /Library/LaunchDaemons/com.qiuchenly.macos.god.plist
        log_success "服务已停止"
    else
        log_warning "服务未运行"
    fi
}

# 删除文件
remove_files() {
    log_info "正在删除文件..."
    
    # 删除可执行文件
    if [[ -f /usr/local/bin/macOSGod ]]; then
        rm -f /usr/local/bin/macOSGod
        log_success "已删除 /usr/local/bin/macOSGod"
    fi
    
    if [[ -f /usr/local/lib/CoreInject.dylib ]]; then
        rm -f /usr/local/lib/CoreInject.dylib
        log_success "已删除 /usr/local/lib/CoreInject.dylib"
    fi
    
    # 删除LaunchDaemon配置
    if [[ -f /Library/LaunchDaemons/com.qiuchenly.macos.god.plist ]]; then
        rm -f /Library/LaunchDaemons/com.qiuchenly.macos.god.plist
        log_success "已删除 /Library/LaunchDaemons/com.qiuchenly.macos.god.plist"
    fi
    
    # 删除日志文件
    if [[ -f /var/log/macos_god.log ]]; then
        rm -f /var/log/macos_god.log
        log_success "已删除 /var/log/macos_god.log"
    fi
    
    if [[ -f /var/log/macos_god_error.log ]]; then
        rm -f /var/log/macos_god_error.log
        log_success "已删除 /var/log/macos_god_error.log"
    fi
}

# 主函数
main() {
    log_info "正在卸载上帝之眼..."
    
    check_root
    stop_service
    remove_files
    
    log_success "卸载上帝之眼完成!"
}

# 运行主函数
main "$@" 