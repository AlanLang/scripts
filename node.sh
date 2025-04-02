#!/bin/bash
# alan - 2025-03-28
# 自动安装 Node.js 环境（适用于 Debian 12）

set -e  # 遇到错误立即退出

echo "=== 开始安装 Node.js 环境 ==="

# 安装 curl（如未安装）
echo "检查并安装 curl..."
sudo apt update && sudo apt install -y curl

# 添加 Node.js 官方 LTS 版本的安装源
echo "添加 NodeSource 官方源（LTS）..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -

# 安装 Node.js 和 npm
echo "安装 Node.js 和 npm..."
sudo apt install -y nodejs

# 验证安装
echo "验证 Node.js 安装..."
if command -v node &>/dev/null; then
    echo "✅ Node.js 安装成功，版本：$(node -v)"
else
    echo "❌ Node.js 安装失败"
    exit 1
fi

echo "验证 npm 安装..."
if command -v npm &>/dev/null; then
    echo "✅ npm 安装成功，版本：$(npm -v)"
else
    echo "❌ npm 安装失败"
    exit 1
fi

echo "🎉 Node.js 环境安装完成！你可以开始使用 Node 和 npm 了。"
