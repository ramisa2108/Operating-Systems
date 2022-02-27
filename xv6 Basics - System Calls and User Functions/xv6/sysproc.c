#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "stat.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_getsize(void)
{
  return myproc()->sz;
}

void 
sys_quitqemu(void)
{
  outw(0xB004, 0x0|0x2000);
  outw(0x604, 0x0|0x2000);
}

int 
sys_incr(void)
{
  int x;
  argint(0, &x);
  return (x + 1);
}

int sys_add(void)
{
  struct intstruct *allnumbers;
  argptr(0, (void *)&allnumbers, sizeof(*allnumbers));
  int sum = 0;
  int i;

  for(i=0;i<allnumbers->sz;i++){
    sum += allnumbers->nums[i];
  }
  return sum;
}

char* 
sys_substr(void)
{
  char *s;
  int start, len;
  
  argint(1, &start);
  argint(2, &len);
  argstr(0, &s);

  char *subs = &s[start];
  
  int i,j;
  for(i=1, j=start+1; i<len;i++, j++){
    subs[i] = s[j];
  }
  subs[i] = '\0';

  

  return subs;

}

int 
sys_getreadcount(void){

  return myproc()->readcount;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
