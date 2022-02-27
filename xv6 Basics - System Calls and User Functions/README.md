# xv6 Basics
### Installing xv6
1. Clone the original xv6 repository by running  
	
	`git clone https://github.com/mit-pdos/xv6-public`
	
2. Install an emulator to boot xv6 (here we use qemu)  
	
	`sudo apt-install qemu` 
	
3. Run xv6
	- to run in a new terminal: `make qemu`
	- to run in the same terminal: `make qemu-nox`
	
### Adding System calls
Adding a new system call `getsize` for getting process size:

1. `syscall.h`
 - **line 23** #define SYS_getsize 22
2. `syscall.c` 
 - **line 106** extern int sys_getsize(void);
 - **line 135** [SYS_getsize] sys_getsize
3. `usys.S`
 - **line 32** SYSCALL(getsize)
4. `user.h`
 - **line 27** int getsize(void);
5. `sysproc.c`
	- **line 46**
	- 		int
			sys_getsize(void)
			{	
				return myproc()->sz;
			}

 - If the system call works on files, add it to `sysfile.c` instead.


### Adding user functions
Adding a new user function `hello` that calls `getsize`:

1. `hello.c`
	- Write the new `.c` file 
	- Use xv6 headers, not gcc/ g++ headers
	- 
			#include "types.h"
			#include "stat.h"
			#include "user.h"


			int main(void)
			{

			    printf(1, "Hello world!\n");
			    printf(1, "%d\n", getsize());
			    exit();
			}
2. `Makefile`
 - **line 185** inside `UPROGS` add `_hello\`
 - **line 260** inside `EXTRA` add `hello.c` 
3. run `make qemu-nox`


