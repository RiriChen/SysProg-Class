1. Can you think of why we use `fork/execvp` instead of just calling `execvp` directly? What value do you think the `fork` provides?

    > **Answer**: We use `fork()` to create a new child process that is an exact copy of its parent in terms of memory, file descriptors, and execution state. This new child process then can execute the syscall of `execvp()` to replace this newly made child process with whatever new program that needs to be excuted while keeping intact the parent process. If we called `execvp()` directly in the drexel shell application, the shell itself would be replaced by the new program, making it impossible to return control to the user after execution. The `fork()` function ensures that the shell remains active while running external commands in a separate process.

2. What happens if the `fork()` system call fails? How does your implementation handle this scenario?

    > **Answer**:  If `fork()` fails, it returns `-1`, which means no child process was created. This commonly happens due to resource exhaustion (aka too many processes running). My implementation checks the return value of `fork()`, and if it fails, it prints an error message to stderr using `fprintf(stderr, "error: fork failed.\n")` and returns `ERR_EXEC_CMD`.

3. How does `execvp()` find the command to execute? What system environment variable plays a role in this process?

    > **Answer**:  `execvp()` searches for the specified command in the directories listed in the `PATH` environment variable. If the command is not found in any of these directories, `execvp()` returns an error (`-1`) and sets `errno` which is relavant in the extra credit.

4. What is the purpose of calling `wait()` in the parent process after forking? What would happen if we didn’t call it?

    > **Answer**:  The parent process calls `wait()` or `waitpid()` to halt parent execution until the child process is finished executing. This function call would prevent the child from becoming a zombie process, meaning the process has completed execution but remains in the process table. If `wait()` or `waitpid()` is not called, the system may accumulate these dead processes which could eventually lead to a resource exhaustion.

5. In the referenced demo code we used `WEXITSTATUS()`. What information does this provide, and why is it important?

    > **Answer**:  `WEXITSTATUS(status)` extracts the exit status of the child process from the value returned by `wait()` or `waitpid()`. This gives the shell an idea if the child process' execution was successful or not, which can be useful for error handling.

6. Describe how your implementation of `build_cmd_buff()` handles quoted arguments. Why is this necessary?

    > **Answer**:  My implementation iterates through every character within `cmd_buff->_cmd_buffer` using pointers. I have a flag, `quotes`, to indicate the presence of quotation marks. If `quotes` is true, my code will instead of using the space character as the delimiter, it uses quotations. The code then  makes everything within the quotations one argument. This implementaiton is necessary to handle cases like `echo "hello, world"`, where `"hello, world"` should be treated as a single argument even if there is a space within the quotes.

7. What changes did you make to your parsing logic compared to the previous assignment? Were there any unexpected challenges in refactoring your old code?

    > **Answer**:  Compared to the previous assignment, I modified the parsing logic to support quoted arguments which means I was unfortunetely not able to utilize the `strtok()`. I had some challanges at first storing the right string into into `cmd_buff->argv` since sometimes my implementation stored the wrong string, but only took a few tweaks to fix teh issue.

8. For this quesiton, you need to do some research on Linux signals. You can use [this google search](https://www.google.com/search?q=Linux+signals+overview+site%3Aman7.org+OR+site%3Alinux.die.net+OR+site%3Atldp.org&oq=Linux+signals+overview+site%3Aman7.org+OR+site%3Alinux.die.net+OR+site%3Atldp.org&gs_lcrp=EgZjaHJvbWUyBggAEEUYOdIBBzc2MGowajeoAgCwAgA&sourceid=chrome&ie=UTF-8) to get started.

- What is the purpose of signals in a Linux system, and how do they differ from other forms of interprocess communication (IPC)?

    > **Answer**:  Signals are a form of interprocess communication (IPC) used to notify processes of events asynchronously. Unlike pipes or shared memory, signals do not transfer data; they instead interrupt a process to handle an event.

- Find and describe three commonly used signals (e.g., `SIGKILL`, `SIGTERM`, `SIGINT`). What are their typical use cases?

    > **Answer**:  `SIGKILL` immediately terminates a process and cannot be ignored and is used when a process must be forcefully stopped. `SIGTERM` requests a process to terminate, allowing cleanup and is the default signal sent by `kill <pid>`. `SIGINT` is sent when th  user presses `Ctrl+C` to terminate the program from teh terminal.

- What happens when a process receives `SIGSTOP`? Can it be caught or ignored like `SIGINT`? Why or why not?

    > **Answer**:  `SIGSTOP` pauses a process until it receives `SIGCONT`. Unlike `SIGINT`, it cannot be caught, ignored, or blocked, ensuring that administrators can always pause a process.
