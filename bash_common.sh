# Colors
GREEN="\e[32m"
RED="\e[31m"
MAGENTA="\e[35m"
ENDCOLOR="\e[0m"

declare -a border_lines
border()
{
  max_length=0
  max_line=""
  for line in "${border_lines[@]}"; do
    clean_line=$(echo $line | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2};?)?)?[mGK]//g")
    if [ ${#clean_line} -gt $max_length ]; then
      max_length=${#clean_line}
      max_line="$clean_line"
    fi
  done
  spaced_text="   $max_line     "
  title="|$spaced_text|"
  edge=$(echo "$title" | sed 's/./*/g')
  spacing=$(echo "$spaced_text" | sed 's/./ /g')
  echo "$edge"
  echo "|$spacing|"
  for line in "${border_lines[@]}"; do
    clean_line=$(echo $line | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2};?)?)?[mGK]//g")
    end_spacing_num=`expr $max_length - ${#clean_line} + 4`
    end_spacing=$(head -c $end_spacing_num < /dev/zero | tr '\0' ' ')
    echo -e "|    ${line}${end_spacing}|"
  done
  echo "|$spacing|"
  echo "$edge"
}

spinner() {
  spin='-\|/'

  i=0
  while :;
  do
    i=$(( (i+1) %4 ))
    printf "\r${spin:$i:1}"
    sleep .1
  done
}
spinner_pid=
function start_spinner {
    set +m
    { spinner & } 2>/dev/null
    spinner_pid=$!
}

function stop_spinner {
    { kill -9 $spinner_pid && wait; } 2>/dev/null
    set -m
    echo -en "\033[2K\r"
}

trap "stop_spinner;exit" SIGINT SIGTERM EXIT
 