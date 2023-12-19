#!/usr/bin/env bash

[[ $DEBUG ]] && set -x

###
### vars
###

STAGES=$1
[[ $STAGES == "all" ]] && { STAGES="12345"; }
[[ $STAGES =~ ^[1-5]+$ ]] || { echo "ERROR: no or wrong selected stages ($STAGES)"; exit 1; }

STAGE_FUNCTIONS=(
    "echo_one"
    "echo_two"
    "echo_three"
    "echo_four"
    "echo_five"
)

STAGES_OK=0
STAGES_EXPECTED=${#STAGES}

###
### functions
###

function loop_stages {
    local CMD="$1"

    for (( i=0; i<${#STAGES}; i++ )); do
        STAGE=${STAGES:$i:1}
        STAGE_FUNCTION=${STAGE_FUNCTIONS[$STAGE-1]}

        case "$CMD" in
            echo_stages)
                echo "Order: $i - Stage: $STAGE - Function: $STAGE_FUNCTION";;
            exec_stages)
                eval $STAGE_FUNCTION;;
        esac
    done
}

function echo_one {
    echo "one" && \
    ((STAGES_OK++))
}

function echo_two {
    echo "two" && \
    ((STAGES_OK++))
}

function echo_three {
    echo "three" && \
    ((STAGES_OK++))
}

function echo_four {
    echo "four" && \
    ((STAGES_OK++))
}

function echo_five {
    echo "five" #&& \
    #((STAGES_OK++))
}

###
### structured
###

# aks if selection is correct
echo "Following stages will run:"
echo ""

loop_stages echo_stage

echo ""
read -p "Please confirm (yes): " YES
echo ""

[[ $YES ]] || { echo "Aborted. Please confirm with yes to run selected stages."; exit 1; }

loop_stages exec_stage

echo ""
[ $STAGES_OK -eq $STAGES_EXPECTED ] \
    && { echo "All $STAGES_OK of $STAGES_EXPECTED stages went ok"; exit 0; } \
    || { echo "Only $STAGES_OK of $STAGES_EXPECTED stages went ok"; exit 1; }