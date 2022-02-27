# xv6 Basics

### Adding System calls
Steps for adding a new system call for getting process size add the following:

1. syscall.h
 - **line 23** #define SYS_getsize 22
2. syscall.c 
 - **line 106** extern int sys_getsize(void);
 - **line 135** [SYS_getsize] sys_getsize
3. usys.S
 - **line 32** SYSCALL(getsize)
4. user.h
 - **line 27** int getsize(void);
5. sysproc.c
 - **line 46**
	 	int
		sys_getsize(void)
		{
  			return myproc()->sz;
		}

If the system call works on files, add it in sysfile.c in step 5.




