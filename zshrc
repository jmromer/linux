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

alias ..='\cd ..; l'     # go to parent dir and list contents
alias ...='\cd ../..; l' # go to grandparent dir and list contents
alias mkdir='mkdir -p'   # create subdirectories as necessary
alias h='history'        # show history
alias dirs='dirs -v'     # show directory stack
alias ls='eza --group-directories-first --time-style=long-iso --classify'
alias l='ls'
alias la='ls -a'
alias ld='ls -d .*'
alias ll='ls -l'
alias lla='ls -al'
alias lld='ls -al -d .*'
alias lt='eza --tree --level=3'

alias fd='fdfind'

alias pp='pretty-print-path'
alias b=bundle
alias vi='vim -U $XDG_CONFIG_HOME/vim/vimrc.minimal.vim'
alias vin='\vim -U NONE'
alias vim=nvim

#-------------------------------------------------------------
# ALIASES: Postfix
#-------------------------------------------------------------
alias -g G='| grep --line-number --context=1' # grep w/ context
alias -g C="| pbcopy" # copy to clipboard
alias -g P='| less'   # send to pager

#-------------------------------------------------------------
# EDITOR / PAGER
#-------------------------------------------------------------
export EDITOR="vim"
export PAGER="less"
export LESSOPEN="| src-hilite-lesspipe.sh %s"
export LESS=' --no-init --RAW-CONTROL-CHARS --quit-if-one-screen '


#-------------------------------------------------------------
# COLORS
#-------------------------------------------------------------
autoload -U colors && colors

color() {
    # shellcheck disable=SC2154
    [[ $1 == 'red'    ]] && printf "%s" "%{${fg_no_bold[red]}%}"
    [[ $1 == 'yellow' ]] && printf "%s" "%{${fg_no_bold[yellow]}%}"
    [[ $1 == 'green'  ]] && printf "%s" "%{${fg_no_bold[green]}%}"
    [[ $1 == 'violet' ]] && printf "%s" "%{${fg_no_bold[magenta]}%}"
    [[ $1 == 'blue'   ]] && printf "%s" "%{${fg_no_bold[blue]}%}"
    [[ $1 == 'white'  ]] && printf "%s" "%{${fg_no_bold[white]}%}"
    # shellcheck disable=SC2154
    [[ $1 == 'reset'  ]] && printf "%s" "%{${reset_color}%}"
}

#-------------------------------------------------------------
# COLORIZED GIT PROMPT
#-------------------------------------------------------------
git_color() {
  case "${git_status}" in
    *'not staged'* |\
      *'to be committed'* |\
      *'untracked files present'* |\
      *'no rastreados'* |\
      *'archivos sin seguimiento'* |\
      *'a ser confirmados'*)
      echo -ne "$(color red)"
      ;;
    *'branch is ahead of'* |\
      *'have diverged'* |\
      *'rama está adelantada'* |\
      *'rama está detrás de'* |\
      *'han divergido'*)
      echo -ne "$(color yellow)"
      ;;
    *working\ *\ clean* |\
      *'está limpio'*)
      echo -ne "$(color green)"
      ;;
    *'Unmerged'* |\
      *'no fusionadas'* |\
      *'rebase interactivo en progreso'*)
      echo -ne "$(color violet)"
      ;;
    *)
      echo -ne "$(color white)"
      ;;
  esac
}

git_branch() {
  git_status="$(\git status 2> /dev/null)"
  local is_on_branch='^(On branch|En la rama) ([^[:space:]]+)'
  local is_on_commit='HEAD (detached at|desacoplada en) ([^[:space:]]+)'
  local is_rebasing="(rebasing branch|rebase de la rama) '([^[:space:]]+)' (on|sobre) '([^[:space:]]+)'"
  local branch
  local commit

  if [[ ${git_status} =~ ${is_on_branch} ]]; then
    branch=${BASH_REMATCH[2]:-${match[2]}} # bash/zsh portable
    if [[ ${git_status} =~ (Unmerged paths|no fusionadas) ]]; then
      git_color && echo -n "merging into ${branch} "
    else
      git_color && echo -n "${branch} "
    fi
  elif [[ ${git_status} =~ ${is_on_commit} ]]; then
    commit=${BASH_REMATCH[2]:-${match[2]}}
    git_color && echo -n "${commit} "
  elif [[ ${git_status} =~ ${is_rebasing} ]]; then
    branch=${BASH_REMATCH[2]:-${match[2]}}
    commit=${BASH_REMATCH[4]:-${match[4]}}
    git_color && echo -n "rebasing ${branch} onto ${commit} "
  fi
}

