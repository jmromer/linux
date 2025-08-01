# Lines configured by zsh-newuser-install
HISTFILE=~/.state/zsh/histfile
HISTSIZE=1000
SAVEHIST=1000
setopt notify
unsetopt autocd
bindkey -e

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/jmromer/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall


# Editor used by CLI
export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"


eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
export PATH="$HOME/.config/emacs/bin:$PATH"
export PATH="./bin:$HOME/.local/bin:$PATH"

alias l=ls
alias ls='eza -lh --group-directories-first --icons=auto'
alias lsa='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias ff="fzf --preview 'batcat --style=numbers --color=always {}'"
alias fd='fdfind'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias n='nvim'


git_branch() {
  local git_status
  local is_on_branch
  local is_on_commit
  local is_rebasing

  git_status="$(\git status 2>/dev/null)"
  is_on_branch='^On branch ([^[:space:]]+)'
  is_on_commit='HEAD detached at ([^[:space:]]+)'
  is_rebasing="rebasing branch '([^[:space:]]+)' on '([^[:space:]]+)'"

  if [[ $git_status =~ $is_on_branch ]]; then
    local branch=${BASH_REMATCH[1]:-${match[1]}} # bash/zsh portable
    if [[ $git_status =~ "Unmerged paths" ]]; then
      printf " (merging into $branch) "
    else
      printf " ($branch) "
    fi
  elif [[ $git_status =~ $is_on_commit ]]; then
    local commit=${BASH_REMATCH[1]:-${match[1]}}
    printf " ($commit) "
  elif [[ $git_status =~ $is_rebasing ]]; then
    local branch=${BASH_REMATCH[1]:-${match[1]}}
    local commit=${BASH_REMATCH[2]:-${match[2]}}
    printf " (rebasing $branch on $commit) "
  fi
}

# Set the prompt with Unicode character
PROMPT=$'\uf0a9 '

# Function to update terminal title dynamically
function set_title() {
  print -Pn "\e]0;%~$(git_branch)\a"
}

# Hook the title update to run before each prompt
precmd_functions+=(set_title)

if command -v fzf &> /dev/null; then
  if [[ -f /usr/share/bash-completion/completions/fzf ]]; then
    source /usr/share/bash-completion/completions/fzf
  fi
  if [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
  fi
fi
