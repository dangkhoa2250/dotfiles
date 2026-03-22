# Dotfiles

Bộ cấu hình dotfiles cho tmux, WezTerm, và Oh My Posh với support đa nền tảng (Windows/WSL/macOS).

## 📦 Mục lục

- [Cấu trúc](#-cấu-trúc)
- [Yêu cầu](#-yêu-cầu)
- [Cài đặt](#-cài-đặt)
- [Cấu hình chi tiết](#-cấu-hình-chi-tiết)
- [Key Bindings](#-key-bindings)

## 📁 Cấu trúc

```
dotfiles/
├── tmux/
│   └── .tmux.conf          # Tmux configuration
├── wezterm/
│   └── wezterm.lua         # WezTerm configuration
├── oh-my-posh/
│   ├── posh-macos.omp.json # Oh My Posh theme for macOS
│   └── posh-wsl.omp.json   # Oh My Posh theme for WSL
├── install.sh              # Installation script (macOS/WSL)
├── install.ps1             # Installation script (Windows)
└── README.md
```

## 🛠 Yêu cầu

### Tất cả nền tảng
- Git

### macOS
- Homebrew
- tmux (`brew install tmux`)
- WezTerm (`brew install --cask wezterm`)
- Oh My Posh (`brew install jandedobbeleer/oh-my-posh/oh-my-posh`)
- JetBrains Mono Nerd Font (`brew install --cask font-jetbrains-mono-nerd-font`)

### WSL (Ubuntu)
- tmux (`sudo apt install tmux`)
- WezTerm (tải từ https://wezfurlong.org/wezterm/install/linux.html)
- Oh My Posh (`curl -s https://ohmyposh.dev/install.sh | bash -s`)
- JetBrains Mono Nerd Font (tải từ https://www.nerdfonts.com/)

### Windows (PowerShell)
- WezTerm (tải từ https://wezfurlong.org/wezterm/install/windows.html)
- Oh My Posh (`winget install --id JanDeDobbeleer.OhMyPosh -e`)

## 🚀 Cài đặt

### macOS / WSL (Ubuntu)

```bash
# Clone repository
git clone https://github.com/YOUR_USERNAME/dotfiles.git
cd dotfiles

# Chạy script cài đặt
chmod +x install.sh
./install.sh
```

Sau đó chọn option **5** để cài đặt tất cả.

### Windows (PowerShell)

```powershell
# Clone repository
git clone https://github.com/YOUR_USERNAME/dotfiles.git
cd dotfiles

# Chạy script cài đặt
.\install.ps1
```

> ⚠️ **Lưu ý**: Nếu gặp lỗi khi tạo symlink, chạy PowerShell với quyền Administrator hoặc enable Developer Mode.

### Cài đặt thủ công

#### Tmux

```bash
# Symlink config
ln -sf ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf

# Install TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Reload tmux
tmux kill-server
tmux
```

#### WezTerm

```bash
# macOS
mkdir -p ~/.config/wezterm
ln -sf ~/dotfiles/wezterm/wezterm.lua ~/.config/wezterm/wezterm.lua

# WSL/Ubuntu
mkdir -p ~/.config/wezterm
ln -sf ~/dotfiles/wezterm/wezterm.lua ~/.config/wezterm/wezterm.lua

# Windows (PowerShell)
# Tự động copy khi chạy install.ps1
```

#### Oh My Posh

```bash
# macOS
oh-my-posh init zsh --config ~/dotfiles/oh-my-posh/posh-macos.omp.json >> ~/.zshrc

# WSL/Ubuntu
oh-my-posh init bash --config ~/dotfiles/oh-my-posh/posh-wsl.omp.json >> ~/.bashrc
```

## ⚙️ Cấu hình chi tiết

### Tmux

| Tính năng | Mô tả |
|-----------|-------|
| Prefix | `Ctrl+a` |
| Mouse support | Bật |
| History limit | 50000 |
| Vi mode | Bật |
| TPM | Đã tích hợp |

### WezTerm

| Tính năng | Mô tả |
|-----------|-------|
| Color scheme | Catppuccin Mocha |
| Font | JetBrainsMono Nerd Font |
| Font size | 13 |
| Opacity | 92% |
| Tab bar | Bật |

### Oh My Posh

| Segment | Mô tả |
|---------|-------|
| OS | Hiển thị icon OS + WSL indicator |
| Path | Thư mục hiện tại |
| Git | Branch, status, staging/working changes |
| Root | Indicator khi chạy bằng root |
| Exit code | Hiển thị exit code |
| Node/Go/Python/Rust/Java | Version của runtime |
| Time | Thời gian hiện tại |
| Battery | (WSL) Phần trăm pin |

## ⌨️ Key Bindings

### Tmux

| Phím | Mô tả |
|------|-------|
| `Prefix` | `Ctrl+a` |
| `Prefix |` | Split vertical |
| `Prefix -` | Split horizontal |
| `Prefix h/j/k/l` | Di chuyển giữa các panes |
| `Prefix [number]` | Chuyển đến window |
| `Prefix c` | Tạo window mới |
| `Prefix r` | Reload config |
| `Prefix z` | Zoom pane |

### WezTerm

| Phím | Mô tả |
|------|-------|
| `Leader` | `Ctrl+a` |
| `Leader \|` | Split vertical |
| `Leader -` | Split horizontal |
| `Leader h/j/k/l` | Di chuyển giữa các panes |
| `Leader [number]` | Chuyển đến tab |
| `Leader c` | Tạo tab mới |
| `Leader r` | Reload config |
| `Leader z` | Zoom pane |
| `Ctrl+Shift+C/V` | Copy/Paste (Windows) |
| `Cmd+C/V` | Copy/Paste (macOS) |

## 🎨 Themes

### Oh My Posh

- **macOS**: `posh-macos.omp.json` - Tối ưu cho macOS với hiển thị OS icon
- **WSL**: `posh-wsl.omp.json` - Tối ưu cho WSL với battery indicator

## 🔧 Troubleshooting

### Tmux

**Lỗi: "unknown option: -c"**
- Update tmux lên version mới nhất

**TPM plugins không load**
- Nhấn `Prefix + I` để install plugins

### WezTerm

**Lỗi font chữ**
- Cài đặt JetBrains Mono Nerd Font
- Restart WezTerm

**Lua error**
- Kiểm tra syntax: `wezterm cli reload`

### Oh My Posh

**Theme không hiển thị đúng**
- Kiểm tra đường dẫn config file
- Restart terminal

## 📝 License

MIT License

## 🙏 Credits

- [Tmux](https://github.com/tmux/tmux)
- [WezTerm](https://github.com/wez/wezterm)
- [Oh My Posh](https://github.com/JanDeDobbeleer/oh-my-posh)
- [Catppuccin](https://github.com/catppuccin/catppuccin)
- [JetBrains Mono](https://www.jetbrains.com/lp/mono/)
