# ~/.bashrc: sourced by interactive non-login Bash shells.

export PATH="$HOME/.local/bin:$PATH"

export EDITOR=vim
export VISUAL=vim

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[ -d "$PYENV_ROOT/bin" ] && export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv >/dev/null 2>&1 && eval "$(pyenv init - bash)"

if [[ $- == *i* ]] && [[ "$TERM" != "linux" ]] && command -v powerline-shell >/dev/null 2>&1; then
  _update_ps1() {
    PS1="$(powerline-shell $?)"
  }

  if [[ ! "$PROMPT_COMMAND" =~ _update_ps1 ]]; then
    PROMPT_COMMAND="_update_ps1${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
  fi
fi
