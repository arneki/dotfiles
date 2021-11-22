alias ls='ls --color'
alias ll='ls -la'
alias cp="cp -i"                    # Confirm before overwriting something
alias df='df -h'                    # Human-readable sizes
alias src="source $HOME/.zshrc"     # source ~/.zshrc

# git aliases
alias gl='git log --stat'
alias gs='git status'
alias gd='git diff'

alias assh='autossh -M 0'

# singularity
alias -g singexec='singularity exec --app "${app:-dls}" --overlay /containers/overlays/2021-02-17_buster_texlive_unpacked.img:ro "${container:-$(readlink -f /containers/stable/latest)}"'
alias -g singshell='singexec zsh'
