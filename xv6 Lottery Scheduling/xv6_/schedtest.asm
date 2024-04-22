
_schedtest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
            break;
    }
}

int main(int argc, char *argv[])
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	57                   	push   %edi
  12:	56                   	push   %esi
  13:	53                   	push   %ebx
  14:	51                   	push   %ecx
  15:	81 ec 18 09 00 00    	sub    $0x918,%esp
  1b:	8b 01                	mov    (%ecx),%eax
  1d:	8b 59 04             	mov    0x4(%ecx),%ebx
  20:	89 85 e0 f6 ff ff    	mov    %eax,-0x920(%ebp)
    if (argc < 3) {
  26:	83 f8 02             	cmp    $0x2,%eax
  29:	0f 8e 28 02 00 00    	jle    257 <main+0x257>
                  argv[0]);
        exit();
    }
    int tickets_for[MAX_CHILDREN];
    int active_pids[MAX_CHILDREN];
    int num_seconds = atoi(argv[1]);
  2f:	83 ec 0c             	sub    $0xc,%esp
  32:	ff 73 04             	pushl  0x4(%ebx)
  35:	e8 c6 06 00 00       	call   700 <atoi>
    int num_children = argc - 2;
    if (num_children > MAX_CHILDREN) {
  3a:	83 c4 10             	add    $0x10,%esp
    int num_seconds = atoi(argv[1]);
  3d:	89 c7                	mov    %eax,%edi
    int num_children = argc - 2;
  3f:	8b 85 e0 f6 ff ff    	mov    -0x920(%ebp),%eax
  45:	83 e8 02             	sub    $0x2,%eax
  48:	89 85 e4 f6 ff ff    	mov    %eax,-0x91c(%ebp)
    if (num_children > MAX_CHILDREN) {
  4e:	83 f8 20             	cmp    $0x20,%eax
  51:	0f 8f ec 01 00 00    	jg     243 <main+0x243>
        printf(2, "only up to %d supported\n", MAX_CHILDREN);
        exit();
    }
    /* give us a lot of ticket so we don't get starved */
    settickets(LARGE_TICKET_COUNT);
  57:	83 ec 0c             	sub    $0xc,%esp
    for (int i = 0; i < num_children; ++i) {
  5a:	31 f6                	xor    %esi,%esi
    settickets(LARGE_TICKET_COUNT);
  5c:	68 a0 86 01 00       	push   $0x186a0
  61:	e8 ad 07 00 00       	call   813 <settickets>
    for (int i = 0; i < num_children; ++i) {
  66:	89 bd dc f6 ff ff    	mov    %edi,-0x924(%ebp)
  6c:	89 f7                	mov    %esi,%edi
  6e:	89 de                	mov    %ebx,%esi
  70:	8b 9d e4 f6 ff ff    	mov    -0x91c(%ebp),%ebx
  76:	83 c4 10             	add    $0x10,%esp
  79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        int tickets = atoi(argv[i + 2]);
  80:	83 ec 0c             	sub    $0xc,%esp
  83:	ff 74 be 08          	pushl  0x8(%esi,%edi,4)
  87:	e8 74 06 00 00       	call   700 <atoi>
        tickets_for[i] = tickets;
  8c:	89 84 bd e8 f6 ff ff 	mov    %eax,-0x918(%ebp,%edi,4)
        active_pids[i] = spawn(tickets);
  93:	89 04 24             	mov    %eax,(%esp)
  96:	e8 b5 02 00 00       	call   350 <spawn>
    for (int i = 0; i < num_children; ++i) {
  9b:	83 c4 10             	add    $0x10,%esp
        active_pids[i] = spawn(tickets);
  9e:	89 84 bd 68 f7 ff ff 	mov    %eax,-0x898(%ebp,%edi,4)
    for (int i = 0; i < num_children; ++i) {
  a5:	89 f8                	mov    %edi,%eax
  a7:	8d 7f 01             	lea    0x1(%edi),%edi
  aa:	39 df                	cmp    %ebx,%edi
  ac:	75 d2                	jne    80 <main+0x80>
    }
    wait_for_ticket_counts(num_children, active_pids, tickets_for);
  ae:	83 ec 04             	sub    $0x4,%esp
  b1:	8b bd dc f6 ff ff    	mov    -0x924(%ebp),%edi
  b7:	89 85 dc f6 ff ff    	mov    %eax,-0x924(%ebp)
  bd:	8d 85 e8 f6 ff ff    	lea    -0x918(%ebp),%eax
  c3:	50                   	push   %eax
  c4:	8d 85 68 f7 ff ff    	lea    -0x898(%ebp),%eax
  ca:	50                   	push   %eax
  cb:	ff b5 e4 f6 ff ff    	pushl  -0x91c(%ebp)
  d1:	e8 4a 03 00 00       	call   420 <wait_for_ticket_counts>
    struct pstat before, after;
    getpinfo(&before);
  d6:	8d 85 e8 f7 ff ff    	lea    -0x818(%ebp),%eax
  dc:	89 04 24             	mov    %eax,(%esp)
  df:	e8 37 07 00 00       	call   81b <getpinfo>
    for(int i=0; i<NPROC; ++i){
  e4:	8d 85 e8 f7 ff ff    	lea    -0x818(%ebp),%eax
  ea:	83 c4 10             	add    $0x10,%esp
    int num_processes = 0;
  ed:	31 d2                	xor    %edx,%edx
  ef:	8d 8d e8 f8 ff ff    	lea    -0x718(%ebp),%ecx
  f5:	8d 76 00             	lea    0x0(%esi),%esi
        num_processes += inuse[i];
  f8:	03 10                	add    (%eax),%edx
  fa:	83 c0 04             	add    $0x4,%eax
  fd:	89 d3                	mov    %edx,%ebx
    for(int i=0; i<NPROC; ++i){
  ff:	39 c1                	cmp    %eax,%ecx
 101:	75 f5                	jne    f8 <main+0xf8>
    int before_num_processes = get_num_process(before.inuse);
    sleep(num_seconds);
 103:	83 ec 0c             	sub    $0xc,%esp
 106:	57                   	push   %edi
 107:	8d bd e8 fc ff ff    	lea    -0x318(%ebp),%edi
 10d:	e8 f1 06 00 00       	call   803 <sleep>
    getpinfo(&after);
 112:	8d 85 e8 fb ff ff    	lea    -0x418(%ebp),%eax
 118:	89 04 24             	mov    %eax,(%esp)
 11b:	e8 fb 06 00 00       	call   81b <getpinfo>
    for(int i=0; i<NPROC; ++i){
 120:	8d 85 e8 fb ff ff    	lea    -0x418(%ebp),%eax
 126:	83 c4 10             	add    $0x10,%esp
    int num_processes = 0;
 129:	31 c9                	xor    %ecx,%ecx
 12b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 12f:	90                   	nop
        num_processes += inuse[i];
 130:	8b 30                	mov    (%eax),%esi
 132:	83 c0 04             	add    $0x4,%eax
 135:	01 ce                	add    %ecx,%esi
 137:	89 f1                	mov    %esi,%ecx
    for(int i=0; i<NPROC; ++i){
 139:	39 f8                	cmp    %edi,%eax
 13b:	75 f3                	jne    130 <main+0x130>
 13d:	8b 85 e0 f6 ff ff    	mov    -0x920(%ebp),%eax
 143:	8d bd 68 f7 ff ff    	lea    -0x898(%ebp),%edi
 149:	89 9d e0 f6 ff ff    	mov    %ebx,-0x920(%ebp)
 14f:	89 fb                	mov    %edi,%ebx
 151:	8d 84 85 60 f7 ff ff 	lea    -0x8a0(%ebp,%eax,4),%eax
 158:	89 c7                	mov    %eax,%edi
 15a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    int after_num_processes = get_num_process(after.inuse);
    for (int i = 0; i < num_children; ++i) {
        kill(active_pids[i]);
 160:	83 ec 0c             	sub    $0xc,%esp
 163:	ff 33                	pushl  (%ebx)
 165:	83 c3 04             	add    $0x4,%ebx
 168:	e8 36 06 00 00       	call   7a3 <kill>
    for (int i = 0; i < num_children; ++i) {
 16d:	83 c4 10             	add    $0x10,%esp
 170:	39 df                	cmp    %ebx,%edi
 172:	75 ec                	jne    160 <main+0x160>
    }
    for (int i = 0; i < num_children; ++i) {
 174:	31 ff                	xor    %edi,%edi
 176:	89 fb                	mov    %edi,%ebx
 178:	8b bd dc f6 ff ff    	mov    -0x924(%ebp),%edi
 17e:	66 90                	xchg   %ax,%ax
        wait();
 180:	e8 f6 05 00 00       	call   77b <wait>
    for (int i = 0; i < num_children; ++i) {
 185:	89 d8                	mov    %ebx,%eax
 187:	83 c3 01             	add    $0x1,%ebx
 18a:	39 c7                	cmp    %eax,%edi
 18c:	75 f2                	jne    180 <main+0x180>
 18e:	8b 9d e0 f6 ff ff    	mov    -0x920(%ebp),%ebx
    }
    if (before_num_processes >= NPROC || after_num_processes >= NPROC) {
 194:	83 fb 3f             	cmp    $0x3f,%ebx
 197:	7f 05                	jg     19e <main+0x19e>
 199:	83 fe 3f             	cmp    $0x3f,%esi
 19c:	7e 20                	jle    1be <main+0x1be>
        printf(2, "getpinfo's num_processes is greater than NPROC before parent slept\n");
 19e:	83 ec 08             	sub    $0x8,%esp
 1a1:	68 44 0d 00 00       	push   $0xd44
 1a6:	6a 02                	push   $0x2
 1a8:	e8 33 07 00 00       	call   8e0 <printf>
            }
            printf(1, "%d\t%d\n", tickets_for[i], after.ticks[after_index] - before.ticks[before_index]);
        }
    }
    exit();
 1ad:	8d 65 f0             	lea    -0x10(%ebp),%esp
 1b0:	b8 01 00 00 00       	mov    $0x1,%eax
 1b5:	59                   	pop    %ecx
 1b6:	5b                   	pop    %ebx
 1b7:	5e                   	pop    %esi
 1b8:	5f                   	pop    %edi
 1b9:	5d                   	pop    %ebp
 1ba:	8d 61 fc             	lea    -0x4(%ecx),%esp
 1bd:	c3                   	ret    
    printf(1, "TICKETS\tTICKS\n");
 1be:	50                   	push   %eax
    for (int i = 0; i < num_children; ++i) {
 1bf:	31 ff                	xor    %edi,%edi
    printf(1, "TICKETS\tTICKS\n");
 1c1:	50                   	push   %eax
 1c2:	68 70 0c 00 00       	push   $0xc70
 1c7:	6a 01                	push   $0x1
 1c9:	e8 12 07 00 00       	call   8e0 <printf>
    for (int i = 0; i < num_children; ++i) {
 1ce:	89 9d e0 f6 ff ff    	mov    %ebx,-0x920(%ebp)
    printf(1, "TICKETS\tTICKS\n");
 1d4:	83 c4 10             	add    $0x10,%esp
    for (int i = 0; i < num_children; ++i) {
 1d7:	89 b5 dc f6 ff ff    	mov    %esi,-0x924(%ebp)
        int before_index = find_index_of_pid(before.pid, before_num_processes, active_pids[i]);
 1dd:	8b 8c bd 68 f7 ff ff 	mov    -0x898(%ebp,%edi,4),%ecx
    for (int i = 0; i < list_size; ++i) {
 1e4:	31 db                	xor    %ebx,%ebx
 1e6:	eb 0c                	jmp    1f4 <main+0x1f4>
        if (list[i] == pid)
 1e8:	3b 8c 9d e8 f9 ff ff 	cmp    -0x618(%ebp,%ebx,4),%ecx
 1ef:	74 0e                	je     1ff <main+0x1ff>
    for (int i = 0; i < list_size; ++i) {
 1f1:	83 c3 01             	add    $0x1,%ebx
 1f4:	39 9d e0 f6 ff ff    	cmp    %ebx,-0x920(%ebp)
 1fa:	7f ec                	jg     1e8 <main+0x1e8>
    return -1;
 1fc:	83 cb ff             	or     $0xffffffff,%ebx
    for (int i = 0; i < list_size; ++i) {
 1ff:	31 f6                	xor    %esi,%esi
 201:	eb 0c                	jmp    20f <main+0x20f>
        if (list[i] == pid)
 203:	3b 8c b5 e8 fd ff ff 	cmp    -0x218(%ebp,%esi,4),%ecx
 20a:	74 5f                	je     26b <main+0x26b>
    for (int i = 0; i < list_size; ++i) {
 20c:	83 c6 01             	add    $0x1,%esi
 20f:	39 b5 dc f6 ff ff    	cmp    %esi,-0x924(%ebp)
 215:	7f ec                	jg     203 <main+0x203>
        if (before_index == -1)
 217:	83 c3 01             	add    $0x1,%ebx
 21a:	75 11                	jne    22d <main+0x22d>
            printf(2, "child %d did not exist for getpinfo before parent slept\n", i);
 21c:	50                   	push   %eax
 21d:	57                   	push   %edi
 21e:	68 88 0d 00 00       	push   $0xd88
 223:	6a 02                	push   $0x2
 225:	e8 b6 06 00 00       	call   8e0 <printf>
 22a:	83 c4 10             	add    $0x10,%esp
            printf(2, "child %d did not exist for getpinfo after parent slept\n", i);
 22d:	56                   	push   %esi
 22e:	57                   	push   %edi
 22f:	68 c4 0d 00 00       	push   $0xdc4
 234:	6a 02                	push   $0x2
 236:	e8 a5 06 00 00       	call   8e0 <printf>
 23b:	83 c4 10             	add    $0x10,%esp
 23e:	e9 bb 00 00 00       	jmp    2fe <main+0x2fe>
        printf(2, "only up to %d supported\n", MAX_CHILDREN);
 243:	50                   	push   %eax
 244:	6a 20                	push   $0x20
 246:	68 57 0c 00 00       	push   $0xc57
 24b:	6a 02                	push   $0x2
 24d:	e8 8e 06 00 00       	call   8e0 <printf>
        exit();
 252:	e8 1c 05 00 00       	call   773 <exit>
        printf(2, "usage: %s seconds tickets1 tickets2 ... ticketsN\n"
 257:	50                   	push   %eax
 258:	ff 33                	pushl  (%ebx)
 25a:	68 98 0c 00 00       	push   $0xc98
 25f:	6a 02                	push   $0x2
 261:	e8 7a 06 00 00       	call   8e0 <printf>
        exit();
 266:	e8 08 05 00 00       	call   773 <exit>
        if (before_index == -1)
 26b:	83 fb ff             	cmp    $0xffffffff,%ebx
 26e:	74 7d                	je     2ed <main+0x2ed>
            if (before.tickets[before_index] != tickets_for[i]) {
 270:	8b 84 bd e8 f6 ff ff 	mov    -0x918(%ebp,%edi,4),%eax
 277:	39 84 9d e8 f8 ff ff 	cmp    %eax,-0x718(%ebp,%ebx,4)
 27e:	74 11                	je     291 <main+0x291>
                printf(2, "child %d had wrong number of tickets in getpinfo before parent slept\n", i);
 280:	51                   	push   %ecx
 281:	57                   	push   %edi
 282:	68 fc 0d 00 00       	push   $0xdfc
 287:	6a 02                	push   $0x2
 289:	e8 52 06 00 00       	call   8e0 <printf>
 28e:	83 c4 10             	add    $0x10,%esp
            if (after.tickets[after_index] != tickets_for[i]) {
 291:	8b 84 bd e8 f6 ff ff 	mov    -0x918(%ebp,%edi,4),%eax
 298:	39 84 b5 e8 fc ff ff 	cmp    %eax,-0x318(%ebp,%esi,4)
 29f:	74 11                	je     2b2 <main+0x2b2>
                printf(2, "child %d had wrong number of tickets in getpinfo after parent slept\n", i);
 2a1:	52                   	push   %edx
 2a2:	57                   	push   %edi
 2a3:	68 44 0e 00 00       	push   $0xe44
 2a8:	6a 02                	push   $0x2
 2aa:	e8 31 06 00 00       	call   8e0 <printf>
 2af:	83 c4 10             	add    $0x10,%esp
            printf(1, "%d\t%d\n", tickets_for[i], after.ticks[after_index] - before.ticks[before_index]);
 2b2:	8b 94 b5 e8 fe ff ff 	mov    -0x118(%ebp,%esi,4),%edx
 2b9:	89 d0                	mov    %edx,%eax
 2bb:	2b 84 9d e8 fa ff ff 	sub    -0x518(%ebp,%ebx,4),%eax
 2c2:	50                   	push   %eax
 2c3:	ff b4 bd e8 f6 ff ff 	pushl  -0x918(%ebp,%edi,4)
 2ca:	68 8f 0c 00 00       	push   $0xc8f
 2cf:	6a 01                	push   $0x1
 2d1:	e8 0a 06 00 00       	call   8e0 <printf>
 2d6:	83 c4 10             	add    $0x10,%esp
    for (int i = 0; i < num_children; ++i) {
 2d9:	83 c7 01             	add    $0x1,%edi
 2dc:	39 bd e4 f6 ff ff    	cmp    %edi,-0x91c(%ebp)
 2e2:	0f 8f f5 fe ff ff    	jg     1dd <main+0x1dd>
    exit();
 2e8:	e8 86 04 00 00       	call   773 <exit>
            printf(2, "child %d did not exist for getpinfo before parent slept\n", i);
 2ed:	50                   	push   %eax
 2ee:	57                   	push   %edi
 2ef:	68 88 0d 00 00       	push   $0xd88
 2f4:	6a 02                	push   $0x2
 2f6:	e8 e5 05 00 00       	call   8e0 <printf>
 2fb:	83 c4 10             	add    $0x10,%esp
            printf(1, "%d\t--unknown--\n", tickets_for[i]);
 2fe:	53                   	push   %ebx
 2ff:	ff b4 bd e8 f6 ff ff 	pushl  -0x918(%ebp,%edi,4)
 306:	68 7f 0c 00 00       	push   $0xc7f
 30b:	6a 01                	push   $0x1
 30d:	e8 ce 05 00 00       	call   8e0 <printf>
 312:	83 c4 10             	add    $0x10,%esp
 315:	eb c2                	jmp    2d9 <main+0x2d9>
 317:	66 90                	xchg   %ax,%ax
 319:	66 90                	xchg   %ax,%ax
 31b:	66 90                	xchg   %ax,%ax
 31d:	66 90                	xchg   %ax,%ax
 31f:	90                   	nop

00000320 <yield_forever>:
void yield_forever() {
 320:	f3 0f 1e fb          	endbr32 
 324:	55                   	push   %ebp
 325:	89 e5                	mov    %esp,%ebp
 327:	83 ec 08             	sub    $0x8,%esp
 32a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        yield();
 330:	e8 ee 04 00 00       	call   823 <yield>
    while (1) {
 335:	eb f9                	jmp    330 <yield_forever+0x10>
 337:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 33e:	66 90                	xchg   %ax,%ax

00000340 <run_forever>:
void run_forever() {
 340:	f3 0f 1e fb          	endbr32 
 344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while (1) {
 348:	eb fe                	jmp    348 <run_forever+0x8>
 34a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000350 <spawn>:
int spawn(int tickets) {
 350:	f3 0f 1e fb          	endbr32 
 354:	55                   	push   %ebp
 355:	89 e5                	mov    %esp,%ebp
 357:	53                   	push   %ebx
 358:	83 ec 04             	sub    $0x4,%esp
    int pid = fork();
 35b:	e8 0b 04 00 00       	call   76b <fork>
    if (pid == 0) {
 360:	85 c0                	test   %eax,%eax
 362:	74 0e                	je     372 <spawn+0x22>
 364:	89 c3                	mov    %eax,%ebx
    } else if (pid != -1) {
 366:	83 f8 ff             	cmp    $0xffffffff,%eax
 369:	74 25                	je     390 <spawn+0x40>
}
 36b:	89 d8                	mov    %ebx,%eax
 36d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 370:	c9                   	leave  
 371:	c3                   	ret    
        settickets(tickets);
 372:	83 ec 0c             	sub    $0xc,%esp
 375:	ff 75 08             	pushl  0x8(%ebp)
 378:	e8 96 04 00 00       	call   813 <settickets>
        yield();
 37d:	e8 a1 04 00 00       	call   823 <yield>
 382:	83 c4 10             	add    $0x10,%esp
    while (1) {
 385:	eb fe                	jmp    385 <spawn+0x35>
 387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 38e:	66 90                	xchg   %ax,%ax
        printf(2, "error in fork\n");
 390:	83 ec 08             	sub    $0x8,%esp
 393:	68 48 0c 00 00       	push   $0xc48
 398:	6a 02                	push   $0x2
 39a:	e8 41 05 00 00       	call   8e0 <printf>
 39f:	83 c4 10             	add    $0x10,%esp
 3a2:	eb c7                	jmp    36b <spawn+0x1b>
 3a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3af:	90                   	nop

000003b0 <find_index_of_pid>:
int find_index_of_pid(int *list, int list_size, int pid) {
 3b0:	f3 0f 1e fb          	endbr32 
 3b4:	55                   	push   %ebp
 3b5:	89 e5                	mov    %esp,%ebp
 3b7:	53                   	push   %ebx
 3b8:	8b 55 0c             	mov    0xc(%ebp),%edx
 3bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
 3be:	8b 5d 10             	mov    0x10(%ebp),%ebx
    for (int i = 0; i < list_size; ++i) {
 3c1:	85 d2                	test   %edx,%edx
 3c3:	7e 1b                	jle    3e0 <find_index_of_pid+0x30>
 3c5:	31 c0                	xor    %eax,%eax
 3c7:	eb 0e                	jmp    3d7 <find_index_of_pid+0x27>
 3c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3d0:	83 c0 01             	add    $0x1,%eax
 3d3:	39 c2                	cmp    %eax,%edx
 3d5:	74 09                	je     3e0 <find_index_of_pid+0x30>
        if (list[i] == pid)
 3d7:	39 1c 81             	cmp    %ebx,(%ecx,%eax,4)
 3da:	75 f4                	jne    3d0 <find_index_of_pid+0x20>
}
 3dc:	5b                   	pop    %ebx
 3dd:	5d                   	pop    %ebp
 3de:	c3                   	ret    
 3df:	90                   	nop
    return -1;
 3e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 3e5:	5b                   	pop    %ebx
 3e6:	5d                   	pop    %ebp
 3e7:	c3                   	ret    
 3e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3ef:	90                   	nop

000003f0 <get_num_process>:
int get_num_process(int *inuse){
 3f0:	f3 0f 1e fb          	endbr32 
 3f4:	55                   	push   %ebp
    int num_processes = 0;
 3f5:	31 d2                	xor    %edx,%edx
int get_num_process(int *inuse){
 3f7:	89 e5                	mov    %esp,%ebp
 3f9:	8b 45 08             	mov    0x8(%ebp),%eax
 3fc:	8d 88 00 01 00 00    	lea    0x100(%eax),%ecx
 402:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        num_processes += inuse[i];
 408:	03 10                	add    (%eax),%edx
    for(int i=0; i<NPROC; ++i){
 40a:	83 c0 04             	add    $0x4,%eax
 40d:	39 c8                	cmp    %ecx,%eax
 40f:	75 f7                	jne    408 <get_num_process+0x18>
}
 411:	89 d0                	mov    %edx,%eax
 413:	5d                   	pop    %ebp
 414:	c3                   	ret    
 415:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 41c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000420 <wait_for_ticket_counts>:
void wait_for_ticket_counts(int num_children, int *pids, int *tickets) {
 420:	f3 0f 1e fb          	endbr32 
 424:	55                   	push   %ebp
 425:	89 e5                	mov    %esp,%ebp
 427:	57                   	push   %edi
 428:	56                   	push   %esi
 429:	8d bd e8 fb ff ff    	lea    -0x418(%ebp),%edi
 42f:	53                   	push   %ebx
 430:	81 ec 1c 04 00 00    	sub    $0x41c,%esp
 436:	c7 85 dc fb ff ff 64 	movl   $0x64,-0x424(%ebp)
 43d:	00 00 00 
        yield();
 440:	e8 de 03 00 00       	call   823 <yield>
        getpinfo(&info);
 445:	83 ec 0c             	sub    $0xc,%esp
 448:	57                   	push   %edi
 449:	e8 cd 03 00 00       	call   81b <getpinfo>
        for (int i = 0; i < num_children; ++i) {
 44e:	8b 45 08             	mov    0x8(%ebp),%eax
 451:	83 c4 10             	add    $0x10,%esp
 454:	85 c0                	test   %eax,%eax
 456:	0f 8e a0 00 00 00    	jle    4fc <wait_for_ticket_counts+0xdc>
 45c:	c7 85 e4 fb ff ff 00 	movl   $0x0,-0x41c(%ebp)
 463:	00 00 00 
 466:	8d 9d e8 fc ff ff    	lea    -0x318(%ebp),%ebx
        int done = 1;
 46c:	c7 85 e0 fb ff ff 01 	movl   $0x1,-0x420(%ebp)
 473:	00 00 00 
 476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 47d:	8d 76 00             	lea    0x0(%esi),%esi
            int index = find_index_of_pid(info.pid, get_num_process(info.inuse), pids[i]);
 480:	8b 45 0c             	mov    0xc(%ebp),%eax
 483:	8b b5 e4 fb ff ff    	mov    -0x41c(%ebp),%esi
    int num_processes = 0;
 489:	31 c9                	xor    %ecx,%ecx
            int index = find_index_of_pid(info.pid, get_num_process(info.inuse), pids[i]);
 48b:	8b 34 b0             	mov    (%eax,%esi,4),%esi
    for(int i=0; i<NPROC; ++i){
 48e:	89 f8                	mov    %edi,%eax
        num_processes += inuse[i];
 490:	03 08                	add    (%eax),%ecx
 492:	83 c0 04             	add    $0x4,%eax
 495:	89 ca                	mov    %ecx,%edx
    for(int i=0; i<NPROC; ++i){
 497:	39 d8                	cmp    %ebx,%eax
 499:	75 f5                	jne    490 <wait_for_ticket_counts+0x70>
    for (int i = 0; i < list_size; ++i) {
 49b:	85 c9                	test   %ecx,%ecx
 49d:	7e 65                	jle    504 <wait_for_ticket_counts+0xe4>
 49f:	31 c0                	xor    %eax,%eax
 4a1:	eb 0c                	jmp    4af <wait_for_ticket_counts+0x8f>
 4a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4a7:	90                   	nop
 4a8:	83 c0 01             	add    $0x1,%eax
 4ab:	39 d0                	cmp    %edx,%eax
 4ad:	74 55                	je     504 <wait_for_ticket_counts+0xe4>
        if (list[i] == pid)
 4af:	3b b4 87 00 02 00 00 	cmp    0x200(%edi,%eax,4),%esi
 4b6:	75 f0                	jne    4a8 <wait_for_ticket_counts+0x88>
            if (info.tickets[index] != tickets[i]) done = 0;
 4b8:	8b b5 e4 fb ff ff    	mov    -0x41c(%ebp),%esi
 4be:	8b 55 10             	mov    0x10(%ebp),%edx
 4c1:	8b 14 b2             	mov    (%edx,%esi,4),%edx
 4c4:	39 94 85 e8 fc ff ff 	cmp    %edx,-0x318(%ebp,%eax,4)
 4cb:	b8 00 00 00 00       	mov    $0x0,%eax
 4d0:	0f 44 85 e0 fb ff ff 	cmove  -0x420(%ebp),%eax
        for (int i = 0; i < num_children; ++i) {
 4d7:	83 c6 01             	add    $0x1,%esi
 4da:	89 b5 e4 fb ff ff    	mov    %esi,-0x41c(%ebp)
            if (info.tickets[index] != tickets[i]) done = 0;
 4e0:	89 85 e0 fb ff ff    	mov    %eax,-0x420(%ebp)
        for (int i = 0; i < num_children; ++i) {
 4e6:	39 75 08             	cmp    %esi,0x8(%ebp)
 4e9:	75 95                	jne    480 <wait_for_ticket_counts+0x60>
        if (done)
 4eb:	85 c0                	test   %eax,%eax
 4ed:	75 0d                	jne    4fc <wait_for_ticket_counts+0xdc>
    for (int yield_count = 0; yield_count < MAX_YIELDS_FOR_SETUP; ++yield_count) {
 4ef:	83 ad dc fb ff ff 01 	subl   $0x1,-0x424(%ebp)
 4f6:	0f 85 44 ff ff ff    	jne    440 <wait_for_ticket_counts+0x20>
}
 4fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4ff:	5b                   	pop    %ebx
 500:	5e                   	pop    %esi
 501:	5f                   	pop    %edi
 502:	5d                   	pop    %ebp
 503:	c3                   	ret    
    return -1;
 504:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 509:	eb ad                	jmp    4b8 <wait_for_ticket_counts+0x98>
 50b:	66 90                	xchg   %ax,%ax
 50d:	66 90                	xchg   %ax,%ax
 50f:	90                   	nop

00000510 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 510:	f3 0f 1e fb          	endbr32 
 514:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 515:	31 c0                	xor    %eax,%eax
{
 517:	89 e5                	mov    %esp,%ebp
 519:	53                   	push   %ebx
 51a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 51d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
 520:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 524:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 527:	83 c0 01             	add    $0x1,%eax
 52a:	84 d2                	test   %dl,%dl
 52c:	75 f2                	jne    520 <strcpy+0x10>
    ;
  return os;
}
 52e:	89 c8                	mov    %ecx,%eax
 530:	5b                   	pop    %ebx
 531:	5d                   	pop    %ebp
 532:	c3                   	ret    
 533:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 53a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000540 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 540:	f3 0f 1e fb          	endbr32 
 544:	55                   	push   %ebp
 545:	89 e5                	mov    %esp,%ebp
 547:	53                   	push   %ebx
 548:	8b 4d 08             	mov    0x8(%ebp),%ecx
 54b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 54e:	0f b6 01             	movzbl (%ecx),%eax
 551:	0f b6 1a             	movzbl (%edx),%ebx
 554:	84 c0                	test   %al,%al
 556:	75 19                	jne    571 <strcmp+0x31>
 558:	eb 26                	jmp    580 <strcmp+0x40>
 55a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 560:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 564:	83 c1 01             	add    $0x1,%ecx
 567:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 56a:	0f b6 1a             	movzbl (%edx),%ebx
 56d:	84 c0                	test   %al,%al
 56f:	74 0f                	je     580 <strcmp+0x40>
 571:	38 d8                	cmp    %bl,%al
 573:	74 eb                	je     560 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 575:	29 d8                	sub    %ebx,%eax
}
 577:	5b                   	pop    %ebx
 578:	5d                   	pop    %ebp
 579:	c3                   	ret    
 57a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 580:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 582:	29 d8                	sub    %ebx,%eax
}
 584:	5b                   	pop    %ebx
 585:	5d                   	pop    %ebp
 586:	c3                   	ret    
 587:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 58e:	66 90                	xchg   %ax,%ax

00000590 <strlen>:

uint
strlen(const char *s)
{
 590:	f3 0f 1e fb          	endbr32 
 594:	55                   	push   %ebp
 595:	89 e5                	mov    %esp,%ebp
 597:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 59a:	80 3a 00             	cmpb   $0x0,(%edx)
 59d:	74 21                	je     5c0 <strlen+0x30>
 59f:	31 c0                	xor    %eax,%eax
 5a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5a8:	83 c0 01             	add    $0x1,%eax
 5ab:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 5af:	89 c1                	mov    %eax,%ecx
 5b1:	75 f5                	jne    5a8 <strlen+0x18>
    ;
  return n;
}
 5b3:	89 c8                	mov    %ecx,%eax
 5b5:	5d                   	pop    %ebp
 5b6:	c3                   	ret    
 5b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5be:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 5c0:	31 c9                	xor    %ecx,%ecx
}
 5c2:	5d                   	pop    %ebp
 5c3:	89 c8                	mov    %ecx,%eax
 5c5:	c3                   	ret    
 5c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5cd:	8d 76 00             	lea    0x0(%esi),%esi

000005d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 5d0:	f3 0f 1e fb          	endbr32 
 5d4:	55                   	push   %ebp
 5d5:	89 e5                	mov    %esp,%ebp
 5d7:	57                   	push   %edi
 5d8:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 5db:	8b 4d 10             	mov    0x10(%ebp),%ecx
 5de:	8b 45 0c             	mov    0xc(%ebp),%eax
 5e1:	89 d7                	mov    %edx,%edi
 5e3:	fc                   	cld    
 5e4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 5e6:	89 d0                	mov    %edx,%eax
 5e8:	5f                   	pop    %edi
 5e9:	5d                   	pop    %ebp
 5ea:	c3                   	ret    
 5eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5ef:	90                   	nop

000005f0 <strchr>:

char*
strchr(const char *s, char c)
{
 5f0:	f3 0f 1e fb          	endbr32 
 5f4:	55                   	push   %ebp
 5f5:	89 e5                	mov    %esp,%ebp
 5f7:	8b 45 08             	mov    0x8(%ebp),%eax
 5fa:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 5fe:	0f b6 10             	movzbl (%eax),%edx
 601:	84 d2                	test   %dl,%dl
 603:	75 16                	jne    61b <strchr+0x2b>
 605:	eb 21                	jmp    628 <strchr+0x38>
 607:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 60e:	66 90                	xchg   %ax,%ax
 610:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 614:	83 c0 01             	add    $0x1,%eax
 617:	84 d2                	test   %dl,%dl
 619:	74 0d                	je     628 <strchr+0x38>
    if(*s == c)
 61b:	38 d1                	cmp    %dl,%cl
 61d:	75 f1                	jne    610 <strchr+0x20>
      return (char*)s;
  return 0;
}
 61f:	5d                   	pop    %ebp
 620:	c3                   	ret    
 621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 628:	31 c0                	xor    %eax,%eax
}
 62a:	5d                   	pop    %ebp
 62b:	c3                   	ret    
 62c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000630 <gets>:

char*
gets(char *buf, int max)
{
 630:	f3 0f 1e fb          	endbr32 
 634:	55                   	push   %ebp
 635:	89 e5                	mov    %esp,%ebp
 637:	57                   	push   %edi
 638:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 639:	31 f6                	xor    %esi,%esi
{
 63b:	53                   	push   %ebx
 63c:	89 f3                	mov    %esi,%ebx
 63e:	83 ec 1c             	sub    $0x1c,%esp
 641:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 644:	eb 33                	jmp    679 <gets+0x49>
 646:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 64d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 650:	83 ec 04             	sub    $0x4,%esp
 653:	8d 45 e7             	lea    -0x19(%ebp),%eax
 656:	6a 01                	push   $0x1
 658:	50                   	push   %eax
 659:	6a 00                	push   $0x0
 65b:	e8 2b 01 00 00       	call   78b <read>
    if(cc < 1)
 660:	83 c4 10             	add    $0x10,%esp
 663:	85 c0                	test   %eax,%eax
 665:	7e 1c                	jle    683 <gets+0x53>
      break;
    buf[i++] = c;
 667:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 66b:	83 c7 01             	add    $0x1,%edi
 66e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 671:	3c 0a                	cmp    $0xa,%al
 673:	74 23                	je     698 <gets+0x68>
 675:	3c 0d                	cmp    $0xd,%al
 677:	74 1f                	je     698 <gets+0x68>
  for(i=0; i+1 < max; ){
 679:	83 c3 01             	add    $0x1,%ebx
 67c:	89 fe                	mov    %edi,%esi
 67e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 681:	7c cd                	jl     650 <gets+0x20>
 683:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 685:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 688:	c6 03 00             	movb   $0x0,(%ebx)
}
 68b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 68e:	5b                   	pop    %ebx
 68f:	5e                   	pop    %esi
 690:	5f                   	pop    %edi
 691:	5d                   	pop    %ebp
 692:	c3                   	ret    
 693:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 697:	90                   	nop
 698:	8b 75 08             	mov    0x8(%ebp),%esi
 69b:	8b 45 08             	mov    0x8(%ebp),%eax
 69e:	01 de                	add    %ebx,%esi
 6a0:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 6a2:	c6 03 00             	movb   $0x0,(%ebx)
}
 6a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6a8:	5b                   	pop    %ebx
 6a9:	5e                   	pop    %esi
 6aa:	5f                   	pop    %edi
 6ab:	5d                   	pop    %ebp
 6ac:	c3                   	ret    
 6ad:	8d 76 00             	lea    0x0(%esi),%esi

000006b0 <stat>:

int
stat(const char *n, struct stat *st)
{
 6b0:	f3 0f 1e fb          	endbr32 
 6b4:	55                   	push   %ebp
 6b5:	89 e5                	mov    %esp,%ebp
 6b7:	56                   	push   %esi
 6b8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 6b9:	83 ec 08             	sub    $0x8,%esp
 6bc:	6a 00                	push   $0x0
 6be:	ff 75 08             	pushl  0x8(%ebp)
 6c1:	e8 ed 00 00 00       	call   7b3 <open>
  if(fd < 0)
 6c6:	83 c4 10             	add    $0x10,%esp
 6c9:	85 c0                	test   %eax,%eax
 6cb:	78 2b                	js     6f8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 6cd:	83 ec 08             	sub    $0x8,%esp
 6d0:	ff 75 0c             	pushl  0xc(%ebp)
 6d3:	89 c3                	mov    %eax,%ebx
 6d5:	50                   	push   %eax
 6d6:	e8 f0 00 00 00       	call   7cb <fstat>
  close(fd);
 6db:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 6de:	89 c6                	mov    %eax,%esi
  close(fd);
 6e0:	e8 b6 00 00 00       	call   79b <close>
  return r;
 6e5:	83 c4 10             	add    $0x10,%esp
}
 6e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
 6eb:	89 f0                	mov    %esi,%eax
 6ed:	5b                   	pop    %ebx
 6ee:	5e                   	pop    %esi
 6ef:	5d                   	pop    %ebp
 6f0:	c3                   	ret    
 6f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 6f8:	be ff ff ff ff       	mov    $0xffffffff,%esi
 6fd:	eb e9                	jmp    6e8 <stat+0x38>
 6ff:	90                   	nop

00000700 <atoi>:

int
atoi(const char *s)
{
 700:	f3 0f 1e fb          	endbr32 
 704:	55                   	push   %ebp
 705:	89 e5                	mov    %esp,%ebp
 707:	53                   	push   %ebx
 708:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 70b:	0f be 02             	movsbl (%edx),%eax
 70e:	8d 48 d0             	lea    -0x30(%eax),%ecx
 711:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 714:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 719:	77 1a                	ja     735 <atoi+0x35>
 71b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 71f:	90                   	nop
    n = n*10 + *s++ - '0';
 720:	83 c2 01             	add    $0x1,%edx
 723:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 726:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 72a:	0f be 02             	movsbl (%edx),%eax
 72d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 730:	80 fb 09             	cmp    $0x9,%bl
 733:	76 eb                	jbe    720 <atoi+0x20>
  return n;
}
 735:	89 c8                	mov    %ecx,%eax
 737:	5b                   	pop    %ebx
 738:	5d                   	pop    %ebp
 739:	c3                   	ret    
 73a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000740 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 740:	f3 0f 1e fb          	endbr32 
 744:	55                   	push   %ebp
 745:	89 e5                	mov    %esp,%ebp
 747:	57                   	push   %edi
 748:	8b 45 10             	mov    0x10(%ebp),%eax
 74b:	8b 55 08             	mov    0x8(%ebp),%edx
 74e:	56                   	push   %esi
 74f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 752:	85 c0                	test   %eax,%eax
 754:	7e 0f                	jle    765 <memmove+0x25>
 756:	01 d0                	add    %edx,%eax
  dst = vdst;
 758:	89 d7                	mov    %edx,%edi
 75a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 760:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 761:	39 f8                	cmp    %edi,%eax
 763:	75 fb                	jne    760 <memmove+0x20>
  return vdst;
}
 765:	5e                   	pop    %esi
 766:	89 d0                	mov    %edx,%eax
 768:	5f                   	pop    %edi
 769:	5d                   	pop    %ebp
 76a:	c3                   	ret    

0000076b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 76b:	b8 01 00 00 00       	mov    $0x1,%eax
 770:	cd 40                	int    $0x40
 772:	c3                   	ret    

00000773 <exit>:
SYSCALL(exit)
 773:	b8 02 00 00 00       	mov    $0x2,%eax
 778:	cd 40                	int    $0x40
 77a:	c3                   	ret    

0000077b <wait>:
SYSCALL(wait)
 77b:	b8 03 00 00 00       	mov    $0x3,%eax
 780:	cd 40                	int    $0x40
 782:	c3                   	ret    

00000783 <pipe>:
SYSCALL(pipe)
 783:	b8 04 00 00 00       	mov    $0x4,%eax
 788:	cd 40                	int    $0x40
 78a:	c3                   	ret    

0000078b <read>:
SYSCALL(read)
 78b:	b8 05 00 00 00       	mov    $0x5,%eax
 790:	cd 40                	int    $0x40
 792:	c3                   	ret    

00000793 <write>:
SYSCALL(write)
 793:	b8 10 00 00 00       	mov    $0x10,%eax
 798:	cd 40                	int    $0x40
 79a:	c3                   	ret    

0000079b <close>:
SYSCALL(close)
 79b:	b8 15 00 00 00       	mov    $0x15,%eax
 7a0:	cd 40                	int    $0x40
 7a2:	c3                   	ret    

000007a3 <kill>:
SYSCALL(kill)
 7a3:	b8 06 00 00 00       	mov    $0x6,%eax
 7a8:	cd 40                	int    $0x40
 7aa:	c3                   	ret    

000007ab <exec>:
SYSCALL(exec)
 7ab:	b8 07 00 00 00       	mov    $0x7,%eax
 7b0:	cd 40                	int    $0x40
 7b2:	c3                   	ret    

000007b3 <open>:
SYSCALL(open)
 7b3:	b8 0f 00 00 00       	mov    $0xf,%eax
 7b8:	cd 40                	int    $0x40
 7ba:	c3                   	ret    

000007bb <mknod>:
SYSCALL(mknod)
 7bb:	b8 11 00 00 00       	mov    $0x11,%eax
 7c0:	cd 40                	int    $0x40
 7c2:	c3                   	ret    

000007c3 <unlink>:
SYSCALL(unlink)
 7c3:	b8 12 00 00 00       	mov    $0x12,%eax
 7c8:	cd 40                	int    $0x40
 7ca:	c3                   	ret    

000007cb <fstat>:
SYSCALL(fstat)
 7cb:	b8 08 00 00 00       	mov    $0x8,%eax
 7d0:	cd 40                	int    $0x40
 7d2:	c3                   	ret    

000007d3 <link>:
SYSCALL(link)
 7d3:	b8 13 00 00 00       	mov    $0x13,%eax
 7d8:	cd 40                	int    $0x40
 7da:	c3                   	ret    

000007db <mkdir>:
SYSCALL(mkdir)
 7db:	b8 14 00 00 00       	mov    $0x14,%eax
 7e0:	cd 40                	int    $0x40
 7e2:	c3                   	ret    

000007e3 <chdir>:
SYSCALL(chdir)
 7e3:	b8 09 00 00 00       	mov    $0x9,%eax
 7e8:	cd 40                	int    $0x40
 7ea:	c3                   	ret    

000007eb <dup>:
SYSCALL(dup)
 7eb:	b8 0a 00 00 00       	mov    $0xa,%eax
 7f0:	cd 40                	int    $0x40
 7f2:	c3                   	ret    

000007f3 <getpid>:
SYSCALL(getpid)
 7f3:	b8 0b 00 00 00       	mov    $0xb,%eax
 7f8:	cd 40                	int    $0x40
 7fa:	c3                   	ret    

000007fb <sbrk>:
SYSCALL(sbrk)
 7fb:	b8 0c 00 00 00       	mov    $0xc,%eax
 800:	cd 40                	int    $0x40
 802:	c3                   	ret    

00000803 <sleep>:
SYSCALL(sleep)
 803:	b8 0d 00 00 00       	mov    $0xd,%eax
 808:	cd 40                	int    $0x40
 80a:	c3                   	ret    

0000080b <uptime>:
SYSCALL(uptime)
 80b:	b8 0e 00 00 00       	mov    $0xe,%eax
 810:	cd 40                	int    $0x40
 812:	c3                   	ret    

00000813 <settickets>:
SYSCALL(settickets)
 813:	b8 16 00 00 00       	mov    $0x16,%eax
 818:	cd 40                	int    $0x40
 81a:	c3                   	ret    

0000081b <getpinfo>:
SYSCALL(getpinfo)
 81b:	b8 17 00 00 00       	mov    $0x17,%eax
 820:	cd 40                	int    $0x40
 822:	c3                   	ret    

00000823 <yield>:
SYSCALL(yield)
 823:	b8 18 00 00 00       	mov    $0x18,%eax
 828:	cd 40                	int    $0x40
 82a:	c3                   	ret    
 82b:	66 90                	xchg   %ax,%ax
 82d:	66 90                	xchg   %ax,%ax
 82f:	90                   	nop

00000830 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 830:	55                   	push   %ebp
 831:	89 e5                	mov    %esp,%ebp
 833:	57                   	push   %edi
 834:	56                   	push   %esi
 835:	53                   	push   %ebx
 836:	83 ec 3c             	sub    $0x3c,%esp
 839:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 83c:	89 d1                	mov    %edx,%ecx
{
 83e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 841:	85 d2                	test   %edx,%edx
 843:	0f 89 7f 00 00 00    	jns    8c8 <printint+0x98>
 849:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 84d:	74 79                	je     8c8 <printint+0x98>
    neg = 1;
 84f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 856:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 858:	31 db                	xor    %ebx,%ebx
 85a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 85d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 860:	89 c8                	mov    %ecx,%eax
 862:	31 d2                	xor    %edx,%edx
 864:	89 cf                	mov    %ecx,%edi
 866:	f7 75 c4             	divl   -0x3c(%ebp)
 869:	0f b6 92 90 0e 00 00 	movzbl 0xe90(%edx),%edx
 870:	89 45 c0             	mov    %eax,-0x40(%ebp)
 873:	89 d8                	mov    %ebx,%eax
 875:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 878:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 87b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 87e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 881:	76 dd                	jbe    860 <printint+0x30>
  if(neg)
 883:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 886:	85 c9                	test   %ecx,%ecx
 888:	74 0c                	je     896 <printint+0x66>
    buf[i++] = '-';
 88a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 88f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 891:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 896:	8b 7d b8             	mov    -0x48(%ebp),%edi
 899:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 89d:	eb 07                	jmp    8a6 <printint+0x76>
 89f:	90                   	nop
 8a0:	0f b6 13             	movzbl (%ebx),%edx
 8a3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 8a6:	83 ec 04             	sub    $0x4,%esp
 8a9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 8ac:	6a 01                	push   $0x1
 8ae:	56                   	push   %esi
 8af:	57                   	push   %edi
 8b0:	e8 de fe ff ff       	call   793 <write>
  while(--i >= 0)
 8b5:	83 c4 10             	add    $0x10,%esp
 8b8:	39 de                	cmp    %ebx,%esi
 8ba:	75 e4                	jne    8a0 <printint+0x70>
    putc(fd, buf[i]);
}
 8bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 8bf:	5b                   	pop    %ebx
 8c0:	5e                   	pop    %esi
 8c1:	5f                   	pop    %edi
 8c2:	5d                   	pop    %ebp
 8c3:	c3                   	ret    
 8c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 8c8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 8cf:	eb 87                	jmp    858 <printint+0x28>
 8d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8df:	90                   	nop

000008e0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 8e0:	f3 0f 1e fb          	endbr32 
 8e4:	55                   	push   %ebp
 8e5:	89 e5                	mov    %esp,%ebp
 8e7:	57                   	push   %edi
 8e8:	56                   	push   %esi
 8e9:	53                   	push   %ebx
 8ea:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8ed:	8b 75 0c             	mov    0xc(%ebp),%esi
 8f0:	0f b6 1e             	movzbl (%esi),%ebx
 8f3:	84 db                	test   %bl,%bl
 8f5:	0f 84 b4 00 00 00    	je     9af <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 8fb:	8d 45 10             	lea    0x10(%ebp),%eax
 8fe:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 901:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 904:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 906:	89 45 d0             	mov    %eax,-0x30(%ebp)
 909:	eb 33                	jmp    93e <printf+0x5e>
 90b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 90f:	90                   	nop
 910:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 913:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 918:	83 f8 25             	cmp    $0x25,%eax
 91b:	74 17                	je     934 <printf+0x54>
  write(fd, &c, 1);
 91d:	83 ec 04             	sub    $0x4,%esp
 920:	88 5d e7             	mov    %bl,-0x19(%ebp)
 923:	6a 01                	push   $0x1
 925:	57                   	push   %edi
 926:	ff 75 08             	pushl  0x8(%ebp)
 929:	e8 65 fe ff ff       	call   793 <write>
 92e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 931:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 934:	0f b6 1e             	movzbl (%esi),%ebx
 937:	83 c6 01             	add    $0x1,%esi
 93a:	84 db                	test   %bl,%bl
 93c:	74 71                	je     9af <printf+0xcf>
    c = fmt[i] & 0xff;
 93e:	0f be cb             	movsbl %bl,%ecx
 941:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 944:	85 d2                	test   %edx,%edx
 946:	74 c8                	je     910 <printf+0x30>
      }
    } else if(state == '%'){
 948:	83 fa 25             	cmp    $0x25,%edx
 94b:	75 e7                	jne    934 <printf+0x54>
      if(c == 'd'){
 94d:	83 f8 64             	cmp    $0x64,%eax
 950:	0f 84 9a 00 00 00    	je     9f0 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 956:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 95c:	83 f9 70             	cmp    $0x70,%ecx
 95f:	74 5f                	je     9c0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 961:	83 f8 73             	cmp    $0x73,%eax
 964:	0f 84 d6 00 00 00    	je     a40 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 96a:	83 f8 63             	cmp    $0x63,%eax
 96d:	0f 84 8d 00 00 00    	je     a00 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 973:	83 f8 25             	cmp    $0x25,%eax
 976:	0f 84 b4 00 00 00    	je     a30 <printf+0x150>
  write(fd, &c, 1);
 97c:	83 ec 04             	sub    $0x4,%esp
 97f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 983:	6a 01                	push   $0x1
 985:	57                   	push   %edi
 986:	ff 75 08             	pushl  0x8(%ebp)
 989:	e8 05 fe ff ff       	call   793 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 98e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 991:	83 c4 0c             	add    $0xc,%esp
 994:	6a 01                	push   $0x1
 996:	83 c6 01             	add    $0x1,%esi
 999:	57                   	push   %edi
 99a:	ff 75 08             	pushl  0x8(%ebp)
 99d:	e8 f1 fd ff ff       	call   793 <write>
  for(i = 0; fmt[i]; i++){
 9a2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 9a6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 9a9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 9ab:	84 db                	test   %bl,%bl
 9ad:	75 8f                	jne    93e <printf+0x5e>
    }
  }
}
 9af:	8d 65 f4             	lea    -0xc(%ebp),%esp
 9b2:	5b                   	pop    %ebx
 9b3:	5e                   	pop    %esi
 9b4:	5f                   	pop    %edi
 9b5:	5d                   	pop    %ebp
 9b6:	c3                   	ret    
 9b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 9be:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 9c0:	83 ec 0c             	sub    $0xc,%esp
 9c3:	b9 10 00 00 00       	mov    $0x10,%ecx
 9c8:	6a 00                	push   $0x0
 9ca:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 9cd:	8b 45 08             	mov    0x8(%ebp),%eax
 9d0:	8b 13                	mov    (%ebx),%edx
 9d2:	e8 59 fe ff ff       	call   830 <printint>
        ap++;
 9d7:	89 d8                	mov    %ebx,%eax
 9d9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 9dc:	31 d2                	xor    %edx,%edx
        ap++;
 9de:	83 c0 04             	add    $0x4,%eax
 9e1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 9e4:	e9 4b ff ff ff       	jmp    934 <printf+0x54>
 9e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 9f0:	83 ec 0c             	sub    $0xc,%esp
 9f3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 9f8:	6a 01                	push   $0x1
 9fa:	eb ce                	jmp    9ca <printf+0xea>
 9fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 a00:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 a03:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 a06:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 a08:	6a 01                	push   $0x1
        ap++;
 a0a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 a0d:	57                   	push   %edi
 a0e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 a11:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 a14:	e8 7a fd ff ff       	call   793 <write>
        ap++;
 a19:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 a1c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 a1f:	31 d2                	xor    %edx,%edx
 a21:	e9 0e ff ff ff       	jmp    934 <printf+0x54>
 a26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a2d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 a30:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 a33:	83 ec 04             	sub    $0x4,%esp
 a36:	e9 59 ff ff ff       	jmp    994 <printf+0xb4>
 a3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 a3f:	90                   	nop
        s = (char*)*ap;
 a40:	8b 45 d0             	mov    -0x30(%ebp),%eax
 a43:	8b 18                	mov    (%eax),%ebx
        ap++;
 a45:	83 c0 04             	add    $0x4,%eax
 a48:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 a4b:	85 db                	test   %ebx,%ebx
 a4d:	74 17                	je     a66 <printf+0x186>
        while(*s != 0){
 a4f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 a52:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 a54:	84 c0                	test   %al,%al
 a56:	0f 84 d8 fe ff ff    	je     934 <printf+0x54>
 a5c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 a5f:	89 de                	mov    %ebx,%esi
 a61:	8b 5d 08             	mov    0x8(%ebp),%ebx
 a64:	eb 1a                	jmp    a80 <printf+0x1a0>
          s = "(null)";
 a66:	bb 89 0e 00 00       	mov    $0xe89,%ebx
        while(*s != 0){
 a6b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 a6e:	b8 28 00 00 00       	mov    $0x28,%eax
 a73:	89 de                	mov    %ebx,%esi
 a75:	8b 5d 08             	mov    0x8(%ebp),%ebx
 a78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a7f:	90                   	nop
  write(fd, &c, 1);
 a80:	83 ec 04             	sub    $0x4,%esp
          s++;
 a83:	83 c6 01             	add    $0x1,%esi
 a86:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 a89:	6a 01                	push   $0x1
 a8b:	57                   	push   %edi
 a8c:	53                   	push   %ebx
 a8d:	e8 01 fd ff ff       	call   793 <write>
        while(*s != 0){
 a92:	0f b6 06             	movzbl (%esi),%eax
 a95:	83 c4 10             	add    $0x10,%esp
 a98:	84 c0                	test   %al,%al
 a9a:	75 e4                	jne    a80 <printf+0x1a0>
 a9c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 a9f:	31 d2                	xor    %edx,%edx
 aa1:	e9 8e fe ff ff       	jmp    934 <printf+0x54>
 aa6:	66 90                	xchg   %ax,%ax
 aa8:	66 90                	xchg   %ax,%ax
 aaa:	66 90                	xchg   %ax,%ax
 aac:	66 90                	xchg   %ax,%ax
 aae:	66 90                	xchg   %ax,%ax

00000ab0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ab0:	f3 0f 1e fb          	endbr32 
 ab4:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ab5:	a1 34 12 00 00       	mov    0x1234,%eax
{
 aba:	89 e5                	mov    %esp,%ebp
 abc:	57                   	push   %edi
 abd:	56                   	push   %esi
 abe:	53                   	push   %ebx
 abf:	8b 5d 08             	mov    0x8(%ebp),%ebx
 ac2:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 ac4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ac7:	39 c8                	cmp    %ecx,%eax
 ac9:	73 15                	jae    ae0 <free+0x30>
 acb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 acf:	90                   	nop
 ad0:	39 d1                	cmp    %edx,%ecx
 ad2:	72 14                	jb     ae8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ad4:	39 d0                	cmp    %edx,%eax
 ad6:	73 10                	jae    ae8 <free+0x38>
{
 ad8:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ada:	8b 10                	mov    (%eax),%edx
 adc:	39 c8                	cmp    %ecx,%eax
 ade:	72 f0                	jb     ad0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ae0:	39 d0                	cmp    %edx,%eax
 ae2:	72 f4                	jb     ad8 <free+0x28>
 ae4:	39 d1                	cmp    %edx,%ecx
 ae6:	73 f0                	jae    ad8 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 ae8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 aeb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 aee:	39 fa                	cmp    %edi,%edx
 af0:	74 1e                	je     b10 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 af2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 af5:	8b 50 04             	mov    0x4(%eax),%edx
 af8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 afb:	39 f1                	cmp    %esi,%ecx
 afd:	74 28                	je     b27 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 aff:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 b01:	5b                   	pop    %ebx
  freep = p;
 b02:	a3 34 12 00 00       	mov    %eax,0x1234
}
 b07:	5e                   	pop    %esi
 b08:	5f                   	pop    %edi
 b09:	5d                   	pop    %ebp
 b0a:	c3                   	ret    
 b0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 b0f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 b10:	03 72 04             	add    0x4(%edx),%esi
 b13:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 b16:	8b 10                	mov    (%eax),%edx
 b18:	8b 12                	mov    (%edx),%edx
 b1a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 b1d:	8b 50 04             	mov    0x4(%eax),%edx
 b20:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 b23:	39 f1                	cmp    %esi,%ecx
 b25:	75 d8                	jne    aff <free+0x4f>
    p->s.size += bp->s.size;
 b27:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 b2a:	a3 34 12 00 00       	mov    %eax,0x1234
    p->s.size += bp->s.size;
 b2f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 b32:	8b 53 f8             	mov    -0x8(%ebx),%edx
 b35:	89 10                	mov    %edx,(%eax)
}
 b37:	5b                   	pop    %ebx
 b38:	5e                   	pop    %esi
 b39:	5f                   	pop    %edi
 b3a:	5d                   	pop    %ebp
 b3b:	c3                   	ret    
 b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000b40 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b40:	f3 0f 1e fb          	endbr32 
 b44:	55                   	push   %ebp
 b45:	89 e5                	mov    %esp,%ebp
 b47:	57                   	push   %edi
 b48:	56                   	push   %esi
 b49:	53                   	push   %ebx
 b4a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 b50:	8b 3d 34 12 00 00    	mov    0x1234,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b56:	8d 70 07             	lea    0x7(%eax),%esi
 b59:	c1 ee 03             	shr    $0x3,%esi
 b5c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 b5f:	85 ff                	test   %edi,%edi
 b61:	0f 84 a9 00 00 00    	je     c10 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b67:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 b69:	8b 48 04             	mov    0x4(%eax),%ecx
 b6c:	39 f1                	cmp    %esi,%ecx
 b6e:	73 6d                	jae    bdd <malloc+0x9d>
 b70:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 b76:	bb 00 10 00 00       	mov    $0x1000,%ebx
 b7b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 b7e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 b85:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 b88:	eb 17                	jmp    ba1 <malloc+0x61>
 b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b90:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 b92:	8b 4a 04             	mov    0x4(%edx),%ecx
 b95:	39 f1                	cmp    %esi,%ecx
 b97:	73 4f                	jae    be8 <malloc+0xa8>
 b99:	8b 3d 34 12 00 00    	mov    0x1234,%edi
 b9f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 ba1:	39 c7                	cmp    %eax,%edi
 ba3:	75 eb                	jne    b90 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 ba5:	83 ec 0c             	sub    $0xc,%esp
 ba8:	ff 75 e4             	pushl  -0x1c(%ebp)
 bab:	e8 4b fc ff ff       	call   7fb <sbrk>
  if(p == (char*)-1)
 bb0:	83 c4 10             	add    $0x10,%esp
 bb3:	83 f8 ff             	cmp    $0xffffffff,%eax
 bb6:	74 1b                	je     bd3 <malloc+0x93>
  hp->s.size = nu;
 bb8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 bbb:	83 ec 0c             	sub    $0xc,%esp
 bbe:	83 c0 08             	add    $0x8,%eax
 bc1:	50                   	push   %eax
 bc2:	e8 e9 fe ff ff       	call   ab0 <free>
  return freep;
 bc7:	a1 34 12 00 00       	mov    0x1234,%eax
      if((p = morecore(nunits)) == 0)
 bcc:	83 c4 10             	add    $0x10,%esp
 bcf:	85 c0                	test   %eax,%eax
 bd1:	75 bd                	jne    b90 <malloc+0x50>
        return 0;
  }
}
 bd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 bd6:	31 c0                	xor    %eax,%eax
}
 bd8:	5b                   	pop    %ebx
 bd9:	5e                   	pop    %esi
 bda:	5f                   	pop    %edi
 bdb:	5d                   	pop    %ebp
 bdc:	c3                   	ret    
    if(p->s.size >= nunits){
 bdd:	89 c2                	mov    %eax,%edx
 bdf:	89 f8                	mov    %edi,%eax
 be1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 be8:	39 ce                	cmp    %ecx,%esi
 bea:	74 54                	je     c40 <malloc+0x100>
        p->s.size -= nunits;
 bec:	29 f1                	sub    %esi,%ecx
 bee:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 bf1:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 bf4:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 bf7:	a3 34 12 00 00       	mov    %eax,0x1234
}
 bfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 bff:	8d 42 08             	lea    0x8(%edx),%eax
}
 c02:	5b                   	pop    %ebx
 c03:	5e                   	pop    %esi
 c04:	5f                   	pop    %edi
 c05:	5d                   	pop    %ebp
 c06:	c3                   	ret    
 c07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 c0e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 c10:	c7 05 34 12 00 00 38 	movl   $0x1238,0x1234
 c17:	12 00 00 
    base.s.size = 0;
 c1a:	bf 38 12 00 00       	mov    $0x1238,%edi
    base.s.ptr = freep = prevp = &base;
 c1f:	c7 05 38 12 00 00 38 	movl   $0x1238,0x1238
 c26:	12 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c29:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 c2b:	c7 05 3c 12 00 00 00 	movl   $0x0,0x123c
 c32:	00 00 00 
    if(p->s.size >= nunits){
 c35:	e9 36 ff ff ff       	jmp    b70 <malloc+0x30>
 c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 c40:	8b 0a                	mov    (%edx),%ecx
 c42:	89 08                	mov    %ecx,(%eax)
 c44:	eb b1                	jmp    bf7 <malloc+0xb7>
