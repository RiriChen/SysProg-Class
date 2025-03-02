1. Your shell forks multiple child processes when executing piped commands. How does your implementation ensure that all child processes complete before the shell continues accepting user input? What would happen if you forgot to call waitpid() on all child processes?

In the `execute_pipeline()` function, the parent process calls `waitpid()` for each child process after forking them using a for loop. This ensures that all the child processes are complete before the shell continues. If `waitpid()` is not called, the shell would not wait for the child processes to complete. This could lead to zombie processes and the shell might accept new user input before the piped commands have finished executing which could lead to unpredictable behavior.

2. The `dup2()` function is used to redirect input and output file descriptors. Explain why it is necessary to close unused pipe ends after calling `dup2()`. What could go wrong if you leave pipes open?

If unused pipe ends are not closed, there could be resource leaks (run out of file descriptors), deadlocks, and unexpected behavior. For example, if a pipe is not closed in the parent process, the child process might not receive an `EOF` signal, causing the process to stall forever.

3. Your shell recognizes built-in commands (`cd`, `exit`, `dragon`). Unlike external commands, built-in commands do not require `execvp()`. Why is cd implemented as a built-in rather than an external command? What challenges would arise if `cd` were implemented as an external process?

If `cd` were implemented as an external command, it would change the working directory of the child process but not the parent shell process. By implementing cd as a built-in command, it directly modifies the shell's working directory using the `chdir()` system call. Some of the challenges that would arise if `cd` were implemented as an external process would be ineffectiveness and complexity that just isn't worth it.

4. Currently, your shell supports a fixed number of piped commands (`CMD_MAX`). How would you modify your implementation to allow an arbitrary number of piped commands while still handling memory allocation efficiently? What trade-offs would you need to consider?

To allow an arbitrary numver of piped commands while still handling memory allocation efficiently, memory can be dynamically allocated for the pipes and pids arrays based on the number of commands in the pipeline. The issue with this approach is that dynamic memory allocation would always lead to risk of memory leaks, error handloing needed, worst in performance since dynamic memory allocation is slow, and this implementation would be more difficult to make work.
