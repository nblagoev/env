#
# ~/.zshrc
#

# Start tmux by default and exit terminal if tmux exits. {{{
   if [[ -n "$TMUX" || "$AUTOSTART_TMUX" = "no" ]] ; then
     # export TERM=screen-256color-italic
   else
     tmux attach-session || exec tmux new-session;
     #tmux attach-session || exec tmux new-session && exit;
   fi
# }}}

if [[ $TERM = dumb ]]; then
  unset zle_bracketed_paste
fi

[ -f "$DOTFILES/shell/functions.sh" ] && source "$DOTFILES/shell/functions.sh"

# ALIASES {{{
  alias vim="nvim"

  alias ll='exa -ghlFa --group-directories-first --color-scale --git'
  alias lt='exa -ghlFT --color-scale --git'

  alias cd..='cd ../'                         # Go back 1 directory level (for fast typers)
  alias ..='cd ../'                           # Go back 1 directory level
  alias ...='cd ../../'                       # Go back 2 directory levels
  alias .3='cd ../../../'                     # Go back 3 directory levels
  alias .4='cd ../../../../'                  # Go back 4 directory levels
  alias .5='cd ../../../../../'               # Go back 5 directory levels
  alias .6='cd ../../../../../../'            # Go back 6 directory levels

  # Get week number
  alias week='date +%V'

  # Stopwatch
  alias timer='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'

  # IP addresses
  alias pubip="dig +short myip.opendns.com @resolver1.opendns.com"
  alias localip="sudo ifconfig | grep -Eo 'inet (addr:)?([0-9]*\\.){3}[0-9]*' | grep -Eo '([0-9]*\\.){3}[0-9]*' | grep -v '127.0.0.1'"
  alias ips="sudo ifconfig -a | grep -o 'inet6\\? \\(addr:\\)\\?\\s\\?\\(\\(\\([0-9]\\+\\.\\)\\{3\\}[0-9]\\+\\)\\|[a-fA-F0-9:]\\+\\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

  # URL-encode strings
  alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

  alias path='echo $PATH | tr -s ":" "\n"'
  alias serve='http-server' # npm install http-server
  alias json='python -m json.tool'
  #alias clip='clip.exe'
  alias npm-exec='PATH=$(npm bin):$PATH'
  alias clip='pbcopy'
  alias findP="ps -ef | grep -v grep | grep "

  alias weather="curl -4 http://wttr.in/Sofia"

  # Lists the ten most used commands.
  alias history-stat="history 0 | awk '{print \$2}' | sort | uniq -c | sort -n -r | head"

  # Pipe my public key to my clipboard.
  alias pubkey="more ~/.ssh/id_rsa.pub | xclip -selection clipboard | echo '=> Public key copied to clipboard.'"

  # Pipe my private key to my clipboard.
  alias prikey="more ~/.ssh/id_rsa | xclip -selection clipboard | echo '=> Private key copied to clipboard.'"

  # tmux
  alias tn='tmux new -s "${$(basename `PWD`)//./}" || tmux at -t "${$(basename `PWD`)//./}"'
  alias attach="tmux attach -t"
  alias clearTmux="clear && printf '\e[3J'"

  # My IP
  alias myip='curl -s https://4.ifcfg.me/'
  alias mylocalip='ifconfig | sed -En "s/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p"'

  # Download file with original filename
  alias get="curl -O -L"

  # Show $PATH in readable view
  alias path='echo -e ${PATH//:/\\n}'

  alias code="code-insiders"

  #eval "$(hub alias -s)"

# }}}

# ZSH highlighting settings {{{
  typeset -A ZSH_HIGHLIGHT_PATTERNS

  ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red,bold')
  ZSH_HIGHLIGHT_PATTERNS+=('sudo*' 'fg=white,bold,bg=red,bold')

  ZSH_HIGHLIGHT_PATTERNS+=('\|' 'fg=magenta,bold')
  ZSH_HIGHLIGHT_PATTERNS+=('>' 'fg=magenta,bold')
  ZSH_HIGHLIGHT_PATTERNS+=('>>' 'fg=magenta,bold')

  # Highlight MAC addresses, IPs.
  ZSH_HIGHLIGHT_PATTERNS+=('[0-9a-fA-F][0-9a-fA-F]:[0-9a-fA-F][0-9a-fA-F]:[0-9a-fA-F][0-9a-fA-F]:[0-9a-fA-F][0-9a-fA-F]:[0-9a-fA-F][0-9a-fA-F]:[0-9a-fA-F][0-9a-fA-F]' 'fg=yellow')
  ZSH_HIGHLIGHT_PATTERNS+=(' [0-9]##.[0-9]##.[0-9]##.[0-9]##' 'fg=yellow')

  ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor root line)
