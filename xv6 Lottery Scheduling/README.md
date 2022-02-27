# xv6 Lottery Scheduling

**Idea of lottery scheduling**: 

Each running process is assigned a slice of the processor based on the number of tickets it has; the more tickets a process has, the more it runs. Each time slice, a randomized lottery determines the winner of the lottery; that winning process is the one that runs for that time slice.


Changes made in xv6:

- `Makefile`  
	CPUS set to 1

- `defs.h`  
	New function declarations

- `pstat.h`  
	Header file that constains `struct pstat` to hold process state information

- `proc.h`  
	tickets and ticks added to `struct proc`

- `proc.c`  
    - `generate_random` : generating random number of tickets  
    - `allocproc(void), fork(void)` : process tickets and ticks initialization  
    - `scheduler(void)` : lottery scheduling implementation  
    - `settickets` : setting tickets for a given proc id  
    - `getpinfo` : copying info from process table into a `pstat` pointer  
	
- `sysproc.c`  
    - `sys_settickets` : for calling `settickets` in `proc.c`  
    - `sys_getpinfo` : for calling `getpinfo` in `proc.c`  

- `syscall.c, syscall.h, usys.S, user.h`  
	new system calls informations

- `schedtest.c`  
    new user function for testing lottery scheduling
  	
- Check `lottery.patch` for details of the changes

