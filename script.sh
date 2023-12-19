#!/usr/bin/env bash

[[ $DEBUG ]] && set -x

STAGES=${1:-"12345"}
[[ $STAGES =~ ^[1-5]+$ ]] || { echo "ERROR: Invalid stage selection ('$STAGES')."; exit 1; }

function echo_one { echo "one"; }
function echo_two { echo "two"; }
function echo_three { echo "three"; }
function echo_four { echo "four"; }
function echo_five { echo "five"; }

STAGE_FUNCTIONS=(
    "echo_one"
    "echo_two"
    "echo_three"
    "echo_four"
    "echo_five"
)

STAGES_OK=0

# Display the order and names of the functions

echo "Stages will be executed in the following order:"
echo
for STAGE in $(echo $STAGES | grep -o .); do
    STAGE_FUNCTION=${STAGE_FUNCTIONS[$STAGE-1]}
    echo "Stage: $STAGE - Function: $STAGE_FUNCTION"
done

# Confirm execution

echo
read -p "Confirm execution (yes): " CONFIRMATION
[[ $CONFIRMATION == "yes" ]] || { echo; echo "Execution aborted."; exit 1; }

# Execute the stages

echo
for STAGE in $(echo $STAGES | grep -o .); do
    STAGE_FUNCTION=${STAGE_FUNCTIONS[$STAGE-1]}
    $STAGE_FUNCTION && ((STAGES_OK++))
done

# Display the result of the execution

echo
[[ $STAGES_OK -eq ${#STAGES} ]] && echo "All stages executed successfully." || echo "Some stages failed."
