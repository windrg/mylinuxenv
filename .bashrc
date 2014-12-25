# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias llh='ls -alF -h'
alias la='ls -A'
alias l='ls -CF'
alias v='vim'
alias vd='vimdiff'
alias vq='vim -q'
alias f='find'
alias s='source'
alias g='grep'
alias e='egrep'
alias his='history'
alias ws='cd /home/cysh/ws'
alias gcom='gnome-commander'
alias cs='cscope' 
alias csd='cscope -d'
alias hosts='cat /etc/hosts'
alias m='miniterm.py /dev/ttyUSB0 -b 115200'
alias hgrep='history | grep'
alias psgrep='ps -ef | grep'
alias dvi='adb shell dmesg | vi'
alias sshmnc='ssh cy13.shin@mnc'

# my ville
alias vill='cd /home/cysh/vill/'
#alias 510='cd /home/cysh/vill/510/'
alias e6430='cd /home/cysh/vill/e6430/'
alias mnc='cd /home/cysh/vill/mnc/'
alias conn='cd /home/cysh/vill/conn/'
#alias ishtar='cd /home/cysh/vill/ishtar/'
#alias pe='cd /home/cysh/vill/pe/'


# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export EDITOR=/usr/bin/vim


export PATH=${PATH}:/home/cysh/bin:/home/cysh/bin/abin:/home/cysh/bin/adt-bundle-linux-x86_64-20140702/sdk/tools
export PATH=/usr/lib/ccache:${PATH}:/home/cysh/bin:/home/cysh/bin/abin:/home/cysh/bin/adt-bundle-linux-x86_64-20140702/sdk/tools:/home/cysh/bin/adt-bundle-linux-x86_64-20140702/sdk/platform-tools:/home/cysh/bin/frame_decode:/home/cysh/p4v-2014.1.888424/bin

# distcc
export CONCURRENCY_LEVEL=40
export DISTCC_HOSTS="mnc localhost"
export DISTCC_LOG=/tmp/distcc.log
export DISTCC_VERBOSE=1

# ccache
#export USE_CCACHE=1
export CCACHE_DIR=/home/cysh/.ccache
#export CCACHE_PREFIX="distcc"
export CCACHE_LOGFILE=/tmp/ccache.log
#export PATH=/usr/lib/ccache:${PATH}

#This should be copied to /root/.bashrc
#export http_proxy="http://168.219.61.252:8080"
#export https_proxy="http://168.219.61.252:8080"
#export ftp_proxy="ftp://168.219.61.252:8080"
#export socket_proxy="socket://168.219.61.252:8080"
