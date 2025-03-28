#!/bin/bash
# alan - 2025-03-28
# 自动安装 Yazi（文件管理器）
# 适用于 Debian 12 及以上

set -e  # 遇到错误立即退出

echo "=== 开始安装 Yazi ==="

# 确保系统有 unzip 和 curl
echo "安装必要工具 unzip 和 curl..."
sudo apt update && sudo apt install -y unzip curl

# Yazi 下载地址
YAZI_URL="https://github.com/sxyazi/yazi/releases/download/nightly/yazi-x86_64-unknown-linux-musl.zip"
YAZI_ZIP="yazi.zip"

# 下载 Yazi
echo "下载 Yazi..."
curl -L "$YAZI_URL" -o "$YAZI_ZIP"

# 解压 Yazi
echo "解压 Yazi..."
unzip -o "$YAZI_ZIP"

# 移动 Yazi 到全局路径
echo "移动 Yazi 到 /usr/local/bin..."
sudo mv yazi-x86_64-unknown-linux-musl/yazi /usr/local/bin/yazi
sudo chmod +x /usr/local/bin/yazi

# 删除下载的 zip 文件
rm -f "$YAZI_ZIP"

# 检查安装是否成功
if command -v yazi &>/dev/null; then
    echo "✅ Yazi 安装成功！"
    echo "运行 'yazi' 以启动文件管理器 🚀"
else
    echo "❌ 安装失败，请手动检查问题。"
    exit 1
fi
