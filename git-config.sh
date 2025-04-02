#!/bin/bash
# alan - 2025-03-28
# 自动配置 git 和 ssh
# 适用于 Debian 12 及以上

set -e  # 遇到错误立即退出
set -u  # 使用未定义变量时退出

echo "=== Git 配置开始 ==="

# 配置 Git 用户名和邮箱
GIT_NAME="alan"
GIT_EMAIL="langwdalan@gmail.com"

git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"

echo "已设置 Git 用户名为：$GIT_NAME"
echo "已设置 Git 邮箱为：$GIT_EMAIL"

echo "=== SSH 配置开始 ==="

SSH_KEY_PATH="$HOME/.ssh/id_rsa"

# 检查是否为交互式终端
if [ ! -t 0 ]; then
  echo "错误：当前不支持交互式输入，请在终端中运行脚本"
  exit 1
fi

# 检查 SSH 密钥是否已存在
if [ -f "$SSH_KEY_PATH" ]; then
  echo "SSH 密钥已存在，跳过生成"
else
  echo -n "请输入 SSH 密钥的注释信息 (例如: your.email@example.com): "
  read ssh_comment

  if [ -z "$ssh_comment" ]; then
    echo "错误：注释信息不能为空"
    exit 1
  fi

  mkdir -p ~/.ssh
  chmod 700 ~/.ssh

  ssh-keygen -t rsa -C "$ssh_comment" -f "$SSH_KEY_PATH" -N ""
  echo "SSH 密钥生成成功：$SSH_KEY_PATH"
fi

# 显示公钥内容
echo "=== 公钥如下，请将其添加到 Git 服务平台（如 GitHub、GitLab） ==="
cat "${SSH_KEY_PATH}.pub"
echo "=== Git 和 SSH 配置完成 ==="
