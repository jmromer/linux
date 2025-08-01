source ~/.local/share/omakub/defaults/bash/rc

# Editor used by CLI
export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

export PATH="$HOME/.config/emacs/bin:$PATH"

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

export PS1=$'\uf0a9 '
export PS1="\[\e]0;\w\$(git_branch)\a\]$PS1"

alias l=ls
unalias g

echo .bashrc
