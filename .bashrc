. ~/.secrets
. ~/.bash_completion
. ~/.aliases
. ~/.ps1colors
. ~/.runtimes

export EDITOR=nano
export VISUAL=nano
export PATH=$PATH:~/.bin
export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
export LATITUDE=""
export LONGITUDE=""
export WEATHER=""
export WEATHER_TIME=0
eval $( keychain --eval --agents ssh --inherit any id_rsa id_ed25519 ec2.pem mbp.pem )

declare -A WEATHER_ICONS

#clear-night, rain, snow, sleet, wind, fog, cloudy, partly-cloudy-day, or partly-cloudy-night

WEATHER_ICONS["clear-day"]="☀️"
WEATHER_ICONS["clear-night"]="🌙️"
WEATHER_ICONS["rain"]="☔️"
WEATHER_ICONS["snow"]="❄️️"
WEATHER_ICONS["sleet"]="🌧️️"
WEATHER_ICONS["wind"]="🌬️"
WEATHER_ICONS["fog"]="🌫️️"
WEATHER_ICONS["partly-cloudy-day"]="🌤️️"

function getweather {
    if (( $(date "+%s") - $WEATHER_TIME > 600)); then
        export LATITUDE=$(~/Downloads/whereami  --help | grep Latitude | cut -d' ' -f2 | xargs)
        export LONGITUDE=$(~/Downloads/whereami  --help | grep Longitude | cut -d' ' -f2 | xargs)
        export WEATHER=$(curl -s "https://api.darksky.net/forecast/1483bb7e8db6078b288b18cefb583da7/${LATITUDE},${LONGITUDE}?exclude=flags,alerts,daily,hourly,minutely")
        export WEATHER_TIME=$(date +"%s")
    fi

    export W_TEMP=$(echo ${WEATHER} | jq -r .currently.temperature)
    export W_CONDITIONS=$(echo ${WEATHER} | jq -r .currently.summary)
    export W_ICON=$(echo ${WEATHER} | jq -r .currently.icon)
    export W_EMOJI=${WEATHER_ICONS[$W_ICON]-🌎}

    export WEATHER_SUMMARY="${W_EMOJI}  ${W_CONDITIONS} and ${W_TEMP}°F"
}

function getprompt {
    local OLDSTATUS=$?
    local HOST TIME HISTORY WHOAMI PROMPT WHEREAMI OLDSTATUS GIT_BRANCH GIT_INFO GIT_MODIFIED_FILES GIT_TOTAL_FILES;

    eval $(direnv export bash);

#    getweather

    if $(git rev-parse --is-inside-work-tree > /dev/null 2>&1); then
        GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD | xargs)
        GIT_MODIFIED_FILES=$(git status --porcelain | wc -l | xargs)

        if [[ ${GIT_MODIFIED_FILES} -gt 0 ]]; then
            GIT_TOTAL_FILES=$(git ls-files `git rev-parse --show-toplevel` | wc -l | xargs)

            GIT_INFO="${DRed}🌱 ${GIT_BRANCH} (${Red}${GIT_MODIFIED_FILES}${DRed}/${GIT_TOTAL_FILES})${Color_Off}"
        else
            GIT_INFO="${DPurple}🌱 ${GIT_BRANCH}${Color_Off}"
        fi
    else
        GIT_INFO=''
    fi



    if [ "$OLDSTATUS" -eq 0 ]; then
            PColor="🍺 "
    else
            PColor="💩 "
    fi

    if [ $HOSTNAME == "hq-mc-edrap.local" ]; then
            HOST=""
    else
            HOST="${Red}\h${Color_Off}:"
    fi

    TIME="${Cyan}🕘 \t${Color_Off}"
    HISTORY="${Green}📒\!${Color_Off}"
    WHOAMI="${Cyan}\u${Color_Off}"
    PROMPT="$PColor${Color_Off}"
    WHEREAMI="📘 ${HOST}${Blue}\w ${GIT_INFO} ${Color_Off}"

    export PS1="\n    $TIME ⎦${WHEREAMI}⎡ \n ${HISTORY} $PROMPT"
    #export PS1="\n    $WEATHER_SUMMARY at $TIME \n    ⎦${WHEREAMI}⎡ \n ${HISTORY} $PROMPT"


}

export PROMPT_COMMAND="getprompt; history -a; history -c; history -r; _fasd_prompt_func;"

fasd_cache="$HOME/.fasd-init-bash"

if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  fasd --init posix-alias bash-hook bash-ccomp bash-ccomp-install >| "$fasd_cache"
fi

. ~/.fasd-init-bash

unset fasd_cache

# tabtab source for yarn package
# uninstall by removing these lines or running `tabtab uninstall yarn`
[ -f /Users/edwarddrapkin/.config/yarn/global/node_modules/tabtab/.completions/yarn.bash ] && . /Users/edwarddrapkin/.config/yarn/global/node_modules/tabtab/.completions/yarn.bash
[ -s "/Users/edwarddrapkin/.jabba/jabba.sh" ] && source "/Users/edwarddrapkin/.jabba/jabba.sh"
