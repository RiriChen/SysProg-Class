#!/usr/bin/env bats

# File: student_tests.sh
# Create your unit tests suite in this file

@test "Test basic command execution (ls)" {
    run ./dsh <<EOF
ls
EOF
    [[ "$output" == *"$(ls)"* ]]
    [ "$status" -eq 0 ]
}

@test "Test multiple piped commands (ls | grep .c | wc -l)" {
    run ./dsh <<EOF
ls | grep .c | wc -l
EOF
    stripped_output=$(echo "$output" | tr -d '[:space:]')

    expected_output="3dsh3>dsh3>cmdloopreturned0"

    echo "Captured stdout:"
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    [ "$stripped_output" = "$expected_output" ]
    [ "$status" -eq 0 ]
}

@test "Test empty command" {
    run ./dsh <<EOF

EOF
    [[ "$output" == *"warning: no commands provided"* ]]
    [ "$status" -eq 0 ]
}

@test "Test invalid command" {
    run ./dsh <<EOF
bruh
EOF
    [[ "$output" == *"error: fail to execute external commands"* ]]
    [ "$status" -eq 0 ]
}

@test "Test too many pipes" {
    run ./dsh <<EOF
ls | grep .c | wc -l | cat | more | cat | cat | cat | cat | cat
EOF
    [[ "$output" == *"error: piping limited to 8 commands"* ]]
    [ "$status" -eq 0 ]
}

@test "Test command with arguments (echo hello)" {
    run ./dsh <<EOF
echo hello
EOF
    stripped_output=$(echo "$output" | tr -d '[:space:]')

    expected_output="hellodsh3>dsh3>cmdloopreturned0"

    echo "Captured stdout:"
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    [ "$stripped_output" = "$expected_output" ]
    [ "$status" -eq 0 ]
}

#@test "Test command with redirection (echo hello > output.txt)" {
#    run ./dsh <<EOF
#echo hello > output.txt
#EOF
#    [ -f "output.txt" ]
#    [ "$(cat output.txt)" = "hello" ]
#    [ "$status" -eq 0 ]
#
#    rm output.txt
#}

#@test "Test command with append redirection (echo world >> output.txt)" {
#    echo "hello" > output.txt
#
#    run ./dsh <<EOF
#echo world >> output.txt
#EOF
#    [ "$(cat output.txt)" = "hello\nworld" ]
#    [ "$status" -eq 0 ]
#
#    rm output.txt
#}

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
