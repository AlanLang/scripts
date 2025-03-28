#!/bin/bash
# alan - 2025-03-28
# use in debian 12

set -e  # 遇到错误立即退出

echo "=== 开始安装环境 ==="

# 更新 apt 并安装必要的软件（不再安装 Neovim）
echo "更新 apt 并安装 Git、Zsh、Tmux、Stow..."
sudo apt update && sudo apt install -y git zsh tmux stow curl

# 检查 Git 是否安装成功
if ! command -v git &>/dev/null; then
    echo "Git 安装失败，请检查网络连接或手动安装 Git。"
    exit 1
fi
echo "Git 版本：$(git --version)"

# 下载并安装 Neovim 二进制文件
echo "安装最新版本的 Neovim..."
LATEST_NVIM="https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz"

if [ -z "$LATEST_NVIM" ]; then
    echo "无法获取最新 Neovim 版本，检查网络或 GitHub API 限制。"
    exit 1
fi

echo "从 $LATEST_NVIM 下载 Neovim..."
curl -L "$LATEST_NVIM" -o nvim-linux64.tar.gz
tar xzf nvim-linux64.tar.gz
sudo mv nvim-linux-x86_64 /usr/local/nvim

# 创建 Neovim 软链接到全局路径
sudo ln -sf /usr/local/nvim/bin/nvim /usr/local/bin/nvim
rm -f nvim-linux64.tar.gz  # 清理安装包
echo "Neovim 安装成功，版本：$(nvim --version | head -n 1)"

# 安装 oh-my-zsh（非交互模式）
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "安装 oh-my-zsh..."
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "oh-my-zsh 已安装，跳过安装。"
fi

# 安装 oh-my-zsh 插件
echo "安装 oh-my-zsh 插件..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
mkdir -p "$ZSH_CUSTOM/plugins"

PLUGINS=(
    "zsh-users/zsh-autosuggestions"
    "zsh-users/zsh-syntax-highlighting"
)
for plugin in "${PLUGINS[@]}"; do
    PLUGIN_DIR="$ZSH_CUSTOM/plugins/$(basename $plugin)"
    if [ ! -d "$PLUGIN_DIR" ]; then
        git clone "https://github.com/$plugin.git" "$PLUGIN_DIR"
    else
        echo "$(basename $plugin) 已存在，跳过克隆。"
    fi
done

# 安装 powerlevel10k 主题
THEME_DIR="$ZSH_CUSTOM/themes/powerlevel10k"
if [ ! -d "$THEME_DIR" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$THEME_DIR"
else
    echo "powerlevel10k 已存在，跳过克隆。"
fi

# 克隆 dotfiles 仓库
DOTFILES_DIR="$HOME/dotfiles"
if [ -d "$DOTFILES_DIR/.git" ]; then
    echo "dotfiles 仓库已存在，跳过克隆。"
else
    echo "克隆 dotfiles..."
    rm -rf "$DOTFILES_DIR"
    git clone https://github.com/AlanLang/dotfile.git "$DOTFILES_DIR"
fi

# 解决 stow 冲突：删除已有文件
echo "清理可能存在的旧配置..."
rm -f ~/.zshrc ~/.tmux.conf ~/.config/nvim ~/.config/git

# 软链接配置文件（强制覆盖）
echo "应用 dotfiles 配置..."
cd "$DOTFILES_DIR"
stow -R git tmux zsh nvim

# 提示用户手动切换 shell
echo "=== 安装完成 ==="
echo "请手动将 zsh 设为默认 shell，运行以下命令："
echo "chsh -s $(command -v zsh) $USER"
echo "然后重新登录终端即可生效。"
