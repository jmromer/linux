#!/usr/bin/env sh

# Homebrew setup
# -----------------------------
# n-1: http://archlever.blogspot.com/2013/09/lies-damned-lies-and-truths-backed-by.html
case "$(uname -ps)" in
  Linux*)
    MACHINE="linux"
    HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
    MACHINE_CORES=$(echo "$(nproc) - 1" | bc)
  ;;
  Darwin\ arm*)
    MACHINE="apple"
    HOMEBREW_PREFIX="/opt/homebrew"

    if command -v /usr/sbin/sysctl >/dev/null; then
      MACHINE_CORES=$(echo "$(/usr/sbin/sysctl -n hw.ncpu) - 1" | bc)
    fi
  ;;
  Darwin*)
    MACHINE="intel-mac"
    HOMEBREW_PREFIX="/usr/local"
    if command -v /usr/sbin/sysctl >/dev/null; then
      MACHINE_CORES=$(echo "$(/usr/sbin/sysctl -n hw.ncpu) - 1" | bc)
    fi
  ;;
esac

if [[ -z "${MACHINE_CORES}" ]]; then
  MACHINE_CORES=8
  echo "Warning: MACHINE_CORES set to default value of ${MACHINE_CORES}."
fi

export MACHINE
export MACHINE_CORES
export HOMEBREW_PREFIX

[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

export ORG_HOME="${HOME}/Org"

export FZF_DEFAULT_OPTS="
  --no-multi
  --exact
  --tiebreak=index
  --color='bg:#1d1e20,bg+:#1d1e20,preview-bg:#1d1e20,border:#1d1e20'
  --bind='ctrl-f:preview-down'
  --bind='ctrl-b:preview-up'
"
export FZF_DEFAULT_COMMAND="fdfind --hidden --type f --exclude .git --exclude node_modules"
export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
