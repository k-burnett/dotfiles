#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
# basic prompt
source ~/.git-prompt.sh
PS1='[\A \u@\h \w$(__git_ps1 " (%s)")]\$ '
