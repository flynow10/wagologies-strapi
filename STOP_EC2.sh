#!/usr/bin/env zsh

# Load envs
source "./.script_envs"

# Load common functions
source "./bash_common.sh"
echo "Stopping Strapi Instance ${INSTANCE_ID}"
aws_out=$(aws ec2 stop-instances --instance-ids $INSTANCE_ID)

is_stopping=$(echo $aws_out | jq -r ".StoppingInstances[0].CurrentState.Name")
was_stopped=$(echo $aws_out | jq -r ".StoppingInstances[0].PreviousState.Name")

if [[ "$was_stopped" == "stopped" ]] && [[ "$is_stopping" == "stopped" ]]; then
  echo -e "${GREEN}Strapi instance is already stopped${ENDCOLOR}"
  exit 0
fi

get_status() {
  aws_status_out=$(aws ec2 describe-instance-status --include-all-instances --instance-ids $INSTANCE_ID)
  echo $aws_status_out | jq -r ".InstanceStatuses[0].InstanceState.Name"
} 

start_spinner
echo -en "\r- Current status: ${MAGENTA}${is_stopping}${ENDCOLOR}"
is_stopped=$(get_status)

attempt_count=0
while [[ "$is_stopped" != "stopped" ]]; do
  echo -en "\e[1A\e[K- Current status: ${MAGENTA}${is_stopped}${ENDCOLOR}"
  sleep 5
  is_stopped=$(get_status)
  attempt_count=$((attempt_count + 1))
  if ((attempt_count >= 10)); then
    stop_spinner
    echo -e "Current status: ${MAGENTA}${is_stopped}${ENDCOLOR}"
    echo -e "${RED}Failed to stop strapi instance!${ENDCOLOR}"
    exit 1
  fi
done
stop_spinner
echo -e "Current status: ${MAGENTA}${is_stopped}${ENDCOLOR}"
echo -e "${GREEN}Successfully shutdown strapi instance${ENDCOLOR}"