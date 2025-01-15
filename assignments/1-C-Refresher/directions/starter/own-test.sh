#!/bin/bash

# Program to test
PROGRAM="./stringfun"

# Output separator for better readability
SEPARATOR="=================================================="

# Example strings
EMPTY=""
WHITE_SPACES="   "
TAB="   "
BAD_SPACING="   Hello  World!   BRUH  "
SYMBOLS=",@.%  /* &^"
SENTENCE="This class is Systems Programming (CS283)."

# List of strings
LIST=("$EMPTY"
      "$WHITE_SPACES"
      "$TAB"
      "$BAD_SPACING"
      "$SYMBOLS"
      "$SENTENCE")

# Function to check if program worked
check() {
    local error=$?
    if [[ $error -ne 0 ]]; then
        echo "Error Code: $error"
    fi
}

# Function to run a test
run_test() {
    local flag="$1"
    echo "$SEPARATOR"
    if [[ $1 == '-x' ]]; then
        local find="$2"
        local replace="$3"
        for str in "${LIST[@]}"; do
            $PROGRAM $flag "$str" "$find" "$replace"
            check
        done
    else
        for str in "${LIST[@]}"; do
            $PROGRAM $flag "$str"
            check
        done
    fi
    echo -e "$SEPARATOR\n"
}

# Check if the program exists
if [[ ! -x "$PROGRAM" ]]; then
    echo "Error: $PROGRAM not found or not executable."
    exit 1
fi

echo "Invalid Arguments:"
echo "$SEPARATOR"
$PROGRAM
check
$PROGRAM -c
check
echo -e "$SEPARATOR\n"

echo "Count words flag:"
run_test "-c"

echo "Reverse string flag:"
run_test "-r"

echo "Print words flag:"
run_test "-w"

echo "Replace words flag:"
run_test "-x" "Systems" "maybe"
run_test "-x" "CS283" "ECE353"
run_test "-x" "(CS283)" "wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww"
