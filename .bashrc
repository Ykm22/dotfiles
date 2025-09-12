export PATH="$PATH:~/.local/bin"

# Function to get current git branch
get_git_branch() {
  local branch=$(git branch --show-current 2>/dev/null)
  if [ -n "$branch" ]; then
    echo " (\033[1;33m$branch\033[0m)"
  fi
}

# Color codes
PURPLE='\033[1;35m'
BLUE='\033[1;34m'
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
RESET='\033[0m'

# Custom PS1 with colors and git branch
PS1="\[\033[1;34m\]\u\[\033[1;35m\]@\[\033[1;32m\]\h\[\033[0m\]:\[\033[1;34m\]\w\[\033[1;33m\]\$(git branch --show-current 2>/dev/null | sed 's/.*/(&)/')\[\033[0m\]\$ "

export WORK=~/repos/rinftech/
export HYPR_CONFIG=~/.config/hypr/hyprland.conf

alias ls='eza -l'
alias rngr='ranger'

export EDITOR=nvim
