source  /usr/lib/git-core/git-sh-prompt

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# History settings
HISTCONTROL=ignoredups:ignorespace
shopt -s histappend
HISTSIZE=10000
HISTFILESIZE=20000
PROMPT_DIRTRIM=3

# Resize window after command if needed
shopt -s checkwinsize

# Prompt
PS1='\[\e[32;1m\]\u\[\e[97m\]@\[\e[94m\]\h\[\e[0m\]:\[\e[96m\]\w\[\e[0m\]\[$(__git_ps1)\] \[\e[97m\]\$\[\e[0m\] '

# Commands completition
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# Aliases
alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias grep='grep --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

export PATH=$PATH:/usr/local/go/bin

