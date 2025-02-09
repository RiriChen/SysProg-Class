1. In this assignment I suggested you use `fgets()` to get user input in the main while loop. Why is `fgets()` a good choice for this application?

    > **Answer**:  `fgets()` is a good choice for this application because it stops reading after an EOF or newline which essentially makes the shell a "line by line" processor. Each line is considered its own command similar to other shells.

2. You needed to use `malloc()` to allocte memory for `cmd_buff` in `dsh_cli.c`. Can you explain why you needed to do that, instead of allocating a fixed-size array?

    > **Answer**: Using `malloc()` over allocating a fixed-size array improves memory managment, prevents stack overflow, and makes the application more scalable and modular for the future. Sizing of the `cmd_buff` can vary, so dynamically allocating the memory is good practice.


3. In `dshlib.c`, the function `build_cmd_list(`)` must trim leading and trailing spaces from each command before storing it. Why is this necessary? If we didn't trim spaces, what kind of issues might arise when executing commands in our shell?

    > **Answer**: It is necessary to trim the leading and trailing spaces from each command before storing because it would cause issues with certain functions like `strtok()`, proper command matching such as ` ls` not being matched to `ls` even though there is only a leading space difference, and any parsing issues that may occur.

4. For this question you need to do some research on STDIN, STDOUT, and STDERR in Linux. We've learned this week that shells are "robust brokers of input and output". Google _"linux shell stdin stdout stderr explained"_ to get started.

- One topic you should have found information on is "redirection". Please provide at least 3 redirection examples that we should implement in our custom shell, and explain what challenges we might have implementing them.

    > **Answer**:  Output redirection for overwrite (`>`), append redirection (`>>`), and input redirection (`<`). These redirections should be implemented so we could write certain content to a file either overwriting the file or appending to it, and also feed the contents of a file into a command. These implementations could be troublesome since we need to parse `>`, `>>`, and `<`, use `open()` with the appropiate flags to gain access to a file, and it would become more difficult with multiple arguments and multiple redirections with different types too.

- You should have also learned about "pipes". Redirection and piping both involve controlling input and output in the shell, but they serve different purposes. Explain the key differences between redirection and piping.

    > **Answer**:  Redirection is used for file-based input/output handling while piping is for real-time communications between commands. Redirection is a lot more efficient when dealing with files, but piping allows command chaining by sending one command’s output as another command’s input immediately, without writing to a file. Both are useful, but are used for different situations.

- STDERR is often used for error messages, while STDOUT is for regular output. Why is it important to keep these separate in a shell?

    > **Answer**:  They occupy different file descriptors which would make the debugging and loggig process more clear and easier.

- How should our custom shell handle errors from commands that fail? Consider cases where a command outputs both STDOUT and STDERR. Should we provide a way to merge them, and if so, how?

    > **Answer**:  Our custom shell should clearly display errors without suppressing them and allow users to redirect STDERR separately or merge it with STDOUT. We should check exit codes ($?) to detect failures and provide meaningful feedback.