# VCS_STATUS_COMMIT=c000eddcff0fb38df2d0137efe24d9d2d900f209
# VCS_STATUS_COMMITS_AHEAD=0
# VCS_STATUS_COMMITS_BEHIND=0
# VCS_STATUS_HAS_CONFLICTED=0
# VCS_STATUS_HAS_STAGED=0
# VCS_STATUS_HAS_UNSTAGED=1
# VCS_STATUS_HAS_UNTRACKED=1
# VCS_STATUS_NUM_ASSUME_UNCHANGED=0
# VCS_STATUS_NUM_CONFLICTED=0
# VCS_STATUS_NUM_STAGED=0
# VCS_STATUS_NUM_UNSTAGED=1
# VCS_STATUS_NUM_SKIP_WORKTREE=0
# VCS_STATUS_NUM_STAGED_NEW=0
# VCS_STATUS_NUM_STAGED_DELETED=0
# VCS_STATUS_NUM_UNSTAGED_DELETED=0
# VCS_STATUS_NUM_UNTRACKED=1
# VCS_STATUS_PUSH_COMMITS_AHEAD=0
# VCS_STATUS_PUSH_COMMITS_BEHIND=0
# VCS_STATUS_COMMIT_SUMMARY
gitstatus_prompt() {
  PROMPT=$''
  PROMPT+="$(color blue)%c$(color reset) "

  if gitstatus_query MY && [[ ${VCS_STATUS_RESULT} == ok-sync ]]; then
    if (( VCS_STATUS_HAS_CONFLICTED )); then
      PROMPT+="$(color violet)"
    elif (( VCS_STATUS_HAS_STAGED )) ||
         (( VCS_STATUS_HAS_UNSTAGED )) ||
         (( VCS_STATUS_HAS_UNTRACKED ));
    then
      PROMPT+="$(color red)"
    elif (( VCS_STATUS_COMMITS_AHEAD )) ||
         (( VCS_STATUS_COMMITS_BEHIND )) ||
         (( VCS_STATUS_PUSH_COMMITS_AHEAD )) ||
         (( VCS_STATUS_PUSH_COMMITS_BEHIND ));
    then
      PROMPT+="$(color yellow)"
    else
      PROMPT+="$(color green)"
    fi
    local hash="${VCS_STATUS_COMMIT:0:10}"
    local branch="${VCS_STATUS_LOCAL_BRANCH:-@${hash}}"
    PROMPT+="${branch//\%/%%} "  # escape %
  fi

  PROMPT+="$(color reset)%# "
  setopt no_prompt_{bang,subst} prompt_percent  # enable/disable correct prompt expansions
}

#-------------------------------------------------------------
# Omakub prompt, zellij title
#-------------------------------------------------------------
# # Set the prompt with Unicode character
# PROMPT=$'\uf0a9 '

#-------------------------------------------------------------
# PROMPT WITH SHORT PWD, COLORIZED GIT INFO
#-------------------------------------------------------------
setopt prompt_subst       # enables command substitution

if [[ -f "${HOMEBREW_PREFIX}/opt/gitstatus/gitstatus.plugin.zsh" ]]; then
    source "${HOMEBREW_PREFIX}/opt/gitstatus/gitstatus.plugin.zsh"
    gitstatus_stop 'MY' && gitstatus_start -s -1 -u -1 -c -1 -d -1 'MY'
    autoload -Uz add-zsh-hook
    add-zsh-hook precmd gitstatus_prompt
else
  PS1=$'$(color blue)%c$(color reset) ' # basename of pwd after a newline
  PS1+='$(git_branch)'      # current branch or commit name, with color
  PS1+='$(color reset)%# '  # reset color, add %
  export PS1
fi

#-------------------------------------------------------------
# Set terminal title dynamically (zellij displays in ribbon)
#-------------------------------------------------------------
function set_title() {
  print -Pn "\e]0;%~$(git_branch)\a"
}

# Hook the title update to run before each prompt
precmd_functions+=(set_title)

#-------------------------------------------------------------
# COMMAND COMPLETION
#-------------------------------------------------------------
# shellcheck disable=SC2206
fpath=(
  ${BREW_PREFIX}/share/zsh/site-functions
  ${BREW_PREFIX}/share/zsh-completions
#  ${ZDOTDIR}/completions
  ${fpath}
)

autoload -Uz compinit
compinit

compdef g=git
setopt complete_aliases


if command -v fzf &> /dev/null; then
  if [[ -f /usr/share/bash-completion/completions/fzf ]]; then
    source /usr/share/bash-completion/completions/fzf
  fi
  if [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
  fi
fi