# }}}

# Emacs mode {{{
  bindkey -e
  export KEYTIMEOUT=1
# }}}

# completions {{{
  zmodload zsh/complist
  autoload -U compinit && compinit

  # Set options
  setopt MENU_COMPLETE       # press <Tab> one time to select item
  setopt COMPLETEALIASES     # complete alias
  setopt COMPLETE_IN_WORD    # Complete from both ends of a word.
  setopt ALWAYS_TO_END       # Move cursor to the end of a completed word.
  setopt PATH_DIRS           # Perform path search even on command names with slashes.
  setopt AUTO_MENU           # Show completion menu on a successive tab press.
  setopt AUTO_LIST           # Automatically list choices on ambiguous completion.
  setopt AUTO_PARAM_SLASH    # If completed parameter is a directory, add a trailing slash.
  setopt EXTENDED_GLOB       # Needed for file modification glob modifiers with compinit
  unsetopt FLOW_CONTROL # Disable start/stop characters in shell editor.

  zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

  # Group matches and describe.
  zstyle ':completion:*:*:*:*:*' menu select
  zstyle ':completion:*:matches' group 'yes'
  zstyle ':completion:*:options' description 'yes'
  zstyle ':completion:*:options' auto-description '%d'
  zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
  zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
  zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
  zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
  zstyle ':completion:*:default' list-prompt '%S%M matches%s'
  zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
  zstyle ':completion:*' group-name ''
  zstyle ':completion:*' verbose yes

  # Fuzzy match mistyped completions.
  zstyle ':completion:*' completer _complete _match _approximate
  zstyle ':completion:*:match:*' original only
  zstyle ':completion:*:approximate:*' max-errors 1 numeric

  # Increase the number of errors based on the length of the typed word. But make
  # sure to cap (at 7) the max-errors to avoid hanging.
  zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3>7?7:($#PREFIX+$#SUFFIX)/3))numeric)'

  # Don't complete unavailable commands.
  zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

  # Array completion element sorting.
  zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

  # Directories
  export LSCOLORS=ExFxCxdxBxegedabagacad
  export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
  # zstyle ':completion:*' list-colors 'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
  zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
  zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
  zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
  zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
  zstyle ':completion:*' squeeze-slashes true

  # History
  zstyle ':completion:*:history-words' stop yes
  zstyle ':completion:*:history-words' remove-all-dups yes
  zstyle ':completion:*:history-words' list false
  zstyle ':completion:*:history-words' menu yes

  # Environment Variables
  zstyle ':completion::*:(-command-|export):*' fake-parameters ${${${_comps[(I)-value-*]#*,}%%,*}:#-*-}

  # Populate hostname completion. But allow ignoring custom entries from static
  # */etc/hosts* which might be uninteresting.
  zstyle -a ':prezto:module:completion:*:hosts' etc-host-ignores '_etc_host_ignores'

  zstyle -e ':completion:*:hosts' hosts 'reply=(
    ${=${=${=${${(f)"$(cat {/etc/ssh/ssh_,~/.ssh/}known_hosts(|2)(N) 2> /dev/null)"}%%[#| ]*}//\]:[0-9]*/ }//,/ }//\[/ }
    ${=${(f)"$(cat /etc/hosts(|)(N) <<(ypcat hosts 2> /dev/null))"}%%(\#${_etc_host_ignores:+|${(j:|:)~_etc_host_ignores}})*}
    ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2> /dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
  )'

  # Don't complete uninteresting users...
  zstyle ':completion:*:*:*:users' ignored-patterns \
    adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
    dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
    hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
    mailman mailnull mldonkey mysql nagios \
    named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
    operator pcap postfix postgres privoxy pulse pvm quagga radvd \
    rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs '_*'

  # ... unless we really want to.
  zstyle '*' single-ignored show

  # Ignore multiple entries.
  zstyle ':completion:*:(rm|kill|diff):*' ignore-line other
  zstyle ':completion:*:rm:*' file-patterns '*:all-files'

  # auto rehash
  zstyle ':completion:*' rehash true

  #highlight prefix
  zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)*==34=34}:${(s.:.)LS_COLORS}")'

  # Kill
  zstyle ':completion:*:*:*:*:processes' command 'ps -u $LOGNAME -o pid,user,command -w'
  zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
  zstyle ':completion:*:*:kill:*' menu yes select
  zstyle ':completion:*:*:kill:*' force-list always
  zstyle ':completion:*:*:kill:*' insert-ids single

  # Man
  zstyle ':completion:*:manuals' separate-sections true
  zstyle ':completion:*:manuals.(^1*)' insert-sections true

  # SSH/SCP/RSYNC
  zstyle ':completion:*:(ssh|scp|rsync):*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
  zstyle ':completion:*:(scp|rsync):*' group-order users files all-files hosts-domain hosts-host hosts-ipaddr
  zstyle ':completion:*:ssh:*' group-order users hosts-domain hosts-host users hosts-ipaddr
  zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
  zstyle ':completion:*:(ssh|scp|rsync):*:hosts-domain' ignored-patterns '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*'
  zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'

# }}}

### Oh-My-Zsh {{{
  SPACESHIP_DIR_TRUNC=0
  SPACESHIP_EXIT_CODE_SHOW=true
  SPACESHIP_KUBECONTEXT_SHOW=false
  SPACESHIP_EMBER_SHOW=false
  SPACESHIP_DOTNET_SHOW=false
  SPACESHIP_PYENV_SHOW=false
  SPACESHIP_CONDA_SHOW=false
  SPACESHIP_VENV_SHOW=false
  SPACESHIP_AWS_SHOW=false
  SPACESHIP_DOCKER_SHOW=false
  SPACESHIP_JULIA_SHOW=false
  SPACESHIP_HASKELL_SHOW=false
  SPACESHIP_RUST_SHOW=false
  SPACESHIP_PHP_SHOW=false
  SPACESHIP_GOLANG_SHOW=false
  SPACESHIP_GOLANG_SHOW=false
  SPACESHIP_XCODE_SHOW_LOCAL=false
  SPACESHIP_ELIXIR_SHOW=false
  SPACESHIP_RUBY_SHOW=false
  SPACESHIP_NODE_SHOW=false
  SPACESHIP_PACKAGE_SHOW=false
  SPACESHIP_HOST_PREFIX="at  "
  SPACESHIP_BATTERY_SHOW=false
  COMPLETION_WAITING_DOTS=true

  # Uncomment the following line to enable command auto-correction.
  # ENABLE_CORRECTION="true"

  # Uncomment the following line if you want to disable marking untracked files
  # under VCS as dirty. This makes repository status check for large repositories
  # much, much faster.
  # DISABLE_UNTRACKED_FILES_DIRTY="true"

  #source $ZSH/oh-my-zsh.sh
### }}}

# fasd {{{
  eval "$(fasd --init auto)"
# }}}

# pet {{{

function prev() {
  PREV=$(fc -lrn | head -n 1)
  sh -c "pet new `printf %q "$PREV"`"
}

function pet-select() {
  BUFFER=$(pet search --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle redisplay
}

zle -N pet-select
stty -ixon
bindkey '^s' pet-select

# }}}

# Zplug plugin definitions {{{
  export ZPLUG_HOME=/usr/local/opt/zplug
  source $ZPLUG_HOME/init.zsh

  zplug zsh-users/zsh-syntax-highlighting
  zplug zsh-users/zsh-completions
  zplug zsh-users/zsh-autosuggestions

  zplug "plugins/gulp", from:oh-my-zsh

  zplug hlissner/zsh-autopair
  #zplug akoenig/npm-run.plugin.zsh

  zplug denysdovhan/spaceship-prompt, use:spaceship.zsh, as:theme
# }}}

# FZF {{{
# --files: List files that would be searched but do not search
# --ignore: Do respect .gitignore, etc...
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
# --no-messages: don't show error messages in the output
  # export FZF_DEFAULT_COMMAND='ag -l -g ""'
  export FZF_DEFAULT_COMMAND='rg --files --ignore-case --hidden --follow --no-messages'

  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# }}}

# Zplug {{{
# Can manage local plugins
# zplug "~/.zsh", from:local

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  printf "Install? [y/N]: "

  if read -q; then
    echo; zplug install
  fi
fi

# Then, source plugins and add commands to $PATH
# Only source zplugins when a new terminal is opened not when source ~/.zshrc
# This is due to conflict between some plugins that causes a crash
# https://github.com/zsh-users/zsh-autosuggestions/issues/205
if [[ $ZSH_EVAL_CONTEXT == 'file' ]]; then
  zplug load
fi
# }}}

# History options {{{
  if [ -z "$HISTFILE" ]; then
    HISTFILE=$HOME/.zsh_history
  fi

  HISTSIZE=50000
  SAVEHIST=50000

  setopt append_history
  setopt extended_history
  setopt -g hist_expire_dups_first
  setopt -g hist_ignore_dups # ignore duplication command history list
  setopt -g HIST_IGNORE_ALL_DUPS
  setopt -g HIST_FIND_NO_DUPS
  setopt hist_ignore_space
  setopt hist_verify
  setopt inc_append_history
  setopt share_history # share command history data
#}}}

# Auto suggestions {{{
  export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'
  bindkey '^e' autosuggest-accept
# }}}

# Fix for 'widgets can only be called when ZLE is active.' {{{
# https://stackoverflow.com/questions/20357441/zsh-on-10-9-widgets-can-only-be-called-when-zle-is-active
  TRAPWINCH() {
    zle && { zle reset-prompt; zle -R }
  }
# }}}

# Fzf functions {{{
  # fbr - checkout git branch (including remote branches)
  __fzf_branch() {
    local cmd='git branch'

    setopt localoptions pipefail 2> /dev/null
    eval "$cmd" | FZF_DEFAULT_OPTS="--ansi --height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" $(__fzfcmd) -m "$@" | while read item; do
      echo -n "${(q)item} " | cut -d'\' -f1
    done
    local ret=$?
    echo
    return $ret
  }

  branch-widget() {
    LBUFFER="${LBUFFER}$(__fzf_branch)"
    local ret=$?
    zle redisplay
    typeset -f zle-line-init >/dev/null && zle zle-line-init
    return $ret
  }

  zle     -N   branch-widget
  bindkey '^B' branch-widget

  bindkey '^F' fzf-file-widget # use ^F for file completion instead of ^T

  # fstash - easier way to deal with stashes
  # type fstash to get a list of your stashes
  # enter shows you the contents of the stash
  # ctrl-d shows a diff of the stash against your current HEAD
  # ctrl-b checks the stash out as a branch, for easier merging
  zmodload zsh/mapfile # Needsed for mappin the files in fstash
  fstash() {
    local out q k sha
    while out=$(
      git stash list --pretty="%C(yellow)%h %>(14)%Cgreen%cr %C(blue)%gs" |
      fzf --ansi --no-sort --query="$q" --print-query \
          --expect=ctrl-d,ctrl-b);
    do
      $mapfile -t out <<< "$out"
      q="${out[0]}"
      k="${out[1]}"
      sha="${out[-1]}"
      sha="${sha%% *}"
      [[ -z "$sha" ]] && continue
      if [[ "$k" == 'ctrl-d' ]]; then
        git diff $sha
      elif [[ "$k" == 'ctrl-b' ]]; then
        git stash branch "stash-$sha" $sha
        break;
      else
        git stash show -p $sha
      fi
    done
  }

# }}}

# FUNCTIONS {{{

# Create a new directory and enter it
function mkd() {
	mkdir -p "$@" && cd "$_";
}

# Create a .tar.gz archive, using `zopfli`, `pigz` or `gzip` for compression
function targz() {
	local tmpFile="${@%/}.tar";
	tar -cvf "${tmpFile}" --exclude=".DS_Store" "${@}" || return 1;

	size=$(
		stat -f"%z" "${tmpFile}" 2> /dev/null; # macOS `stat`
		stat -c"%s" "${tmpFile}" 2> /dev/null;  # GNU `stat`
	);

	local cmd="";
	if (( size < 52428800 )) && hash zopfli 2> /dev/null; then
		# the .tar file is smaller than 50 MB and Zopfli is available; use it
		cmd="zopfli";
	else
		if hash pigz 2> /dev/null; then
			cmd="pigz";
		else
			cmd="gzip";
		fi;
	fi;

	echo "Compressing .tar ($((size / 1000)) kB) using \`${cmd}\`…";
	"${cmd}" -v "${tmpFile}" || return 1;
	[ -f "${tmpFile}" ] && rm "${tmpFile}";

	zippedSize=$(
		stat -f"%z" "${tmpFile}.gz" 2> /dev/null; # macOS `stat`
		stat -c"%s" "${tmpFile}.gz" 2> /dev/null; # GNU `stat`
	);

	echo "${tmpFile}.gz ($((zippedSize / 1000)) kB) created successfully.";
}

# Determine size of a file or total size of a directory
function fs() {
	if du -b /dev/null > /dev/null 2>&1; then
		local arg=-sbh;
	else
		local arg=-sh;
	fi
	if [[ -n "$@" ]]; then
		du $arg -- "$@";
	else
		du $arg .[^.]* ./*;
	fi;
}

# Compare original and gzipped file size
function gz() {
	local origsize=$(wc -c < "$1");
	local gzipsize=$(gzip -c "$1" | wc -c);
	local ratio=$(echo "$gzipsize * 100 / $origsize" | bc -l);
	printf "orig: %d bytes\n" "$origsize";
	printf "gzip: %d bytes (%2.2f%%)\n" "$gzipsize" "$ratio";
}

# Run `dig` and display the most useful info
function digga() {
	dig +nocmd "$1" any +multiline +noall +answer;
}

function port() {
	lsof -n -i:$@ | grep LISTEN;
}

function tm() {
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  if [ $1 ]; then
     tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s $1 && tmux $change -t "$1"); return
  fi
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&  tmux $change -t "$session" || echo "No sessions found."
}

# Count code lines in some directory.
# $ loc py js css
# # => Lines of code for .py: 3781
# # => Lines of code for .js: 3354
# # => Lines of code for .css: 2970
# # => Total lines of code: 10105
function loc() {
  local total
  local firstletter
  local ext
  local lines
  total=0
  for ext in $@; do
    firstletter=$(echo $ext | cut -c1-1)
    if [[ firstletter != "." ]]; then
      ext=".$ext"
    fi
    lines=`find-exec "*$ext" cat | wc -l`
    lines=${lines// /}
    total=$(($total + $lines))
    echo "Lines of code for ${fg[blue]}$ext${reset_color}: ${fg[green]}$lines${reset_color}"
  done
  echo "${fg[blue]}Total${reset_color} lines of code: ${fg[green]}$total${reset_color}"
}

# $ retry ping google.com
function retry() {
  echo Retrying "$@"
  $@
  sleep 1
  retry $@
}

# $ size dir1 file2.js
function size() {
  # du -sh "$@" 2>&1 | grep -v '^du:' | sort -nr
  du -shck "$@" | sort -rn | awk '
      function human(x) {
          s="kMGTEPYZ";
          while (x>=1000 && length(s)>1)
              {x/=1024; s=substr(s,2)}
          return int(x+0.5) substr(s,1,1)
      }
      {gsub(/^[0-9]+/, human($1)); print}'
}

# Extract archives - use: extract <file>
# Based on http://dotfiles.org/~pseup/.bashrc
function extract() {
	if [ -f "$1" ] ; then
		local filename=$(basename "$1")
		local foldername="${filename%%.*}"
		local fullpath=`perl -e 'use Cwd "abs_path";print abs_path(shift)' "$1"`
		local didfolderexist=false
		if [ -d "$foldername" ]; then
			didfolderexist=true
			read -p "$foldername already exists, do you want to overwrite it? (y/n) " -n 1
			echo
			if [[ $REPLY =~ ^[Nn]$ ]]; then
				return
			fi
		fi
		mkdir -p "$foldername" && cd "$foldername"
		case $1 in
			*.tar.bz2) tar xjf "$fullpath" ;;
			*.tar.gz) tar xzf "$fullpath" ;;
			*.tar.xz) tar Jxvf "$fullpath" ;;
			*.tar.Z) tar xzf "$fullpath" ;;
			*.tar) tar xf "$fullpath" ;;
			*.taz) tar xzf "$fullpath" ;;
			*.tb2) tar xjf "$fullpath" ;;
			*.tbz) tar xjf "$fullpath" ;;
			*.tbz2) tar xjf "$fullpath" ;;
			*.tgz) tar xzf "$fullpath" ;;
			*.txz) tar Jxvf "$fullpath" ;;
			*.zip) unzip "$fullpath" ;;
			*) echo "'$1' cannot be extracted via extract()" && cd .. && ! $didfolderexist && rm -r "$foldername" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}

# preview csv files. source: http://stackoverflow.com/questions/1875305/command-line-csv-viewer
function csvpreview(){
      sed 's/,,/, ,/g;s/,,/, ,/g' "$@" | column -s, -t | less -#2 -N -S
}

# git commit browser. needs fzf
function gitlog() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --toggle-sort=\` \
      --bind "ctrl-m:execute:
                echo '{}' | grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R'"
}

function chromep() {
	/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
	 	--proxy-server="socks5://127.0.0.1:5678" \
		--host-resolver-rules="MAP * 0.0.0.0 , EXCLUDE localhost"
}

# }}}

# vim: foldmethod=marker:sw=2
