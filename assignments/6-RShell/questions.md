1. How does the remote client determine when a command's output is fully received from the server, and what techniques can be used to handle partial reads or ensure complete message transmission?

The client uses a null terminator `(\0)` to mark the end of a command’s output. To handle partial reads, the buffer size should include this terminator (buffer size + 1), ensuring the server knows when to stop reading.

2. This week's lecture on TCP explains that it is a reliable stream protocol rather than a message-oriented one. Since TCP does not preserve message boundaries, how should a networked shell protocol define and detect the beginning and end of a command sent over a TCP connection? What challenges arise if this is not handled correctly?

Since TCP is a continuous stream and doesn’t keep message boundaries, a shell should use a null terminator or delimiter to separate commands. Without this, commands may be misread or merged, leading to errors.

3. Describe the general differences between stateful and stateless protocols.

Stateless protocols handle each request independently, while stateful ones remember past interactions. Stateless is simpler and scalable, while stateful allows ongoing context.

4. Our lecture this week stated that UDP is "unreliable". If that is the case, why would we ever use it?

UDP is faster and has less delay, making it great for live streaming, online gaming, and VoIP, where speed matters more than perfect data transer

5. What interface/abstraction is provided by the operating system to enable applications to use network communications?

The Sockets API provides functions like `send()`, `recv()`, and `connect()` for handling network connections using TCP or UDP.
