. ~/.secrets
. ~/.bash_completion
. ~/.aliases
. ~/.ps1colors
. ~/.runtimes

export PATH=$PATH:~/.bin
export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history

eval $( keychain --eval --agents ssh --inherit any id_rsa id_ed25519 )

fasd_cache="$HOME/.fasd-init-bash"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  fasd --init posix-alias bash-hook bash-ccomp bash-ccomp-install >| "$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache

function getprompt {
	local HOST TIME HISTORY WHOAMI PROMPT WHEREAMI OLDSTATUS;

	OLDSTATUS=$?;

	eval $(direnv export bash);

    if [ "$?" -eq 0 -o "$?" -eq 1 ]; then #1 == ctrl-c
            PColor="🍺 "
    else
            PColor="💩 "
    fi

    if [ $HOSTNAME == "Eddies-Laptop.local" ]; then
            HOST=""
    else
            HOST="${Red}\h${Color_Off}:"
    fi

    TIME="${Cyan}🕘 \t${Color_Off}"
    HISTORY="${Green}📒\#${Color_Off}"
    WHOAMI="${Cyan}\u${Color_Off}"
    PROMPT="$PColor${Color_Off}"
    WHEREAMI="📘 ${HOST}${Blue}\w ${Color_Off}"

    export PS1="\n    $TIME ⎦${WHEREAMI}⎡ \n ${HISTORY} $PROMPT"

	return $OLDSTATUS;
}

export PROMPT_COMMAND="history -a; getprompt"

