#!/usr/bin/env zsh
# Load envs
source "./.script_envs"

# Load common functions
source "./bash_common.sh"

echo "Starting Strapi Instance $INSTANCE_ID"

aws_out=$(aws ec2 start-instances --instance-ids $INSTANCE_ID)
is_running=$(echo $aws_out | jq -r ".StartingInstances[0].CurrentState.Name")
was_running=$(echo $aws_out | jq -r ".StartingInstances[0].PreviousState.Name")

if [[ "$was_running" == "running" ]]; then
  echo "Strapi instance is already running"
fi

if [[ "$is_running" != "running" ]] && [[ "$is_running" != "pending" ]]; then
  echo "Strapi instance failed to start"
  echo "$aws_out"
  exit 1
fi

echo "Attempting to reach server..."
echo -en "-${MAGENTA} Attempt [1/10]${ENDCOLOR}"
start_spinner
response_code=$(curl -m 10 -I "$ACCESS_URL" 2> /dev/null | head -n 1 | cut -d$' ' -f2)

attempt_count=0
while [ "$response_code" -ne "200" ]
do
  attempt_count=$((attempt_count + 1))
  echo -en "\r-${MAGENTA} Attempt [$((attempt_count + 1))/10]${ENDCOLOR}"
  sleep 7
  response_code=$(curl -m 10 -I "$ACCESS_URL" 2> /dev/null | head -n 1 | cut -d$' ' -f2)
  if [ $attempt_count -ge 9 ]; then
    stop_spinner
    echo
    echo -e "${RED}Something went wrong! Could not reach server after 10 attempts.${ENDCOLOR}" 
    exit 1
  fi
done
stop_spinner

echo
border_lines=("${GREEN}Strapi instance successfully started!${ENDCOLOR}" "" "URL: ${MAGENTA}${ACCESS_URL}${ENDCOLOR}")
border
exit 0