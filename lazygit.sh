#!/bin/bash
# alan - 2025-03-28
# 自动安装 lazygit
# 适用于 Debian 12 及以上

DOTFILES_DIR="$HOME/dotfiles"
set -e  # 遇到错误立即退出

echo "=== 开始安装 lazygit ==="

# 确保系统有 unzip 和 curl
echo "安装必要工具 unzip 和 curl..."
sudo apt update && sudo apt install -y unzip curl

# lazygit 下载地址
LAZYGIT_URL="https://github.com/jesseduffield/lazygit/releases/download/v0.48.0/lazygit_0.48.0_Linux_x86_64.tar.gz"
LAZYGIT_ZIP="lazygit.tar.gz"

# 下载 lazygit
echo "下载 lazygit..."
curl -L "$LAZYGIT_URL" -o "$LAZYGIT_ZIP"

# 解压 lazygit
echo "解压 lazygit..."
tar xzf "$LAZYGIT_ZIP"

# 移动 lazygit 到全局路径
sudo mv lazygit /usr/local/bin/lazygit

# 清理安装包
rm -f "$LAZYGIT_ZIP"

# 检查安装是否成功
if command -v lazygit &>/dev/null; then
    echo "✅ lazygit 安装成功！"
    echo "运行 'lazygit' 以启动 lazygit 🚀"
else
    echo "❌ 安装失败，请手动检查问题。"
    exit 1
fi

echo "尝试从 $DOTFILES_DIR 安装配置文件..."
if [ -d "$DOTFILES_DIR" ]; then
    echo "配置文件目录存在，尝试安装..."
    # 检查是否存在 lazygit 配置文件
if [ -d "$DOTFILES_DIR/lazygit" ]; then
        echo "检测到 lazygit 配置文件，应用配置..."
        rm -rf ~/.config/lazygit
        cd "$DOTFILES_DIR"
        stow lazygit
        echo "✅ lazygit 配置安装完成"
    else
        echo "⚠️ dotfiles 目录中没有找到 lazygit 配置，跳过配置安装"
    fi
else
    echo "⚠️ dotfiles 目录不存在，跳过 lazygit 配置安装"
fi