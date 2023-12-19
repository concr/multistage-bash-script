#!/usr/bin/env bash

[[ $DEBUG ]] && set -x

### Variables

SELECTED_STAGES=$1

case "$SELECTED_STAGES" in
    "all") STAGES="12345" ;;
    *[!1-5]* | "") echo "ERROR: Invalid stage selection ('$SELECTED_STAGES'). Please select from stages 1-5."; exit 1 ;;
    *) STAGES=$SELECTED_STAGES ;;
esac

STAGE_ACTION_FUNCTIONS=(
    "echo_one"
    "echo_two"
    "echo_three"
    "echo_four"
    "echo_five"
)

STAGES_OK=0
STAGES_EXPECTED=${#STAGES}

### Functions

function handle_stages {
    local CMD="$1"
    for (( i=0; i<${#STAGES}; i++ )); do
        STAGE=${STAGES:$i:1}
        STAGE_FUNCTION=${STAGE_ACTION_FUNCTIONS[$STAGE-1]}

        [[ "$CMD" == "echo" ]] && echo "Order: $i - Stage: $STAGE - Function: $STAGE_FUNCTION"
        [[ "$CMD" == "exec" ]] && eval "$STAGE_FUNCTION"
    done
}

function echo_one {
    echo "one"
    ((STAGES_OK++))
}

function echo_two {
    echo "two"
    ((STAGES_OK++))
}

function echo_three {
    echo "three"
    ((STAGES_OK++))
}

function echo_four {
    echo "four"
    ((STAGES_OK++))
}

function echo_five {
    echo "five"
    ((STAGES_OK++))
}

### Main Execution

# Ask if the selection is correct
echo "Following stages will run:"
echo ""

handle_stages "echo"

echo ""
read -p "Please confirm (yes): " YES
echo ""

[[ $YES == "yes" ]] || { echo "Aborted. Please confirm with 'yes' to run selected stages."; exit 1; }

handle_stages "exec"

echo ""
if [ $STAGES_OK -eq $STAGES_EXPECTED ]; then
    echo "All $STAGES_OK of $STAGES_EXPECTED stages went ok"
    exit 0
else
    echo "Only $STAGES_OK of $STAGES_EXPECTED stages went ok"
    exit 1
fi