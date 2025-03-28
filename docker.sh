#!/bin/bash
# alan - 2025-03-28
# 自动安装 Docker 和 Docker Compose
# 适用于 Debian 12 及以上

set -e  # 遇到错误立即退出

echo "=== 开始安装 Docker 和 Docker Compose ==="

# 移除旧版本 Docker（如果存在）
echo "删除旧版本 Docker..."
sudo apt remove -y docker docker-engine docker.io containerd runc || true

# 安装必要的依赖包
echo "安装依赖..."
sudo apt update
sudo apt install -y \
    ca-certificates \
    curl \
    gnupg

# 添加 Docker 官方 GPG 密钥
echo "添加 Docker GPG 密钥..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
sudo chmod a+r /etc/apt/keyrings/docker.asc

# 添加 Docker 官方软件源
echo "添加 Docker APT 源..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 更新软件包索引并安装 Docker
echo "安装 Docker..."
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 启动并启用 Docker 服务
echo "启动 Docker..."
sudo systemctl enable --now docker

# 验证 Docker 是否安装成功
if command -v docker &>/dev/null; then
    echo "✅ Docker 安装成功，版本：$(docker --version)"
else
    echo "❌ Docker 安装失败，请手动检查。"
    exit 1
fi

# 安装 Docker Compose
echo "安装 Docker Compose 最新版本..."
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep '"tag_name":' | cut -d '"' -f 4)

if [ -z "$DOCKER_COMPOSE_VERSION" ]; then
    echo "❌ 无法获取 Docker Compose 最新版本，检查网络连接或 GitHub API 限制。"
    exit 1
fi

sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# 验证 Docker Compose 是否安装成功
if command -v docker-compose &>/dev/null; then
    echo "✅ Docker Compose 安装成功，版本：$(docker-compose --version)"
else
    echo "❌ Docker Compose 安装失败，请手动检查。"
    exit 1
fi

echo "🎉 Docker 和 Docker Compose 安装完成！"
echo "运行 'docker run hello-world' 以测试 Docker 是否正常运行。"
