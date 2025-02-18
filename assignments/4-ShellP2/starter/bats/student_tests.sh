#!/usr/bin/env bats

# File: student_tests.sh
#
# Create your unit tests suit in this file

@test "Example: check ls runs without errors" {
    run ./dsh <<EOF
ls
EOF
    # Assertions
    [[ "$output" == *"$(ls)"* ]]
    [ "$status" -eq 0 ]
}

@test "Basic command execution - pwd" {
    run ./dsh <<EOF
pwd
EOF
    [[ "$output" == *"$(pwd)"* ]]
    [ "$status" -eq 0 ]
}

@test "Basic command execution - uname" {
    run ./dsh <<EOF
uname
EOF
    [[ "$output" == *"$(uname)"* ]]
    [ "$status" -eq 0 ]
}

@test "Basic command execution - non-existent command" {
    run ./dsh <<EOF
bruh
EOF
    [ "$status" -eq 0 ]
}

@test "Built-in command - exit" {
    run ./dsh <<EOF
exit
EOF
    [ "$status" -eq 249 ]
}

@test "Built-in command - dragon" {
    run ./dsh <<EOF
dragon
EOF
    [ "$status" -eq 0 ]
}

@test "Built-in command - cd with argument" {
    run ./dsh <<EOF
cd /tmp
pwd
EOF
    [[ "$output" == *"/tmp"* ]]
    [ "$status" -eq 0 ]
}

@test "Built-in command - cd without argument" {
    run ./dsh <<EOF
cd
pwd
EOF
    [[ "$output" == *"$(pwd)"* ]]
    [ "$status" -eq 0 ]
}

@test "Handles quoted spaces correctly" {
    run ./dsh <<EOF
echo "hello     world"
EOF
    [[ "$output" == *"hello     world"* ]]
    [ "$status" -eq 0 ]
}

@test "Handles multiple spaces between commands" {
    run ./dsh <<EOF
ls      -l
EOF
    [[ "$output" == *"$(ls -l)"* ]]
    [ "$status" -eq 0 ]
}

@test "Handles leading spaces before commands" {
    run ./dsh <<EOF
  ls -lart
EOF
    [[ "$output" == *"$(ls -lart)"* ]]
    [ "$status" -eq 0 ]
}

@test "Empty command (just pressing enter)" {
    run ./dsh <<EOF

EOF
    [[ "$output" == *"warning: no commands provided"* ]]
    [ "$status" -eq 0 ]
}
