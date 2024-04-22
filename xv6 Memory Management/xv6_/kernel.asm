
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 d5 10 80       	mov    $0x8010d5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 b0 34 10 80       	mov    $0x801034b0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	f3 0f 1e fb          	endbr32 
80100044:	55                   	push   %ebp
80100045:	89 e5                	mov    %esp,%ebp
80100047:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100048:	bb 14 d6 10 80       	mov    $0x8010d614,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 00 84 10 80       	push   $0x80108400
80100055:	68 e0 d5 10 80       	push   $0x8010d5e0
8010005a:	e8 a1 51 00 00       	call   80105200 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 dc 1c 11 80       	mov    $0x80111cdc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 2c 1d 11 80 dc 	movl   $0x80111cdc,0x80111d2c
8010006e:	1c 11 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 30 1d 11 80 dc 	movl   $0x80111cdc,0x80111d30
80100078:	1c 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010007b:	eb 05                	jmp    80100082 <binit+0x42>
8010007d:	8d 76 00             	lea    0x0(%esi),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 dc 1c 11 80 	movl   $0x80111cdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 07 84 10 80       	push   $0x80108407
80100097:	50                   	push   %eax
80100098:	e8 23 50 00 00       	call   801050c0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 1d 11 80       	mov    0x80111d30,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 30 1d 11 80    	mov    %ebx,0x80111d30
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 80 1a 11 80    	cmp    $0x80111a80,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	f3 0f 1e fb          	endbr32 
801000d4:	55                   	push   %ebp
801000d5:	89 e5                	mov    %esp,%ebp
801000d7:	57                   	push   %edi
801000d8:	56                   	push   %esi
801000d9:	53                   	push   %ebx
801000da:	83 ec 18             	sub    $0x18,%esp
801000dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801000e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000e3:	68 e0 d5 10 80       	push   $0x8010d5e0
801000e8:	e8 93 52 00 00       	call   80105380 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 30 1d 11 80    	mov    0x80111d30,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb dc 1c 11 80    	cmp    $0x80111cdc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc 1c 11 80    	cmp    $0x80111cdc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 2c 1d 11 80    	mov    0x80111d2c,%ebx
80100126:	81 fb dc 1c 11 80    	cmp    $0x80111cdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc 1c 11 80    	cmp    $0x80111cdc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 e0 d5 10 80       	push   $0x8010d5e0
80100162:	e8 d9 52 00 00       	call   80105440 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 8e 4f 00 00       	call   80105100 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 5f 25 00 00       	call   801026f0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 0e 84 10 80       	push   $0x8010840e
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	f3 0f 1e fb          	endbr32 
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	53                   	push   %ebx
801001b8:	83 ec 10             	sub    $0x10,%esp
801001bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001be:	8d 43 0c             	lea    0xc(%ebx),%eax
801001c1:	50                   	push   %eax
801001c2:	e8 d9 4f 00 00       	call   801051a0 <holdingsleep>
801001c7:	83 c4 10             	add    $0x10,%esp
801001ca:	85 c0                	test   %eax,%eax
801001cc:	74 0f                	je     801001dd <bwrite+0x2d>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ce:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001d1:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d7:	c9                   	leave  
  iderw(b);
801001d8:	e9 13 25 00 00       	jmp    801026f0 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 1f 84 10 80       	push   $0x8010841f
801001e5:	e8 a6 01 00 00       	call   80100390 <panic>
801001ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	f3 0f 1e fb          	endbr32 
801001f4:	55                   	push   %ebp
801001f5:	89 e5                	mov    %esp,%ebp
801001f7:	56                   	push   %esi
801001f8:	53                   	push   %ebx
801001f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	56                   	push   %esi
80100203:	e8 98 4f 00 00       	call   801051a0 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 48 4f 00 00       	call   80105160 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 e0 d5 10 80 	movl   $0x8010d5e0,(%esp)
8010021f:	e8 5c 51 00 00       	call   80105380 <acquire>
  b->refcnt--;
80100224:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100227:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010022a:	83 e8 01             	sub    $0x1,%eax
8010022d:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
80100230:	85 c0                	test   %eax,%eax
80100232:	75 2f                	jne    80100263 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100234:	8b 43 54             	mov    0x54(%ebx),%eax
80100237:	8b 53 50             	mov    0x50(%ebx),%edx
8010023a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010023d:	8b 43 50             	mov    0x50(%ebx),%eax
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100246:	a1 30 1d 11 80       	mov    0x80111d30,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 dc 1c 11 80 	movl   $0x80111cdc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 30 1d 11 80       	mov    0x80111d30,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 30 1d 11 80    	mov    %ebx,0x80111d30
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 e0 d5 10 80 	movl   $0x8010d5e0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 cb 51 00 00       	jmp    80105440 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 26 84 10 80       	push   $0x80108426
8010027d:	e8 0e 01 00 00       	call   80100390 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100290:	f3 0f 1e fb          	endbr32 
80100294:	55                   	push   %ebp
80100295:	89 e5                	mov    %esp,%ebp
80100297:	57                   	push   %edi
80100298:	56                   	push   %esi
80100299:	53                   	push   %ebx
8010029a:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
8010029d:	ff 75 08             	pushl  0x8(%ebp)
{
801002a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  target = n;
801002a3:	89 de                	mov    %ebx,%esi
  iunlock(ip);
801002a5:	e8 96 15 00 00       	call   80101840 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
801002b1:	e8 ca 50 00 00       	call   80105380 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002b9:	83 c4 10             	add    $0x10,%esp
    *dst++ = c;
801002bc:	01 df                	add    %ebx,%edi
  while(n > 0){
801002be:	85 db                	test   %ebx,%ebx
801002c0:	0f 8e 97 00 00 00    	jle    8010035d <consoleread+0xcd>
    while(input.r == input.w){
801002c6:	a1 c0 1f 11 80       	mov    0x80111fc0,%eax
801002cb:	3b 05 c4 1f 11 80    	cmp    0x80111fc4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 c5 10 80       	push   $0x8010c520
801002e0:	68 c0 1f 11 80       	push   $0x80111fc0
801002e5:	e8 e6 42 00 00       	call   801045d0 <sleep>
    while(input.r == input.w){
801002ea:	a1 c0 1f 11 80       	mov    0x80111fc0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 c4 1f 11 80    	cmp    0x80111fc4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 e1 3b 00 00       	call   80103ee0 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 c5 10 80       	push   $0x8010c520
8010030e:	e8 2d 51 00 00       	call   80105440 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 44 14 00 00       	call   80101760 <ilock>
        return -1;
8010031c:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100327:	5b                   	pop    %ebx
80100328:	5e                   	pop    %esi
80100329:	5f                   	pop    %edi
8010032a:	5d                   	pop    %ebp
8010032b:	c3                   	ret    
8010032c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100330:	8d 50 01             	lea    0x1(%eax),%edx
80100333:	89 15 c0 1f 11 80    	mov    %edx,0x80111fc0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 40 1f 11 80 	movsbl -0x7feee0c0(%edx),%ecx
    if(c == C('D')){  // EOF
80100345:	80 f9 04             	cmp    $0x4,%cl
80100348:	74 38                	je     80100382 <consoleread+0xf2>
    *dst++ = c;
8010034a:	89 d8                	mov    %ebx,%eax
    --n;
8010034c:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010034f:	f7 d8                	neg    %eax
80100351:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if(c == '\n')
80100354:	83 f9 0a             	cmp    $0xa,%ecx
80100357:	0f 85 61 ff ff ff    	jne    801002be <consoleread+0x2e>
  release(&cons.lock);
8010035d:	83 ec 0c             	sub    $0xc,%esp
80100360:	68 20 c5 10 80       	push   $0x8010c520
80100365:	e8 d6 50 00 00       	call   80105440 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 ed 13 00 00       	call   80101760 <ilock>
  return target - n;
80100373:	89 f0                	mov    %esi,%eax
80100375:	83 c4 10             	add    $0x10,%esp
}
80100378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010037b:	29 d8                	sub    %ebx,%eax
}
8010037d:	5b                   	pop    %ebx
8010037e:	5e                   	pop    %esi
8010037f:	5f                   	pop    %edi
80100380:	5d                   	pop    %ebp
80100381:	c3                   	ret    
      if(n < target){
80100382:	39 f3                	cmp    %esi,%ebx
80100384:	73 d7                	jae    8010035d <consoleread+0xcd>
        input.r--;
80100386:	a3 c0 1f 11 80       	mov    %eax,0x80111fc0
8010038b:	eb d0                	jmp    8010035d <consoleread+0xcd>
8010038d:	8d 76 00             	lea    0x0(%esi),%esi

80100390 <panic>:
{
80100390:	f3 0f 1e fb          	endbr32 
80100394:	55                   	push   %ebp
80100395:	89 e5                	mov    %esp,%ebp
80100397:	56                   	push   %esi
80100398:	53                   	push   %ebx
80100399:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010039c:	fa                   	cli    
  cons.locking = 0;
8010039d:	c7 05 54 c5 10 80 00 	movl   $0x0,0x8010c554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 5e 29 00 00       	call   80102d10 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 2d 84 10 80       	push   $0x8010842d
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 92 90 10 80 	movl   $0x80109092,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 3f 4e 00 00       	call   80105220 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 41 84 10 80       	push   $0x80108441
801003f1:	e8 ba 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 58 c5 10 80 01 	movl   $0x1,0x8010c558
80100404:	00 00 00 
  for(;;)
80100407:	eb fe                	jmp    80100407 <panic+0x77>
80100409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 ea 00 00 00    	je     80100510 <consputc.part.0+0x100>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 b1 67 00 00       	call   80106be0 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c6                	mov    %eax,%esi
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010045f:	83 fb 0a             	cmp    $0xa,%ebx
80100462:	0f 84 90 00 00 00    	je     801004f8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100468:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010046e:	74 70                	je     801004e0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100470:	0f b6 db             	movzbl %bl,%ebx
80100473:	8d 70 01             	lea    0x1(%eax),%esi
80100476:	80 cf 07             	or     $0x7,%bh
80100479:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100480:	80 
  if(pos < 0 || pos > 25*80)
80100481:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100487:	0f 8f f9 00 00 00    	jg     80100586 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010048d:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100493:	0f 8f a7 00 00 00    	jg     80100540 <consputc.part.0+0x130>
80100499:	89 f0                	mov    %esi,%eax
8010049b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
801004a2:	88 45 e7             	mov    %al,-0x19(%ebp)
801004a5:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004a8:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004ad:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ba:	89 f8                	mov    %edi,%eax
801004bc:	89 ca                	mov    %ecx,%edx
801004be:	ee                   	out    %al,(%dx)
801004bf:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c4:	89 da                	mov    %ebx,%edx
801004c6:	ee                   	out    %al,(%dx)
801004c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004cb:	89 ca                	mov    %ecx,%edx
801004cd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004ce:	b8 20 07 00 00       	mov    $0x720,%eax
801004d3:	66 89 06             	mov    %ax,(%esi)
}
801004d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004d9:	5b                   	pop    %ebx
801004da:	5e                   	pop    %esi
801004db:	5f                   	pop    %edi
801004dc:	5d                   	pop    %ebp
801004dd:	c3                   	ret    
801004de:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004e0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004e3:	85 c0                	test   %eax,%eax
801004e5:	75 9a                	jne    80100481 <consputc.part.0+0x71>
801004e7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004eb:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004f0:	31 ff                	xor    %edi,%edi
801004f2:	eb b4                	jmp    801004a8 <consputc.part.0+0x98>
801004f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004f8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004fd:	f7 e2                	mul    %edx
801004ff:	c1 ea 06             	shr    $0x6,%edx
80100502:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100505:	c1 e0 04             	shl    $0x4,%eax
80100508:	8d 70 50             	lea    0x50(%eax),%esi
8010050b:	e9 71 ff ff ff       	jmp    80100481 <consputc.part.0+0x71>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 08                	push   $0x8
80100515:	e8 c6 66 00 00       	call   80106be0 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 ba 66 00 00       	call   80106be0 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 ae 66 00 00       	call   80106be0 <uartputc>
80100532:	83 c4 10             	add    $0x10,%esp
80100535:	e9 f8 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 ca 4f 00 00       	call   80105530 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 15 4f 00 00       	call   80105490 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 45 84 10 80       	push   $0x80108445
8010058e:	e8 fd fd ff ff       	call   80100390 <panic>
80100593:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010059a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801005a0 <printint>:
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 2c             	sub    $0x2c,%esp
801005a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005ac:	85 c9                	test   %ecx,%ecx
801005ae:	74 04                	je     801005b4 <printint+0x14>
801005b0:	85 c0                	test   %eax,%eax
801005b2:	78 6d                	js     80100621 <printint+0x81>
    x = xx;
801005b4:	89 c1                	mov    %eax,%ecx
801005b6:	31 f6                	xor    %esi,%esi
  i = 0;
801005b8:	89 75 cc             	mov    %esi,-0x34(%ebp)
801005bb:	31 db                	xor    %ebx,%ebx
801005bd:	8d 7d d7             	lea    -0x29(%ebp),%edi
    buf[i++] = digits[x % base];
801005c0:	89 c8                	mov    %ecx,%eax
801005c2:	31 d2                	xor    %edx,%edx
801005c4:	89 ce                	mov    %ecx,%esi
801005c6:	f7 75 d4             	divl   -0x2c(%ebp)
801005c9:	0f b6 92 70 84 10 80 	movzbl -0x7fef7b90(%edx),%edx
801005d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
801005d3:	89 d8                	mov    %ebx,%eax
801005d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
801005d8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801005db:	89 75 d0             	mov    %esi,-0x30(%ebp)
    buf[i++] = digits[x % base];
801005de:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  }while((x /= base) != 0);
801005e1:	8b 75 d4             	mov    -0x2c(%ebp),%esi
801005e4:	39 75 d0             	cmp    %esi,-0x30(%ebp)
801005e7:	73 d7                	jae    801005c0 <printint+0x20>
801005e9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  if(sign)
801005ec:	85 f6                	test   %esi,%esi
801005ee:	74 0c                	je     801005fc <printint+0x5c>
    buf[i++] = '-';
801005f0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801005f5:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
801005f7:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
801005fc:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
80100600:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100603:	8b 15 58 c5 10 80    	mov    0x8010c558,%edx
80100609:	85 d2                	test   %edx,%edx
8010060b:	74 03                	je     80100610 <printint+0x70>
  asm volatile("cli");
8010060d:	fa                   	cli    
    for(;;)
8010060e:	eb fe                	jmp    8010060e <printint+0x6e>
80100610:	e8 fb fd ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
80100615:	39 fb                	cmp    %edi,%ebx
80100617:	74 10                	je     80100629 <printint+0x89>
80100619:	0f be 03             	movsbl (%ebx),%eax
8010061c:	83 eb 01             	sub    $0x1,%ebx
8010061f:	eb e2                	jmp    80100603 <printint+0x63>
    x = -xx;
80100621:	f7 d8                	neg    %eax
80100623:	89 ce                	mov    %ecx,%esi
80100625:	89 c1                	mov    %eax,%ecx
80100627:	eb 8f                	jmp    801005b8 <printint+0x18>
}
80100629:	83 c4 2c             	add    $0x2c,%esp
8010062c:	5b                   	pop    %ebx
8010062d:	5e                   	pop    %esi
8010062e:	5f                   	pop    %edi
8010062f:	5d                   	pop    %ebp
80100630:	c3                   	ret    
80100631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010063f:	90                   	nop

80100640 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100640:	f3 0f 1e fb          	endbr32 
80100644:	55                   	push   %ebp
80100645:	89 e5                	mov    %esp,%ebp
80100647:	57                   	push   %edi
80100648:	56                   	push   %esi
80100649:	53                   	push   %ebx
8010064a:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
8010064d:	ff 75 08             	pushl  0x8(%ebp)
{
80100650:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
80100653:	e8 e8 11 00 00       	call   80101840 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010065f:	e8 1c 4d 00 00       	call   80105380 <acquire>
  for(i = 0; i < n; i++)
80100664:	83 c4 10             	add    $0x10,%esp
80100667:	85 db                	test   %ebx,%ebx
80100669:	7e 24                	jle    8010068f <consolewrite+0x4f>
8010066b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100671:	8b 15 58 c5 10 80    	mov    0x8010c558,%edx
80100677:	85 d2                	test   %edx,%edx
80100679:	74 05                	je     80100680 <consolewrite+0x40>
8010067b:	fa                   	cli    
    for(;;)
8010067c:	eb fe                	jmp    8010067c <consolewrite+0x3c>
8010067e:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
80100680:	0f b6 07             	movzbl (%edi),%eax
80100683:	83 c7 01             	add    $0x1,%edi
80100686:	e8 85 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
8010068b:	39 fe                	cmp    %edi,%esi
8010068d:	75 e2                	jne    80100671 <consolewrite+0x31>
  release(&cons.lock);
8010068f:	83 ec 0c             	sub    $0xc,%esp
80100692:	68 20 c5 10 80       	push   $0x8010c520
80100697:	e8 a4 4d 00 00       	call   80105440 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 bb 10 00 00       	call   80101760 <ilock>

  return n;
}
801006a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006a8:	89 d8                	mov    %ebx,%eax
801006aa:	5b                   	pop    %ebx
801006ab:	5e                   	pop    %esi
801006ac:	5f                   	pop    %edi
801006ad:	5d                   	pop    %ebp
801006ae:	c3                   	ret    
801006af:	90                   	nop

801006b0 <cprintf>:
{
801006b0:	f3 0f 1e fb          	endbr32 
801006b4:	55                   	push   %ebp
801006b5:	89 e5                	mov    %esp,%ebp
801006b7:	57                   	push   %edi
801006b8:	56                   	push   %esi
801006b9:	53                   	push   %ebx
801006ba:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006bd:	a1 54 c5 10 80       	mov    0x8010c554,%eax
801006c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006c5:	85 c0                	test   %eax,%eax
801006c7:	0f 85 e8 00 00 00    	jne    801007b5 <cprintf+0x105>
  if (fmt == 0)
801006cd:	8b 45 08             	mov    0x8(%ebp),%eax
801006d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d3:	85 c0                	test   %eax,%eax
801006d5:	0f 84 5a 01 00 00    	je     80100835 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006db:	0f b6 00             	movzbl (%eax),%eax
801006de:	85 c0                	test   %eax,%eax
801006e0:	74 36                	je     80100718 <cprintf+0x68>
  argp = (uint*)(void*)(&fmt + 1);
801006e2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e5:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006e7:	83 f8 25             	cmp    $0x25,%eax
801006ea:	74 44                	je     80100730 <cprintf+0x80>
  if(panicked){
801006ec:	8b 0d 58 c5 10 80    	mov    0x8010c558,%ecx
801006f2:	85 c9                	test   %ecx,%ecx
801006f4:	74 0f                	je     80100705 <cprintf+0x55>
801006f6:	fa                   	cli    
    for(;;)
801006f7:	eb fe                	jmp    801006f7 <cprintf+0x47>
801006f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100700:	b8 25 00 00 00       	mov    $0x25,%eax
80100705:	e8 06 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010070a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010070d:	83 c6 01             	add    $0x1,%esi
80100710:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
80100714:	85 c0                	test   %eax,%eax
80100716:	75 cf                	jne    801006e7 <cprintf+0x37>
  if(locking)
80100718:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010071b:	85 c0                	test   %eax,%eax
8010071d:	0f 85 fd 00 00 00    	jne    80100820 <cprintf+0x170>
}
80100723:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100726:	5b                   	pop    %ebx
80100727:	5e                   	pop    %esi
80100728:	5f                   	pop    %edi
80100729:	5d                   	pop    %ebp
8010072a:	c3                   	ret    
8010072b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010072f:	90                   	nop
    c = fmt[++i] & 0xff;
80100730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100733:	83 c6 01             	add    $0x1,%esi
80100736:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
8010073a:	85 ff                	test   %edi,%edi
8010073c:	74 da                	je     80100718 <cprintf+0x68>
    switch(c){
8010073e:	83 ff 70             	cmp    $0x70,%edi
80100741:	74 5a                	je     8010079d <cprintf+0xed>
80100743:	7f 2a                	jg     8010076f <cprintf+0xbf>
80100745:	83 ff 25             	cmp    $0x25,%edi
80100748:	0f 84 92 00 00 00    	je     801007e0 <cprintf+0x130>
8010074e:	83 ff 64             	cmp    $0x64,%edi
80100751:	0f 85 a1 00 00 00    	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 10, 1);
80100757:	8b 03                	mov    (%ebx),%eax
80100759:	8d 7b 04             	lea    0x4(%ebx),%edi
8010075c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100761:	ba 0a 00 00 00       	mov    $0xa,%edx
80100766:	89 fb                	mov    %edi,%ebx
80100768:	e8 33 fe ff ff       	call   801005a0 <printint>
      break;
8010076d:	eb 9b                	jmp    8010070a <cprintf+0x5a>
    switch(c){
8010076f:	83 ff 73             	cmp    $0x73,%edi
80100772:	75 24                	jne    80100798 <cprintf+0xe8>
      if((s = (char*)*argp++) == 0)
80100774:	8d 7b 04             	lea    0x4(%ebx),%edi
80100777:	8b 1b                	mov    (%ebx),%ebx
80100779:	85 db                	test   %ebx,%ebx
8010077b:	75 55                	jne    801007d2 <cprintf+0x122>
        s = "(null)";
8010077d:	bb 58 84 10 80       	mov    $0x80108458,%ebx
      for(; *s; s++)
80100782:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100787:	8b 15 58 c5 10 80    	mov    0x8010c558,%edx
8010078d:	85 d2                	test   %edx,%edx
8010078f:	74 39                	je     801007ca <cprintf+0x11a>
80100791:	fa                   	cli    
    for(;;)
80100792:	eb fe                	jmp    80100792 <cprintf+0xe2>
80100794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100798:	83 ff 78             	cmp    $0x78,%edi
8010079b:	75 5b                	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 16, 0);
8010079d:	8b 03                	mov    (%ebx),%eax
8010079f:	8d 7b 04             	lea    0x4(%ebx),%edi
801007a2:	31 c9                	xor    %ecx,%ecx
801007a4:	ba 10 00 00 00       	mov    $0x10,%edx
801007a9:	89 fb                	mov    %edi,%ebx
801007ab:	e8 f0 fd ff ff       	call   801005a0 <printint>
      break;
801007b0:	e9 55 ff ff ff       	jmp    8010070a <cprintf+0x5a>
    acquire(&cons.lock);
801007b5:	83 ec 0c             	sub    $0xc,%esp
801007b8:	68 20 c5 10 80       	push   $0x8010c520
801007bd:	e8 be 4b 00 00       	call   80105380 <acquire>
801007c2:	83 c4 10             	add    $0x10,%esp
801007c5:	e9 03 ff ff ff       	jmp    801006cd <cprintf+0x1d>
801007ca:	e8 41 fc ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801007cf:	83 c3 01             	add    $0x1,%ebx
801007d2:	0f be 03             	movsbl (%ebx),%eax
801007d5:	84 c0                	test   %al,%al
801007d7:	75 ae                	jne    80100787 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
801007d9:	89 fb                	mov    %edi,%ebx
801007db:	e9 2a ff ff ff       	jmp    8010070a <cprintf+0x5a>
  if(panicked){
801007e0:	8b 3d 58 c5 10 80    	mov    0x8010c558,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	0f 84 12 ff ff ff    	je     80100700 <cprintf+0x50>
801007ee:	fa                   	cli    
    for(;;)
801007ef:	eb fe                	jmp    801007ef <cprintf+0x13f>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007f8:	8b 0d 58 c5 10 80    	mov    0x8010c558,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 06                	je     80100808 <cprintf+0x158>
80100802:	fa                   	cli    
    for(;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x153>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	e8 fe fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100812:	8b 15 58 c5 10 80    	mov    0x8010c558,%edx
80100818:	85 d2                	test   %edx,%edx
8010081a:	74 2c                	je     80100848 <cprintf+0x198>
8010081c:	fa                   	cli    
    for(;;)
8010081d:	eb fe                	jmp    8010081d <cprintf+0x16d>
8010081f:	90                   	nop
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 c5 10 80       	push   $0x8010c520
80100828:	e8 13 4c 00 00       	call   80105440 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 5f 84 10 80       	push   $0x8010845f
8010083d:	e8 4e fb ff ff       	call   80100390 <panic>
80100842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100848:	89 f8                	mov    %edi,%eax
8010084a:	e8 c1 fb ff ff       	call   80100410 <consputc.part.0>
8010084f:	e9 b6 fe ff ff       	jmp    8010070a <cprintf+0x5a>
80100854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010085b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010085f:	90                   	nop

80100860 <consoleintr>:
{
80100860:	f3 0f 1e fb          	endbr32 
80100864:	55                   	push   %ebp
80100865:	89 e5                	mov    %esp,%ebp
80100867:	57                   	push   %edi
80100868:	56                   	push   %esi
  int c, doprocdump = 0;
80100869:	31 f6                	xor    %esi,%esi
{
8010086b:	53                   	push   %ebx
8010086c:	83 ec 18             	sub    $0x18,%esp
8010086f:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
80100872:	68 20 c5 10 80       	push   $0x8010c520
80100877:	e8 04 4b 00 00       	call   80105380 <acquire>
  while((c = getc()) >= 0){
8010087c:	83 c4 10             	add    $0x10,%esp
8010087f:	eb 17                	jmp    80100898 <consoleintr+0x38>
    switch(c){
80100881:	83 fb 08             	cmp    $0x8,%ebx
80100884:	0f 84 f6 00 00 00    	je     80100980 <consoleintr+0x120>
8010088a:	83 fb 10             	cmp    $0x10,%ebx
8010088d:	0f 85 15 01 00 00    	jne    801009a8 <consoleintr+0x148>
80100893:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100898:	ff d7                	call   *%edi
8010089a:	89 c3                	mov    %eax,%ebx
8010089c:	85 c0                	test   %eax,%eax
8010089e:	0f 88 23 01 00 00    	js     801009c7 <consoleintr+0x167>
    switch(c){
801008a4:	83 fb 15             	cmp    $0x15,%ebx
801008a7:	74 77                	je     80100920 <consoleintr+0xc0>
801008a9:	7e d6                	jle    80100881 <consoleintr+0x21>
801008ab:	83 fb 7f             	cmp    $0x7f,%ebx
801008ae:	0f 84 cc 00 00 00    	je     80100980 <consoleintr+0x120>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008b4:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 c0 1f 11 80    	sub    0x80111fc0,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 58 c5 10 80    	mov    0x8010c558,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d c8 1f 11 80    	mov    %ecx,0x80111fc8
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 40 1f 11 80    	mov    %bl,-0x7feee0c0(%eax)
  if(panicked){
801008e7:	85 d2                	test   %edx,%edx
801008e9:	0f 85 ff 00 00 00    	jne    801009ee <consoleintr+0x18e>
801008ef:	89 d8                	mov    %ebx,%eax
801008f1:	e8 1a fb ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008f6:	83 fb 0a             	cmp    $0xa,%ebx
801008f9:	0f 84 0f 01 00 00    	je     80100a0e <consoleintr+0x1ae>
801008ff:	83 fb 04             	cmp    $0x4,%ebx
80100902:	0f 84 06 01 00 00    	je     80100a0e <consoleintr+0x1ae>
80100908:	a1 c0 1f 11 80       	mov    0x80111fc0,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 c8 1f 11 80    	cmp    %eax,0x80111fc8
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100920:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
80100925:	39 05 c4 1f 11 80    	cmp    %eax,0x80111fc4
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba 40 1f 11 80 0a 	cmpb   $0xa,-0x7feee0c0(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 58 c5 10 80    	mov    0x8010c558,%edx
        input.e--;
8010094c:	a3 c8 1f 11 80       	mov    %eax,0x80111fc8
  if(panicked){
80100951:	85 d2                	test   %edx,%edx
80100953:	74 0b                	je     80100960 <consoleintr+0x100>
80100955:	fa                   	cli    
    for(;;)
80100956:	eb fe                	jmp    80100956 <consoleintr+0xf6>
80100958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010095f:	90                   	nop
80100960:	b8 00 01 00 00       	mov    $0x100,%eax
80100965:	e8 a6 fa ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
8010096a:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
8010096f:	3b 05 c4 1f 11 80    	cmp    0x80111fc4,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
80100985:	3b 05 c4 1f 11 80    	cmp    0x80111fc4,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 c8 1f 11 80       	mov    %eax,0x80111fc8
  if(panicked){
80100999:	a1 58 c5 10 80       	mov    0x8010c558,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 16                	je     801009b8 <consoleintr+0x158>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x143>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009a8:	85 db                	test   %ebx,%ebx
801009aa:	0f 84 e8 fe ff ff    	je     80100898 <consoleintr+0x38>
801009b0:	e9 ff fe ff ff       	jmp    801008b4 <consoleintr+0x54>
801009b5:	8d 76 00             	lea    0x0(%esi),%esi
801009b8:	b8 00 01 00 00       	mov    $0x100,%eax
801009bd:	e8 4e fa ff ff       	call   80100410 <consputc.part.0>
801009c2:	e9 d1 fe ff ff       	jmp    80100898 <consoleintr+0x38>
  release(&cons.lock);
801009c7:	83 ec 0c             	sub    $0xc,%esp
801009ca:	68 20 c5 10 80       	push   $0x8010c520
801009cf:	e8 6c 4a 00 00       	call   80105440 <release>
  if(doprocdump) {
801009d4:	83 c4 10             	add    $0x10,%esp
801009d7:	85 f6                	test   %esi,%esi
801009d9:	75 1d                	jne    801009f8 <consoleintr+0x198>
}
801009db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009de:	5b                   	pop    %ebx
801009df:	5e                   	pop    %esi
801009e0:	5f                   	pop    %edi
801009e1:	5d                   	pop    %ebp
801009e2:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
801009e3:	c6 80 40 1f 11 80 0a 	movb   $0xa,-0x7feee0c0(%eax)
  if(panicked){
801009ea:	85 d2                	test   %edx,%edx
801009ec:	74 16                	je     80100a04 <consoleintr+0x1a4>
801009ee:	fa                   	cli    
    for(;;)
801009ef:	eb fe                	jmp    801009ef <consoleintr+0x18f>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801009f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009fb:	5b                   	pop    %ebx
801009fc:	5e                   	pop    %esi
801009fd:	5f                   	pop    %edi
801009fe:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
801009ff:	e9 8c 3e 00 00       	jmp    80104890 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 c4 1f 11 80       	mov    %eax,0x80111fc4
          wakeup(&input.r);
80100a1b:	68 c0 1f 11 80       	push   $0x80111fc0
80100a20:	e8 6b 3d 00 00       	call   80104790 <wakeup>
80100a25:	83 c4 10             	add    $0x10,%esp
80100a28:	e9 6b fe ff ff       	jmp    80100898 <consoleintr+0x38>
80100a2d:	8d 76 00             	lea    0x0(%esi),%esi

80100a30 <consoleinit>:

void
consoleinit(void)
{
80100a30:	f3 0f 1e fb          	endbr32 
80100a34:	55                   	push   %ebp
80100a35:	89 e5                	mov    %esp,%ebp
80100a37:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a3a:	68 68 84 10 80       	push   $0x80108468
80100a3f:	68 20 c5 10 80       	push   $0x8010c520
80100a44:	e8 b7 47 00 00       	call   80105200 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 8c 29 11 80 40 	movl   $0x80100640,0x8011298c
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 88 29 11 80 90 	movl   $0x80100290,0x80112988
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 c5 10 80 01 	movl   $0x1,0x8010c554
80100a6a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a6d:	e8 2e 1e 00 00       	call   801028a0 <ioapicenable>
}
80100a72:	83 c4 10             	add    $0x10,%esp
80100a75:	c9                   	leave  
80100a76:	c3                   	ret    
80100a77:	66 90                	xchg   %ax,%ax
80100a79:	66 90                	xchg   %ax,%ax
80100a7b:	66 90                	xchg   %ax,%ax
80100a7d:	66 90                	xchg   %ax,%ax
80100a7f:	90                   	nop

80100a80 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a80:	f3 0f 1e fb          	endbr32 
80100a84:	55                   	push   %ebp
80100a85:	89 e5                	mov    %esp,%ebp
80100a87:	57                   	push   %edi
80100a88:	56                   	push   %esi
80100a89:	53                   	push   %ebx
80100a8a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a90:	e8 4b 34 00 00       	call   80103ee0 <myproc>
80100a95:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a9b:	e8 00 27 00 00       	call   801031a0 <begin_op>

  if((ip = namei(path)) == 0){
80100aa0:	83 ec 0c             	sub    $0xc,%esp
80100aa3:	ff 75 08             	pushl  0x8(%ebp)
80100aa6:	e8 85 15 00 00       	call   80102030 <namei>
80100aab:	83 c4 10             	add    $0x10,%esp
80100aae:	85 c0                	test   %eax,%eax
80100ab0:	0f 84 fe 02 00 00    	je     80100db4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ab6:	83 ec 0c             	sub    $0xc,%esp
80100ab9:	89 c3                	mov    %eax,%ebx
80100abb:	50                   	push   %eax
80100abc:	e8 9f 0c 00 00       	call   80101760 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ac1:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ac7:	6a 34                	push   $0x34
80100ac9:	6a 00                	push   $0x0
80100acb:	50                   	push   %eax
80100acc:	53                   	push   %ebx
80100acd:	e8 8e 0f 00 00       	call   80101a60 <readi>
80100ad2:	83 c4 20             	add    $0x20,%esp
80100ad5:	83 f8 34             	cmp    $0x34,%eax
80100ad8:	74 26                	je     80100b00 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100ada:	83 ec 0c             	sub    $0xc,%esp
80100add:	53                   	push   %ebx
80100ade:	e8 1d 0f 00 00       	call   80101a00 <iunlockput>
    end_op();
80100ae3:	e8 28 27 00 00       	call   80103210 <end_op>
80100ae8:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100aeb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100af0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100af3:	5b                   	pop    %ebx
80100af4:	5e                   	pop    %esi
80100af5:	5f                   	pop    %edi
80100af6:	5d                   	pop    %ebp
80100af7:	c3                   	ret    
80100af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aff:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80100b00:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b07:	45 4c 46 
80100b0a:	75 ce                	jne    80100ada <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
80100b0c:	e8 9f 71 00 00       	call   80107cb0 <setupkvm>
80100b11:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b17:	85 c0                	test   %eax,%eax
80100b19:	74 bf                	je     80100ada <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b1b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b22:	00 
80100b23:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b29:	0f 84 a4 02 00 00    	je     80100dd3 <exec+0x353>
  sz = 0;
80100b2f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b36:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b39:	31 ff                	xor    %edi,%edi
80100b3b:	e9 86 00 00 00       	jmp    80100bc6 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
80100b40:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b47:	75 6c                	jne    80100bb5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b49:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b4f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b55:	0f 82 87 00 00 00    	jb     80100be2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b5b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b61:	72 7f                	jb     80100be2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b63:	83 ec 04             	sub    $0x4,%esp
80100b66:	50                   	push   %eax
80100b67:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b6d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b73:	e8 88 75 00 00       	call   80108100 <allocuvm>
80100b78:	83 c4 10             	add    $0x10,%esp
80100b7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b81:	85 c0                	test   %eax,%eax
80100b83:	74 5d                	je     80100be2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100b85:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b8b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b90:	75 50                	jne    80100be2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b92:	83 ec 0c             	sub    $0xc,%esp
80100b95:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b9b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100ba1:	53                   	push   %ebx
80100ba2:	50                   	push   %eax
80100ba3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba9:	e8 42 6e 00 00       	call   801079f0 <loaduvm>
80100bae:	83 c4 20             	add    $0x20,%esp
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	78 2d                	js     80100be2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bb5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bbc:	83 c7 01             	add    $0x1,%edi
80100bbf:	83 c6 20             	add    $0x20,%esi
80100bc2:	39 f8                	cmp    %edi,%eax
80100bc4:	7e 3a                	jle    80100c00 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bc6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bcc:	6a 20                	push   $0x20
80100bce:	56                   	push   %esi
80100bcf:	50                   	push   %eax
80100bd0:	53                   	push   %ebx
80100bd1:	e8 8a 0e 00 00       	call   80101a60 <readi>
80100bd6:	83 c4 10             	add    $0x10,%esp
80100bd9:	83 f8 20             	cmp    $0x20,%eax
80100bdc:	0f 84 5e ff ff ff    	je     80100b40 <exec+0xc0>
    freevm(pgdir);
80100be2:	83 ec 0c             	sub    $0xc,%esp
80100be5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100beb:	e8 40 70 00 00       	call   80107c30 <freevm>
  if(ip){
80100bf0:	83 c4 10             	add    $0x10,%esp
80100bf3:	e9 e2 fe ff ff       	jmp    80100ada <exec+0x5a>
80100bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bff:	90                   	nop
80100c00:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c06:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c0c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c12:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c18:	83 ec 0c             	sub    $0xc,%esp
80100c1b:	53                   	push   %ebx
80100c1c:	e8 df 0d 00 00       	call   80101a00 <iunlockput>
  end_op();
80100c21:	e8 ea 25 00 00       	call   80103210 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 c9 74 00 00       	call   80108100 <allocuvm>
80100c37:	83 c4 10             	add    $0x10,%esp
80100c3a:	89 c6                	mov    %eax,%esi
80100c3c:	85 c0                	test   %eax,%eax
80100c3e:	0f 84 94 00 00 00    	je     80100cd8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c44:	83 ec 08             	sub    $0x8,%esp
80100c47:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c4d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c4f:	50                   	push   %eax
80100c50:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c51:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c53:	e8 f8 70 00 00       	call   80107d50 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c58:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c5b:	83 c4 10             	add    $0x10,%esp
80100c5e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c64:	8b 00                	mov    (%eax),%eax
80100c66:	85 c0                	test   %eax,%eax
80100c68:	0f 84 8b 00 00 00    	je     80100cf9 <exec+0x279>
80100c6e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c74:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c7a:	eb 23                	jmp    80100c9f <exec+0x21f>
80100c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c80:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c83:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c8a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c8d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c93:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	74 59                	je     80100cf3 <exec+0x273>
    if(argc >= MAXARG)
80100c9a:	83 ff 20             	cmp    $0x20,%edi
80100c9d:	74 39                	je     80100cd8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c9f:	83 ec 0c             	sub    $0xc,%esp
80100ca2:	50                   	push   %eax
80100ca3:	e8 e8 49 00 00       	call   80105690 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 d5 49 00 00       	call   80105690 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 24 72 00 00       	call   80107ef0 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 4a 6f 00 00       	call   80107c30 <freevm>
80100ce6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100ce9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cee:	e9 fd fd ff ff       	jmp    80100af0 <exec+0x70>
80100cf3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cf9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d00:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d02:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d09:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d0d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d0f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d12:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d18:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d1a:	50                   	push   %eax
80100d1b:	52                   	push   %edx
80100d1c:	53                   	push   %ebx
80100d1d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d23:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d2a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d2d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d33:	e8 b8 71 00 00       	call   80107ef0 <copyout>
80100d38:	83 c4 10             	add    $0x10,%esp
80100d3b:	85 c0                	test   %eax,%eax
80100d3d:	78 99                	js     80100cd8 <exec+0x258>
  for(last=s=path; *s; s++)
80100d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d42:	8b 55 08             	mov    0x8(%ebp),%edx
80100d45:	0f b6 00             	movzbl (%eax),%eax
80100d48:	84 c0                	test   %al,%al
80100d4a:	74 13                	je     80100d5f <exec+0x2df>
80100d4c:	89 d1                	mov    %edx,%ecx
80100d4e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80100d50:	83 c1 01             	add    $0x1,%ecx
80100d53:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d55:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100d58:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d5b:	84 c0                	test   %al,%al
80100d5d:	75 f1                	jne    80100d50 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d5f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d65:	83 ec 04             	sub    $0x4,%esp
80100d68:	6a 10                	push   $0x10
80100d6a:	89 f8                	mov    %edi,%eax
80100d6c:	52                   	push   %edx
80100d6d:	83 c0 6c             	add    $0x6c,%eax
80100d70:	50                   	push   %eax
80100d71:	e8 da 48 00 00       	call   80105650 <safestrcpy>
  curproc->pgdir = pgdir;
80100d76:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d7c:	89 f8                	mov    %edi,%eax
80100d7e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100d81:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100d83:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d86:	89 c1                	mov    %eax,%ecx
80100d88:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d8e:	8b 40 18             	mov    0x18(%eax),%eax
80100d91:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d94:	8b 41 18             	mov    0x18(%ecx),%eax
80100d97:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d9a:	89 0c 24             	mov    %ecx,(%esp)
80100d9d:	e8 be 6a 00 00       	call   80107860 <switchuvm>
  freevm(oldpgdir);
80100da2:	89 3c 24             	mov    %edi,(%esp)
80100da5:	e8 86 6e 00 00       	call   80107c30 <freevm>
  return 0;
80100daa:	83 c4 10             	add    $0x10,%esp
80100dad:	31 c0                	xor    %eax,%eax
80100daf:	e9 3c fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100db4:	e8 57 24 00 00       	call   80103210 <end_op>
    cprintf("exec: fail\n");
80100db9:	83 ec 0c             	sub    $0xc,%esp
80100dbc:	68 81 84 10 80       	push   $0x80108481
80100dc1:	e8 ea f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100dc6:	83 c4 10             	add    $0x10,%esp
80100dc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dce:	e9 1d fd ff ff       	jmp    80100af0 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dd3:	31 ff                	xor    %edi,%edi
80100dd5:	be 00 20 00 00       	mov    $0x2000,%esi
80100dda:	e9 39 fe ff ff       	jmp    80100c18 <exec+0x198>
80100ddf:	90                   	nop

80100de0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100de0:	f3 0f 1e fb          	endbr32 
80100de4:	55                   	push   %ebp
80100de5:	89 e5                	mov    %esp,%ebp
80100de7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100dea:	68 8d 84 10 80       	push   $0x8010848d
80100def:	68 e0 1f 11 80       	push   $0x80111fe0
80100df4:	e8 07 44 00 00       	call   80105200 <initlock>
}
80100df9:	83 c4 10             	add    $0x10,%esp
80100dfc:	c9                   	leave  
80100dfd:	c3                   	ret    
80100dfe:	66 90                	xchg   %ax,%ax

80100e00 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e00:	f3 0f 1e fb          	endbr32 
80100e04:	55                   	push   %ebp
80100e05:	89 e5                	mov    %esp,%ebp
80100e07:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e08:	bb 14 20 11 80       	mov    $0x80112014,%ebx
{
80100e0d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e10:	68 e0 1f 11 80       	push   $0x80111fe0
80100e15:	e8 66 45 00 00       	call   80105380 <acquire>
80100e1a:	83 c4 10             	add    $0x10,%esp
80100e1d:	eb 0c                	jmp    80100e2b <filealloc+0x2b>
80100e1f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e20:	83 c3 18             	add    $0x18,%ebx
80100e23:	81 fb 74 29 11 80    	cmp    $0x80112974,%ebx
80100e29:	74 25                	je     80100e50 <filealloc+0x50>
    if(f->ref == 0){
80100e2b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e2e:	85 c0                	test   %eax,%eax
80100e30:	75 ee                	jne    80100e20 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e32:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e35:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e3c:	68 e0 1f 11 80       	push   $0x80111fe0
80100e41:	e8 fa 45 00 00       	call   80105440 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e46:	89 d8                	mov    %ebx,%eax
      return f;
80100e48:	83 c4 10             	add    $0x10,%esp
}
80100e4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e4e:	c9                   	leave  
80100e4f:	c3                   	ret    
  release(&ftable.lock);
80100e50:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e53:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e55:	68 e0 1f 11 80       	push   $0x80111fe0
80100e5a:	e8 e1 45 00 00       	call   80105440 <release>
}
80100e5f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e61:	83 c4 10             	add    $0x10,%esp
}
80100e64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e67:	c9                   	leave  
80100e68:	c3                   	ret    
80100e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e70 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e70:	f3 0f 1e fb          	endbr32 
80100e74:	55                   	push   %ebp
80100e75:	89 e5                	mov    %esp,%ebp
80100e77:	53                   	push   %ebx
80100e78:	83 ec 10             	sub    $0x10,%esp
80100e7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e7e:	68 e0 1f 11 80       	push   $0x80111fe0
80100e83:	e8 f8 44 00 00       	call   80105380 <acquire>
  if(f->ref < 1)
80100e88:	8b 43 04             	mov    0x4(%ebx),%eax
80100e8b:	83 c4 10             	add    $0x10,%esp
80100e8e:	85 c0                	test   %eax,%eax
80100e90:	7e 1a                	jle    80100eac <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100e92:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e95:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e98:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e9b:	68 e0 1f 11 80       	push   $0x80111fe0
80100ea0:	e8 9b 45 00 00       	call   80105440 <release>
  return f;
}
80100ea5:	89 d8                	mov    %ebx,%eax
80100ea7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eaa:	c9                   	leave  
80100eab:	c3                   	ret    
    panic("filedup");
80100eac:	83 ec 0c             	sub    $0xc,%esp
80100eaf:	68 94 84 10 80       	push   $0x80108494
80100eb4:	e8 d7 f4 ff ff       	call   80100390 <panic>
80100eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ec0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ec0:	f3 0f 1e fb          	endbr32 
80100ec4:	55                   	push   %ebp
80100ec5:	89 e5                	mov    %esp,%ebp
80100ec7:	57                   	push   %edi
80100ec8:	56                   	push   %esi
80100ec9:	53                   	push   %ebx
80100eca:	83 ec 28             	sub    $0x28,%esp
80100ecd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ed0:	68 e0 1f 11 80       	push   $0x80111fe0
80100ed5:	e8 a6 44 00 00       	call   80105380 <acquire>
  if(f->ref < 1)
80100eda:	8b 53 04             	mov    0x4(%ebx),%edx
80100edd:	83 c4 10             	add    $0x10,%esp
80100ee0:	85 d2                	test   %edx,%edx
80100ee2:	0f 8e a1 00 00 00    	jle    80100f89 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100ee8:	83 ea 01             	sub    $0x1,%edx
80100eeb:	89 53 04             	mov    %edx,0x4(%ebx)
80100eee:	75 40                	jne    80100f30 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100ef0:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100ef4:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100ef7:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100ef9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100eff:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f02:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f05:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f08:	68 e0 1f 11 80       	push   $0x80111fe0
  ff = *f;
80100f0d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f10:	e8 2b 45 00 00       	call   80105440 <release>

  if(ff.type == FD_PIPE)
80100f15:	83 c4 10             	add    $0x10,%esp
80100f18:	83 ff 01             	cmp    $0x1,%edi
80100f1b:	74 53                	je     80100f70 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f1d:	83 ff 02             	cmp    $0x2,%edi
80100f20:	74 26                	je     80100f48 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f22:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f25:	5b                   	pop    %ebx
80100f26:	5e                   	pop    %esi
80100f27:	5f                   	pop    %edi
80100f28:	5d                   	pop    %ebp
80100f29:	c3                   	ret    
80100f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f30:	c7 45 08 e0 1f 11 80 	movl   $0x80111fe0,0x8(%ebp)
}
80100f37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f3a:	5b                   	pop    %ebx
80100f3b:	5e                   	pop    %esi
80100f3c:	5f                   	pop    %edi
80100f3d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f3e:	e9 fd 44 00 00       	jmp    80105440 <release>
80100f43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f47:	90                   	nop
    begin_op();
80100f48:	e8 53 22 00 00       	call   801031a0 <begin_op>
    iput(ff.ip);
80100f4d:	83 ec 0c             	sub    $0xc,%esp
80100f50:	ff 75 e0             	pushl  -0x20(%ebp)
80100f53:	e8 38 09 00 00       	call   80101890 <iput>
    end_op();
80100f58:	83 c4 10             	add    $0x10,%esp
}
80100f5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f5e:	5b                   	pop    %ebx
80100f5f:	5e                   	pop    %esi
80100f60:	5f                   	pop    %edi
80100f61:	5d                   	pop    %ebp
    end_op();
80100f62:	e9 a9 22 00 00       	jmp    80103210 <end_op>
80100f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f6e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100f70:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f74:	83 ec 08             	sub    $0x8,%esp
80100f77:	53                   	push   %ebx
80100f78:	56                   	push   %esi
80100f79:	e8 f2 29 00 00       	call   80103970 <pipeclose>
80100f7e:	83 c4 10             	add    $0x10,%esp
}
80100f81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f84:	5b                   	pop    %ebx
80100f85:	5e                   	pop    %esi
80100f86:	5f                   	pop    %edi
80100f87:	5d                   	pop    %ebp
80100f88:	c3                   	ret    
    panic("fileclose");
80100f89:	83 ec 0c             	sub    $0xc,%esp
80100f8c:	68 9c 84 10 80       	push   $0x8010849c
80100f91:	e8 fa f3 ff ff       	call   80100390 <panic>
80100f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9d:	8d 76 00             	lea    0x0(%esi),%esi

80100fa0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fa0:	f3 0f 1e fb          	endbr32 
80100fa4:	55                   	push   %ebp
80100fa5:	89 e5                	mov    %esp,%ebp
80100fa7:	53                   	push   %ebx
80100fa8:	83 ec 04             	sub    $0x4,%esp
80100fab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fae:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fb1:	75 2d                	jne    80100fe0 <filestat+0x40>
    ilock(f->ip);
80100fb3:	83 ec 0c             	sub    $0xc,%esp
80100fb6:	ff 73 10             	pushl  0x10(%ebx)
80100fb9:	e8 a2 07 00 00       	call   80101760 <ilock>
    stati(f->ip, st);
80100fbe:	58                   	pop    %eax
80100fbf:	5a                   	pop    %edx
80100fc0:	ff 75 0c             	pushl  0xc(%ebp)
80100fc3:	ff 73 10             	pushl  0x10(%ebx)
80100fc6:	e8 65 0a 00 00       	call   80101a30 <stati>
    iunlock(f->ip);
80100fcb:	59                   	pop    %ecx
80100fcc:	ff 73 10             	pushl  0x10(%ebx)
80100fcf:	e8 6c 08 00 00       	call   80101840 <iunlock>
    return 0;
  }
  return -1;
}
80100fd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80100fd7:	83 c4 10             	add    $0x10,%esp
80100fda:	31 c0                	xor    %eax,%eax
}
80100fdc:	c9                   	leave  
80100fdd:	c3                   	ret    
80100fde:	66 90                	xchg   %ax,%ax
80100fe0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80100fe3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fe8:	c9                   	leave  
80100fe9:	c3                   	ret    
80100fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ff0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100ff0:	f3 0f 1e fb          	endbr32 
80100ff4:	55                   	push   %ebp
80100ff5:	89 e5                	mov    %esp,%ebp
80100ff7:	57                   	push   %edi
80100ff8:	56                   	push   %esi
80100ff9:	53                   	push   %ebx
80100ffa:	83 ec 0c             	sub    $0xc,%esp
80100ffd:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101000:	8b 75 0c             	mov    0xc(%ebp),%esi
80101003:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101006:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010100a:	74 64                	je     80101070 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010100c:	8b 03                	mov    (%ebx),%eax
8010100e:	83 f8 01             	cmp    $0x1,%eax
80101011:	74 45                	je     80101058 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101013:	83 f8 02             	cmp    $0x2,%eax
80101016:	75 5f                	jne    80101077 <fileread+0x87>
    ilock(f->ip);
80101018:	83 ec 0c             	sub    $0xc,%esp
8010101b:	ff 73 10             	pushl  0x10(%ebx)
8010101e:	e8 3d 07 00 00       	call   80101760 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101023:	57                   	push   %edi
80101024:	ff 73 14             	pushl  0x14(%ebx)
80101027:	56                   	push   %esi
80101028:	ff 73 10             	pushl  0x10(%ebx)
8010102b:	e8 30 0a 00 00       	call   80101a60 <readi>
80101030:	83 c4 20             	add    $0x20,%esp
80101033:	89 c6                	mov    %eax,%esi
80101035:	85 c0                	test   %eax,%eax
80101037:	7e 03                	jle    8010103c <fileread+0x4c>
      f->off += r;
80101039:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010103c:	83 ec 0c             	sub    $0xc,%esp
8010103f:	ff 73 10             	pushl  0x10(%ebx)
80101042:	e8 f9 07 00 00       	call   80101840 <iunlock>
    return r;
80101047:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010104a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010104d:	89 f0                	mov    %esi,%eax
8010104f:	5b                   	pop    %ebx
80101050:	5e                   	pop    %esi
80101051:	5f                   	pop    %edi
80101052:	5d                   	pop    %ebp
80101053:	c3                   	ret    
80101054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101058:	8b 43 0c             	mov    0xc(%ebx),%eax
8010105b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010105e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101061:	5b                   	pop    %ebx
80101062:	5e                   	pop    %esi
80101063:	5f                   	pop    %edi
80101064:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101065:	e9 a6 2a 00 00       	jmp    80103b10 <piperead>
8010106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101070:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101075:	eb d3                	jmp    8010104a <fileread+0x5a>
  panic("fileread");
80101077:	83 ec 0c             	sub    $0xc,%esp
8010107a:	68 a6 84 10 80       	push   $0x801084a6
8010107f:	e8 0c f3 ff ff       	call   80100390 <panic>
80101084:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010108b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010108f:	90                   	nop

80101090 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101090:	f3 0f 1e fb          	endbr32 
80101094:	55                   	push   %ebp
80101095:	89 e5                	mov    %esp,%ebp
80101097:	57                   	push   %edi
80101098:	56                   	push   %esi
80101099:	53                   	push   %ebx
8010109a:	83 ec 1c             	sub    $0x1c,%esp
8010109d:	8b 45 0c             	mov    0xc(%ebp),%eax
801010a0:	8b 75 08             	mov    0x8(%ebp),%esi
801010a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010a6:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010a9:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010b0:	0f 84 c1 00 00 00    	je     80101177 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
801010b6:	8b 06                	mov    (%esi),%eax
801010b8:	83 f8 01             	cmp    $0x1,%eax
801010bb:	0f 84 c3 00 00 00    	je     80101184 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010c1:	83 f8 02             	cmp    $0x2,%eax
801010c4:	0f 85 cc 00 00 00    	jne    80101196 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010cd:	31 ff                	xor    %edi,%edi
    while(i < n){
801010cf:	85 c0                	test   %eax,%eax
801010d1:	7f 34                	jg     80101107 <filewrite+0x77>
801010d3:	e9 98 00 00 00       	jmp    80101170 <filewrite+0xe0>
801010d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010df:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010e0:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010e3:	83 ec 0c             	sub    $0xc,%esp
801010e6:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010ec:	e8 4f 07 00 00       	call   80101840 <iunlock>
      end_op();
801010f1:	e8 1a 21 00 00       	call   80103210 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801010f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010f9:	83 c4 10             	add    $0x10,%esp
801010fc:	39 c3                	cmp    %eax,%ebx
801010fe:	75 60                	jne    80101160 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101100:	01 df                	add    %ebx,%edi
    while(i < n){
80101102:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101105:	7e 69                	jle    80101170 <filewrite+0xe0>
      int n1 = n - i;
80101107:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010110a:	b8 00 06 00 00       	mov    $0x600,%eax
8010110f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101111:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101117:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010111a:	e8 81 20 00 00       	call   801031a0 <begin_op>
      ilock(f->ip);
8010111f:	83 ec 0c             	sub    $0xc,%esp
80101122:	ff 76 10             	pushl  0x10(%esi)
80101125:	e8 36 06 00 00       	call   80101760 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010112a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010112d:	53                   	push   %ebx
8010112e:	ff 76 14             	pushl  0x14(%esi)
80101131:	01 f8                	add    %edi,%eax
80101133:	50                   	push   %eax
80101134:	ff 76 10             	pushl  0x10(%esi)
80101137:	e8 24 0a 00 00       	call   80101b60 <writei>
8010113c:	83 c4 20             	add    $0x20,%esp
8010113f:	85 c0                	test   %eax,%eax
80101141:	7f 9d                	jg     801010e0 <filewrite+0x50>
      iunlock(f->ip);
80101143:	83 ec 0c             	sub    $0xc,%esp
80101146:	ff 76 10             	pushl  0x10(%esi)
80101149:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010114c:	e8 ef 06 00 00       	call   80101840 <iunlock>
      end_op();
80101151:	e8 ba 20 00 00       	call   80103210 <end_op>
      if(r < 0)
80101156:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101159:	83 c4 10             	add    $0x10,%esp
8010115c:	85 c0                	test   %eax,%eax
8010115e:	75 17                	jne    80101177 <filewrite+0xe7>
        panic("short filewrite");
80101160:	83 ec 0c             	sub    $0xc,%esp
80101163:	68 af 84 10 80       	push   $0x801084af
80101168:	e8 23 f2 ff ff       	call   80100390 <panic>
8010116d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101170:	89 f8                	mov    %edi,%eax
80101172:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101175:	74 05                	je     8010117c <filewrite+0xec>
80101177:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010117c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010117f:	5b                   	pop    %ebx
80101180:	5e                   	pop    %esi
80101181:	5f                   	pop    %edi
80101182:	5d                   	pop    %ebp
80101183:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101184:	8b 46 0c             	mov    0xc(%esi),%eax
80101187:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010118a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010118d:	5b                   	pop    %ebx
8010118e:	5e                   	pop    %esi
8010118f:	5f                   	pop    %edi
80101190:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101191:	e9 7a 28 00 00       	jmp    80103a10 <pipewrite>
  panic("filewrite");
80101196:	83 ec 0c             	sub    $0xc,%esp
80101199:	68 b5 84 10 80       	push   $0x801084b5
8010119e:	e8 ed f1 ff ff       	call   80100390 <panic>
801011a3:	66 90                	xchg   %ax,%ax
801011a5:	66 90                	xchg   %ax,%ax
801011a7:	66 90                	xchg   %ax,%ax
801011a9:	66 90                	xchg   %ax,%ax
801011ab:	66 90                	xchg   %ax,%ax
801011ad:	66 90                	xchg   %ax,%ax
801011af:	90                   	nop

801011b0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011b0:	55                   	push   %ebp
801011b1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011b3:	89 d0                	mov    %edx,%eax
801011b5:	c1 e8 0c             	shr    $0xc,%eax
801011b8:	03 05 f8 29 11 80    	add    0x801129f8,%eax
{
801011be:	89 e5                	mov    %esp,%ebp
801011c0:	56                   	push   %esi
801011c1:	53                   	push   %ebx
801011c2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011c4:	83 ec 08             	sub    $0x8,%esp
801011c7:	50                   	push   %eax
801011c8:	51                   	push   %ecx
801011c9:	e8 02 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011ce:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011d0:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801011d3:	ba 01 00 00 00       	mov    $0x1,%edx
801011d8:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801011db:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801011e1:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801011e4:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801011e6:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801011eb:	85 d1                	test   %edx,%ecx
801011ed:	74 25                	je     80101214 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801011ef:	f7 d2                	not    %edx
  log_write(bp);
801011f1:	83 ec 0c             	sub    $0xc,%esp
801011f4:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
801011f6:	21 ca                	and    %ecx,%edx
801011f8:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
801011fc:	50                   	push   %eax
801011fd:	e8 7e 21 00 00       	call   80103380 <log_write>
  brelse(bp);
80101202:	89 34 24             	mov    %esi,(%esp)
80101205:	e8 e6 ef ff ff       	call   801001f0 <brelse>
}
8010120a:	83 c4 10             	add    $0x10,%esp
8010120d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101210:	5b                   	pop    %ebx
80101211:	5e                   	pop    %esi
80101212:	5d                   	pop    %ebp
80101213:	c3                   	ret    
    panic("freeing free block");
80101214:	83 ec 0c             	sub    $0xc,%esp
80101217:	68 bf 84 10 80       	push   $0x801084bf
8010121c:	e8 6f f1 ff ff       	call   80100390 <panic>
80101221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101228:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010122f:	90                   	nop

80101230 <balloc>:
{
80101230:	55                   	push   %ebp
80101231:	89 e5                	mov    %esp,%ebp
80101233:	57                   	push   %edi
80101234:	56                   	push   %esi
80101235:	53                   	push   %ebx
80101236:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101239:	8b 0d e0 29 11 80    	mov    0x801129e0,%ecx
{
8010123f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101242:	85 c9                	test   %ecx,%ecx
80101244:	0f 84 87 00 00 00    	je     801012d1 <balloc+0xa1>
8010124a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101251:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101254:	83 ec 08             	sub    $0x8,%esp
80101257:	89 f0                	mov    %esi,%eax
80101259:	c1 f8 0c             	sar    $0xc,%eax
8010125c:	03 05 f8 29 11 80    	add    0x801129f8,%eax
80101262:	50                   	push   %eax
80101263:	ff 75 d8             	pushl  -0x28(%ebp)
80101266:	e8 65 ee ff ff       	call   801000d0 <bread>
8010126b:	83 c4 10             	add    $0x10,%esp
8010126e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101271:	a1 e0 29 11 80       	mov    0x801129e0,%eax
80101276:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101279:	31 c0                	xor    %eax,%eax
8010127b:	eb 2f                	jmp    801012ac <balloc+0x7c>
8010127d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101280:	89 c1                	mov    %eax,%ecx
80101282:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101287:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010128a:	83 e1 07             	and    $0x7,%ecx
8010128d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010128f:	89 c1                	mov    %eax,%ecx
80101291:	c1 f9 03             	sar    $0x3,%ecx
80101294:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101299:	89 fa                	mov    %edi,%edx
8010129b:	85 df                	test   %ebx,%edi
8010129d:	74 41                	je     801012e0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010129f:	83 c0 01             	add    $0x1,%eax
801012a2:	83 c6 01             	add    $0x1,%esi
801012a5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012aa:	74 05                	je     801012b1 <balloc+0x81>
801012ac:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012af:	77 cf                	ja     80101280 <balloc+0x50>
    brelse(bp);
801012b1:	83 ec 0c             	sub    $0xc,%esp
801012b4:	ff 75 e4             	pushl  -0x1c(%ebp)
801012b7:	e8 34 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012bc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012c3:	83 c4 10             	add    $0x10,%esp
801012c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012c9:	39 05 e0 29 11 80    	cmp    %eax,0x801129e0
801012cf:	77 80                	ja     80101251 <balloc+0x21>
  panic("balloc: out of blocks");
801012d1:	83 ec 0c             	sub    $0xc,%esp
801012d4:	68 d2 84 10 80       	push   $0x801084d2
801012d9:	e8 b2 f0 ff ff       	call   80100390 <panic>
801012de:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012e3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012e6:	09 da                	or     %ebx,%edx
801012e8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012ec:	57                   	push   %edi
801012ed:	e8 8e 20 00 00       	call   80103380 <log_write>
        brelse(bp);
801012f2:	89 3c 24             	mov    %edi,(%esp)
801012f5:	e8 f6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801012fa:	58                   	pop    %eax
801012fb:	5a                   	pop    %edx
801012fc:	56                   	push   %esi
801012fd:	ff 75 d8             	pushl  -0x28(%ebp)
80101300:	e8 cb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101305:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101308:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010130a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010130d:	68 00 02 00 00       	push   $0x200
80101312:	6a 00                	push   $0x0
80101314:	50                   	push   %eax
80101315:	e8 76 41 00 00       	call   80105490 <memset>
  log_write(bp);
8010131a:	89 1c 24             	mov    %ebx,(%esp)
8010131d:	e8 5e 20 00 00       	call   80103380 <log_write>
  brelse(bp);
80101322:	89 1c 24             	mov    %ebx,(%esp)
80101325:	e8 c6 ee ff ff       	call   801001f0 <brelse>
}
8010132a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010132d:	89 f0                	mov    %esi,%eax
8010132f:	5b                   	pop    %ebx
80101330:	5e                   	pop    %esi
80101331:	5f                   	pop    %edi
80101332:	5d                   	pop    %ebp
80101333:	c3                   	ret    
80101334:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010133b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010133f:	90                   	nop

80101340 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101340:	55                   	push   %ebp
80101341:	89 e5                	mov    %esp,%ebp
80101343:	57                   	push   %edi
80101344:	89 c7                	mov    %eax,%edi
80101346:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101347:	31 f6                	xor    %esi,%esi
{
80101349:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010134a:	bb 34 2a 11 80       	mov    $0x80112a34,%ebx
{
8010134f:	83 ec 28             	sub    $0x28,%esp
80101352:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101355:	68 00 2a 11 80       	push   $0x80112a00
8010135a:	e8 21 40 00 00       	call   80105380 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101362:	83 c4 10             	add    $0x10,%esp
80101365:	eb 1b                	jmp    80101382 <iget+0x42>
80101367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010136e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101370:	39 3b                	cmp    %edi,(%ebx)
80101372:	74 6c                	je     801013e0 <iget+0xa0>
80101374:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010137a:	81 fb 54 46 11 80    	cmp    $0x80114654,%ebx
80101380:	73 26                	jae    801013a8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101382:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101385:	85 c9                	test   %ecx,%ecx
80101387:	7f e7                	jg     80101370 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101389:	85 f6                	test   %esi,%esi
8010138b:	75 e7                	jne    80101374 <iget+0x34>
8010138d:	89 d8                	mov    %ebx,%eax
8010138f:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101395:	85 c9                	test   %ecx,%ecx
80101397:	75 6e                	jne    80101407 <iget+0xc7>
80101399:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010139b:	81 fb 54 46 11 80    	cmp    $0x80114654,%ebx
801013a1:	72 df                	jb     80101382 <iget+0x42>
801013a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013a7:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013a8:	85 f6                	test   %esi,%esi
801013aa:	74 73                	je     8010141f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013ac:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013af:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013b1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013b4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013bb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013c2:	68 00 2a 11 80       	push   $0x80112a00
801013c7:	e8 74 40 00 00       	call   80105440 <release>

  return ip;
801013cc:	83 c4 10             	add    $0x10,%esp
}
801013cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013d2:	89 f0                	mov    %esi,%eax
801013d4:	5b                   	pop    %ebx
801013d5:	5e                   	pop    %esi
801013d6:	5f                   	pop    %edi
801013d7:	5d                   	pop    %ebp
801013d8:	c3                   	ret    
801013d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013e0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013e3:	75 8f                	jne    80101374 <iget+0x34>
      release(&icache.lock);
801013e5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013e8:	83 c1 01             	add    $0x1,%ecx
      return ip;
801013eb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013ed:	68 00 2a 11 80       	push   $0x80112a00
      ip->ref++;
801013f2:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801013f5:	e8 46 40 00 00       	call   80105440 <release>
      return ip;
801013fa:	83 c4 10             	add    $0x10,%esp
}
801013fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101400:	89 f0                	mov    %esi,%eax
80101402:	5b                   	pop    %ebx
80101403:	5e                   	pop    %esi
80101404:	5f                   	pop    %edi
80101405:	5d                   	pop    %ebp
80101406:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101407:	81 fb 54 46 11 80    	cmp    $0x80114654,%ebx
8010140d:	73 10                	jae    8010141f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010140f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101412:	85 c9                	test   %ecx,%ecx
80101414:	0f 8f 56 ff ff ff    	jg     80101370 <iget+0x30>
8010141a:	e9 6e ff ff ff       	jmp    8010138d <iget+0x4d>
    panic("iget: no inodes");
8010141f:	83 ec 0c             	sub    $0xc,%esp
80101422:	68 e8 84 10 80       	push   $0x801084e8
80101427:	e8 64 ef ff ff       	call   80100390 <panic>
8010142c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101430 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101430:	55                   	push   %ebp
80101431:	89 e5                	mov    %esp,%ebp
80101433:	57                   	push   %edi
80101434:	56                   	push   %esi
80101435:	89 c6                	mov    %eax,%esi
80101437:	53                   	push   %ebx
80101438:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010143b:	83 fa 0b             	cmp    $0xb,%edx
8010143e:	0f 86 84 00 00 00    	jbe    801014c8 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101444:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101447:	83 fb 7f             	cmp    $0x7f,%ebx
8010144a:	0f 87 98 00 00 00    	ja     801014e8 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101450:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101456:	8b 16                	mov    (%esi),%edx
80101458:	85 c0                	test   %eax,%eax
8010145a:	74 54                	je     801014b0 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010145c:	83 ec 08             	sub    $0x8,%esp
8010145f:	50                   	push   %eax
80101460:	52                   	push   %edx
80101461:	e8 6a ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101466:	83 c4 10             	add    $0x10,%esp
80101469:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
8010146d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010146f:	8b 1a                	mov    (%edx),%ebx
80101471:	85 db                	test   %ebx,%ebx
80101473:	74 1b                	je     80101490 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101475:	83 ec 0c             	sub    $0xc,%esp
80101478:	57                   	push   %edi
80101479:	e8 72 ed ff ff       	call   801001f0 <brelse>
    return addr;
8010147e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101481:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101484:	89 d8                	mov    %ebx,%eax
80101486:	5b                   	pop    %ebx
80101487:	5e                   	pop    %esi
80101488:	5f                   	pop    %edi
80101489:	5d                   	pop    %ebp
8010148a:	c3                   	ret    
8010148b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010148f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101490:	8b 06                	mov    (%esi),%eax
80101492:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101495:	e8 96 fd ff ff       	call   80101230 <balloc>
8010149a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010149d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014a0:	89 c3                	mov    %eax,%ebx
801014a2:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801014a4:	57                   	push   %edi
801014a5:	e8 d6 1e 00 00       	call   80103380 <log_write>
801014aa:	83 c4 10             	add    $0x10,%esp
801014ad:	eb c6                	jmp    80101475 <bmap+0x45>
801014af:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014b0:	89 d0                	mov    %edx,%eax
801014b2:	e8 79 fd ff ff       	call   80101230 <balloc>
801014b7:	8b 16                	mov    (%esi),%edx
801014b9:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014bf:	eb 9b                	jmp    8010145c <bmap+0x2c>
801014c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
801014c8:	8d 3c 90             	lea    (%eax,%edx,4),%edi
801014cb:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801014ce:	85 db                	test   %ebx,%ebx
801014d0:	75 af                	jne    80101481 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014d2:	8b 00                	mov    (%eax),%eax
801014d4:	e8 57 fd ff ff       	call   80101230 <balloc>
801014d9:	89 47 5c             	mov    %eax,0x5c(%edi)
801014dc:	89 c3                	mov    %eax,%ebx
}
801014de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014e1:	89 d8                	mov    %ebx,%eax
801014e3:	5b                   	pop    %ebx
801014e4:	5e                   	pop    %esi
801014e5:	5f                   	pop    %edi
801014e6:	5d                   	pop    %ebp
801014e7:	c3                   	ret    
  panic("bmap: out of range");
801014e8:	83 ec 0c             	sub    $0xc,%esp
801014eb:	68 f8 84 10 80       	push   $0x801084f8
801014f0:	e8 9b ee ff ff       	call   80100390 <panic>
801014f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101500 <readsb>:
{
80101500:	f3 0f 1e fb          	endbr32 
80101504:	55                   	push   %ebp
80101505:	89 e5                	mov    %esp,%ebp
80101507:	56                   	push   %esi
80101508:	53                   	push   %ebx
80101509:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010150c:	83 ec 08             	sub    $0x8,%esp
8010150f:	6a 01                	push   $0x1
80101511:	ff 75 08             	pushl  0x8(%ebp)
80101514:	e8 b7 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101519:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010151c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010151e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101521:	6a 1c                	push   $0x1c
80101523:	50                   	push   %eax
80101524:	56                   	push   %esi
80101525:	e8 06 40 00 00       	call   80105530 <memmove>
  brelse(bp);
8010152a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010152d:	83 c4 10             	add    $0x10,%esp
}
80101530:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101533:	5b                   	pop    %ebx
80101534:	5e                   	pop    %esi
80101535:	5d                   	pop    %ebp
  brelse(bp);
80101536:	e9 b5 ec ff ff       	jmp    801001f0 <brelse>
8010153b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010153f:	90                   	nop

80101540 <iinit>:
{
80101540:	f3 0f 1e fb          	endbr32 
80101544:	55                   	push   %ebp
80101545:	89 e5                	mov    %esp,%ebp
80101547:	53                   	push   %ebx
80101548:	bb 40 2a 11 80       	mov    $0x80112a40,%ebx
8010154d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101550:	68 0b 85 10 80       	push   $0x8010850b
80101555:	68 00 2a 11 80       	push   $0x80112a00
8010155a:	e8 a1 3c 00 00       	call   80105200 <initlock>
  for(i = 0; i < NINODE; i++) {
8010155f:	83 c4 10             	add    $0x10,%esp
80101562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101568:	83 ec 08             	sub    $0x8,%esp
8010156b:	68 12 85 10 80       	push   $0x80108512
80101570:	53                   	push   %ebx
80101571:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101577:	e8 44 3b 00 00       	call   801050c0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010157c:	83 c4 10             	add    $0x10,%esp
8010157f:	81 fb 60 46 11 80    	cmp    $0x80114660,%ebx
80101585:	75 e1                	jne    80101568 <iinit+0x28>
  readsb(dev, &sb);
80101587:	83 ec 08             	sub    $0x8,%esp
8010158a:	68 e0 29 11 80       	push   $0x801129e0
8010158f:	ff 75 08             	pushl  0x8(%ebp)
80101592:	e8 69 ff ff ff       	call   80101500 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101597:	ff 35 f8 29 11 80    	pushl  0x801129f8
8010159d:	ff 35 f4 29 11 80    	pushl  0x801129f4
801015a3:	ff 35 f0 29 11 80    	pushl  0x801129f0
801015a9:	ff 35 ec 29 11 80    	pushl  0x801129ec
801015af:	ff 35 e8 29 11 80    	pushl  0x801129e8
801015b5:	ff 35 e4 29 11 80    	pushl  0x801129e4
801015bb:	ff 35 e0 29 11 80    	pushl  0x801129e0
801015c1:	68 ec 85 10 80       	push   $0x801085ec
801015c6:	e8 e5 f0 ff ff       	call   801006b0 <cprintf>
}
801015cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015ce:	83 c4 30             	add    $0x30,%esp
801015d1:	c9                   	leave  
801015d2:	c3                   	ret    
801015d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801015e0 <ialloc>:
{
801015e0:	f3 0f 1e fb          	endbr32 
801015e4:	55                   	push   %ebp
801015e5:	89 e5                	mov    %esp,%ebp
801015e7:	57                   	push   %edi
801015e8:	56                   	push   %esi
801015e9:	53                   	push   %ebx
801015ea:	83 ec 1c             	sub    $0x1c,%esp
801015ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801015f0:	83 3d e8 29 11 80 01 	cmpl   $0x1,0x801129e8
{
801015f7:	8b 75 08             	mov    0x8(%ebp),%esi
801015fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801015fd:	0f 86 8d 00 00 00    	jbe    80101690 <ialloc+0xb0>
80101603:	bf 01 00 00 00       	mov    $0x1,%edi
80101608:	eb 1d                	jmp    80101627 <ialloc+0x47>
8010160a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101610:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101613:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101616:	53                   	push   %ebx
80101617:	e8 d4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 c4 10             	add    $0x10,%esp
8010161f:	3b 3d e8 29 11 80    	cmp    0x801129e8,%edi
80101625:	73 69                	jae    80101690 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101627:	89 f8                	mov    %edi,%eax
80101629:	83 ec 08             	sub    $0x8,%esp
8010162c:	c1 e8 03             	shr    $0x3,%eax
8010162f:	03 05 f4 29 11 80    	add    0x801129f4,%eax
80101635:	50                   	push   %eax
80101636:	56                   	push   %esi
80101637:	e8 94 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010163c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010163f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101641:	89 f8                	mov    %edi,%eax
80101643:	83 e0 07             	and    $0x7,%eax
80101646:	c1 e0 06             	shl    $0x6,%eax
80101649:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010164d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101651:	75 bd                	jne    80101610 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101653:	83 ec 04             	sub    $0x4,%esp
80101656:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101659:	6a 40                	push   $0x40
8010165b:	6a 00                	push   $0x0
8010165d:	51                   	push   %ecx
8010165e:	e8 2d 3e 00 00       	call   80105490 <memset>
      dip->type = type;
80101663:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101667:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010166a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010166d:	89 1c 24             	mov    %ebx,(%esp)
80101670:	e8 0b 1d 00 00       	call   80103380 <log_write>
      brelse(bp);
80101675:	89 1c 24             	mov    %ebx,(%esp)
80101678:	e8 73 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010167d:	83 c4 10             	add    $0x10,%esp
}
80101680:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101683:	89 fa                	mov    %edi,%edx
}
80101685:	5b                   	pop    %ebx
      return iget(dev, inum);
80101686:	89 f0                	mov    %esi,%eax
}
80101688:	5e                   	pop    %esi
80101689:	5f                   	pop    %edi
8010168a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010168b:	e9 b0 fc ff ff       	jmp    80101340 <iget>
  panic("ialloc: no inodes");
80101690:	83 ec 0c             	sub    $0xc,%esp
80101693:	68 18 85 10 80       	push   $0x80108518
80101698:	e8 f3 ec ff ff       	call   80100390 <panic>
8010169d:	8d 76 00             	lea    0x0(%esi),%esi

801016a0 <iupdate>:
{
801016a0:	f3 0f 1e fb          	endbr32 
801016a4:	55                   	push   %ebp
801016a5:	89 e5                	mov    %esp,%ebp
801016a7:	56                   	push   %esi
801016a8:	53                   	push   %ebx
801016a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ac:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016af:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016b2:	83 ec 08             	sub    $0x8,%esp
801016b5:	c1 e8 03             	shr    $0x3,%eax
801016b8:	03 05 f4 29 11 80    	add    0x801129f4,%eax
801016be:	50                   	push   %eax
801016bf:	ff 73 a4             	pushl  -0x5c(%ebx)
801016c2:	e8 09 ea ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016c7:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016cb:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ce:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d0:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016d3:	83 e0 07             	and    $0x7,%eax
801016d6:	c1 e0 06             	shl    $0x6,%eax
801016d9:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016dd:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016e0:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016e4:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016e7:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016eb:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016ef:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801016f3:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801016f7:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801016fb:	8b 53 fc             	mov    -0x4(%ebx),%edx
801016fe:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101701:	6a 34                	push   $0x34
80101703:	53                   	push   %ebx
80101704:	50                   	push   %eax
80101705:	e8 26 3e 00 00       	call   80105530 <memmove>
  log_write(bp);
8010170a:	89 34 24             	mov    %esi,(%esp)
8010170d:	e8 6e 1c 00 00       	call   80103380 <log_write>
  brelse(bp);
80101712:	89 75 08             	mov    %esi,0x8(%ebp)
80101715:	83 c4 10             	add    $0x10,%esp
}
80101718:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010171b:	5b                   	pop    %ebx
8010171c:	5e                   	pop    %esi
8010171d:	5d                   	pop    %ebp
  brelse(bp);
8010171e:	e9 cd ea ff ff       	jmp    801001f0 <brelse>
80101723:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010172a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101730 <idup>:
{
80101730:	f3 0f 1e fb          	endbr32 
80101734:	55                   	push   %ebp
80101735:	89 e5                	mov    %esp,%ebp
80101737:	53                   	push   %ebx
80101738:	83 ec 10             	sub    $0x10,%esp
8010173b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010173e:	68 00 2a 11 80       	push   $0x80112a00
80101743:	e8 38 3c 00 00       	call   80105380 <acquire>
  ip->ref++;
80101748:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010174c:	c7 04 24 00 2a 11 80 	movl   $0x80112a00,(%esp)
80101753:	e8 e8 3c 00 00       	call   80105440 <release>
}
80101758:	89 d8                	mov    %ebx,%eax
8010175a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010175d:	c9                   	leave  
8010175e:	c3                   	ret    
8010175f:	90                   	nop

80101760 <ilock>:
{
80101760:	f3 0f 1e fb          	endbr32 
80101764:	55                   	push   %ebp
80101765:	89 e5                	mov    %esp,%ebp
80101767:	56                   	push   %esi
80101768:	53                   	push   %ebx
80101769:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010176c:	85 db                	test   %ebx,%ebx
8010176e:	0f 84 b3 00 00 00    	je     80101827 <ilock+0xc7>
80101774:	8b 53 08             	mov    0x8(%ebx),%edx
80101777:	85 d2                	test   %edx,%edx
80101779:	0f 8e a8 00 00 00    	jle    80101827 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010177f:	83 ec 0c             	sub    $0xc,%esp
80101782:	8d 43 0c             	lea    0xc(%ebx),%eax
80101785:	50                   	push   %eax
80101786:	e8 75 39 00 00       	call   80105100 <acquiresleep>
  if(ip->valid == 0){
8010178b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010178e:	83 c4 10             	add    $0x10,%esp
80101791:	85 c0                	test   %eax,%eax
80101793:	74 0b                	je     801017a0 <ilock+0x40>
}
80101795:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101798:	5b                   	pop    %ebx
80101799:	5e                   	pop    %esi
8010179a:	5d                   	pop    %ebp
8010179b:	c3                   	ret    
8010179c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017a0:	8b 43 04             	mov    0x4(%ebx),%eax
801017a3:	83 ec 08             	sub    $0x8,%esp
801017a6:	c1 e8 03             	shr    $0x3,%eax
801017a9:	03 05 f4 29 11 80    	add    0x801129f4,%eax
801017af:	50                   	push   %eax
801017b0:	ff 33                	pushl  (%ebx)
801017b2:	e8 19 e9 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017b7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ba:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017bc:	8b 43 04             	mov    0x4(%ebx),%eax
801017bf:	83 e0 07             	and    $0x7,%eax
801017c2:	c1 e0 06             	shl    $0x6,%eax
801017c5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017c9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017cc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017cf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017d3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017d7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017db:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017df:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017e3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017e7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017eb:	8b 50 fc             	mov    -0x4(%eax),%edx
801017ee:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017f1:	6a 34                	push   $0x34
801017f3:	50                   	push   %eax
801017f4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801017f7:	50                   	push   %eax
801017f8:	e8 33 3d 00 00       	call   80105530 <memmove>
    brelse(bp);
801017fd:	89 34 24             	mov    %esi,(%esp)
80101800:	e8 eb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101805:	83 c4 10             	add    $0x10,%esp
80101808:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010180d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101814:	0f 85 7b ff ff ff    	jne    80101795 <ilock+0x35>
      panic("ilock: no type");
8010181a:	83 ec 0c             	sub    $0xc,%esp
8010181d:	68 30 85 10 80       	push   $0x80108530
80101822:	e8 69 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101827:	83 ec 0c             	sub    $0xc,%esp
8010182a:	68 2a 85 10 80       	push   $0x8010852a
8010182f:	e8 5c eb ff ff       	call   80100390 <panic>
80101834:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010183b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010183f:	90                   	nop

80101840 <iunlock>:
{
80101840:	f3 0f 1e fb          	endbr32 
80101844:	55                   	push   %ebp
80101845:	89 e5                	mov    %esp,%ebp
80101847:	56                   	push   %esi
80101848:	53                   	push   %ebx
80101849:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010184c:	85 db                	test   %ebx,%ebx
8010184e:	74 28                	je     80101878 <iunlock+0x38>
80101850:	83 ec 0c             	sub    $0xc,%esp
80101853:	8d 73 0c             	lea    0xc(%ebx),%esi
80101856:	56                   	push   %esi
80101857:	e8 44 39 00 00       	call   801051a0 <holdingsleep>
8010185c:	83 c4 10             	add    $0x10,%esp
8010185f:	85 c0                	test   %eax,%eax
80101861:	74 15                	je     80101878 <iunlock+0x38>
80101863:	8b 43 08             	mov    0x8(%ebx),%eax
80101866:	85 c0                	test   %eax,%eax
80101868:	7e 0e                	jle    80101878 <iunlock+0x38>
  releasesleep(&ip->lock);
8010186a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010186d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101870:	5b                   	pop    %ebx
80101871:	5e                   	pop    %esi
80101872:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101873:	e9 e8 38 00 00       	jmp    80105160 <releasesleep>
    panic("iunlock");
80101878:	83 ec 0c             	sub    $0xc,%esp
8010187b:	68 3f 85 10 80       	push   $0x8010853f
80101880:	e8 0b eb ff ff       	call   80100390 <panic>
80101885:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010188c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101890 <iput>:
{
80101890:	f3 0f 1e fb          	endbr32 
80101894:	55                   	push   %ebp
80101895:	89 e5                	mov    %esp,%ebp
80101897:	57                   	push   %edi
80101898:	56                   	push   %esi
80101899:	53                   	push   %ebx
8010189a:	83 ec 28             	sub    $0x28,%esp
8010189d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018a0:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018a3:	57                   	push   %edi
801018a4:	e8 57 38 00 00       	call   80105100 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018a9:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018ac:	83 c4 10             	add    $0x10,%esp
801018af:	85 d2                	test   %edx,%edx
801018b1:	74 07                	je     801018ba <iput+0x2a>
801018b3:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018b8:	74 36                	je     801018f0 <iput+0x60>
  releasesleep(&ip->lock);
801018ba:	83 ec 0c             	sub    $0xc,%esp
801018bd:	57                   	push   %edi
801018be:	e8 9d 38 00 00       	call   80105160 <releasesleep>
  acquire(&icache.lock);
801018c3:	c7 04 24 00 2a 11 80 	movl   $0x80112a00,(%esp)
801018ca:	e8 b1 3a 00 00       	call   80105380 <acquire>
  ip->ref--;
801018cf:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018d3:	83 c4 10             	add    $0x10,%esp
801018d6:	c7 45 08 00 2a 11 80 	movl   $0x80112a00,0x8(%ebp)
}
801018dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018e0:	5b                   	pop    %ebx
801018e1:	5e                   	pop    %esi
801018e2:	5f                   	pop    %edi
801018e3:	5d                   	pop    %ebp
  release(&icache.lock);
801018e4:	e9 57 3b 00 00       	jmp    80105440 <release>
801018e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
801018f0:	83 ec 0c             	sub    $0xc,%esp
801018f3:	68 00 2a 11 80       	push   $0x80112a00
801018f8:	e8 83 3a 00 00       	call   80105380 <acquire>
    int r = ip->ref;
801018fd:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101900:	c7 04 24 00 2a 11 80 	movl   $0x80112a00,(%esp)
80101907:	e8 34 3b 00 00       	call   80105440 <release>
    if(r == 1){
8010190c:	83 c4 10             	add    $0x10,%esp
8010190f:	83 fe 01             	cmp    $0x1,%esi
80101912:	75 a6                	jne    801018ba <iput+0x2a>
80101914:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
8010191a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010191d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101920:	89 cf                	mov    %ecx,%edi
80101922:	eb 0b                	jmp    8010192f <iput+0x9f>
80101924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101928:	83 c6 04             	add    $0x4,%esi
8010192b:	39 fe                	cmp    %edi,%esi
8010192d:	74 19                	je     80101948 <iput+0xb8>
    if(ip->addrs[i]){
8010192f:	8b 16                	mov    (%esi),%edx
80101931:	85 d2                	test   %edx,%edx
80101933:	74 f3                	je     80101928 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101935:	8b 03                	mov    (%ebx),%eax
80101937:	e8 74 f8 ff ff       	call   801011b0 <bfree>
      ip->addrs[i] = 0;
8010193c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101942:	eb e4                	jmp    80101928 <iput+0x98>
80101944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101948:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010194e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101951:	85 c0                	test   %eax,%eax
80101953:	75 33                	jne    80101988 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101955:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101958:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
8010195f:	53                   	push   %ebx
80101960:	e8 3b fd ff ff       	call   801016a0 <iupdate>
      ip->type = 0;
80101965:	31 c0                	xor    %eax,%eax
80101967:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
8010196b:	89 1c 24             	mov    %ebx,(%esp)
8010196e:	e8 2d fd ff ff       	call   801016a0 <iupdate>
      ip->valid = 0;
80101973:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
8010197a:	83 c4 10             	add    $0x10,%esp
8010197d:	e9 38 ff ff ff       	jmp    801018ba <iput+0x2a>
80101982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101988:	83 ec 08             	sub    $0x8,%esp
8010198b:	50                   	push   %eax
8010198c:	ff 33                	pushl  (%ebx)
8010198e:	e8 3d e7 ff ff       	call   801000d0 <bread>
80101993:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101996:	83 c4 10             	add    $0x10,%esp
80101999:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
8010199f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019a2:	8d 70 5c             	lea    0x5c(%eax),%esi
801019a5:	89 cf                	mov    %ecx,%edi
801019a7:	eb 0e                	jmp    801019b7 <iput+0x127>
801019a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019b0:	83 c6 04             	add    $0x4,%esi
801019b3:	39 f7                	cmp    %esi,%edi
801019b5:	74 19                	je     801019d0 <iput+0x140>
      if(a[j])
801019b7:	8b 16                	mov    (%esi),%edx
801019b9:	85 d2                	test   %edx,%edx
801019bb:	74 f3                	je     801019b0 <iput+0x120>
        bfree(ip->dev, a[j]);
801019bd:	8b 03                	mov    (%ebx),%eax
801019bf:	e8 ec f7 ff ff       	call   801011b0 <bfree>
801019c4:	eb ea                	jmp    801019b0 <iput+0x120>
801019c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019cd:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801019d0:	83 ec 0c             	sub    $0xc,%esp
801019d3:	ff 75 e4             	pushl  -0x1c(%ebp)
801019d6:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019d9:	e8 12 e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019de:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019e4:	8b 03                	mov    (%ebx),%eax
801019e6:	e8 c5 f7 ff ff       	call   801011b0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019eb:	83 c4 10             	add    $0x10,%esp
801019ee:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019f5:	00 00 00 
801019f8:	e9 58 ff ff ff       	jmp    80101955 <iput+0xc5>
801019fd:	8d 76 00             	lea    0x0(%esi),%esi

80101a00 <iunlockput>:
{
80101a00:	f3 0f 1e fb          	endbr32 
80101a04:	55                   	push   %ebp
80101a05:	89 e5                	mov    %esp,%ebp
80101a07:	53                   	push   %ebx
80101a08:	83 ec 10             	sub    $0x10,%esp
80101a0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101a0e:	53                   	push   %ebx
80101a0f:	e8 2c fe ff ff       	call   80101840 <iunlock>
  iput(ip);
80101a14:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a17:	83 c4 10             	add    $0x10,%esp
}
80101a1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a1d:	c9                   	leave  
  iput(ip);
80101a1e:	e9 6d fe ff ff       	jmp    80101890 <iput>
80101a23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a30 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a30:	f3 0f 1e fb          	endbr32 
80101a34:	55                   	push   %ebp
80101a35:	89 e5                	mov    %esp,%ebp
80101a37:	8b 55 08             	mov    0x8(%ebp),%edx
80101a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a3d:	8b 0a                	mov    (%edx),%ecx
80101a3f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a42:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a45:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a48:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a4c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a4f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a53:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a57:	8b 52 58             	mov    0x58(%edx),%edx
80101a5a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a5d:	5d                   	pop    %ebp
80101a5e:	c3                   	ret    
80101a5f:	90                   	nop

80101a60 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a60:	f3 0f 1e fb          	endbr32 
80101a64:	55                   	push   %ebp
80101a65:	89 e5                	mov    %esp,%ebp
80101a67:	57                   	push   %edi
80101a68:	56                   	push   %esi
80101a69:	53                   	push   %ebx
80101a6a:	83 ec 1c             	sub    $0x1c,%esp
80101a6d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a70:	8b 45 08             	mov    0x8(%ebp),%eax
80101a73:	8b 75 10             	mov    0x10(%ebp),%esi
80101a76:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a79:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a7c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a81:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a84:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a87:	0f 84 a3 00 00 00    	je     80101b30 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a90:	8b 40 58             	mov    0x58(%eax),%eax
80101a93:	39 c6                	cmp    %eax,%esi
80101a95:	0f 87 b6 00 00 00    	ja     80101b51 <readi+0xf1>
80101a9b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a9e:	31 c9                	xor    %ecx,%ecx
80101aa0:	89 da                	mov    %ebx,%edx
80101aa2:	01 f2                	add    %esi,%edx
80101aa4:	0f 92 c1             	setb   %cl
80101aa7:	89 cf                	mov    %ecx,%edi
80101aa9:	0f 82 a2 00 00 00    	jb     80101b51 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101aaf:	89 c1                	mov    %eax,%ecx
80101ab1:	29 f1                	sub    %esi,%ecx
80101ab3:	39 d0                	cmp    %edx,%eax
80101ab5:	0f 43 cb             	cmovae %ebx,%ecx
80101ab8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101abb:	85 c9                	test   %ecx,%ecx
80101abd:	74 63                	je     80101b22 <readi+0xc2>
80101abf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101ac3:	89 f2                	mov    %esi,%edx
80101ac5:	c1 ea 09             	shr    $0x9,%edx
80101ac8:	89 d8                	mov    %ebx,%eax
80101aca:	e8 61 f9 ff ff       	call   80101430 <bmap>
80101acf:	83 ec 08             	sub    $0x8,%esp
80101ad2:	50                   	push   %eax
80101ad3:	ff 33                	pushl  (%ebx)
80101ad5:	e8 f6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101ada:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101add:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ae2:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae5:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae7:	89 f0                	mov    %esi,%eax
80101ae9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101aee:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101af0:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101af3:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101af5:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101af9:	39 d9                	cmp    %ebx,%ecx
80101afb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101afe:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aff:	01 df                	add    %ebx,%edi
80101b01:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b03:	50                   	push   %eax
80101b04:	ff 75 e0             	pushl  -0x20(%ebp)
80101b07:	e8 24 3a 00 00       	call   80105530 <memmove>
    brelse(bp);
80101b0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b0f:	89 14 24             	mov    %edx,(%esp)
80101b12:	e8 d9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b17:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b1a:	83 c4 10             	add    $0x10,%esp
80101b1d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b20:	77 9e                	ja     80101ac0 <readi+0x60>
  }
  return n;
80101b22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b28:	5b                   	pop    %ebx
80101b29:	5e                   	pop    %esi
80101b2a:	5f                   	pop    %edi
80101b2b:	5d                   	pop    %ebp
80101b2c:	c3                   	ret    
80101b2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b34:	66 83 f8 09          	cmp    $0x9,%ax
80101b38:	77 17                	ja     80101b51 <readi+0xf1>
80101b3a:	8b 04 c5 80 29 11 80 	mov    -0x7feed680(,%eax,8),%eax
80101b41:	85 c0                	test   %eax,%eax
80101b43:	74 0c                	je     80101b51 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b45:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b4b:	5b                   	pop    %ebx
80101b4c:	5e                   	pop    %esi
80101b4d:	5f                   	pop    %edi
80101b4e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b4f:	ff e0                	jmp    *%eax
      return -1;
80101b51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b56:	eb cd                	jmp    80101b25 <readi+0xc5>
80101b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b5f:	90                   	nop

80101b60 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b60:	f3 0f 1e fb          	endbr32 
80101b64:	55                   	push   %ebp
80101b65:	89 e5                	mov    %esp,%ebp
80101b67:	57                   	push   %edi
80101b68:	56                   	push   %esi
80101b69:	53                   	push   %ebx
80101b6a:	83 ec 1c             	sub    $0x1c,%esp
80101b6d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b70:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b73:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b76:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b7b:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b7e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b81:	8b 75 10             	mov    0x10(%ebp),%esi
80101b84:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b87:	0f 84 b3 00 00 00    	je     80101c40 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b90:	39 70 58             	cmp    %esi,0x58(%eax)
80101b93:	0f 82 e3 00 00 00    	jb     80101c7c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b99:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b9c:	89 f8                	mov    %edi,%eax
80101b9e:	01 f0                	add    %esi,%eax
80101ba0:	0f 82 d6 00 00 00    	jb     80101c7c <writei+0x11c>
80101ba6:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bab:	0f 87 cb 00 00 00    	ja     80101c7c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bb1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bb8:	85 ff                	test   %edi,%edi
80101bba:	74 75                	je     80101c31 <writei+0xd1>
80101bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bc0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bc3:	89 f2                	mov    %esi,%edx
80101bc5:	c1 ea 09             	shr    $0x9,%edx
80101bc8:	89 f8                	mov    %edi,%eax
80101bca:	e8 61 f8 ff ff       	call   80101430 <bmap>
80101bcf:	83 ec 08             	sub    $0x8,%esp
80101bd2:	50                   	push   %eax
80101bd3:	ff 37                	pushl  (%edi)
80101bd5:	e8 f6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101bda:	b9 00 02 00 00       	mov    $0x200,%ecx
80101bdf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101be2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101be5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101be7:	89 f0                	mov    %esi,%eax
80101be9:	83 c4 0c             	add    $0xc,%esp
80101bec:	25 ff 01 00 00       	and    $0x1ff,%eax
80101bf1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101bf3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101bf7:	39 d9                	cmp    %ebx,%ecx
80101bf9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101bfc:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bfd:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101bff:	ff 75 dc             	pushl  -0x24(%ebp)
80101c02:	50                   	push   %eax
80101c03:	e8 28 39 00 00       	call   80105530 <memmove>
    log_write(bp);
80101c08:	89 3c 24             	mov    %edi,(%esp)
80101c0b:	e8 70 17 00 00       	call   80103380 <log_write>
    brelse(bp);
80101c10:	89 3c 24             	mov    %edi,(%esp)
80101c13:	e8 d8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c18:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c1b:	83 c4 10             	add    $0x10,%esp
80101c1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c21:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c24:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c27:	77 97                	ja     80101bc0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c2c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c2f:	77 37                	ja     80101c68 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c31:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c37:	5b                   	pop    %ebx
80101c38:	5e                   	pop    %esi
80101c39:	5f                   	pop    %edi
80101c3a:	5d                   	pop    %ebp
80101c3b:	c3                   	ret    
80101c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c44:	66 83 f8 09          	cmp    $0x9,%ax
80101c48:	77 32                	ja     80101c7c <writei+0x11c>
80101c4a:	8b 04 c5 84 29 11 80 	mov    -0x7feed67c(,%eax,8),%eax
80101c51:	85 c0                	test   %eax,%eax
80101c53:	74 27                	je     80101c7c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c5b:	5b                   	pop    %ebx
80101c5c:	5e                   	pop    %esi
80101c5d:	5f                   	pop    %edi
80101c5e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c5f:	ff e0                	jmp    *%eax
80101c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c68:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c6b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c6e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c71:	50                   	push   %eax
80101c72:	e8 29 fa ff ff       	call   801016a0 <iupdate>
80101c77:	83 c4 10             	add    $0x10,%esp
80101c7a:	eb b5                	jmp    80101c31 <writei+0xd1>
      return -1;
80101c7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c81:	eb b1                	jmp    80101c34 <writei+0xd4>
80101c83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c90 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c90:	f3 0f 1e fb          	endbr32 
80101c94:	55                   	push   %ebp
80101c95:	89 e5                	mov    %esp,%ebp
80101c97:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c9a:	6a 0e                	push   $0xe
80101c9c:	ff 75 0c             	pushl  0xc(%ebp)
80101c9f:	ff 75 08             	pushl  0x8(%ebp)
80101ca2:	e8 f9 38 00 00       	call   801055a0 <strncmp>
}
80101ca7:	c9                   	leave  
80101ca8:	c3                   	ret    
80101ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101cb0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cb0:	f3 0f 1e fb          	endbr32 
80101cb4:	55                   	push   %ebp
80101cb5:	89 e5                	mov    %esp,%ebp
80101cb7:	57                   	push   %edi
80101cb8:	56                   	push   %esi
80101cb9:	53                   	push   %ebx
80101cba:	83 ec 1c             	sub    $0x1c,%esp
80101cbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cc0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cc5:	0f 85 89 00 00 00    	jne    80101d54 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101ccb:	8b 53 58             	mov    0x58(%ebx),%edx
80101cce:	31 ff                	xor    %edi,%edi
80101cd0:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cd3:	85 d2                	test   %edx,%edx
80101cd5:	74 42                	je     80101d19 <dirlookup+0x69>
80101cd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cde:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ce0:	6a 10                	push   $0x10
80101ce2:	57                   	push   %edi
80101ce3:	56                   	push   %esi
80101ce4:	53                   	push   %ebx
80101ce5:	e8 76 fd ff ff       	call   80101a60 <readi>
80101cea:	83 c4 10             	add    $0x10,%esp
80101ced:	83 f8 10             	cmp    $0x10,%eax
80101cf0:	75 55                	jne    80101d47 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101cf2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101cf7:	74 18                	je     80101d11 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101cf9:	83 ec 04             	sub    $0x4,%esp
80101cfc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101cff:	6a 0e                	push   $0xe
80101d01:	50                   	push   %eax
80101d02:	ff 75 0c             	pushl  0xc(%ebp)
80101d05:	e8 96 38 00 00       	call   801055a0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d0a:	83 c4 10             	add    $0x10,%esp
80101d0d:	85 c0                	test   %eax,%eax
80101d0f:	74 17                	je     80101d28 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d11:	83 c7 10             	add    $0x10,%edi
80101d14:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d17:	72 c7                	jb     80101ce0 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d1c:	31 c0                	xor    %eax,%eax
}
80101d1e:	5b                   	pop    %ebx
80101d1f:	5e                   	pop    %esi
80101d20:	5f                   	pop    %edi
80101d21:	5d                   	pop    %ebp
80101d22:	c3                   	ret    
80101d23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d27:	90                   	nop
      if(poff)
80101d28:	8b 45 10             	mov    0x10(%ebp),%eax
80101d2b:	85 c0                	test   %eax,%eax
80101d2d:	74 05                	je     80101d34 <dirlookup+0x84>
        *poff = off;
80101d2f:	8b 45 10             	mov    0x10(%ebp),%eax
80101d32:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d34:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d38:	8b 03                	mov    (%ebx),%eax
80101d3a:	e8 01 f6 ff ff       	call   80101340 <iget>
}
80101d3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d42:	5b                   	pop    %ebx
80101d43:	5e                   	pop    %esi
80101d44:	5f                   	pop    %edi
80101d45:	5d                   	pop    %ebp
80101d46:	c3                   	ret    
      panic("dirlookup read");
80101d47:	83 ec 0c             	sub    $0xc,%esp
80101d4a:	68 59 85 10 80       	push   $0x80108559
80101d4f:	e8 3c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d54:	83 ec 0c             	sub    $0xc,%esp
80101d57:	68 47 85 10 80       	push   $0x80108547
80101d5c:	e8 2f e6 ff ff       	call   80100390 <panic>
80101d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d6f:	90                   	nop

80101d70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d70:	55                   	push   %ebp
80101d71:	89 e5                	mov    %esp,%ebp
80101d73:	57                   	push   %edi
80101d74:	56                   	push   %esi
80101d75:	53                   	push   %ebx
80101d76:	89 c3                	mov    %eax,%ebx
80101d78:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d7b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d7e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d81:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101d84:	0f 84 86 01 00 00    	je     80101f10 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d8a:	e8 51 21 00 00       	call   80103ee0 <myproc>
  acquire(&icache.lock);
80101d8f:	83 ec 0c             	sub    $0xc,%esp
80101d92:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101d94:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d97:	68 00 2a 11 80       	push   $0x80112a00
80101d9c:	e8 df 35 00 00       	call   80105380 <acquire>
  ip->ref++;
80101da1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101da5:	c7 04 24 00 2a 11 80 	movl   $0x80112a00,(%esp)
80101dac:	e8 8f 36 00 00       	call   80105440 <release>
80101db1:	83 c4 10             	add    $0x10,%esp
80101db4:	eb 0d                	jmp    80101dc3 <namex+0x53>
80101db6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dbd:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101dc0:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101dc3:	0f b6 07             	movzbl (%edi),%eax
80101dc6:	3c 2f                	cmp    $0x2f,%al
80101dc8:	74 f6                	je     80101dc0 <namex+0x50>
  if(*path == 0)
80101dca:	84 c0                	test   %al,%al
80101dcc:	0f 84 ee 00 00 00    	je     80101ec0 <namex+0x150>
  while(*path != '/' && *path != 0)
80101dd2:	0f b6 07             	movzbl (%edi),%eax
80101dd5:	84 c0                	test   %al,%al
80101dd7:	0f 84 fb 00 00 00    	je     80101ed8 <namex+0x168>
80101ddd:	89 fb                	mov    %edi,%ebx
80101ddf:	3c 2f                	cmp    $0x2f,%al
80101de1:	0f 84 f1 00 00 00    	je     80101ed8 <namex+0x168>
80101de7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dee:	66 90                	xchg   %ax,%ax
80101df0:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80101df4:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	74 04                	je     80101dff <namex+0x8f>
80101dfb:	84 c0                	test   %al,%al
80101dfd:	75 f1                	jne    80101df0 <namex+0x80>
  len = path - s;
80101dff:	89 d8                	mov    %ebx,%eax
80101e01:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101e03:	83 f8 0d             	cmp    $0xd,%eax
80101e06:	0f 8e 84 00 00 00    	jle    80101e90 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101e0c:	83 ec 04             	sub    $0x4,%esp
80101e0f:	6a 0e                	push   $0xe
80101e11:	57                   	push   %edi
    path++;
80101e12:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101e14:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e17:	e8 14 37 00 00       	call   80105530 <memmove>
80101e1c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e1f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e22:	75 0c                	jne    80101e30 <namex+0xc0>
80101e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e28:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101e2b:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e2e:	74 f8                	je     80101e28 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e30:	83 ec 0c             	sub    $0xc,%esp
80101e33:	56                   	push   %esi
80101e34:	e8 27 f9 ff ff       	call   80101760 <ilock>
    if(ip->type != T_DIR){
80101e39:	83 c4 10             	add    $0x10,%esp
80101e3c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e41:	0f 85 a1 00 00 00    	jne    80101ee8 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e47:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e4a:	85 d2                	test   %edx,%edx
80101e4c:	74 09                	je     80101e57 <namex+0xe7>
80101e4e:	80 3f 00             	cmpb   $0x0,(%edi)
80101e51:	0f 84 d9 00 00 00    	je     80101f30 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e57:	83 ec 04             	sub    $0x4,%esp
80101e5a:	6a 00                	push   $0x0
80101e5c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e5f:	56                   	push   %esi
80101e60:	e8 4b fe ff ff       	call   80101cb0 <dirlookup>
80101e65:	83 c4 10             	add    $0x10,%esp
80101e68:	89 c3                	mov    %eax,%ebx
80101e6a:	85 c0                	test   %eax,%eax
80101e6c:	74 7a                	je     80101ee8 <namex+0x178>
  iunlock(ip);
80101e6e:	83 ec 0c             	sub    $0xc,%esp
80101e71:	56                   	push   %esi
80101e72:	e8 c9 f9 ff ff       	call   80101840 <iunlock>
  iput(ip);
80101e77:	89 34 24             	mov    %esi,(%esp)
80101e7a:	89 de                	mov    %ebx,%esi
80101e7c:	e8 0f fa ff ff       	call   80101890 <iput>
80101e81:	83 c4 10             	add    $0x10,%esp
80101e84:	e9 3a ff ff ff       	jmp    80101dc3 <namex+0x53>
80101e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101e93:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101e96:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101e99:	83 ec 04             	sub    $0x4,%esp
80101e9c:	50                   	push   %eax
80101e9d:	57                   	push   %edi
    name[len] = 0;
80101e9e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101ea0:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ea3:	e8 88 36 00 00       	call   80105530 <memmove>
    name[len] = 0;
80101ea8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101eab:	83 c4 10             	add    $0x10,%esp
80101eae:	c6 00 00             	movb   $0x0,(%eax)
80101eb1:	e9 69 ff ff ff       	jmp    80101e1f <namex+0xaf>
80101eb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ebd:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ec0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ec3:	85 c0                	test   %eax,%eax
80101ec5:	0f 85 85 00 00 00    	jne    80101f50 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101ecb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ece:	89 f0                	mov    %esi,%eax
80101ed0:	5b                   	pop    %ebx
80101ed1:	5e                   	pop    %esi
80101ed2:	5f                   	pop    %edi
80101ed3:	5d                   	pop    %ebp
80101ed4:	c3                   	ret    
80101ed5:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101ed8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101edb:	89 fb                	mov    %edi,%ebx
80101edd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101ee0:	31 c0                	xor    %eax,%eax
80101ee2:	eb b5                	jmp    80101e99 <namex+0x129>
80101ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101ee8:	83 ec 0c             	sub    $0xc,%esp
80101eeb:	56                   	push   %esi
80101eec:	e8 4f f9 ff ff       	call   80101840 <iunlock>
  iput(ip);
80101ef1:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101ef4:	31 f6                	xor    %esi,%esi
  iput(ip);
80101ef6:	e8 95 f9 ff ff       	call   80101890 <iput>
      return 0;
80101efb:	83 c4 10             	add    $0x10,%esp
}
80101efe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f01:	89 f0                	mov    %esi,%eax
80101f03:	5b                   	pop    %ebx
80101f04:	5e                   	pop    %esi
80101f05:	5f                   	pop    %edi
80101f06:	5d                   	pop    %ebp
80101f07:	c3                   	ret    
80101f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f0f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101f10:	ba 01 00 00 00       	mov    $0x1,%edx
80101f15:	b8 01 00 00 00       	mov    $0x1,%eax
80101f1a:	89 df                	mov    %ebx,%edi
80101f1c:	e8 1f f4 ff ff       	call   80101340 <iget>
80101f21:	89 c6                	mov    %eax,%esi
80101f23:	e9 9b fe ff ff       	jmp    80101dc3 <namex+0x53>
80101f28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f2f:	90                   	nop
      iunlock(ip);
80101f30:	83 ec 0c             	sub    $0xc,%esp
80101f33:	56                   	push   %esi
80101f34:	e8 07 f9 ff ff       	call   80101840 <iunlock>
      return ip;
80101f39:	83 c4 10             	add    $0x10,%esp
}
80101f3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f3f:	89 f0                	mov    %esi,%eax
80101f41:	5b                   	pop    %ebx
80101f42:	5e                   	pop    %esi
80101f43:	5f                   	pop    %edi
80101f44:	5d                   	pop    %ebp
80101f45:	c3                   	ret    
80101f46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f4d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101f50:	83 ec 0c             	sub    $0xc,%esp
80101f53:	56                   	push   %esi
    return 0;
80101f54:	31 f6                	xor    %esi,%esi
    iput(ip);
80101f56:	e8 35 f9 ff ff       	call   80101890 <iput>
    return 0;
80101f5b:	83 c4 10             	add    $0x10,%esp
80101f5e:	e9 68 ff ff ff       	jmp    80101ecb <namex+0x15b>
80101f63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f70 <dirlink>:
{
80101f70:	f3 0f 1e fb          	endbr32 
80101f74:	55                   	push   %ebp
80101f75:	89 e5                	mov    %esp,%ebp
80101f77:	57                   	push   %edi
80101f78:	56                   	push   %esi
80101f79:	53                   	push   %ebx
80101f7a:	83 ec 20             	sub    $0x20,%esp
80101f7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f80:	6a 00                	push   $0x0
80101f82:	ff 75 0c             	pushl  0xc(%ebp)
80101f85:	53                   	push   %ebx
80101f86:	e8 25 fd ff ff       	call   80101cb0 <dirlookup>
80101f8b:	83 c4 10             	add    $0x10,%esp
80101f8e:	85 c0                	test   %eax,%eax
80101f90:	75 6b                	jne    80101ffd <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f92:	8b 7b 58             	mov    0x58(%ebx),%edi
80101f95:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f98:	85 ff                	test   %edi,%edi
80101f9a:	74 2d                	je     80101fc9 <dirlink+0x59>
80101f9c:	31 ff                	xor    %edi,%edi
80101f9e:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fa1:	eb 0d                	jmp    80101fb0 <dirlink+0x40>
80101fa3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fa7:	90                   	nop
80101fa8:	83 c7 10             	add    $0x10,%edi
80101fab:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101fae:	73 19                	jae    80101fc9 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fb0:	6a 10                	push   $0x10
80101fb2:	57                   	push   %edi
80101fb3:	56                   	push   %esi
80101fb4:	53                   	push   %ebx
80101fb5:	e8 a6 fa ff ff       	call   80101a60 <readi>
80101fba:	83 c4 10             	add    $0x10,%esp
80101fbd:	83 f8 10             	cmp    $0x10,%eax
80101fc0:	75 4e                	jne    80102010 <dirlink+0xa0>
    if(de.inum == 0)
80101fc2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101fc7:	75 df                	jne    80101fa8 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80101fc9:	83 ec 04             	sub    $0x4,%esp
80101fcc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101fcf:	6a 0e                	push   $0xe
80101fd1:	ff 75 0c             	pushl  0xc(%ebp)
80101fd4:	50                   	push   %eax
80101fd5:	e8 16 36 00 00       	call   801055f0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fda:	6a 10                	push   $0x10
  de.inum = inum;
80101fdc:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fdf:	57                   	push   %edi
80101fe0:	56                   	push   %esi
80101fe1:	53                   	push   %ebx
  de.inum = inum;
80101fe2:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fe6:	e8 75 fb ff ff       	call   80101b60 <writei>
80101feb:	83 c4 20             	add    $0x20,%esp
80101fee:	83 f8 10             	cmp    $0x10,%eax
80101ff1:	75 2a                	jne    8010201d <dirlink+0xad>
  return 0;
80101ff3:	31 c0                	xor    %eax,%eax
}
80101ff5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ff8:	5b                   	pop    %ebx
80101ff9:	5e                   	pop    %esi
80101ffa:	5f                   	pop    %edi
80101ffb:	5d                   	pop    %ebp
80101ffc:	c3                   	ret    
    iput(ip);
80101ffd:	83 ec 0c             	sub    $0xc,%esp
80102000:	50                   	push   %eax
80102001:	e8 8a f8 ff ff       	call   80101890 <iput>
    return -1;
80102006:	83 c4 10             	add    $0x10,%esp
80102009:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010200e:	eb e5                	jmp    80101ff5 <dirlink+0x85>
      panic("dirlink read");
80102010:	83 ec 0c             	sub    $0xc,%esp
80102013:	68 68 85 10 80       	push   $0x80108568
80102018:	e8 73 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010201d:	83 ec 0c             	sub    $0xc,%esp
80102020:	68 d1 8d 10 80       	push   $0x80108dd1
80102025:	e8 66 e3 ff ff       	call   80100390 <panic>
8010202a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102030 <namei>:

struct inode*
namei(char *path)
{
80102030:	f3 0f 1e fb          	endbr32 
80102034:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102035:	31 d2                	xor    %edx,%edx
{
80102037:	89 e5                	mov    %esp,%ebp
80102039:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010203c:	8b 45 08             	mov    0x8(%ebp),%eax
8010203f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102042:	e8 29 fd ff ff       	call   80101d70 <namex>
}
80102047:	c9                   	leave  
80102048:	c3                   	ret    
80102049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102050 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102050:	f3 0f 1e fb          	endbr32 
80102054:	55                   	push   %ebp
  return namex(path, 1, name);
80102055:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010205a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010205c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010205f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102062:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102063:	e9 08 fd ff ff       	jmp    80101d70 <namex>
80102068:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010206f:	90                   	nop

80102070 <itoa>:


char* itoa(int i, char b[]){
80102070:	f3 0f 1e fb          	endbr32 
80102074:	55                   	push   %ebp
    char const digit[] = "0123456789";
80102075:	b8 38 39 00 00       	mov    $0x3938,%eax
char* itoa(int i, char b[]){
8010207a:	89 e5                	mov    %esp,%ebp
8010207c:	57                   	push   %edi
8010207d:	56                   	push   %esi
8010207e:	53                   	push   %ebx
8010207f:	83 ec 10             	sub    $0x10,%esp
80102082:	8b 7d 0c             	mov    0xc(%ebp),%edi
80102085:	8b 4d 08             	mov    0x8(%ebp),%ecx
    char const digit[] = "0123456789";
80102088:	c7 45 e9 30 31 32 33 	movl   $0x33323130,-0x17(%ebp)
8010208f:	c7 45 ed 34 35 36 37 	movl   $0x37363534,-0x13(%ebp)
80102096:	66 89 45 f1          	mov    %ax,-0xf(%ebp)
8010209a:	89 fb                	mov    %edi,%ebx
8010209c:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
    char* p = b;
    if(i<0){
801020a0:	85 c9                	test   %ecx,%ecx
801020a2:	79 08                	jns    801020ac <itoa+0x3c>
        *p++ = '-';
801020a4:	c6 07 2d             	movb   $0x2d,(%edi)
801020a7:	8d 5f 01             	lea    0x1(%edi),%ebx
        i *= -1;
801020aa:	f7 d9                	neg    %ecx
    }
    int shifter = i;
801020ac:	89 ca                	mov    %ecx,%edx
    do{ //Move to where representation ends
        ++p;
        shifter = shifter/10;
801020ae:	be cd cc cc cc       	mov    $0xcccccccd,%esi
801020b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020b7:	90                   	nop
801020b8:	89 d0                	mov    %edx,%eax
        ++p;
801020ba:	83 c3 01             	add    $0x1,%ebx
        shifter = shifter/10;
801020bd:	f7 e6                	mul    %esi
    }while(shifter);
801020bf:	c1 ea 03             	shr    $0x3,%edx
801020c2:	75 f4                	jne    801020b8 <itoa+0x48>
    *p = '\0';
801020c4:	c6 03 00             	movb   $0x0,(%ebx)
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
801020c7:	be cd cc cc cc       	mov    $0xcccccccd,%esi
801020cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020d0:	89 c8                	mov    %ecx,%eax
801020d2:	83 eb 01             	sub    $0x1,%ebx
801020d5:	f7 e6                	mul    %esi
801020d7:	c1 ea 03             	shr    $0x3,%edx
801020da:	8d 04 92             	lea    (%edx,%edx,4),%eax
801020dd:	01 c0                	add    %eax,%eax
801020df:	29 c1                	sub    %eax,%ecx
801020e1:	0f b6 44 0d e9       	movzbl -0x17(%ebp,%ecx,1),%eax
        i = i/10;
801020e6:	89 d1                	mov    %edx,%ecx
        *--p = digit[i%10];
801020e8:	88 03                	mov    %al,(%ebx)
    }while(i);
801020ea:	85 d2                	test   %edx,%edx
801020ec:	75 e2                	jne    801020d0 <itoa+0x60>
    return b;
}
801020ee:	83 c4 10             	add    $0x10,%esp
801020f1:	89 f8                	mov    %edi,%eax
801020f3:	5b                   	pop    %ebx
801020f4:	5e                   	pop    %esi
801020f5:	5f                   	pop    %edi
801020f6:	5d                   	pop    %ebp
801020f7:	c3                   	ret    
801020f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020ff:	90                   	nop

80102100 <removeSwapFile>:

//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
80102100:	f3 0f 1e fb          	endbr32 
80102104:	55                   	push   %ebp
80102105:	89 e5                	mov    %esp,%ebp
80102107:	57                   	push   %edi
80102108:	56                   	push   %esi
	//path of proccess
	char path[DIGITS];
	memmove(path,"/.swap", 6);
80102109:	8d 75 bc             	lea    -0x44(%ebp),%esi
{
8010210c:	53                   	push   %ebx
8010210d:	83 ec 40             	sub    $0x40,%esp
80102110:	8b 5d 08             	mov    0x8(%ebp),%ebx
	memmove(path,"/.swap", 6);
80102113:	6a 06                	push   $0x6
80102115:	68 75 85 10 80       	push   $0x80108575
8010211a:	56                   	push   %esi
8010211b:	e8 10 34 00 00       	call   80105530 <memmove>
	itoa(p->pid, path+ 6);
80102120:	58                   	pop    %eax
80102121:	8d 45 c2             	lea    -0x3e(%ebp),%eax
80102124:	5a                   	pop    %edx
80102125:	50                   	push   %eax
80102126:	ff 73 10             	pushl  0x10(%ebx)
80102129:	e8 42 ff ff ff       	call   80102070 <itoa>
	struct inode *ip, *dp;
	struct dirent de;
	char name[DIRSIZ];
	uint off;

	if(0 == p->swapFile)
8010212e:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102131:	83 c4 10             	add    $0x10,%esp
80102134:	85 c0                	test   %eax,%eax
80102136:	0f 84 7a 01 00 00    	je     801022b6 <removeSwapFile+0x1b6>
	{
		return -1;
	}
	fileclose(p->swapFile);
8010213c:	83 ec 0c             	sub    $0xc,%esp
  return namex(path, 1, name);
8010213f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
	fileclose(p->swapFile);
80102142:	50                   	push   %eax
80102143:	e8 78 ed ff ff       	call   80100ec0 <fileclose>

	begin_op();
80102148:	e8 53 10 00 00       	call   801031a0 <begin_op>
  return namex(path, 1, name);
8010214d:	89 f0                	mov    %esi,%eax
8010214f:	89 d9                	mov    %ebx,%ecx
80102151:	ba 01 00 00 00       	mov    $0x1,%edx
80102156:	e8 15 fc ff ff       	call   80101d70 <namex>
	if((dp = nameiparent(path, name)) == 0)
8010215b:	83 c4 10             	add    $0x10,%esp
  return namex(path, 1, name);
8010215e:	89 c6                	mov    %eax,%esi
	if((dp = nameiparent(path, name)) == 0)
80102160:	85 c0                	test   %eax,%eax
80102162:	0f 84 55 01 00 00    	je     801022bd <removeSwapFile+0x1bd>
	{
		end_op();
		return -1;
	}

	ilock(dp);
80102168:	83 ec 0c             	sub    $0xc,%esp
8010216b:	50                   	push   %eax
8010216c:	e8 ef f5 ff ff       	call   80101760 <ilock>
  return strncmp(s, t, DIRSIZ);
80102171:	83 c4 0c             	add    $0xc,%esp
80102174:	6a 0e                	push   $0xe
80102176:	68 7d 85 10 80       	push   $0x8010857d
8010217b:	53                   	push   %ebx
8010217c:	e8 1f 34 00 00       	call   801055a0 <strncmp>

	  // Cannot unlink "." or "..".
	if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80102181:	83 c4 10             	add    $0x10,%esp
80102184:	85 c0                	test   %eax,%eax
80102186:	0f 84 f4 00 00 00    	je     80102280 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
8010218c:	83 ec 04             	sub    $0x4,%esp
8010218f:	6a 0e                	push   $0xe
80102191:	68 7c 85 10 80       	push   $0x8010857c
80102196:	53                   	push   %ebx
80102197:	e8 04 34 00 00       	call   801055a0 <strncmp>
	if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010219c:	83 c4 10             	add    $0x10,%esp
8010219f:	85 c0                	test   %eax,%eax
801021a1:	0f 84 d9 00 00 00    	je     80102280 <removeSwapFile+0x180>
	   goto bad;

	if((ip = dirlookup(dp, name, &off)) == 0)
801021a7:	83 ec 04             	sub    $0x4,%esp
801021aa:	8d 45 b8             	lea    -0x48(%ebp),%eax
801021ad:	50                   	push   %eax
801021ae:	53                   	push   %ebx
801021af:	56                   	push   %esi
801021b0:	e8 fb fa ff ff       	call   80101cb0 <dirlookup>
801021b5:	83 c4 10             	add    $0x10,%esp
801021b8:	89 c3                	mov    %eax,%ebx
801021ba:	85 c0                	test   %eax,%eax
801021bc:	0f 84 be 00 00 00    	je     80102280 <removeSwapFile+0x180>
		goto bad;
	ilock(ip);
801021c2:	83 ec 0c             	sub    $0xc,%esp
801021c5:	50                   	push   %eax
801021c6:	e8 95 f5 ff ff       	call   80101760 <ilock>

	if(ip->nlink < 1)
801021cb:	83 c4 10             	add    $0x10,%esp
801021ce:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801021d3:	0f 8e 00 01 00 00    	jle    801022d9 <removeSwapFile+0x1d9>
		panic("unlink: nlink < 1");
	if(ip->type == T_DIR && !isdirempty(ip)){
801021d9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801021de:	74 78                	je     80102258 <removeSwapFile+0x158>
		iunlockput(ip);
		goto bad;
	}

	memset(&de, 0, sizeof(de));
801021e0:	83 ec 04             	sub    $0x4,%esp
801021e3:	8d 7d d8             	lea    -0x28(%ebp),%edi
801021e6:	6a 10                	push   $0x10
801021e8:	6a 00                	push   $0x0
801021ea:	57                   	push   %edi
801021eb:	e8 a0 32 00 00       	call   80105490 <memset>
	if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021f0:	6a 10                	push   $0x10
801021f2:	ff 75 b8             	pushl  -0x48(%ebp)
801021f5:	57                   	push   %edi
801021f6:	56                   	push   %esi
801021f7:	e8 64 f9 ff ff       	call   80101b60 <writei>
801021fc:	83 c4 20             	add    $0x20,%esp
801021ff:	83 f8 10             	cmp    $0x10,%eax
80102202:	0f 85 c4 00 00 00    	jne    801022cc <removeSwapFile+0x1cc>
		panic("unlink: writei");
	if(ip->type == T_DIR){
80102208:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010220d:	0f 84 8d 00 00 00    	je     801022a0 <removeSwapFile+0x1a0>
  iunlock(ip);
80102213:	83 ec 0c             	sub    $0xc,%esp
80102216:	56                   	push   %esi
80102217:	e8 24 f6 ff ff       	call   80101840 <iunlock>
  iput(ip);
8010221c:	89 34 24             	mov    %esi,(%esp)
8010221f:	e8 6c f6 ff ff       	call   80101890 <iput>
		dp->nlink--;
		iupdate(dp);
	}
	iunlockput(dp);

	ip->nlink--;
80102224:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
	iupdate(ip);
80102229:	89 1c 24             	mov    %ebx,(%esp)
8010222c:	e8 6f f4 ff ff       	call   801016a0 <iupdate>
  iunlock(ip);
80102231:	89 1c 24             	mov    %ebx,(%esp)
80102234:	e8 07 f6 ff ff       	call   80101840 <iunlock>
  iput(ip);
80102239:	89 1c 24             	mov    %ebx,(%esp)
8010223c:	e8 4f f6 ff ff       	call   80101890 <iput>
	iunlockput(ip);

	end_op();
80102241:	e8 ca 0f 00 00       	call   80103210 <end_op>

	return 0;
80102246:	83 c4 10             	add    $0x10,%esp
80102249:	31 c0                	xor    %eax,%eax
	bad:
		iunlockput(dp);
		end_op();
		return -1;

}
8010224b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010224e:	5b                   	pop    %ebx
8010224f:	5e                   	pop    %esi
80102250:	5f                   	pop    %edi
80102251:	5d                   	pop    %ebp
80102252:	c3                   	ret    
80102253:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102257:	90                   	nop
	if(ip->type == T_DIR && !isdirempty(ip)){
80102258:	83 ec 0c             	sub    $0xc,%esp
8010225b:	53                   	push   %ebx
8010225c:	e8 ff 39 00 00       	call   80105c60 <isdirempty>
80102261:	83 c4 10             	add    $0x10,%esp
80102264:	85 c0                	test   %eax,%eax
80102266:	0f 85 74 ff ff ff    	jne    801021e0 <removeSwapFile+0xe0>
  iunlock(ip);
8010226c:	83 ec 0c             	sub    $0xc,%esp
8010226f:	53                   	push   %ebx
80102270:	e8 cb f5 ff ff       	call   80101840 <iunlock>
  iput(ip);
80102275:	89 1c 24             	mov    %ebx,(%esp)
80102278:	e8 13 f6 ff ff       	call   80101890 <iput>
		goto bad;
8010227d:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80102280:	83 ec 0c             	sub    $0xc,%esp
80102283:	56                   	push   %esi
80102284:	e8 b7 f5 ff ff       	call   80101840 <iunlock>
  iput(ip);
80102289:	89 34 24             	mov    %esi,(%esp)
8010228c:	e8 ff f5 ff ff       	call   80101890 <iput>
		end_op();
80102291:	e8 7a 0f 00 00       	call   80103210 <end_op>
		return -1;
80102296:	83 c4 10             	add    $0x10,%esp
80102299:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010229e:	eb ab                	jmp    8010224b <removeSwapFile+0x14b>
		iupdate(dp);
801022a0:	83 ec 0c             	sub    $0xc,%esp
		dp->nlink--;
801022a3:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
		iupdate(dp);
801022a8:	56                   	push   %esi
801022a9:	e8 f2 f3 ff ff       	call   801016a0 <iupdate>
801022ae:	83 c4 10             	add    $0x10,%esp
801022b1:	e9 5d ff ff ff       	jmp    80102213 <removeSwapFile+0x113>
		return -1;
801022b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022bb:	eb 8e                	jmp    8010224b <removeSwapFile+0x14b>
		end_op();
801022bd:	e8 4e 0f 00 00       	call   80103210 <end_op>
		return -1;
801022c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022c7:	e9 7f ff ff ff       	jmp    8010224b <removeSwapFile+0x14b>
		panic("unlink: writei");
801022cc:	83 ec 0c             	sub    $0xc,%esp
801022cf:	68 91 85 10 80       	push   $0x80108591
801022d4:	e8 b7 e0 ff ff       	call   80100390 <panic>
		panic("unlink: nlink < 1");
801022d9:	83 ec 0c             	sub    $0xc,%esp
801022dc:	68 7f 85 10 80       	push   $0x8010857f
801022e1:	e8 aa e0 ff ff       	call   80100390 <panic>
801022e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022ed:	8d 76 00             	lea    0x0(%esi),%esi

801022f0 <createSwapFile>:


//return 0 on success
int
createSwapFile(struct proc* p)
{
801022f0:	f3 0f 1e fb          	endbr32 
801022f4:	55                   	push   %ebp
801022f5:	89 e5                	mov    %esp,%ebp
801022f7:	56                   	push   %esi
801022f8:	53                   	push   %ebx


  char path[DIGITS];
	memmove(path,"/.swap", 6);
801022f9:	8d 75 ea             	lea    -0x16(%ebp),%esi
{
801022fc:	83 ec 14             	sub    $0x14,%esp
801022ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
	memmove(path,"/.swap", 6);
80102302:	6a 06                	push   $0x6
80102304:	68 75 85 10 80       	push   $0x80108575
80102309:	56                   	push   %esi
8010230a:	e8 21 32 00 00       	call   80105530 <memmove>
	itoa(p->pid, path+ 6);
8010230f:	58                   	pop    %eax
80102310:	8d 45 f0             	lea    -0x10(%ebp),%eax
80102313:	5a                   	pop    %edx
80102314:	50                   	push   %eax
80102315:	ff 73 10             	pushl  0x10(%ebx)
80102318:	e8 53 fd ff ff       	call   80102070 <itoa>

  
  begin_op();
8010231d:	e8 7e 0e 00 00       	call   801031a0 <begin_op>
  struct inode * in = create(path, T_FILE, 0, 0);
80102322:	6a 00                	push   $0x0
80102324:	6a 00                	push   $0x0
80102326:	6a 02                	push   $0x2
80102328:	56                   	push   %esi
80102329:	e8 52 3b 00 00       	call   80105e80 <create>
    
	iunlock(in);
8010232e:	83 c4 14             	add    $0x14,%esp
80102331:	50                   	push   %eax
  struct inode * in = create(path, T_FILE, 0, 0);
80102332:	89 c6                	mov    %eax,%esi
	iunlock(in);
80102334:	e8 07 f5 ff ff       	call   80101840 <iunlock>

  
	p->swapFile = filealloc();
80102339:	e8 c2 ea ff ff       	call   80100e00 <filealloc>
	if (p->swapFile == 0)
8010233e:	83 c4 10             	add    $0x10,%esp
	p->swapFile = filealloc();
80102341:	89 43 7c             	mov    %eax,0x7c(%ebx)
	if (p->swapFile == 0)
80102344:	85 c0                	test   %eax,%eax
80102346:	74 32                	je     8010237a <createSwapFile+0x8a>
		panic("no slot for files on /store");

	p->swapFile->ip = in;
80102348:	89 70 10             	mov    %esi,0x10(%eax)
	p->swapFile->type = FD_INODE;
8010234b:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010234e:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
	p->swapFile->off = 0;
80102354:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102357:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
	p->swapFile->readable = O_WRONLY;
8010235e:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102361:	c6 40 08 01          	movb   $0x1,0x8(%eax)
	p->swapFile->writable = O_RDWR;
80102365:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102368:	c6 40 09 02          	movb   $0x2,0x9(%eax)
    end_op();
8010236c:	e8 9f 0e 00 00       	call   80103210 <end_op>

    return 0;
}
80102371:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102374:	31 c0                	xor    %eax,%eax
80102376:	5b                   	pop    %ebx
80102377:	5e                   	pop    %esi
80102378:	5d                   	pop    %ebp
80102379:	c3                   	ret    
		panic("no slot for files on /store");
8010237a:	83 ec 0c             	sub    $0xc,%esp
8010237d:	68 a0 85 10 80       	push   $0x801085a0
80102382:	e8 09 e0 ff ff       	call   80100390 <panic>
80102387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010238e:	66 90                	xchg   %ax,%ax

80102390 <writeToSwapFile>:

//return as sys_write (-1 when error)
int
writeToSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102390:	f3 0f 1e fb          	endbr32 
80102394:	55                   	push   %ebp
80102395:	89 e5                	mov    %esp,%ebp
80102397:	8b 45 08             	mov    0x8(%ebp),%eax
	p->swapFile->off = placeOnFile;
8010239a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010239d:	8b 50 7c             	mov    0x7c(%eax),%edx
801023a0:	89 4a 14             	mov    %ecx,0x14(%edx)

	return filewrite(p->swapFile, buffer, size);
801023a3:	8b 55 14             	mov    0x14(%ebp),%edx
801023a6:	89 55 10             	mov    %edx,0x10(%ebp)
801023a9:	8b 40 7c             	mov    0x7c(%eax),%eax
801023ac:	89 45 08             	mov    %eax,0x8(%ebp)

}
801023af:	5d                   	pop    %ebp
	return filewrite(p->swapFile, buffer, size);
801023b0:	e9 db ec ff ff       	jmp    80101090 <filewrite>
801023b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023c0 <readFromSwapFile>:

//return as sys_read (-1 when error)
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
801023c0:	f3 0f 1e fb          	endbr32 
801023c4:	55                   	push   %ebp
801023c5:	89 e5                	mov    %esp,%ebp
801023c7:	8b 45 08             	mov    0x8(%ebp),%eax
	p->swapFile->off = placeOnFile;
801023ca:	8b 4d 10             	mov    0x10(%ebp),%ecx
801023cd:	8b 50 7c             	mov    0x7c(%eax),%edx
801023d0:	89 4a 14             	mov    %ecx,0x14(%edx)

	return fileread(p->swapFile, buffer,  size);
801023d3:	8b 55 14             	mov    0x14(%ebp),%edx
801023d6:	89 55 10             	mov    %edx,0x10(%ebp)
801023d9:	8b 40 7c             	mov    0x7c(%eax),%eax
801023dc:	89 45 08             	mov    %eax,0x8(%ebp)
}
801023df:	5d                   	pop    %ebp
	return fileread(p->swapFile, buffer,  size);
801023e0:	e9 0b ec ff ff       	jmp    80100ff0 <fileread>
801023e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023f0 <copySwapFile>:


// copy parent swapfile to child swapfile
int
copySwapFile(struct proc *parent, struct proc *child)
{
801023f0:	f3 0f 1e fb          	endbr32 
801023f4:	55                   	push   %ebp
801023f5:	89 e5                	mov    %esp,%ebp
801023f7:	57                   	push   %edi
801023f8:	56                   	push   %esi
801023f9:	53                   	push   %ebx
801023fa:	81 ec 00 10 00 00    	sub    $0x1000,%esp
80102400:	83 0c 24 00          	orl    $0x0,(%esp)
80102404:	83 ec 1c             	sub    $0x1c,%esp
80102407:	31 db                	xor    %ebx,%ebx
80102409:	8b 75 08             	mov    0x8(%ebp),%esi
8010240c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010240f:	eb 16                	jmp    80102427 <copySwapFile+0x37>
80102411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  char buffer[PGSIZE];
  
  for(int i=0;i<MAX_SWAP_PAGES();i++)
80102418:	83 c3 10             	add    $0x10,%ebx
8010241b:	81 fb f0 00 00 00    	cmp    $0xf0,%ebx
80102421:	0f 84 85 00 00 00    	je     801024ac <copySwapFile+0xbc>
  {
    if(parent->swappedPages[i].present){
80102427:	8b 84 1e 88 00 00 00 	mov    0x88(%esi,%ebx,1),%eax
8010242e:	85 c0                	test   %eax,%eax
80102430:	74 e6                	je     80102418 <copySwapFile+0x28>
	p->swapFile->off = placeOnFile;
80102432:	8b 46 7c             	mov    0x7c(%esi),%eax
80102435:	89 d9                	mov    %ebx,%ecx
	return fileread(p->swapFile, buffer,  size);
80102437:	83 ec 04             	sub    $0x4,%esp
8010243a:	c1 e1 08             	shl    $0x8,%ecx
	p->swapFile->off = placeOnFile;
8010243d:	89 48 14             	mov    %ecx,0x14(%eax)
	return fileread(p->swapFile, buffer,  size);
80102440:	8d 85 e8 ef ff ff    	lea    -0x1018(%ebp),%eax
80102446:	68 00 10 00 00       	push   $0x1000
8010244b:	50                   	push   %eax
8010244c:	ff 76 7c             	pushl  0x7c(%esi)
	p->swapFile->off = placeOnFile;
8010244f:	89 8d e4 ef ff ff    	mov    %ecx,-0x101c(%ebp)
	return fileread(p->swapFile, buffer,  size);
80102455:	e8 96 eb ff ff       	call   80100ff0 <fileread>
      if(readFromSwapFile(parent, buffer, i*PGSIZE, PGSIZE) == -1)
8010245a:	83 c4 10             	add    $0x10,%esp
8010245d:	8b 8d e4 ef ff ff    	mov    -0x101c(%ebp),%ecx
80102463:	83 f8 ff             	cmp    $0xffffffff,%eax
80102466:	74 58                	je     801024c0 <copySwapFile+0xd0>
	p->swapFile->off = placeOnFile;
80102468:	8b 47 7c             	mov    0x7c(%edi),%eax
	return filewrite(p->swapFile, buffer, size);
8010246b:	83 ec 04             	sub    $0x4,%esp
	p->swapFile->off = placeOnFile;
8010246e:	89 48 14             	mov    %ecx,0x14(%eax)
	return filewrite(p->swapFile, buffer, size);
80102471:	8d 85 e8 ef ff ff    	lea    -0x1018(%ebp),%eax
80102477:	68 00 10 00 00       	push   $0x1000
8010247c:	50                   	push   %eax
8010247d:	ff 77 7c             	pushl  0x7c(%edi)
80102480:	e8 0b ec ff ff       	call   80101090 <filewrite>
      {
        cprintf("Problem reading file\n");

      }
      if(writeToSwapFile(child, buffer, i*PGSIZE, PGSIZE) == -1)
80102485:	83 c4 10             	add    $0x10,%esp
80102488:	83 f8 ff             	cmp    $0xffffffff,%eax
8010248b:	75 8b                	jne    80102418 <copySwapFile+0x28>
      {
        cprintf("Problem writing in file\n");
8010248d:	83 ec 0c             	sub    $0xc,%esp
80102490:	83 c3 10             	add    $0x10,%ebx
80102493:	68 d2 85 10 80       	push   $0x801085d2
80102498:	e8 13 e2 ff ff       	call   801006b0 <cprintf>
8010249d:	83 c4 10             	add    $0x10,%esp
  for(int i=0;i<MAX_SWAP_PAGES();i++)
801024a0:	81 fb f0 00 00 00    	cmp    $0xf0,%ebx
801024a6:	0f 85 7b ff ff ff    	jne    80102427 <copySwapFile+0x37>
      }
    }
  }
  return 0;
}
801024ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024af:	31 c0                	xor    %eax,%eax
801024b1:	5b                   	pop    %ebx
801024b2:	5e                   	pop    %esi
801024b3:	5f                   	pop    %edi
801024b4:	5d                   	pop    %ebp
801024b5:	c3                   	ret    
801024b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024bd:	8d 76 00             	lea    0x0(%esi),%esi
        cprintf("Problem reading file\n");
801024c0:	83 ec 0c             	sub    $0xc,%esp
801024c3:	68 bc 85 10 80       	push   $0x801085bc
801024c8:	e8 e3 e1 ff ff       	call   801006b0 <cprintf>
801024cd:	8b 8d e4 ef ff ff    	mov    -0x101c(%ebp),%ecx
801024d3:	83 c4 10             	add    $0x10,%esp
801024d6:	eb 90                	jmp    80102468 <copySwapFile+0x78>
801024d8:	66 90                	xchg   %ax,%ax
801024da:	66 90                	xchg   %ax,%ax
801024dc:	66 90                	xchg   %ax,%ax
801024de:	66 90                	xchg   %ax,%ax

801024e0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801024e0:	55                   	push   %ebp
801024e1:	89 e5                	mov    %esp,%ebp
801024e3:	57                   	push   %edi
801024e4:	56                   	push   %esi
801024e5:	53                   	push   %ebx
801024e6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801024e9:	85 c0                	test   %eax,%eax
801024eb:	0f 84 b4 00 00 00    	je     801025a5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801024f1:	8b 70 08             	mov    0x8(%eax),%esi
801024f4:	89 c3                	mov    %eax,%ebx
801024f6:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801024fc:	0f 87 96 00 00 00    	ja     80102598 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102502:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102507:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010250e:	66 90                	xchg   %ax,%ax
80102510:	89 ca                	mov    %ecx,%edx
80102512:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102513:	83 e0 c0             	and    $0xffffffc0,%eax
80102516:	3c 40                	cmp    $0x40,%al
80102518:	75 f6                	jne    80102510 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010251a:	31 ff                	xor    %edi,%edi
8010251c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102521:	89 f8                	mov    %edi,%eax
80102523:	ee                   	out    %al,(%dx)
80102524:	b8 01 00 00 00       	mov    $0x1,%eax
80102529:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010252e:	ee                   	out    %al,(%dx)
8010252f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102534:	89 f0                	mov    %esi,%eax
80102536:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102537:	89 f0                	mov    %esi,%eax
80102539:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010253e:	c1 f8 08             	sar    $0x8,%eax
80102541:	ee                   	out    %al,(%dx)
80102542:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102547:	89 f8                	mov    %edi,%eax
80102549:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010254a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010254e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102553:	c1 e0 04             	shl    $0x4,%eax
80102556:	83 e0 10             	and    $0x10,%eax
80102559:	83 c8 e0             	or     $0xffffffe0,%eax
8010255c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010255d:	f6 03 04             	testb  $0x4,(%ebx)
80102560:	75 16                	jne    80102578 <idestart+0x98>
80102562:	b8 20 00 00 00       	mov    $0x20,%eax
80102567:	89 ca                	mov    %ecx,%edx
80102569:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010256a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010256d:	5b                   	pop    %ebx
8010256e:	5e                   	pop    %esi
8010256f:	5f                   	pop    %edi
80102570:	5d                   	pop    %ebp
80102571:	c3                   	ret    
80102572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102578:	b8 30 00 00 00       	mov    $0x30,%eax
8010257d:	89 ca                	mov    %ecx,%edx
8010257f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102580:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102585:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102588:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010258d:	fc                   	cld    
8010258e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102590:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102593:	5b                   	pop    %ebx
80102594:	5e                   	pop    %esi
80102595:	5f                   	pop    %edi
80102596:	5d                   	pop    %ebp
80102597:	c3                   	ret    
    panic("incorrect blockno");
80102598:	83 ec 0c             	sub    $0xc,%esp
8010259b:	68 48 86 10 80       	push   $0x80108648
801025a0:	e8 eb dd ff ff       	call   80100390 <panic>
    panic("idestart");
801025a5:	83 ec 0c             	sub    $0xc,%esp
801025a8:	68 3f 86 10 80       	push   $0x8010863f
801025ad:	e8 de dd ff ff       	call   80100390 <panic>
801025b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801025c0 <ideinit>:
{
801025c0:	f3 0f 1e fb          	endbr32 
801025c4:	55                   	push   %ebp
801025c5:	89 e5                	mov    %esp,%ebp
801025c7:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801025ca:	68 5a 86 10 80       	push   $0x8010865a
801025cf:	68 80 c5 10 80       	push   $0x8010c580
801025d4:	e8 27 2c 00 00       	call   80105200 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801025d9:	58                   	pop    %eax
801025da:	a1 20 4d 11 80       	mov    0x80114d20,%eax
801025df:	5a                   	pop    %edx
801025e0:	83 e8 01             	sub    $0x1,%eax
801025e3:	50                   	push   %eax
801025e4:	6a 0e                	push   $0xe
801025e6:	e8 b5 02 00 00       	call   801028a0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801025eb:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025ee:	ba f7 01 00 00       	mov    $0x1f7,%edx
801025f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025f7:	90                   	nop
801025f8:	ec                   	in     (%dx),%al
801025f9:	83 e0 c0             	and    $0xffffffc0,%eax
801025fc:	3c 40                	cmp    $0x40,%al
801025fe:	75 f8                	jne    801025f8 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102600:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102605:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010260a:	ee                   	out    %al,(%dx)
8010260b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102610:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102615:	eb 0e                	jmp    80102625 <ideinit+0x65>
80102617:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010261e:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102620:	83 e9 01             	sub    $0x1,%ecx
80102623:	74 0f                	je     80102634 <ideinit+0x74>
80102625:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102626:	84 c0                	test   %al,%al
80102628:	74 f6                	je     80102620 <ideinit+0x60>
      havedisk1 = 1;
8010262a:	c7 05 60 c5 10 80 01 	movl   $0x1,0x8010c560
80102631:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102634:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102639:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010263e:	ee                   	out    %al,(%dx)
}
8010263f:	c9                   	leave  
80102640:	c3                   	ret    
80102641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102648:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010264f:	90                   	nop

80102650 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102650:	f3 0f 1e fb          	endbr32 
80102654:	55                   	push   %ebp
80102655:	89 e5                	mov    %esp,%ebp
80102657:	57                   	push   %edi
80102658:	56                   	push   %esi
80102659:	53                   	push   %ebx
8010265a:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010265d:	68 80 c5 10 80       	push   $0x8010c580
80102662:	e8 19 2d 00 00       	call   80105380 <acquire>

  if((b = idequeue) == 0){
80102667:	8b 1d 64 c5 10 80    	mov    0x8010c564,%ebx
8010266d:	83 c4 10             	add    $0x10,%esp
80102670:	85 db                	test   %ebx,%ebx
80102672:	74 5f                	je     801026d3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102674:	8b 43 58             	mov    0x58(%ebx),%eax
80102677:	a3 64 c5 10 80       	mov    %eax,0x8010c564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010267c:	8b 33                	mov    (%ebx),%esi
8010267e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102684:	75 2b                	jne    801026b1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102686:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010268b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010268f:	90                   	nop
80102690:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102691:	89 c1                	mov    %eax,%ecx
80102693:	83 e1 c0             	and    $0xffffffc0,%ecx
80102696:	80 f9 40             	cmp    $0x40,%cl
80102699:	75 f5                	jne    80102690 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010269b:	a8 21                	test   $0x21,%al
8010269d:	75 12                	jne    801026b1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010269f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801026a2:	b9 80 00 00 00       	mov    $0x80,%ecx
801026a7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801026ac:	fc                   	cld    
801026ad:	f3 6d                	rep insl (%dx),%es:(%edi)
801026af:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801026b1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801026b4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801026b7:	83 ce 02             	or     $0x2,%esi
801026ba:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801026bc:	53                   	push   %ebx
801026bd:	e8 ce 20 00 00       	call   80104790 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801026c2:	a1 64 c5 10 80       	mov    0x8010c564,%eax
801026c7:	83 c4 10             	add    $0x10,%esp
801026ca:	85 c0                	test   %eax,%eax
801026cc:	74 05                	je     801026d3 <ideintr+0x83>
    idestart(idequeue);
801026ce:	e8 0d fe ff ff       	call   801024e0 <idestart>
    release(&idelock);
801026d3:	83 ec 0c             	sub    $0xc,%esp
801026d6:	68 80 c5 10 80       	push   $0x8010c580
801026db:	e8 60 2d 00 00       	call   80105440 <release>

  release(&idelock);
}
801026e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801026e3:	5b                   	pop    %ebx
801026e4:	5e                   	pop    %esi
801026e5:	5f                   	pop    %edi
801026e6:	5d                   	pop    %ebp
801026e7:	c3                   	ret    
801026e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026ef:	90                   	nop

801026f0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801026f0:	f3 0f 1e fb          	endbr32 
801026f4:	55                   	push   %ebp
801026f5:	89 e5                	mov    %esp,%ebp
801026f7:	53                   	push   %ebx
801026f8:	83 ec 10             	sub    $0x10,%esp
801026fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801026fe:	8d 43 0c             	lea    0xc(%ebx),%eax
80102701:	50                   	push   %eax
80102702:	e8 99 2a 00 00       	call   801051a0 <holdingsleep>
80102707:	83 c4 10             	add    $0x10,%esp
8010270a:	85 c0                	test   %eax,%eax
8010270c:	0f 84 cf 00 00 00    	je     801027e1 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102712:	8b 03                	mov    (%ebx),%eax
80102714:	83 e0 06             	and    $0x6,%eax
80102717:	83 f8 02             	cmp    $0x2,%eax
8010271a:	0f 84 b4 00 00 00    	je     801027d4 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80102720:	8b 53 04             	mov    0x4(%ebx),%edx
80102723:	85 d2                	test   %edx,%edx
80102725:	74 0d                	je     80102734 <iderw+0x44>
80102727:	a1 60 c5 10 80       	mov    0x8010c560,%eax
8010272c:	85 c0                	test   %eax,%eax
8010272e:	0f 84 93 00 00 00    	je     801027c7 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102734:	83 ec 0c             	sub    $0xc,%esp
80102737:	68 80 c5 10 80       	push   $0x8010c580
8010273c:	e8 3f 2c 00 00       	call   80105380 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102741:	a1 64 c5 10 80       	mov    0x8010c564,%eax
  b->qnext = 0;
80102746:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010274d:	83 c4 10             	add    $0x10,%esp
80102750:	85 c0                	test   %eax,%eax
80102752:	74 6c                	je     801027c0 <iderw+0xd0>
80102754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102758:	89 c2                	mov    %eax,%edx
8010275a:	8b 40 58             	mov    0x58(%eax),%eax
8010275d:	85 c0                	test   %eax,%eax
8010275f:	75 f7                	jne    80102758 <iderw+0x68>
80102761:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102764:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102766:	39 1d 64 c5 10 80    	cmp    %ebx,0x8010c564
8010276c:	74 42                	je     801027b0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010276e:	8b 03                	mov    (%ebx),%eax
80102770:	83 e0 06             	and    $0x6,%eax
80102773:	83 f8 02             	cmp    $0x2,%eax
80102776:	74 23                	je     8010279b <iderw+0xab>
80102778:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010277f:	90                   	nop
    sleep(b, &idelock);
80102780:	83 ec 08             	sub    $0x8,%esp
80102783:	68 80 c5 10 80       	push   $0x8010c580
80102788:	53                   	push   %ebx
80102789:	e8 42 1e 00 00       	call   801045d0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010278e:	8b 03                	mov    (%ebx),%eax
80102790:	83 c4 10             	add    $0x10,%esp
80102793:	83 e0 06             	and    $0x6,%eax
80102796:	83 f8 02             	cmp    $0x2,%eax
80102799:	75 e5                	jne    80102780 <iderw+0x90>
  }


  release(&idelock);
8010279b:	c7 45 08 80 c5 10 80 	movl   $0x8010c580,0x8(%ebp)
}
801027a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027a5:	c9                   	leave  
  release(&idelock);
801027a6:	e9 95 2c 00 00       	jmp    80105440 <release>
801027ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027af:	90                   	nop
    idestart(b);
801027b0:	89 d8                	mov    %ebx,%eax
801027b2:	e8 29 fd ff ff       	call   801024e0 <idestart>
801027b7:	eb b5                	jmp    8010276e <iderw+0x7e>
801027b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801027c0:	ba 64 c5 10 80       	mov    $0x8010c564,%edx
801027c5:	eb 9d                	jmp    80102764 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
801027c7:	83 ec 0c             	sub    $0xc,%esp
801027ca:	68 89 86 10 80       	push   $0x80108689
801027cf:	e8 bc db ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
801027d4:	83 ec 0c             	sub    $0xc,%esp
801027d7:	68 74 86 10 80       	push   $0x80108674
801027dc:	e8 af db ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801027e1:	83 ec 0c             	sub    $0xc,%esp
801027e4:	68 5e 86 10 80       	push   $0x8010865e
801027e9:	e8 a2 db ff ff       	call   80100390 <panic>
801027ee:	66 90                	xchg   %ax,%ax

801027f0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801027f0:	f3 0f 1e fb          	endbr32 
801027f4:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801027f5:	c7 05 54 46 11 80 00 	movl   $0xfec00000,0x80114654
801027fc:	00 c0 fe 
{
801027ff:	89 e5                	mov    %esp,%ebp
80102801:	56                   	push   %esi
80102802:	53                   	push   %ebx
  ioapic->reg = reg;
80102803:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
8010280a:	00 00 00 
  return ioapic->data;
8010280d:	8b 15 54 46 11 80    	mov    0x80114654,%edx
80102813:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102816:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010281c:	8b 0d 54 46 11 80    	mov    0x80114654,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102822:	0f b6 15 80 47 11 80 	movzbl 0x80114780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102829:	c1 ee 10             	shr    $0x10,%esi
8010282c:	89 f0                	mov    %esi,%eax
8010282e:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
80102831:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102834:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102837:	39 c2                	cmp    %eax,%edx
80102839:	74 16                	je     80102851 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
8010283b:	83 ec 0c             	sub    $0xc,%esp
8010283e:	68 a8 86 10 80       	push   $0x801086a8
80102843:	e8 68 de ff ff       	call   801006b0 <cprintf>
80102848:	8b 0d 54 46 11 80    	mov    0x80114654,%ecx
8010284e:	83 c4 10             	add    $0x10,%esp
80102851:	83 c6 21             	add    $0x21,%esi
{
80102854:	ba 10 00 00 00       	mov    $0x10,%edx
80102859:	b8 20 00 00 00       	mov    $0x20,%eax
8010285e:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102860:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102862:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102864:	8b 0d 54 46 11 80    	mov    0x80114654,%ecx
8010286a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010286d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102873:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102876:	8d 5a 01             	lea    0x1(%edx),%ebx
80102879:	83 c2 02             	add    $0x2,%edx
8010287c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010287e:	8b 0d 54 46 11 80    	mov    0x80114654,%ecx
80102884:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010288b:	39 f0                	cmp    %esi,%eax
8010288d:	75 d1                	jne    80102860 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010288f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102892:	5b                   	pop    %ebx
80102893:	5e                   	pop    %esi
80102894:	5d                   	pop    %ebp
80102895:	c3                   	ret    
80102896:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010289d:	8d 76 00             	lea    0x0(%esi),%esi

801028a0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801028a0:	f3 0f 1e fb          	endbr32 
801028a4:	55                   	push   %ebp
  ioapic->reg = reg;
801028a5:	8b 0d 54 46 11 80    	mov    0x80114654,%ecx
{
801028ab:	89 e5                	mov    %esp,%ebp
801028ad:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801028b0:	8d 50 20             	lea    0x20(%eax),%edx
801028b3:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801028b7:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801028b9:	8b 0d 54 46 11 80    	mov    0x80114654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801028bf:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801028c2:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801028c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801028c8:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801028ca:	a1 54 46 11 80       	mov    0x80114654,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801028cf:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801028d2:	89 50 10             	mov    %edx,0x10(%eax)
}
801028d5:	5d                   	pop    %ebp
801028d6:	c3                   	ret    
801028d7:	66 90                	xchg   %ax,%ax
801028d9:	66 90                	xchg   %ax,%ax
801028db:	66 90                	xchg   %ax,%ax
801028dd:	66 90                	xchg   %ax,%ax
801028df:	90                   	nop

801028e0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801028e0:	f3 0f 1e fb          	endbr32 
801028e4:	55                   	push   %ebp
801028e5:	89 e5                	mov    %esp,%ebp
801028e7:	53                   	push   %ebx
801028e8:	83 ec 04             	sub    $0x4,%esp
801028eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801028ee:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801028f4:	75 7a                	jne    80102970 <kfree+0x90>
801028f6:	81 fb c8 f1 11 80    	cmp    $0x8011f1c8,%ebx
801028fc:	72 72                	jb     80102970 <kfree+0x90>
801028fe:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102904:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102909:	77 65                	ja     80102970 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
8010290b:	83 ec 04             	sub    $0x4,%esp
8010290e:	68 00 10 00 00       	push   $0x1000
80102913:	6a 01                	push   $0x1
80102915:	53                   	push   %ebx
80102916:	e8 75 2b 00 00       	call   80105490 <memset>

  if(kmem.use_lock)
8010291b:	8b 15 94 46 11 80    	mov    0x80114694,%edx
80102921:	83 c4 10             	add    $0x10,%esp
80102924:	85 d2                	test   %edx,%edx
80102926:	75 20                	jne    80102948 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102928:	a1 98 46 11 80       	mov    0x80114698,%eax
8010292d:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010292f:	a1 94 46 11 80       	mov    0x80114694,%eax
  kmem.freelist = r;
80102934:	89 1d 98 46 11 80    	mov    %ebx,0x80114698
  if(kmem.use_lock)
8010293a:	85 c0                	test   %eax,%eax
8010293c:	75 22                	jne    80102960 <kfree+0x80>
    release(&kmem.lock);
}
8010293e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102941:	c9                   	leave  
80102942:	c3                   	ret    
80102943:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102947:	90                   	nop
    acquire(&kmem.lock);
80102948:	83 ec 0c             	sub    $0xc,%esp
8010294b:	68 60 46 11 80       	push   $0x80114660
80102950:	e8 2b 2a 00 00       	call   80105380 <acquire>
80102955:	83 c4 10             	add    $0x10,%esp
80102958:	eb ce                	jmp    80102928 <kfree+0x48>
8010295a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102960:	c7 45 08 60 46 11 80 	movl   $0x80114660,0x8(%ebp)
}
80102967:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010296a:	c9                   	leave  
    release(&kmem.lock);
8010296b:	e9 d0 2a 00 00       	jmp    80105440 <release>
    panic("kfree");
80102970:	83 ec 0c             	sub    $0xc,%esp
80102973:	68 da 86 10 80       	push   $0x801086da
80102978:	e8 13 da ff ff       	call   80100390 <panic>
8010297d:	8d 76 00             	lea    0x0(%esi),%esi

80102980 <freerange>:
{
80102980:	f3 0f 1e fb          	endbr32 
80102984:	55                   	push   %ebp
80102985:	89 e5                	mov    %esp,%ebp
80102987:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102988:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010298b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010298e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010298f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102995:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010299b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801029a1:	39 de                	cmp    %ebx,%esi
801029a3:	72 1f                	jb     801029c4 <freerange+0x44>
801029a5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
801029a8:	83 ec 0c             	sub    $0xc,%esp
801029ab:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801029b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801029b7:	50                   	push   %eax
801029b8:	e8 23 ff ff ff       	call   801028e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801029bd:	83 c4 10             	add    $0x10,%esp
801029c0:	39 f3                	cmp    %esi,%ebx
801029c2:	76 e4                	jbe    801029a8 <freerange+0x28>
}
801029c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801029c7:	5b                   	pop    %ebx
801029c8:	5e                   	pop    %esi
801029c9:	5d                   	pop    %ebp
801029ca:	c3                   	ret    
801029cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801029cf:	90                   	nop

801029d0 <kinit1>:
{
801029d0:	f3 0f 1e fb          	endbr32 
801029d4:	55                   	push   %ebp
801029d5:	89 e5                	mov    %esp,%ebp
801029d7:	56                   	push   %esi
801029d8:	53                   	push   %ebx
801029d9:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801029dc:	83 ec 08             	sub    $0x8,%esp
801029df:	68 e0 86 10 80       	push   $0x801086e0
801029e4:	68 60 46 11 80       	push   $0x80114660
801029e9:	e8 12 28 00 00       	call   80105200 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801029ee:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801029f1:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801029f4:	c7 05 94 46 11 80 00 	movl   $0x0,0x80114694
801029fb:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801029fe:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102a04:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a0a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102a10:	39 de                	cmp    %ebx,%esi
80102a12:	72 20                	jb     80102a34 <kinit1+0x64>
80102a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102a18:	83 ec 0c             	sub    $0xc,%esp
80102a1b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a21:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102a27:	50                   	push   %eax
80102a28:	e8 b3 fe ff ff       	call   801028e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a2d:	83 c4 10             	add    $0x10,%esp
80102a30:	39 de                	cmp    %ebx,%esi
80102a32:	73 e4                	jae    80102a18 <kinit1+0x48>
}
80102a34:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a37:	5b                   	pop    %ebx
80102a38:	5e                   	pop    %esi
80102a39:	5d                   	pop    %ebp
80102a3a:	c3                   	ret    
80102a3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a3f:	90                   	nop

80102a40 <kinit2>:
{
80102a40:	f3 0f 1e fb          	endbr32 
80102a44:	55                   	push   %ebp
80102a45:	89 e5                	mov    %esp,%ebp
80102a47:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102a48:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102a4b:	8b 75 0c             	mov    0xc(%ebp),%esi
80102a4e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102a4f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102a55:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a5b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102a61:	39 de                	cmp    %ebx,%esi
80102a63:	72 1f                	jb     80102a84 <kinit2+0x44>
80102a65:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102a68:	83 ec 0c             	sub    $0xc,%esp
80102a6b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a71:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102a77:	50                   	push   %eax
80102a78:	e8 63 fe ff ff       	call   801028e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a7d:	83 c4 10             	add    $0x10,%esp
80102a80:	39 de                	cmp    %ebx,%esi
80102a82:	73 e4                	jae    80102a68 <kinit2+0x28>
  kmem.use_lock = 1;
80102a84:	c7 05 94 46 11 80 01 	movl   $0x1,0x80114694
80102a8b:	00 00 00 
}
80102a8e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a91:	5b                   	pop    %ebx
80102a92:	5e                   	pop    %esi
80102a93:	5d                   	pop    %ebp
80102a94:	c3                   	ret    
80102a95:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102aa0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102aa0:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102aa4:	a1 94 46 11 80       	mov    0x80114694,%eax
80102aa9:	85 c0                	test   %eax,%eax
80102aab:	75 1b                	jne    80102ac8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102aad:	a1 98 46 11 80       	mov    0x80114698,%eax
  if(r)
80102ab2:	85 c0                	test   %eax,%eax
80102ab4:	74 0a                	je     80102ac0 <kalloc+0x20>
    kmem.freelist = r->next;
80102ab6:	8b 10                	mov    (%eax),%edx
80102ab8:	89 15 98 46 11 80    	mov    %edx,0x80114698
  if(kmem.use_lock)
80102abe:	c3                   	ret    
80102abf:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102ac0:	c3                   	ret    
80102ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102ac8:	55                   	push   %ebp
80102ac9:	89 e5                	mov    %esp,%ebp
80102acb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102ace:	68 60 46 11 80       	push   $0x80114660
80102ad3:	e8 a8 28 00 00       	call   80105380 <acquire>
  r = kmem.freelist;
80102ad8:	a1 98 46 11 80       	mov    0x80114698,%eax
  if(r)
80102add:	8b 15 94 46 11 80    	mov    0x80114694,%edx
80102ae3:	83 c4 10             	add    $0x10,%esp
80102ae6:	85 c0                	test   %eax,%eax
80102ae8:	74 08                	je     80102af2 <kalloc+0x52>
    kmem.freelist = r->next;
80102aea:	8b 08                	mov    (%eax),%ecx
80102aec:	89 0d 98 46 11 80    	mov    %ecx,0x80114698
  if(kmem.use_lock)
80102af2:	85 d2                	test   %edx,%edx
80102af4:	74 16                	je     80102b0c <kalloc+0x6c>
    release(&kmem.lock);
80102af6:	83 ec 0c             	sub    $0xc,%esp
80102af9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102afc:	68 60 46 11 80       	push   $0x80114660
80102b01:	e8 3a 29 00 00       	call   80105440 <release>
  return (char*)r;
80102b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102b09:	83 c4 10             	add    $0x10,%esp
}
80102b0c:	c9                   	leave  
80102b0d:	c3                   	ret    
80102b0e:	66 90                	xchg   %ax,%ax

80102b10 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102b10:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b14:	ba 64 00 00 00       	mov    $0x64,%edx
80102b19:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102b1a:	a8 01                	test   $0x1,%al
80102b1c:	0f 84 be 00 00 00    	je     80102be0 <kbdgetc+0xd0>
{
80102b22:	55                   	push   %ebp
80102b23:	ba 60 00 00 00       	mov    $0x60,%edx
80102b28:	89 e5                	mov    %esp,%ebp
80102b2a:	53                   	push   %ebx
80102b2b:	ec                   	in     (%dx),%al
  return data;
80102b2c:	8b 1d b4 c5 10 80    	mov    0x8010c5b4,%ebx
    return -1;
  data = inb(KBDATAP);
80102b32:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102b35:	3c e0                	cmp    $0xe0,%al
80102b37:	74 57                	je     80102b90 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102b39:	89 d9                	mov    %ebx,%ecx
80102b3b:	83 e1 40             	and    $0x40,%ecx
80102b3e:	84 c0                	test   %al,%al
80102b40:	78 5e                	js     80102ba0 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102b42:	85 c9                	test   %ecx,%ecx
80102b44:	74 09                	je     80102b4f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102b46:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102b49:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102b4c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102b4f:	0f b6 8a 20 88 10 80 	movzbl -0x7fef77e0(%edx),%ecx
  shift ^= togglecode[data];
80102b56:	0f b6 82 20 87 10 80 	movzbl -0x7fef78e0(%edx),%eax
  shift |= shiftcode[data];
80102b5d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
80102b5f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102b61:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102b63:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102b69:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102b6c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102b6f:	8b 04 85 00 87 10 80 	mov    -0x7fef7900(,%eax,4),%eax
80102b76:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102b7a:	74 0b                	je     80102b87 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
80102b7c:	8d 50 9f             	lea    -0x61(%eax),%edx
80102b7f:	83 fa 19             	cmp    $0x19,%edx
80102b82:	77 44                	ja     80102bc8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102b84:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102b87:	5b                   	pop    %ebx
80102b88:	5d                   	pop    %ebp
80102b89:	c3                   	ret    
80102b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102b90:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102b93:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102b95:	89 1d b4 c5 10 80    	mov    %ebx,0x8010c5b4
}
80102b9b:	5b                   	pop    %ebx
80102b9c:	5d                   	pop    %ebp
80102b9d:	c3                   	ret    
80102b9e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102ba0:	83 e0 7f             	and    $0x7f,%eax
80102ba3:	85 c9                	test   %ecx,%ecx
80102ba5:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102ba8:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102baa:	0f b6 8a 20 88 10 80 	movzbl -0x7fef77e0(%edx),%ecx
80102bb1:	83 c9 40             	or     $0x40,%ecx
80102bb4:	0f b6 c9             	movzbl %cl,%ecx
80102bb7:	f7 d1                	not    %ecx
80102bb9:	21 d9                	and    %ebx,%ecx
}
80102bbb:	5b                   	pop    %ebx
80102bbc:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
80102bbd:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
}
80102bc3:	c3                   	ret    
80102bc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102bc8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102bcb:	8d 50 20             	lea    0x20(%eax),%edx
}
80102bce:	5b                   	pop    %ebx
80102bcf:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102bd0:	83 f9 1a             	cmp    $0x1a,%ecx
80102bd3:	0f 42 c2             	cmovb  %edx,%eax
}
80102bd6:	c3                   	ret    
80102bd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102bde:	66 90                	xchg   %ax,%ax
    return -1;
80102be0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102be5:	c3                   	ret    
80102be6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102bed:	8d 76 00             	lea    0x0(%esi),%esi

80102bf0 <kbdintr>:

void
kbdintr(void)
{
80102bf0:	f3 0f 1e fb          	endbr32 
80102bf4:	55                   	push   %ebp
80102bf5:	89 e5                	mov    %esp,%ebp
80102bf7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102bfa:	68 10 2b 10 80       	push   $0x80102b10
80102bff:	e8 5c dc ff ff       	call   80100860 <consoleintr>
}
80102c04:	83 c4 10             	add    $0x10,%esp
80102c07:	c9                   	leave  
80102c08:	c3                   	ret    
80102c09:	66 90                	xchg   %ax,%ax
80102c0b:	66 90                	xchg   %ax,%ax
80102c0d:	66 90                	xchg   %ax,%ax
80102c0f:	90                   	nop

80102c10 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102c10:	f3 0f 1e fb          	endbr32 
  if(!lapic)
80102c14:	a1 9c 46 11 80       	mov    0x8011469c,%eax
80102c19:	85 c0                	test   %eax,%eax
80102c1b:	0f 84 c7 00 00 00    	je     80102ce8 <lapicinit+0xd8>
  lapic[index] = value;
80102c21:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102c28:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c2b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c2e:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102c35:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c38:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c3b:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102c42:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102c45:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c48:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102c4f:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102c52:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c55:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102c5c:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102c5f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c62:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102c69:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102c6c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102c6f:	8b 50 30             	mov    0x30(%eax),%edx
80102c72:	c1 ea 10             	shr    $0x10,%edx
80102c75:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102c7b:	75 73                	jne    80102cf0 <lapicinit+0xe0>
  lapic[index] = value;
80102c7d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102c84:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c87:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c8a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102c91:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c94:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c97:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102c9e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ca1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ca4:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102cab:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cae:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cb1:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102cb8:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cbb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cbe:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102cc5:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102cc8:	8b 50 20             	mov    0x20(%eax),%edx
80102ccb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ccf:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102cd0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102cd6:	80 e6 10             	and    $0x10,%dh
80102cd9:	75 f5                	jne    80102cd0 <lapicinit+0xc0>
  lapic[index] = value;
80102cdb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102ce2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ce5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102ce8:	c3                   	ret    
80102ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102cf0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102cf7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102cfa:	8b 50 20             	mov    0x20(%eax),%edx
}
80102cfd:	e9 7b ff ff ff       	jmp    80102c7d <lapicinit+0x6d>
80102d02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d10 <lapicid>:

int
lapicid(void)
{
80102d10:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80102d14:	a1 9c 46 11 80       	mov    0x8011469c,%eax
80102d19:	85 c0                	test   %eax,%eax
80102d1b:	74 0b                	je     80102d28 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
80102d1d:	8b 40 20             	mov    0x20(%eax),%eax
80102d20:	c1 e8 18             	shr    $0x18,%eax
80102d23:	c3                   	ret    
80102d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102d28:	31 c0                	xor    %eax,%eax
}
80102d2a:	c3                   	ret    
80102d2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d2f:	90                   	nop

80102d30 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102d30:	f3 0f 1e fb          	endbr32 
  if(lapic)
80102d34:	a1 9c 46 11 80       	mov    0x8011469c,%eax
80102d39:	85 c0                	test   %eax,%eax
80102d3b:	74 0d                	je     80102d4a <lapiceoi+0x1a>
  lapic[index] = value;
80102d3d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102d44:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d47:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102d4a:	c3                   	ret    
80102d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d4f:	90                   	nop

80102d50 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102d50:	f3 0f 1e fb          	endbr32 
}
80102d54:	c3                   	ret    
80102d55:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102d60 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102d60:	f3 0f 1e fb          	endbr32 
80102d64:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d65:	b8 0f 00 00 00       	mov    $0xf,%eax
80102d6a:	ba 70 00 00 00       	mov    $0x70,%edx
80102d6f:	89 e5                	mov    %esp,%ebp
80102d71:	53                   	push   %ebx
80102d72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102d75:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102d78:	ee                   	out    %al,(%dx)
80102d79:	b8 0a 00 00 00       	mov    $0xa,%eax
80102d7e:	ba 71 00 00 00       	mov    $0x71,%edx
80102d83:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102d84:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102d86:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102d89:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102d8f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102d91:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102d94:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102d96:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102d99:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102d9c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102da2:	a1 9c 46 11 80       	mov    0x8011469c,%eax
80102da7:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102dad:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102db0:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102db7:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102dba:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102dbd:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102dc4:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102dc7:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102dca:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102dd0:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102dd3:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102dd9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ddc:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102de2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102de5:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
80102deb:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
80102dec:	8b 40 20             	mov    0x20(%eax),%eax
}
80102def:	5d                   	pop    %ebp
80102df0:	c3                   	ret    
80102df1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102df8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dff:	90                   	nop

80102e00 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102e00:	f3 0f 1e fb          	endbr32 
80102e04:	55                   	push   %ebp
80102e05:	b8 0b 00 00 00       	mov    $0xb,%eax
80102e0a:	ba 70 00 00 00       	mov    $0x70,%edx
80102e0f:	89 e5                	mov    %esp,%ebp
80102e11:	57                   	push   %edi
80102e12:	56                   	push   %esi
80102e13:	53                   	push   %ebx
80102e14:	83 ec 4c             	sub    $0x4c,%esp
80102e17:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e18:	ba 71 00 00 00       	mov    $0x71,%edx
80102e1d:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102e1e:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e21:	bb 70 00 00 00       	mov    $0x70,%ebx
80102e26:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e30:	31 c0                	xor    %eax,%eax
80102e32:	89 da                	mov    %ebx,%edx
80102e34:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e35:	b9 71 00 00 00       	mov    $0x71,%ecx
80102e3a:	89 ca                	mov    %ecx,%edx
80102e3c:	ec                   	in     (%dx),%al
80102e3d:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e40:	89 da                	mov    %ebx,%edx
80102e42:	b8 02 00 00 00       	mov    $0x2,%eax
80102e47:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e48:	89 ca                	mov    %ecx,%edx
80102e4a:	ec                   	in     (%dx),%al
80102e4b:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e4e:	89 da                	mov    %ebx,%edx
80102e50:	b8 04 00 00 00       	mov    $0x4,%eax
80102e55:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e56:	89 ca                	mov    %ecx,%edx
80102e58:	ec                   	in     (%dx),%al
80102e59:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e5c:	89 da                	mov    %ebx,%edx
80102e5e:	b8 07 00 00 00       	mov    $0x7,%eax
80102e63:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e64:	89 ca                	mov    %ecx,%edx
80102e66:	ec                   	in     (%dx),%al
80102e67:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e6a:	89 da                	mov    %ebx,%edx
80102e6c:	b8 08 00 00 00       	mov    $0x8,%eax
80102e71:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e72:	89 ca                	mov    %ecx,%edx
80102e74:	ec                   	in     (%dx),%al
80102e75:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e77:	89 da                	mov    %ebx,%edx
80102e79:	b8 09 00 00 00       	mov    $0x9,%eax
80102e7e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e7f:	89 ca                	mov    %ecx,%edx
80102e81:	ec                   	in     (%dx),%al
80102e82:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e84:	89 da                	mov    %ebx,%edx
80102e86:	b8 0a 00 00 00       	mov    $0xa,%eax
80102e8b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e8c:	89 ca                	mov    %ecx,%edx
80102e8e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102e8f:	84 c0                	test   %al,%al
80102e91:	78 9d                	js     80102e30 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102e93:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102e97:	89 fa                	mov    %edi,%edx
80102e99:	0f b6 fa             	movzbl %dl,%edi
80102e9c:	89 f2                	mov    %esi,%edx
80102e9e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102ea1:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102ea5:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ea8:	89 da                	mov    %ebx,%edx
80102eaa:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102ead:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102eb0:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102eb4:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102eb7:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102eba:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102ebe:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102ec1:	31 c0                	xor    %eax,%eax
80102ec3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ec4:	89 ca                	mov    %ecx,%edx
80102ec6:	ec                   	in     (%dx),%al
80102ec7:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102eca:	89 da                	mov    %ebx,%edx
80102ecc:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102ecf:	b8 02 00 00 00       	mov    $0x2,%eax
80102ed4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ed5:	89 ca                	mov    %ecx,%edx
80102ed7:	ec                   	in     (%dx),%al
80102ed8:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102edb:	89 da                	mov    %ebx,%edx
80102edd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102ee0:	b8 04 00 00 00       	mov    $0x4,%eax
80102ee5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ee6:	89 ca                	mov    %ecx,%edx
80102ee8:	ec                   	in     (%dx),%al
80102ee9:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102eec:	89 da                	mov    %ebx,%edx
80102eee:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ef1:	b8 07 00 00 00       	mov    $0x7,%eax
80102ef6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ef7:	89 ca                	mov    %ecx,%edx
80102ef9:	ec                   	in     (%dx),%al
80102efa:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102efd:	89 da                	mov    %ebx,%edx
80102eff:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102f02:	b8 08 00 00 00       	mov    $0x8,%eax
80102f07:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f08:	89 ca                	mov    %ecx,%edx
80102f0a:	ec                   	in     (%dx),%al
80102f0b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f0e:	89 da                	mov    %ebx,%edx
80102f10:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102f13:	b8 09 00 00 00       	mov    $0x9,%eax
80102f18:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f19:	89 ca                	mov    %ecx,%edx
80102f1b:	ec                   	in     (%dx),%al
80102f1c:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102f1f:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102f22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102f25:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102f28:	6a 18                	push   $0x18
80102f2a:	50                   	push   %eax
80102f2b:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102f2e:	50                   	push   %eax
80102f2f:	e8 ac 25 00 00       	call   801054e0 <memcmp>
80102f34:	83 c4 10             	add    $0x10,%esp
80102f37:	85 c0                	test   %eax,%eax
80102f39:	0f 85 f1 fe ff ff    	jne    80102e30 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102f3f:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102f43:	75 78                	jne    80102fbd <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102f45:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102f48:	89 c2                	mov    %eax,%edx
80102f4a:	83 e0 0f             	and    $0xf,%eax
80102f4d:	c1 ea 04             	shr    $0x4,%edx
80102f50:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102f53:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102f56:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102f59:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102f5c:	89 c2                	mov    %eax,%edx
80102f5e:	83 e0 0f             	and    $0xf,%eax
80102f61:	c1 ea 04             	shr    $0x4,%edx
80102f64:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102f67:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102f6a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102f6d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102f70:	89 c2                	mov    %eax,%edx
80102f72:	83 e0 0f             	and    $0xf,%eax
80102f75:	c1 ea 04             	shr    $0x4,%edx
80102f78:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102f7b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102f7e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102f81:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102f84:	89 c2                	mov    %eax,%edx
80102f86:	83 e0 0f             	and    $0xf,%eax
80102f89:	c1 ea 04             	shr    $0x4,%edx
80102f8c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102f8f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102f92:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102f95:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102f98:	89 c2                	mov    %eax,%edx
80102f9a:	83 e0 0f             	and    $0xf,%eax
80102f9d:	c1 ea 04             	shr    $0x4,%edx
80102fa0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fa3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fa6:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102fa9:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102fac:	89 c2                	mov    %eax,%edx
80102fae:	83 e0 0f             	and    $0xf,%eax
80102fb1:	c1 ea 04             	shr    $0x4,%edx
80102fb4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fb7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fba:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102fbd:	8b 75 08             	mov    0x8(%ebp),%esi
80102fc0:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102fc3:	89 06                	mov    %eax,(%esi)
80102fc5:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102fc8:	89 46 04             	mov    %eax,0x4(%esi)
80102fcb:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102fce:	89 46 08             	mov    %eax,0x8(%esi)
80102fd1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102fd4:	89 46 0c             	mov    %eax,0xc(%esi)
80102fd7:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102fda:	89 46 10             	mov    %eax,0x10(%esi)
80102fdd:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102fe0:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102fe3:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102fea:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102fed:	5b                   	pop    %ebx
80102fee:	5e                   	pop    %esi
80102fef:	5f                   	pop    %edi
80102ff0:	5d                   	pop    %ebp
80102ff1:	c3                   	ret    
80102ff2:	66 90                	xchg   %ax,%ax
80102ff4:	66 90                	xchg   %ax,%ax
80102ff6:	66 90                	xchg   %ax,%ax
80102ff8:	66 90                	xchg   %ax,%ax
80102ffa:	66 90                	xchg   %ax,%ax
80102ffc:	66 90                	xchg   %ax,%ax
80102ffe:	66 90                	xchg   %ax,%ax

80103000 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103000:	8b 0d e8 46 11 80    	mov    0x801146e8,%ecx
80103006:	85 c9                	test   %ecx,%ecx
80103008:	0f 8e 8a 00 00 00    	jle    80103098 <install_trans+0x98>
{
8010300e:	55                   	push   %ebp
8010300f:	89 e5                	mov    %esp,%ebp
80103011:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103012:	31 ff                	xor    %edi,%edi
{
80103014:	56                   	push   %esi
80103015:	53                   	push   %ebx
80103016:	83 ec 0c             	sub    $0xc,%esp
80103019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103020:	a1 d4 46 11 80       	mov    0x801146d4,%eax
80103025:	83 ec 08             	sub    $0x8,%esp
80103028:	01 f8                	add    %edi,%eax
8010302a:	83 c0 01             	add    $0x1,%eax
8010302d:	50                   	push   %eax
8010302e:	ff 35 e4 46 11 80    	pushl  0x801146e4
80103034:	e8 97 d0 ff ff       	call   801000d0 <bread>
80103039:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010303b:	58                   	pop    %eax
8010303c:	5a                   	pop    %edx
8010303d:	ff 34 bd ec 46 11 80 	pushl  -0x7feeb914(,%edi,4)
80103044:	ff 35 e4 46 11 80    	pushl  0x801146e4
  for (tail = 0; tail < log.lh.n; tail++) {
8010304a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010304d:	e8 7e d0 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103052:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103055:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103057:	8d 46 5c             	lea    0x5c(%esi),%eax
8010305a:	68 00 02 00 00       	push   $0x200
8010305f:	50                   	push   %eax
80103060:	8d 43 5c             	lea    0x5c(%ebx),%eax
80103063:	50                   	push   %eax
80103064:	e8 c7 24 00 00       	call   80105530 <memmove>
    bwrite(dbuf);  // write dst to disk
80103069:	89 1c 24             	mov    %ebx,(%esp)
8010306c:	e8 3f d1 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80103071:	89 34 24             	mov    %esi,(%esp)
80103074:	e8 77 d1 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80103079:	89 1c 24             	mov    %ebx,(%esp)
8010307c:	e8 6f d1 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103081:	83 c4 10             	add    $0x10,%esp
80103084:	39 3d e8 46 11 80    	cmp    %edi,0x801146e8
8010308a:	7f 94                	jg     80103020 <install_trans+0x20>
  }
}
8010308c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010308f:	5b                   	pop    %ebx
80103090:	5e                   	pop    %esi
80103091:	5f                   	pop    %edi
80103092:	5d                   	pop    %ebp
80103093:	c3                   	ret    
80103094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103098:	c3                   	ret    
80103099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801030a0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801030a0:	55                   	push   %ebp
801030a1:	89 e5                	mov    %esp,%ebp
801030a3:	53                   	push   %ebx
801030a4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
801030a7:	ff 35 d4 46 11 80    	pushl  0x801146d4
801030ad:	ff 35 e4 46 11 80    	pushl  0x801146e4
801030b3:	e8 18 d0 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801030b8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
801030bb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
801030bd:	a1 e8 46 11 80       	mov    0x801146e8,%eax
801030c2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
801030c5:	85 c0                	test   %eax,%eax
801030c7:	7e 19                	jle    801030e2 <write_head+0x42>
801030c9:	31 d2                	xor    %edx,%edx
801030cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801030cf:	90                   	nop
    hb->block[i] = log.lh.block[i];
801030d0:	8b 0c 95 ec 46 11 80 	mov    -0x7feeb914(,%edx,4),%ecx
801030d7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801030db:	83 c2 01             	add    $0x1,%edx
801030de:	39 d0                	cmp    %edx,%eax
801030e0:	75 ee                	jne    801030d0 <write_head+0x30>
  }
  bwrite(buf);
801030e2:	83 ec 0c             	sub    $0xc,%esp
801030e5:	53                   	push   %ebx
801030e6:	e8 c5 d0 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
801030eb:	89 1c 24             	mov    %ebx,(%esp)
801030ee:	e8 fd d0 ff ff       	call   801001f0 <brelse>
}
801030f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801030f6:	83 c4 10             	add    $0x10,%esp
801030f9:	c9                   	leave  
801030fa:	c3                   	ret    
801030fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801030ff:	90                   	nop

80103100 <initlog>:
{
80103100:	f3 0f 1e fb          	endbr32 
80103104:	55                   	push   %ebp
80103105:	89 e5                	mov    %esp,%ebp
80103107:	53                   	push   %ebx
80103108:	83 ec 2c             	sub    $0x2c,%esp
8010310b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010310e:	68 20 89 10 80       	push   $0x80108920
80103113:	68 a0 46 11 80       	push   $0x801146a0
80103118:	e8 e3 20 00 00       	call   80105200 <initlock>
  readsb(dev, &sb);
8010311d:	58                   	pop    %eax
8010311e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103121:	5a                   	pop    %edx
80103122:	50                   	push   %eax
80103123:	53                   	push   %ebx
80103124:	e8 d7 e3 ff ff       	call   80101500 <readsb>
  log.start = sb.logstart;
80103129:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
8010312c:	59                   	pop    %ecx
  log.dev = dev;
8010312d:	89 1d e4 46 11 80    	mov    %ebx,0x801146e4
  log.size = sb.nlog;
80103133:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103136:	a3 d4 46 11 80       	mov    %eax,0x801146d4
  log.size = sb.nlog;
8010313b:	89 15 d8 46 11 80    	mov    %edx,0x801146d8
  struct buf *buf = bread(log.dev, log.start);
80103141:	5a                   	pop    %edx
80103142:	50                   	push   %eax
80103143:	53                   	push   %ebx
80103144:	e8 87 cf ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103149:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
8010314c:	8b 48 5c             	mov    0x5c(%eax),%ecx
8010314f:	89 0d e8 46 11 80    	mov    %ecx,0x801146e8
  for (i = 0; i < log.lh.n; i++) {
80103155:	85 c9                	test   %ecx,%ecx
80103157:	7e 19                	jle    80103172 <initlog+0x72>
80103159:	31 d2                	xor    %edx,%edx
8010315b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010315f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80103160:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80103164:	89 1c 95 ec 46 11 80 	mov    %ebx,-0x7feeb914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010316b:	83 c2 01             	add    $0x1,%edx
8010316e:	39 d1                	cmp    %edx,%ecx
80103170:	75 ee                	jne    80103160 <initlog+0x60>
  brelse(buf);
80103172:	83 ec 0c             	sub    $0xc,%esp
80103175:	50                   	push   %eax
80103176:	e8 75 d0 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010317b:	e8 80 fe ff ff       	call   80103000 <install_trans>
  log.lh.n = 0;
80103180:	c7 05 e8 46 11 80 00 	movl   $0x0,0x801146e8
80103187:	00 00 00 
  write_head(); // clear the log
8010318a:	e8 11 ff ff ff       	call   801030a0 <write_head>
}
8010318f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103192:	83 c4 10             	add    $0x10,%esp
80103195:	c9                   	leave  
80103196:	c3                   	ret    
80103197:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010319e:	66 90                	xchg   %ax,%ax

801031a0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
801031a0:	f3 0f 1e fb          	endbr32 
801031a4:	55                   	push   %ebp
801031a5:	89 e5                	mov    %esp,%ebp
801031a7:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801031aa:	68 a0 46 11 80       	push   $0x801146a0
801031af:	e8 cc 21 00 00       	call   80105380 <acquire>
801031b4:	83 c4 10             	add    $0x10,%esp
801031b7:	eb 1c                	jmp    801031d5 <begin_op+0x35>
801031b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
801031c0:	83 ec 08             	sub    $0x8,%esp
801031c3:	68 a0 46 11 80       	push   $0x801146a0
801031c8:	68 a0 46 11 80       	push   $0x801146a0
801031cd:	e8 fe 13 00 00       	call   801045d0 <sleep>
801031d2:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801031d5:	a1 e0 46 11 80       	mov    0x801146e0,%eax
801031da:	85 c0                	test   %eax,%eax
801031dc:	75 e2                	jne    801031c0 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801031de:	a1 dc 46 11 80       	mov    0x801146dc,%eax
801031e3:	8b 15 e8 46 11 80    	mov    0x801146e8,%edx
801031e9:	83 c0 01             	add    $0x1,%eax
801031ec:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801031ef:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801031f2:	83 fa 1e             	cmp    $0x1e,%edx
801031f5:	7f c9                	jg     801031c0 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
801031f7:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
801031fa:	a3 dc 46 11 80       	mov    %eax,0x801146dc
      release(&log.lock);
801031ff:	68 a0 46 11 80       	push   $0x801146a0
80103204:	e8 37 22 00 00       	call   80105440 <release>
      break;
    }
  }
}
80103209:	83 c4 10             	add    $0x10,%esp
8010320c:	c9                   	leave  
8010320d:	c3                   	ret    
8010320e:	66 90                	xchg   %ax,%ax

80103210 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103210:	f3 0f 1e fb          	endbr32 
80103214:	55                   	push   %ebp
80103215:	89 e5                	mov    %esp,%ebp
80103217:	57                   	push   %edi
80103218:	56                   	push   %esi
80103219:	53                   	push   %ebx
8010321a:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
8010321d:	68 a0 46 11 80       	push   $0x801146a0
80103222:	e8 59 21 00 00       	call   80105380 <acquire>
  log.outstanding -= 1;
80103227:	a1 dc 46 11 80       	mov    0x801146dc,%eax
  if(log.committing)
8010322c:	8b 35 e0 46 11 80    	mov    0x801146e0,%esi
80103232:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103235:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103238:	89 1d dc 46 11 80    	mov    %ebx,0x801146dc
  if(log.committing)
8010323e:	85 f6                	test   %esi,%esi
80103240:	0f 85 1e 01 00 00    	jne    80103364 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103246:	85 db                	test   %ebx,%ebx
80103248:	0f 85 f2 00 00 00    	jne    80103340 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010324e:	c7 05 e0 46 11 80 01 	movl   $0x1,0x801146e0
80103255:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103258:	83 ec 0c             	sub    $0xc,%esp
8010325b:	68 a0 46 11 80       	push   $0x801146a0
80103260:	e8 db 21 00 00       	call   80105440 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103265:	8b 0d e8 46 11 80    	mov    0x801146e8,%ecx
8010326b:	83 c4 10             	add    $0x10,%esp
8010326e:	85 c9                	test   %ecx,%ecx
80103270:	7f 3e                	jg     801032b0 <end_op+0xa0>
    acquire(&log.lock);
80103272:	83 ec 0c             	sub    $0xc,%esp
80103275:	68 a0 46 11 80       	push   $0x801146a0
8010327a:	e8 01 21 00 00       	call   80105380 <acquire>
    wakeup(&log);
8010327f:	c7 04 24 a0 46 11 80 	movl   $0x801146a0,(%esp)
    log.committing = 0;
80103286:	c7 05 e0 46 11 80 00 	movl   $0x0,0x801146e0
8010328d:	00 00 00 
    wakeup(&log);
80103290:	e8 fb 14 00 00       	call   80104790 <wakeup>
    release(&log.lock);
80103295:	c7 04 24 a0 46 11 80 	movl   $0x801146a0,(%esp)
8010329c:	e8 9f 21 00 00       	call   80105440 <release>
801032a1:	83 c4 10             	add    $0x10,%esp
}
801032a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032a7:	5b                   	pop    %ebx
801032a8:	5e                   	pop    %esi
801032a9:	5f                   	pop    %edi
801032aa:	5d                   	pop    %ebp
801032ab:	c3                   	ret    
801032ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801032b0:	a1 d4 46 11 80       	mov    0x801146d4,%eax
801032b5:	83 ec 08             	sub    $0x8,%esp
801032b8:	01 d8                	add    %ebx,%eax
801032ba:	83 c0 01             	add    $0x1,%eax
801032bd:	50                   	push   %eax
801032be:	ff 35 e4 46 11 80    	pushl  0x801146e4
801032c4:	e8 07 ce ff ff       	call   801000d0 <bread>
801032c9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801032cb:	58                   	pop    %eax
801032cc:	5a                   	pop    %edx
801032cd:	ff 34 9d ec 46 11 80 	pushl  -0x7feeb914(,%ebx,4)
801032d4:	ff 35 e4 46 11 80    	pushl  0x801146e4
  for (tail = 0; tail < log.lh.n; tail++) {
801032da:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801032dd:	e8 ee cd ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
801032e2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801032e5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801032e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801032ea:	68 00 02 00 00       	push   $0x200
801032ef:	50                   	push   %eax
801032f0:	8d 46 5c             	lea    0x5c(%esi),%eax
801032f3:	50                   	push   %eax
801032f4:	e8 37 22 00 00       	call   80105530 <memmove>
    bwrite(to);  // write the log
801032f9:	89 34 24             	mov    %esi,(%esp)
801032fc:	e8 af ce ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103301:	89 3c 24             	mov    %edi,(%esp)
80103304:	e8 e7 ce ff ff       	call   801001f0 <brelse>
    brelse(to);
80103309:	89 34 24             	mov    %esi,(%esp)
8010330c:	e8 df ce ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103311:	83 c4 10             	add    $0x10,%esp
80103314:	3b 1d e8 46 11 80    	cmp    0x801146e8,%ebx
8010331a:	7c 94                	jl     801032b0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010331c:	e8 7f fd ff ff       	call   801030a0 <write_head>
    install_trans(); // Now install writes to home locations
80103321:	e8 da fc ff ff       	call   80103000 <install_trans>
    log.lh.n = 0;
80103326:	c7 05 e8 46 11 80 00 	movl   $0x0,0x801146e8
8010332d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103330:	e8 6b fd ff ff       	call   801030a0 <write_head>
80103335:	e9 38 ff ff ff       	jmp    80103272 <end_op+0x62>
8010333a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103340:	83 ec 0c             	sub    $0xc,%esp
80103343:	68 a0 46 11 80       	push   $0x801146a0
80103348:	e8 43 14 00 00       	call   80104790 <wakeup>
  release(&log.lock);
8010334d:	c7 04 24 a0 46 11 80 	movl   $0x801146a0,(%esp)
80103354:	e8 e7 20 00 00       	call   80105440 <release>
80103359:	83 c4 10             	add    $0x10,%esp
}
8010335c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010335f:	5b                   	pop    %ebx
80103360:	5e                   	pop    %esi
80103361:	5f                   	pop    %edi
80103362:	5d                   	pop    %ebp
80103363:	c3                   	ret    
    panic("log.committing");
80103364:	83 ec 0c             	sub    $0xc,%esp
80103367:	68 24 89 10 80       	push   $0x80108924
8010336c:	e8 1f d0 ff ff       	call   80100390 <panic>
80103371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103378:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010337f:	90                   	nop

80103380 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103380:	f3 0f 1e fb          	endbr32 
80103384:	55                   	push   %ebp
80103385:	89 e5                	mov    %esp,%ebp
80103387:	53                   	push   %ebx
80103388:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010338b:	8b 15 e8 46 11 80    	mov    0x801146e8,%edx
{
80103391:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103394:	83 fa 1d             	cmp    $0x1d,%edx
80103397:	0f 8f 91 00 00 00    	jg     8010342e <log_write+0xae>
8010339d:	a1 d8 46 11 80       	mov    0x801146d8,%eax
801033a2:	83 e8 01             	sub    $0x1,%eax
801033a5:	39 c2                	cmp    %eax,%edx
801033a7:	0f 8d 81 00 00 00    	jge    8010342e <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
801033ad:	a1 dc 46 11 80       	mov    0x801146dc,%eax
801033b2:	85 c0                	test   %eax,%eax
801033b4:	0f 8e 81 00 00 00    	jle    8010343b <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
801033ba:	83 ec 0c             	sub    $0xc,%esp
801033bd:	68 a0 46 11 80       	push   $0x801146a0
801033c2:	e8 b9 1f 00 00       	call   80105380 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801033c7:	8b 15 e8 46 11 80    	mov    0x801146e8,%edx
801033cd:	83 c4 10             	add    $0x10,%esp
801033d0:	85 d2                	test   %edx,%edx
801033d2:	7e 4e                	jle    80103422 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801033d4:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
801033d7:	31 c0                	xor    %eax,%eax
801033d9:	eb 0c                	jmp    801033e7 <log_write+0x67>
801033db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801033df:	90                   	nop
801033e0:	83 c0 01             	add    $0x1,%eax
801033e3:	39 c2                	cmp    %eax,%edx
801033e5:	74 29                	je     80103410 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801033e7:	39 0c 85 ec 46 11 80 	cmp    %ecx,-0x7feeb914(,%eax,4)
801033ee:	75 f0                	jne    801033e0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
801033f0:	89 0c 85 ec 46 11 80 	mov    %ecx,-0x7feeb914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801033f7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801033fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801033fd:	c7 45 08 a0 46 11 80 	movl   $0x801146a0,0x8(%ebp)
}
80103404:	c9                   	leave  
  release(&log.lock);
80103405:	e9 36 20 00 00       	jmp    80105440 <release>
8010340a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103410:	89 0c 95 ec 46 11 80 	mov    %ecx,-0x7feeb914(,%edx,4)
    log.lh.n++;
80103417:	83 c2 01             	add    $0x1,%edx
8010341a:	89 15 e8 46 11 80    	mov    %edx,0x801146e8
80103420:	eb d5                	jmp    801033f7 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80103422:	8b 43 08             	mov    0x8(%ebx),%eax
80103425:	a3 ec 46 11 80       	mov    %eax,0x801146ec
  if (i == log.lh.n)
8010342a:	75 cb                	jne    801033f7 <log_write+0x77>
8010342c:	eb e9                	jmp    80103417 <log_write+0x97>
    panic("too big a transaction");
8010342e:	83 ec 0c             	sub    $0xc,%esp
80103431:	68 33 89 10 80       	push   $0x80108933
80103436:	e8 55 cf ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
8010343b:	83 ec 0c             	sub    $0xc,%esp
8010343e:	68 49 89 10 80       	push   $0x80108949
80103443:	e8 48 cf ff ff       	call   80100390 <panic>
80103448:	66 90                	xchg   %ax,%ax
8010344a:	66 90                	xchg   %ax,%ax
8010344c:	66 90                	xchg   %ax,%ax
8010344e:	66 90                	xchg   %ax,%ax

80103450 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103450:	55                   	push   %ebp
80103451:	89 e5                	mov    %esp,%ebp
80103453:	53                   	push   %ebx
80103454:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103457:	e8 64 0a 00 00       	call   80103ec0 <cpuid>
8010345c:	89 c3                	mov    %eax,%ebx
8010345e:	e8 5d 0a 00 00       	call   80103ec0 <cpuid>
80103463:	83 ec 04             	sub    $0x4,%esp
80103466:	53                   	push   %ebx
80103467:	50                   	push   %eax
80103468:	68 64 89 10 80       	push   $0x80108964
8010346d:	e8 3e d2 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103472:	e8 f9 32 00 00       	call   80106770 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103477:	e8 d4 09 00 00       	call   80103e50 <mycpu>
8010347c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010347e:	b8 01 00 00 00       	mov    $0x1,%eax
80103483:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010348a:	e8 81 0d 00 00       	call   80104210 <scheduler>
8010348f:	90                   	nop

80103490 <mpenter>:
{
80103490:	f3 0f 1e fb          	endbr32 
80103494:	55                   	push   %ebp
80103495:	89 e5                	mov    %esp,%ebp
80103497:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010349a:	e8 a1 43 00 00       	call   80107840 <switchkvm>
  seginit();
8010349f:	e8 0c 43 00 00       	call   801077b0 <seginit>
  lapicinit();
801034a4:	e8 67 f7 ff ff       	call   80102c10 <lapicinit>
  mpmain();
801034a9:	e8 a2 ff ff ff       	call   80103450 <mpmain>
801034ae:	66 90                	xchg   %ax,%ax

801034b0 <main>:
{
801034b0:	f3 0f 1e fb          	endbr32 
801034b4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801034b8:	83 e4 f0             	and    $0xfffffff0,%esp
801034bb:	ff 71 fc             	pushl  -0x4(%ecx)
801034be:	55                   	push   %ebp
801034bf:	89 e5                	mov    %esp,%ebp
801034c1:	53                   	push   %ebx
801034c2:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801034c3:	83 ec 08             	sub    $0x8,%esp
801034c6:	68 00 00 40 80       	push   $0x80400000
801034cb:	68 c8 f1 11 80       	push   $0x8011f1c8
801034d0:	e8 fb f4 ff ff       	call   801029d0 <kinit1>
  kvmalloc();      // kernel page table
801034d5:	e8 56 48 00 00       	call   80107d30 <kvmalloc>
  mpinit();        // detect other processors
801034da:	e8 81 01 00 00       	call   80103660 <mpinit>
  lapicinit();     // interrupt controller
801034df:	e8 2c f7 ff ff       	call   80102c10 <lapicinit>
  seginit();       // segment descriptors
801034e4:	e8 c7 42 00 00       	call   801077b0 <seginit>
  picinit();       // disable pic
801034e9:	e8 52 03 00 00       	call   80103840 <picinit>
  ioapicinit();    // another interrupt controller
801034ee:	e8 fd f2 ff ff       	call   801027f0 <ioapicinit>
  consoleinit();   // console hardware
801034f3:	e8 38 d5 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
801034f8:	e8 23 36 00 00       	call   80106b20 <uartinit>
  pinit();         // process table
801034fd:	e8 2e 09 00 00       	call   80103e30 <pinit>
  tvinit();        // trap vectors
80103502:	e8 e9 31 00 00       	call   801066f0 <tvinit>
  binit();         // buffer cache
80103507:	e8 34 cb ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010350c:	e8 cf d8 ff ff       	call   80100de0 <fileinit>
  ideinit();       // disk 
80103511:	e8 aa f0 ff ff       	call   801025c0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103516:	83 c4 0c             	add    $0xc,%esp
80103519:	68 8a 00 00 00       	push   $0x8a
8010351e:	68 8c c4 10 80       	push   $0x8010c48c
80103523:	68 00 70 00 80       	push   $0x80007000
80103528:	e8 03 20 00 00       	call   80105530 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010352d:	83 c4 10             	add    $0x10,%esp
80103530:	69 05 20 4d 11 80 b0 	imul   $0xb0,0x80114d20,%eax
80103537:	00 00 00 
8010353a:	05 a0 47 11 80       	add    $0x801147a0,%eax
8010353f:	3d a0 47 11 80       	cmp    $0x801147a0,%eax
80103544:	76 7a                	jbe    801035c0 <main+0x110>
80103546:	bb a0 47 11 80       	mov    $0x801147a0,%ebx
8010354b:	eb 1c                	jmp    80103569 <main+0xb9>
8010354d:	8d 76 00             	lea    0x0(%esi),%esi
80103550:	69 05 20 4d 11 80 b0 	imul   $0xb0,0x80114d20,%eax
80103557:	00 00 00 
8010355a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103560:	05 a0 47 11 80       	add    $0x801147a0,%eax
80103565:	39 c3                	cmp    %eax,%ebx
80103567:	73 57                	jae    801035c0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103569:	e8 e2 08 00 00       	call   80103e50 <mycpu>
8010356e:	39 c3                	cmp    %eax,%ebx
80103570:	74 de                	je     80103550 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103572:	e8 29 f5 ff ff       	call   80102aa0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103577:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010357a:	c7 05 f8 6f 00 80 90 	movl   $0x80103490,0x80006ff8
80103581:	34 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103584:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
8010358b:	b0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010358e:	05 00 10 00 00       	add    $0x1000,%eax
80103593:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103598:	0f b6 03             	movzbl (%ebx),%eax
8010359b:	68 00 70 00 00       	push   $0x7000
801035a0:	50                   	push   %eax
801035a1:	e8 ba f7 ff ff       	call   80102d60 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801035a6:	83 c4 10             	add    $0x10,%esp
801035a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035b0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801035b6:	85 c0                	test   %eax,%eax
801035b8:	74 f6                	je     801035b0 <main+0x100>
801035ba:	eb 94                	jmp    80103550 <main+0xa0>
801035bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801035c0:	83 ec 08             	sub    $0x8,%esp
801035c3:	68 00 00 00 8e       	push   $0x8e000000
801035c8:	68 00 00 40 80       	push   $0x80400000
801035cd:	e8 6e f4 ff ff       	call   80102a40 <kinit2>
  userinit();      // first user process
801035d2:	e8 39 09 00 00       	call   80103f10 <userinit>
  mpmain();        // finish this processor's setup
801035d7:	e8 74 fe ff ff       	call   80103450 <mpmain>
801035dc:	66 90                	xchg   %ax,%ax
801035de:	66 90                	xchg   %ax,%ax

801035e0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801035e0:	55                   	push   %ebp
801035e1:	89 e5                	mov    %esp,%ebp
801035e3:	57                   	push   %edi
801035e4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801035e5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801035eb:	53                   	push   %ebx
  e = addr+len;
801035ec:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801035ef:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801035f2:	39 de                	cmp    %ebx,%esi
801035f4:	72 10                	jb     80103606 <mpsearch1+0x26>
801035f6:	eb 50                	jmp    80103648 <mpsearch1+0x68>
801035f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035ff:	90                   	nop
80103600:	89 fe                	mov    %edi,%esi
80103602:	39 fb                	cmp    %edi,%ebx
80103604:	76 42                	jbe    80103648 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103606:	83 ec 04             	sub    $0x4,%esp
80103609:	8d 7e 10             	lea    0x10(%esi),%edi
8010360c:	6a 04                	push   $0x4
8010360e:	68 78 89 10 80       	push   $0x80108978
80103613:	56                   	push   %esi
80103614:	e8 c7 1e 00 00       	call   801054e0 <memcmp>
80103619:	83 c4 10             	add    $0x10,%esp
8010361c:	85 c0                	test   %eax,%eax
8010361e:	75 e0                	jne    80103600 <mpsearch1+0x20>
80103620:	89 f2                	mov    %esi,%edx
80103622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103628:	0f b6 0a             	movzbl (%edx),%ecx
8010362b:	83 c2 01             	add    $0x1,%edx
8010362e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103630:	39 fa                	cmp    %edi,%edx
80103632:	75 f4                	jne    80103628 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103634:	84 c0                	test   %al,%al
80103636:	75 c8                	jne    80103600 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103638:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010363b:	89 f0                	mov    %esi,%eax
8010363d:	5b                   	pop    %ebx
8010363e:	5e                   	pop    %esi
8010363f:	5f                   	pop    %edi
80103640:	5d                   	pop    %ebp
80103641:	c3                   	ret    
80103642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103648:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010364b:	31 f6                	xor    %esi,%esi
}
8010364d:	5b                   	pop    %ebx
8010364e:	89 f0                	mov    %esi,%eax
80103650:	5e                   	pop    %esi
80103651:	5f                   	pop    %edi
80103652:	5d                   	pop    %ebp
80103653:	c3                   	ret    
80103654:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010365b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010365f:	90                   	nop

80103660 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103660:	f3 0f 1e fb          	endbr32 
80103664:	55                   	push   %ebp
80103665:	89 e5                	mov    %esp,%ebp
80103667:	57                   	push   %edi
80103668:	56                   	push   %esi
80103669:	53                   	push   %ebx
8010366a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010366d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103674:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010367b:	c1 e0 08             	shl    $0x8,%eax
8010367e:	09 d0                	or     %edx,%eax
80103680:	c1 e0 04             	shl    $0x4,%eax
80103683:	75 1b                	jne    801036a0 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103685:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010368c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103693:	c1 e0 08             	shl    $0x8,%eax
80103696:	09 d0                	or     %edx,%eax
80103698:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010369b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801036a0:	ba 00 04 00 00       	mov    $0x400,%edx
801036a5:	e8 36 ff ff ff       	call   801035e0 <mpsearch1>
801036aa:	89 c6                	mov    %eax,%esi
801036ac:	85 c0                	test   %eax,%eax
801036ae:	0f 84 4c 01 00 00    	je     80103800 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801036b4:	8b 5e 04             	mov    0x4(%esi),%ebx
801036b7:	85 db                	test   %ebx,%ebx
801036b9:	0f 84 61 01 00 00    	je     80103820 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
801036bf:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801036c2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801036c8:	6a 04                	push   $0x4
801036ca:	68 7d 89 10 80       	push   $0x8010897d
801036cf:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801036d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801036d3:	e8 08 1e 00 00       	call   801054e0 <memcmp>
801036d8:	83 c4 10             	add    $0x10,%esp
801036db:	85 c0                	test   %eax,%eax
801036dd:	0f 85 3d 01 00 00    	jne    80103820 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
801036e3:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801036ea:	3c 01                	cmp    $0x1,%al
801036ec:	74 08                	je     801036f6 <mpinit+0x96>
801036ee:	3c 04                	cmp    $0x4,%al
801036f0:	0f 85 2a 01 00 00    	jne    80103820 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
801036f6:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
801036fd:	66 85 d2             	test   %dx,%dx
80103700:	74 26                	je     80103728 <mpinit+0xc8>
80103702:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
80103705:	89 d8                	mov    %ebx,%eax
  sum = 0;
80103707:	31 d2                	xor    %edx,%edx
80103709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103710:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103717:	83 c0 01             	add    $0x1,%eax
8010371a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
8010371c:	39 f8                	cmp    %edi,%eax
8010371e:	75 f0                	jne    80103710 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80103720:	84 d2                	test   %dl,%dl
80103722:	0f 85 f8 00 00 00    	jne    80103820 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103728:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010372e:	a3 9c 46 11 80       	mov    %eax,0x8011469c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103733:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103739:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80103740:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103745:	03 55 e4             	add    -0x1c(%ebp),%edx
80103748:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
8010374b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010374f:	90                   	nop
80103750:	39 c2                	cmp    %eax,%edx
80103752:	76 15                	jbe    80103769 <mpinit+0x109>
    switch(*p){
80103754:	0f b6 08             	movzbl (%eax),%ecx
80103757:	80 f9 02             	cmp    $0x2,%cl
8010375a:	74 5c                	je     801037b8 <mpinit+0x158>
8010375c:	77 42                	ja     801037a0 <mpinit+0x140>
8010375e:	84 c9                	test   %cl,%cl
80103760:	74 6e                	je     801037d0 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103762:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103765:	39 c2                	cmp    %eax,%edx
80103767:	77 eb                	ja     80103754 <mpinit+0xf4>
80103769:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010376c:	85 db                	test   %ebx,%ebx
8010376e:	0f 84 b9 00 00 00    	je     8010382d <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103774:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103778:	74 15                	je     8010378f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010377a:	b8 70 00 00 00       	mov    $0x70,%eax
8010377f:	ba 22 00 00 00       	mov    $0x22,%edx
80103784:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103785:	ba 23 00 00 00       	mov    $0x23,%edx
8010378a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010378b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010378e:	ee                   	out    %al,(%dx)
  }
}
8010378f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103792:	5b                   	pop    %ebx
80103793:	5e                   	pop    %esi
80103794:	5f                   	pop    %edi
80103795:	5d                   	pop    %ebp
80103796:	c3                   	ret    
80103797:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010379e:	66 90                	xchg   %ax,%ax
    switch(*p){
801037a0:	83 e9 03             	sub    $0x3,%ecx
801037a3:	80 f9 01             	cmp    $0x1,%cl
801037a6:	76 ba                	jbe    80103762 <mpinit+0x102>
801037a8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801037af:	eb 9f                	jmp    80103750 <mpinit+0xf0>
801037b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801037b8:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801037bc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801037bf:	88 0d 80 47 11 80    	mov    %cl,0x80114780
      continue;
801037c5:	eb 89                	jmp    80103750 <mpinit+0xf0>
801037c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037ce:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
801037d0:	8b 0d 20 4d 11 80    	mov    0x80114d20,%ecx
801037d6:	83 f9 07             	cmp    $0x7,%ecx
801037d9:	7f 19                	jg     801037f4 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801037db:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
801037e1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801037e5:	83 c1 01             	add    $0x1,%ecx
801037e8:	89 0d 20 4d 11 80    	mov    %ecx,0x80114d20
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801037ee:	88 9f a0 47 11 80    	mov    %bl,-0x7feeb860(%edi)
      p += sizeof(struct mpproc);
801037f4:	83 c0 14             	add    $0x14,%eax
      continue;
801037f7:	e9 54 ff ff ff       	jmp    80103750 <mpinit+0xf0>
801037fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
80103800:	ba 00 00 01 00       	mov    $0x10000,%edx
80103805:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010380a:	e8 d1 fd ff ff       	call   801035e0 <mpsearch1>
8010380f:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103811:	85 c0                	test   %eax,%eax
80103813:	0f 85 9b fe ff ff    	jne    801036b4 <mpinit+0x54>
80103819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103820:	83 ec 0c             	sub    $0xc,%esp
80103823:	68 82 89 10 80       	push   $0x80108982
80103828:	e8 63 cb ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010382d:	83 ec 0c             	sub    $0xc,%esp
80103830:	68 9c 89 10 80       	push   $0x8010899c
80103835:	e8 56 cb ff ff       	call   80100390 <panic>
8010383a:	66 90                	xchg   %ax,%ax
8010383c:	66 90                	xchg   %ax,%ax
8010383e:	66 90                	xchg   %ax,%ax

80103840 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103840:	f3 0f 1e fb          	endbr32 
80103844:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103849:	ba 21 00 00 00       	mov    $0x21,%edx
8010384e:	ee                   	out    %al,(%dx)
8010384f:	ba a1 00 00 00       	mov    $0xa1,%edx
80103854:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103855:	c3                   	ret    
80103856:	66 90                	xchg   %ax,%ax
80103858:	66 90                	xchg   %ax,%ax
8010385a:	66 90                	xchg   %ax,%ax
8010385c:	66 90                	xchg   %ax,%ax
8010385e:	66 90                	xchg   %ax,%ax

80103860 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103860:	f3 0f 1e fb          	endbr32 
80103864:	55                   	push   %ebp
80103865:	89 e5                	mov    %esp,%ebp
80103867:	57                   	push   %edi
80103868:	56                   	push   %esi
80103869:	53                   	push   %ebx
8010386a:	83 ec 0c             	sub    $0xc,%esp
8010386d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103870:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103873:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103879:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010387f:	e8 7c d5 ff ff       	call   80100e00 <filealloc>
80103884:	89 03                	mov    %eax,(%ebx)
80103886:	85 c0                	test   %eax,%eax
80103888:	0f 84 ac 00 00 00    	je     8010393a <pipealloc+0xda>
8010388e:	e8 6d d5 ff ff       	call   80100e00 <filealloc>
80103893:	89 06                	mov    %eax,(%esi)
80103895:	85 c0                	test   %eax,%eax
80103897:	0f 84 8b 00 00 00    	je     80103928 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010389d:	e8 fe f1 ff ff       	call   80102aa0 <kalloc>
801038a2:	89 c7                	mov    %eax,%edi
801038a4:	85 c0                	test   %eax,%eax
801038a6:	0f 84 b4 00 00 00    	je     80103960 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
801038ac:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801038b3:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801038b6:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801038b9:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801038c0:	00 00 00 
  p->nwrite = 0;
801038c3:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801038ca:	00 00 00 
  p->nread = 0;
801038cd:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801038d4:	00 00 00 
  initlock(&p->lock, "pipe");
801038d7:	68 bb 89 10 80       	push   $0x801089bb
801038dc:	50                   	push   %eax
801038dd:	e8 1e 19 00 00       	call   80105200 <initlock>
  (*f0)->type = FD_PIPE;
801038e2:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801038e4:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801038e7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801038ed:	8b 03                	mov    (%ebx),%eax
801038ef:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801038f3:	8b 03                	mov    (%ebx),%eax
801038f5:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801038f9:	8b 03                	mov    (%ebx),%eax
801038fb:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801038fe:	8b 06                	mov    (%esi),%eax
80103900:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103906:	8b 06                	mov    (%esi),%eax
80103908:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
8010390c:	8b 06                	mov    (%esi),%eax
8010390e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103912:	8b 06                	mov    (%esi),%eax
80103914:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103917:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010391a:	31 c0                	xor    %eax,%eax
}
8010391c:	5b                   	pop    %ebx
8010391d:	5e                   	pop    %esi
8010391e:	5f                   	pop    %edi
8010391f:	5d                   	pop    %ebp
80103920:	c3                   	ret    
80103921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103928:	8b 03                	mov    (%ebx),%eax
8010392a:	85 c0                	test   %eax,%eax
8010392c:	74 1e                	je     8010394c <pipealloc+0xec>
    fileclose(*f0);
8010392e:	83 ec 0c             	sub    $0xc,%esp
80103931:	50                   	push   %eax
80103932:	e8 89 d5 ff ff       	call   80100ec0 <fileclose>
80103937:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010393a:	8b 06                	mov    (%esi),%eax
8010393c:	85 c0                	test   %eax,%eax
8010393e:	74 0c                	je     8010394c <pipealloc+0xec>
    fileclose(*f1);
80103940:	83 ec 0c             	sub    $0xc,%esp
80103943:	50                   	push   %eax
80103944:	e8 77 d5 ff ff       	call   80100ec0 <fileclose>
80103949:	83 c4 10             	add    $0x10,%esp
}
8010394c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010394f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103954:	5b                   	pop    %ebx
80103955:	5e                   	pop    %esi
80103956:	5f                   	pop    %edi
80103957:	5d                   	pop    %ebp
80103958:	c3                   	ret    
80103959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103960:	8b 03                	mov    (%ebx),%eax
80103962:	85 c0                	test   %eax,%eax
80103964:	75 c8                	jne    8010392e <pipealloc+0xce>
80103966:	eb d2                	jmp    8010393a <pipealloc+0xda>
80103968:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010396f:	90                   	nop

80103970 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103970:	f3 0f 1e fb          	endbr32 
80103974:	55                   	push   %ebp
80103975:	89 e5                	mov    %esp,%ebp
80103977:	56                   	push   %esi
80103978:	53                   	push   %ebx
80103979:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010397c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010397f:	83 ec 0c             	sub    $0xc,%esp
80103982:	53                   	push   %ebx
80103983:	e8 f8 19 00 00       	call   80105380 <acquire>
  if(writable){
80103988:	83 c4 10             	add    $0x10,%esp
8010398b:	85 f6                	test   %esi,%esi
8010398d:	74 41                	je     801039d0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010398f:	83 ec 0c             	sub    $0xc,%esp
80103992:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103998:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010399f:	00 00 00 
    wakeup(&p->nread);
801039a2:	50                   	push   %eax
801039a3:	e8 e8 0d 00 00       	call   80104790 <wakeup>
801039a8:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801039ab:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801039b1:	85 d2                	test   %edx,%edx
801039b3:	75 0a                	jne    801039bf <pipeclose+0x4f>
801039b5:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801039bb:	85 c0                	test   %eax,%eax
801039bd:	74 31                	je     801039f0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801039bf:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801039c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801039c5:	5b                   	pop    %ebx
801039c6:	5e                   	pop    %esi
801039c7:	5d                   	pop    %ebp
    release(&p->lock);
801039c8:	e9 73 1a 00 00       	jmp    80105440 <release>
801039cd:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801039d0:	83 ec 0c             	sub    $0xc,%esp
801039d3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801039d9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801039e0:	00 00 00 
    wakeup(&p->nwrite);
801039e3:	50                   	push   %eax
801039e4:	e8 a7 0d 00 00       	call   80104790 <wakeup>
801039e9:	83 c4 10             	add    $0x10,%esp
801039ec:	eb bd                	jmp    801039ab <pipeclose+0x3b>
801039ee:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801039f0:	83 ec 0c             	sub    $0xc,%esp
801039f3:	53                   	push   %ebx
801039f4:	e8 47 1a 00 00       	call   80105440 <release>
    kfree((char*)p);
801039f9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801039fc:	83 c4 10             	add    $0x10,%esp
}
801039ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a02:	5b                   	pop    %ebx
80103a03:	5e                   	pop    %esi
80103a04:	5d                   	pop    %ebp
    kfree((char*)p);
80103a05:	e9 d6 ee ff ff       	jmp    801028e0 <kfree>
80103a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a10 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103a10:	f3 0f 1e fb          	endbr32 
80103a14:	55                   	push   %ebp
80103a15:	89 e5                	mov    %esp,%ebp
80103a17:	57                   	push   %edi
80103a18:	56                   	push   %esi
80103a19:	53                   	push   %ebx
80103a1a:	83 ec 28             	sub    $0x28,%esp
80103a1d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103a20:	53                   	push   %ebx
80103a21:	e8 5a 19 00 00       	call   80105380 <acquire>
  for(i = 0; i < n; i++){
80103a26:	8b 45 10             	mov    0x10(%ebp),%eax
80103a29:	83 c4 10             	add    $0x10,%esp
80103a2c:	85 c0                	test   %eax,%eax
80103a2e:	0f 8e bc 00 00 00    	jle    80103af0 <pipewrite+0xe0>
80103a34:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a37:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103a3d:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103a43:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103a46:	03 45 10             	add    0x10(%ebp),%eax
80103a49:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103a4c:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103a52:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103a58:	89 ca                	mov    %ecx,%edx
80103a5a:	05 00 02 00 00       	add    $0x200,%eax
80103a5f:	39 c1                	cmp    %eax,%ecx
80103a61:	74 3b                	je     80103a9e <pipewrite+0x8e>
80103a63:	eb 63                	jmp    80103ac8 <pipewrite+0xb8>
80103a65:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103a68:	e8 73 04 00 00       	call   80103ee0 <myproc>
80103a6d:	8b 48 24             	mov    0x24(%eax),%ecx
80103a70:	85 c9                	test   %ecx,%ecx
80103a72:	75 34                	jne    80103aa8 <pipewrite+0x98>
      wakeup(&p->nread);
80103a74:	83 ec 0c             	sub    $0xc,%esp
80103a77:	57                   	push   %edi
80103a78:	e8 13 0d 00 00       	call   80104790 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103a7d:	58                   	pop    %eax
80103a7e:	5a                   	pop    %edx
80103a7f:	53                   	push   %ebx
80103a80:	56                   	push   %esi
80103a81:	e8 4a 0b 00 00       	call   801045d0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103a86:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103a8c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103a92:	83 c4 10             	add    $0x10,%esp
80103a95:	05 00 02 00 00       	add    $0x200,%eax
80103a9a:	39 c2                	cmp    %eax,%edx
80103a9c:	75 2a                	jne    80103ac8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
80103a9e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103aa4:	85 c0                	test   %eax,%eax
80103aa6:	75 c0                	jne    80103a68 <pipewrite+0x58>
        release(&p->lock);
80103aa8:	83 ec 0c             	sub    $0xc,%esp
80103aab:	53                   	push   %ebx
80103aac:	e8 8f 19 00 00       	call   80105440 <release>
        return -1;
80103ab1:	83 c4 10             	add    $0x10,%esp
80103ab4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103ab9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103abc:	5b                   	pop    %ebx
80103abd:	5e                   	pop    %esi
80103abe:	5f                   	pop    %edi
80103abf:	5d                   	pop    %ebp
80103ac0:	c3                   	ret    
80103ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103ac8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103acb:	8d 4a 01             	lea    0x1(%edx),%ecx
80103ace:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103ad4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
80103ada:	0f b6 06             	movzbl (%esi),%eax
80103add:	83 c6 01             	add    $0x1,%esi
80103ae0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103ae3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103ae7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103aea:	0f 85 5c ff ff ff    	jne    80103a4c <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103af0:	83 ec 0c             	sub    $0xc,%esp
80103af3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103af9:	50                   	push   %eax
80103afa:	e8 91 0c 00 00       	call   80104790 <wakeup>
  release(&p->lock);
80103aff:	89 1c 24             	mov    %ebx,(%esp)
80103b02:	e8 39 19 00 00       	call   80105440 <release>
  return n;
80103b07:	8b 45 10             	mov    0x10(%ebp),%eax
80103b0a:	83 c4 10             	add    $0x10,%esp
80103b0d:	eb aa                	jmp    80103ab9 <pipewrite+0xa9>
80103b0f:	90                   	nop

80103b10 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103b10:	f3 0f 1e fb          	endbr32 
80103b14:	55                   	push   %ebp
80103b15:	89 e5                	mov    %esp,%ebp
80103b17:	57                   	push   %edi
80103b18:	56                   	push   %esi
80103b19:	53                   	push   %ebx
80103b1a:	83 ec 18             	sub    $0x18,%esp
80103b1d:	8b 75 08             	mov    0x8(%ebp),%esi
80103b20:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103b23:	56                   	push   %esi
80103b24:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103b2a:	e8 51 18 00 00       	call   80105380 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103b2f:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103b35:	83 c4 10             	add    $0x10,%esp
80103b38:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103b3e:	74 33                	je     80103b73 <piperead+0x63>
80103b40:	eb 3b                	jmp    80103b7d <piperead+0x6d>
80103b42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103b48:	e8 93 03 00 00       	call   80103ee0 <myproc>
80103b4d:	8b 48 24             	mov    0x24(%eax),%ecx
80103b50:	85 c9                	test   %ecx,%ecx
80103b52:	0f 85 88 00 00 00    	jne    80103be0 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103b58:	83 ec 08             	sub    $0x8,%esp
80103b5b:	56                   	push   %esi
80103b5c:	53                   	push   %ebx
80103b5d:	e8 6e 0a 00 00       	call   801045d0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103b62:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103b68:	83 c4 10             	add    $0x10,%esp
80103b6b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103b71:	75 0a                	jne    80103b7d <piperead+0x6d>
80103b73:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103b79:	85 c0                	test   %eax,%eax
80103b7b:	75 cb                	jne    80103b48 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103b7d:	8b 55 10             	mov    0x10(%ebp),%edx
80103b80:	31 db                	xor    %ebx,%ebx
80103b82:	85 d2                	test   %edx,%edx
80103b84:	7f 28                	jg     80103bae <piperead+0x9e>
80103b86:	eb 34                	jmp    80103bbc <piperead+0xac>
80103b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b8f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103b90:	8d 48 01             	lea    0x1(%eax),%ecx
80103b93:	25 ff 01 00 00       	and    $0x1ff,%eax
80103b98:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103b9e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103ba3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103ba6:	83 c3 01             	add    $0x1,%ebx
80103ba9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103bac:	74 0e                	je     80103bbc <piperead+0xac>
    if(p->nread == p->nwrite)
80103bae:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103bb4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103bba:	75 d4                	jne    80103b90 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103bbc:	83 ec 0c             	sub    $0xc,%esp
80103bbf:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103bc5:	50                   	push   %eax
80103bc6:	e8 c5 0b 00 00       	call   80104790 <wakeup>
  release(&p->lock);
80103bcb:	89 34 24             	mov    %esi,(%esp)
80103bce:	e8 6d 18 00 00       	call   80105440 <release>
  return i;
80103bd3:	83 c4 10             	add    $0x10,%esp
}
80103bd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103bd9:	89 d8                	mov    %ebx,%eax
80103bdb:	5b                   	pop    %ebx
80103bdc:	5e                   	pop    %esi
80103bdd:	5f                   	pop    %edi
80103bde:	5d                   	pop    %ebp
80103bdf:	c3                   	ret    
      release(&p->lock);
80103be0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103be3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103be8:	56                   	push   %esi
80103be9:	e8 52 18 00 00       	call   80105440 <release>
      return -1;
80103bee:	83 c4 10             	add    $0x10,%esp
}
80103bf1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103bf4:	89 d8                	mov    %ebx,%eax
80103bf6:	5b                   	pop    %ebx
80103bf7:	5e                   	pop    %esi
80103bf8:	5f                   	pop    %edi
80103bf9:	5d                   	pop    %ebp
80103bfa:	c3                   	ret    
80103bfb:	66 90                	xchg   %ax,%ax
80103bfd:	66 90                	xchg   %ax,%ax
80103bff:	90                   	nop

80103c00 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103c00:	55                   	push   %ebp
80103c01:	89 e5                	mov    %esp,%ebp
80103c03:	53                   	push   %ebx
80103c04:	83 ec 04             	sub    $0x4,%esp

  if(algo == AGING)
80103c07:	83 3d 04 c0 10 80 02 	cmpl   $0x2,0x8010c004
80103c0e:	0f 84 6c 01 00 00    	je     80103d80 <allocproc+0x180>
  {
    cprintf("Using LRU (Aging)\n");
  }
  else 
  {
    cprintf("Using FIFO\n");
80103c14:	83 ec 0c             	sub    $0xc,%esp
80103c17:	68 d3 89 10 80       	push   $0x801089d3
80103c1c:	e8 8f ca ff ff       	call   801006b0 <cprintf>
80103c21:	83 c4 10             	add    $0x10,%esp
  }

  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80103c24:	83 ec 0c             	sub    $0xc,%esp

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c27:	bb 74 4d 11 80       	mov    $0x80114d74,%ebx
  acquire(&ptable.lock);
80103c2c:	68 40 4d 11 80       	push   $0x80114d40
80103c31:	e8 4a 17 00 00       	call   80105380 <acquire>
80103c36:	83 c4 10             	add    $0x10,%esp
80103c39:	eb 17                	jmp    80103c52 <allocproc+0x52>
80103c3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c3f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c40:	81 c3 70 02 00 00    	add    $0x270,%ebx
80103c46:	81 fb 74 e9 11 80    	cmp    $0x8011e974,%ebx
80103c4c:	0f 84 46 01 00 00    	je     80103d98 <allocproc+0x198>
    if(p->state == UNUSED)
80103c52:	8b 43 0c             	mov    0xc(%ebx),%eax
80103c55:	85 c0                	test   %eax,%eax
80103c57:	75 e7                	jne    80103c40 <allocproc+0x40>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103c59:	a1 08 c0 10 80       	mov    0x8010c008,%eax

  release(&ptable.lock);
80103c5e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103c61:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103c68:	89 43 10             	mov    %eax,0x10(%ebx)
80103c6b:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103c6e:	68 40 4d 11 80       	push   $0x80114d40
  p->pid = nextpid++;
80103c73:	89 15 08 c0 10 80    	mov    %edx,0x8010c008
  release(&ptable.lock);
80103c79:	e8 c2 17 00 00       	call   80105440 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103c7e:	e8 1d ee ff ff       	call   80102aa0 <kalloc>
80103c83:	83 c4 10             	add    $0x10,%esp
80103c86:	89 43 08             	mov    %eax,0x8(%ebx)
80103c89:	85 c0                	test   %eax,%eax
80103c8b:	0f 84 20 01 00 00    	je     80103db1 <allocproc+0x1b1>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103c91:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103c97:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103c9a:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103c9f:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103ca2:	c7 40 14 db 66 10 80 	movl   $0x801066db,0x14(%eax)
  p->context = (struct context*)sp;
80103ca9:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103cac:	6a 14                	push   $0x14
80103cae:	6a 00                	push   $0x0
80103cb0:	50                   	push   %eax
80103cb1:	e8 da 17 00 00       	call   80105490 <memset>
  p->context->eip = (uint)forkret;
80103cb6:	8b 43 1c             	mov    0x1c(%ebx),%eax

  p->pagefaults = 0;
  
  // initialize swap file and page metadata
  if(p->pid > 2)
80103cb9:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103cbc:	c7 40 10 d0 3d 10 80 	movl   $0x80103dd0,0x10(%eax)
  if(p->pid > 2)
80103cc3:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
  p->pagefaults = 0;
80103cc7:	c7 83 6c 02 00 00 00 	movl   $0x0,0x26c(%ebx)
80103cce:	00 00 00 
  if(p->pid > 2)
80103cd1:	7f 0d                	jg     80103ce0 <allocproc+0xe0>
    createSwapFile(p);
    clearPages(p);
  }

  return p;
}
80103cd3:	89 d8                	mov    %ebx,%eax
80103cd5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103cd8:	c9                   	leave  
80103cd9:	c3                   	ret    
80103cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    createSwapFile(p);
80103ce0:	83 ec 0c             	sub    $0xc,%esp
80103ce3:	53                   	push   %ebx
80103ce4:	e8 07 e6 ff ff       	call   801022f0 <createSwapFile>

void clearPages(struct proc *p)
{

    // clear swap pages
    for(int i=0;i<MAX_SWAP_PAGES();i++)
80103ce9:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
80103cef:	8d 93 70 01 00 00    	lea    0x170(%ebx),%edx
80103cf5:	83 c4 10             	add    $0x10,%esp
80103cf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cff:	90                   	nop
    {
      p->swappedPages[i] = (struct pagemeta) {0, 0, 0, 0};
80103d00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103d06:	83 c0 10             	add    $0x10,%eax
80103d09:	c7 40 f4 00 00 00 00 	movl   $0x0,-0xc(%eax)
80103d10:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
80103d17:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
    for(int i=0;i<MAX_SWAP_PAGES();i++)
80103d1e:	39 d0                	cmp    %edx,%eax
80103d20:	75 de                	jne    80103d00 <allocproc+0x100>
    }

    // clear queue
    p->qsize = p->qhead = p->qtail = 0;
80103d22:	c7 83 64 02 00 00 00 	movl   $0x0,0x264(%ebx)
80103d29:	00 00 00 
80103d2c:	8d 93 60 02 00 00    	lea    0x260(%ebx),%edx
80103d32:	c7 83 60 02 00 00 00 	movl   $0x0,0x260(%ebx)
80103d39:	00 00 00 
80103d3c:	c7 83 68 02 00 00 00 	movl   $0x0,0x268(%ebx)
80103d43:	00 00 00 
    

    for(int i=0;i<MAX_PSYC_PAGES;i++)
80103d46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d4d:	8d 76 00             	lea    0x0(%esi),%esi
    {
      p->physicalPages[i] = (struct pagemeta) {0, 0, 0, 0};
80103d50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103d56:	83 c0 10             	add    $0x10,%eax
80103d59:	c7 40 f4 00 00 00 00 	movl   $0x0,-0xc(%eax)
80103d60:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
80103d67:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
    for(int i=0;i<MAX_PSYC_PAGES;i++)
80103d6e:	39 c2                	cmp    %eax,%edx
80103d70:	75 de                	jne    80103d50 <allocproc+0x150>
}
80103d72:	89 d8                	mov    %ebx,%eax
80103d74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d77:	c9                   	leave  
80103d78:	c3                   	ret    
80103d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("Using LRU (Aging)\n");
80103d80:	83 ec 0c             	sub    $0xc,%esp
80103d83:	68 c0 89 10 80       	push   $0x801089c0
80103d88:	e8 23 c9 ff ff       	call   801006b0 <cprintf>
80103d8d:	83 c4 10             	add    $0x10,%esp
80103d90:	e9 8f fe ff ff       	jmp    80103c24 <allocproc+0x24>
80103d95:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103d98:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103d9b:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103d9d:	68 40 4d 11 80       	push   $0x80114d40
80103da2:	e8 99 16 00 00       	call   80105440 <release>
}
80103da7:	89 d8                	mov    %ebx,%eax
  return 0;
80103da9:	83 c4 10             	add    $0x10,%esp
}
80103dac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103daf:	c9                   	leave  
80103db0:	c3                   	ret    
    p->state = UNUSED;
80103db1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103db8:	31 db                	xor    %ebx,%ebx
}
80103dba:	89 d8                	mov    %ebx,%eax
80103dbc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103dbf:	c9                   	leave  
80103dc0:	c3                   	ret    
80103dc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dcf:	90                   	nop

80103dd0 <forkret>:
{
80103dd0:	f3 0f 1e fb          	endbr32 
80103dd4:	55                   	push   %ebp
80103dd5:	89 e5                	mov    %esp,%ebp
80103dd7:	83 ec 14             	sub    $0x14,%esp
  release(&ptable.lock);
80103dda:	68 40 4d 11 80       	push   $0x80114d40
80103ddf:	e8 5c 16 00 00       	call   80105440 <release>
  if (first) {
80103de4:	a1 00 c0 10 80       	mov    0x8010c000,%eax
80103de9:	83 c4 10             	add    $0x10,%esp
80103dec:	85 c0                	test   %eax,%eax
80103dee:	75 08                	jne    80103df8 <forkret+0x28>
}
80103df0:	c9                   	leave  
80103df1:	c3                   	ret    
80103df2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80103df8:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
80103dff:	00 00 00 
    iinit(ROOTDEV);
80103e02:	83 ec 0c             	sub    $0xc,%esp
80103e05:	6a 01                	push   $0x1
80103e07:	e8 34 d7 ff ff       	call   80101540 <iinit>
    initlog(ROOTDEV);
80103e0c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103e13:	e8 e8 f2 ff ff       	call   80103100 <initlog>
}
80103e18:	83 c4 10             	add    $0x10,%esp
80103e1b:	c9                   	leave  
80103e1c:	c3                   	ret    
80103e1d:	8d 76 00             	lea    0x0(%esi),%esi

80103e20 <enableaging>:
{
80103e20:	f3 0f 1e fb          	endbr32 
  algo = AGING;
80103e24:	c7 05 04 c0 10 80 02 	movl   $0x2,0x8010c004
80103e2b:	00 00 00 
}
80103e2e:	c3                   	ret    
80103e2f:	90                   	nop

80103e30 <pinit>:
{
80103e30:	f3 0f 1e fb          	endbr32 
80103e34:	55                   	push   %ebp
80103e35:	89 e5                	mov    %esp,%ebp
80103e37:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103e3a:	68 df 89 10 80       	push   $0x801089df
80103e3f:	68 40 4d 11 80       	push   $0x80114d40
80103e44:	e8 b7 13 00 00       	call   80105200 <initlock>
}
80103e49:	83 c4 10             	add    $0x10,%esp
80103e4c:	c9                   	leave  
80103e4d:	c3                   	ret    
80103e4e:	66 90                	xchg   %ax,%ax

80103e50 <mycpu>:
{
80103e50:	f3 0f 1e fb          	endbr32 
80103e54:	55                   	push   %ebp
80103e55:	89 e5                	mov    %esp,%ebp
80103e57:	56                   	push   %esi
80103e58:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e59:	9c                   	pushf  
80103e5a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103e5b:	f6 c4 02             	test   $0x2,%ah
80103e5e:	75 4a                	jne    80103eaa <mycpu+0x5a>
  apicid = lapicid();
80103e60:	e8 ab ee ff ff       	call   80102d10 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103e65:	8b 35 20 4d 11 80    	mov    0x80114d20,%esi
  apicid = lapicid();
80103e6b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
80103e6d:	85 f6                	test   %esi,%esi
80103e6f:	7e 2c                	jle    80103e9d <mycpu+0x4d>
80103e71:	31 d2                	xor    %edx,%edx
80103e73:	eb 0a                	jmp    80103e7f <mycpu+0x2f>
80103e75:	8d 76 00             	lea    0x0(%esi),%esi
80103e78:	83 c2 01             	add    $0x1,%edx
80103e7b:	39 f2                	cmp    %esi,%edx
80103e7d:	74 1e                	je     80103e9d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
80103e7f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103e85:	0f b6 81 a0 47 11 80 	movzbl -0x7feeb860(%ecx),%eax
80103e8c:	39 d8                	cmp    %ebx,%eax
80103e8e:	75 e8                	jne    80103e78 <mycpu+0x28>
}
80103e90:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103e93:	8d 81 a0 47 11 80    	lea    -0x7feeb860(%ecx),%eax
}
80103e99:	5b                   	pop    %ebx
80103e9a:	5e                   	pop    %esi
80103e9b:	5d                   	pop    %ebp
80103e9c:	c3                   	ret    
  panic("unknown apicid\n");
80103e9d:	83 ec 0c             	sub    $0xc,%esp
80103ea0:	68 e6 89 10 80       	push   $0x801089e6
80103ea5:	e8 e6 c4 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103eaa:	83 ec 0c             	sub    $0xc,%esp
80103ead:	68 c4 8b 10 80       	push   $0x80108bc4
80103eb2:	e8 d9 c4 ff ff       	call   80100390 <panic>
80103eb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ebe:	66 90                	xchg   %ax,%ax

80103ec0 <cpuid>:
cpuid() {
80103ec0:	f3 0f 1e fb          	endbr32 
80103ec4:	55                   	push   %ebp
80103ec5:	89 e5                	mov    %esp,%ebp
80103ec7:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103eca:	e8 81 ff ff ff       	call   80103e50 <mycpu>
}
80103ecf:	c9                   	leave  
  return mycpu()-cpus;
80103ed0:	2d a0 47 11 80       	sub    $0x801147a0,%eax
80103ed5:	c1 f8 04             	sar    $0x4,%eax
80103ed8:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103ede:	c3                   	ret    
80103edf:	90                   	nop

80103ee0 <myproc>:
myproc(void) {
80103ee0:	f3 0f 1e fb          	endbr32 
80103ee4:	55                   	push   %ebp
80103ee5:	89 e5                	mov    %esp,%ebp
80103ee7:	53                   	push   %ebx
80103ee8:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103eeb:	e8 90 13 00 00       	call   80105280 <pushcli>
  c = mycpu();
80103ef0:	e8 5b ff ff ff       	call   80103e50 <mycpu>
  p = c->proc;
80103ef5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103efb:	e8 d0 13 00 00       	call   801052d0 <popcli>
}
80103f00:	83 c4 04             	add    $0x4,%esp
80103f03:	89 d8                	mov    %ebx,%eax
80103f05:	5b                   	pop    %ebx
80103f06:	5d                   	pop    %ebp
80103f07:	c3                   	ret    
80103f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f0f:	90                   	nop

80103f10 <userinit>:
{
80103f10:	f3 0f 1e fb          	endbr32 
80103f14:	55                   	push   %ebp
80103f15:	89 e5                	mov    %esp,%ebp
80103f17:	53                   	push   %ebx
80103f18:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103f1b:	e8 e0 fc ff ff       	call   80103c00 <allocproc>
80103f20:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103f22:	a3 b8 c5 10 80       	mov    %eax,0x8010c5b8
  if((p->pgdir = setupkvm()) == 0)
80103f27:	e8 84 3d 00 00       	call   80107cb0 <setupkvm>
80103f2c:	89 43 04             	mov    %eax,0x4(%ebx)
80103f2f:	85 c0                	test   %eax,%eax
80103f31:	0f 84 bd 00 00 00    	je     80103ff4 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103f37:	83 ec 04             	sub    $0x4,%esp
80103f3a:	68 2c 00 00 00       	push   $0x2c
80103f3f:	68 60 c4 10 80       	push   $0x8010c460
80103f44:	50                   	push   %eax
80103f45:	e8 26 3a 00 00       	call   80107970 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103f4a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103f4d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103f53:	6a 4c                	push   $0x4c
80103f55:	6a 00                	push   $0x0
80103f57:	ff 73 18             	pushl  0x18(%ebx)
80103f5a:	e8 31 15 00 00       	call   80105490 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103f5f:	8b 43 18             	mov    0x18(%ebx),%eax
80103f62:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103f67:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103f6a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103f6f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103f73:	8b 43 18             	mov    0x18(%ebx),%eax
80103f76:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103f7a:	8b 43 18             	mov    0x18(%ebx),%eax
80103f7d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103f81:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103f85:	8b 43 18             	mov    0x18(%ebx),%eax
80103f88:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103f8c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103f90:	8b 43 18             	mov    0x18(%ebx),%eax
80103f93:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103f9a:	8b 43 18             	mov    0x18(%ebx),%eax
80103f9d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103fa4:	8b 43 18             	mov    0x18(%ebx),%eax
80103fa7:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103fae:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103fb1:	6a 10                	push   $0x10
80103fb3:	68 0f 8a 10 80       	push   $0x80108a0f
80103fb8:	50                   	push   %eax
80103fb9:	e8 92 16 00 00       	call   80105650 <safestrcpy>
  p->cwd = namei("/");
80103fbe:	c7 04 24 18 8a 10 80 	movl   $0x80108a18,(%esp)
80103fc5:	e8 66 e0 ff ff       	call   80102030 <namei>
80103fca:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103fcd:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
80103fd4:	e8 a7 13 00 00       	call   80105380 <acquire>
  p->state = RUNNABLE;
80103fd9:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103fe0:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
80103fe7:	e8 54 14 00 00       	call   80105440 <release>
}
80103fec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fef:	83 c4 10             	add    $0x10,%esp
80103ff2:	c9                   	leave  
80103ff3:	c3                   	ret    
    panic("userinit: out of memory?");
80103ff4:	83 ec 0c             	sub    $0xc,%esp
80103ff7:	68 f6 89 10 80       	push   $0x801089f6
80103ffc:	e8 8f c3 ff ff       	call   80100390 <panic>
80104001:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104008:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010400f:	90                   	nop

80104010 <growproc>:
{
80104010:	f3 0f 1e fb          	endbr32 
80104014:	55                   	push   %ebp
80104015:	89 e5                	mov    %esp,%ebp
80104017:	56                   	push   %esi
80104018:	53                   	push   %ebx
80104019:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
8010401c:	e8 5f 12 00 00       	call   80105280 <pushcli>
  c = mycpu();
80104021:	e8 2a fe ff ff       	call   80103e50 <mycpu>
  p = c->proc;
80104026:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010402c:	e8 9f 12 00 00       	call   801052d0 <popcli>
  sz = curproc->sz;
80104031:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80104033:	85 f6                	test   %esi,%esi
80104035:	7f 19                	jg     80104050 <growproc+0x40>
  } else if(n < 0){
80104037:	75 37                	jne    80104070 <growproc+0x60>
  switchuvm(curproc);
80104039:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
8010403c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010403e:	53                   	push   %ebx
8010403f:	e8 1c 38 00 00       	call   80107860 <switchuvm>
  return 0;
80104044:	83 c4 10             	add    $0x10,%esp
80104047:	31 c0                	xor    %eax,%eax
}
80104049:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010404c:	5b                   	pop    %ebx
8010404d:	5e                   	pop    %esi
8010404e:	5d                   	pop    %ebp
8010404f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104050:	83 ec 04             	sub    $0x4,%esp
80104053:	01 c6                	add    %eax,%esi
80104055:	56                   	push   %esi
80104056:	50                   	push   %eax
80104057:	ff 73 04             	pushl  0x4(%ebx)
8010405a:	e8 a1 40 00 00       	call   80108100 <allocuvm>
8010405f:	83 c4 10             	add    $0x10,%esp
80104062:	85 c0                	test   %eax,%eax
80104064:	75 d3                	jne    80104039 <growproc+0x29>
      return -1;
80104066:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010406b:	eb dc                	jmp    80104049 <growproc+0x39>
8010406d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104070:	83 ec 04             	sub    $0x4,%esp
80104073:	01 c6                	add    %eax,%esi
80104075:	56                   	push   %esi
80104076:	50                   	push   %eax
80104077:	ff 73 04             	pushl  0x4(%ebx)
8010407a:	e8 41 3a 00 00       	call   80107ac0 <deallocuvm>
8010407f:	83 c4 10             	add    $0x10,%esp
80104082:	85 c0                	test   %eax,%eax
80104084:	75 b3                	jne    80104039 <growproc+0x29>
80104086:	eb de                	jmp    80104066 <growproc+0x56>
80104088:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010408f:	90                   	nop

80104090 <fork>:
{
80104090:	f3 0f 1e fb          	endbr32 
80104094:	55                   	push   %ebp
80104095:	89 e5                	mov    %esp,%ebp
80104097:	57                   	push   %edi
80104098:	56                   	push   %esi
80104099:	53                   	push   %ebx
8010409a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
8010409d:	e8 de 11 00 00       	call   80105280 <pushcli>
  c = mycpu();
801040a2:	e8 a9 fd ff ff       	call   80103e50 <mycpu>
  p = c->proc;
801040a7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040ad:	e8 1e 12 00 00       	call   801052d0 <popcli>
  if((np = allocproc()) == 0){
801040b2:	e8 49 fb ff ff       	call   80103c00 <allocproc>
801040b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801040ba:	85 c0                	test   %eax,%eax
801040bc:	0f 84 17 01 00 00    	je     801041d9 <fork+0x149>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801040c2:	83 ec 08             	sub    $0x8,%esp
801040c5:	ff 33                	pushl  (%ebx)
801040c7:	89 c7                	mov    %eax,%edi
801040c9:	ff 73 04             	pushl  0x4(%ebx)
801040cc:	e8 af 3c 00 00       	call   80107d80 <copyuvm>
801040d1:	83 c4 10             	add    $0x10,%esp
801040d4:	89 47 04             	mov    %eax,0x4(%edi)
801040d7:	85 c0                	test   %eax,%eax
801040d9:	0f 84 01 01 00 00    	je     801041e0 <fork+0x150>
  np->sz = curproc->sz;
801040df:	8b 03                	mov    (%ebx),%eax
801040e1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801040e4:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
801040e6:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
801040e9:	89 c8                	mov    %ecx,%eax
801040eb:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801040ee:	b9 13 00 00 00       	mov    $0x13,%ecx
801040f3:	8b 73 18             	mov    0x18(%ebx),%esi
801040f6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->pagefaults = 0;
801040f8:	c7 80 6c 02 00 00 00 	movl   $0x0,0x26c(%eax)
801040ff:	00 00 00 
  if(curproc->pid > 2)
80104102:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80104106:	0f 8f 8c 00 00 00    	jg     80104198 <fork+0x108>
  np->tf->eax = 0;
8010410c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(i = 0; i < NOFILE; i++)
8010410f:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80104111:	8b 40 18             	mov    0x18(%eax),%eax
80104114:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
8010411b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010411f:	90                   	nop
    if(curproc->ofile[i])
80104120:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104124:	85 c0                	test   %eax,%eax
80104126:	74 13                	je     8010413b <fork+0xab>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104128:	83 ec 0c             	sub    $0xc,%esp
8010412b:	50                   	push   %eax
8010412c:	e8 3f cd ff ff       	call   80100e70 <filedup>
80104131:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104134:	83 c4 10             	add    $0x10,%esp
80104137:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
8010413b:	83 c6 01             	add    $0x1,%esi
8010413e:	83 fe 10             	cmp    $0x10,%esi
80104141:	75 dd                	jne    80104120 <fork+0x90>
  np->cwd = idup(curproc->cwd);
80104143:	83 ec 0c             	sub    $0xc,%esp
80104146:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104149:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
8010414c:	e8 df d5 ff ff       	call   80101730 <idup>
80104151:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104154:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80104157:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010415a:	8d 47 6c             	lea    0x6c(%edi),%eax
8010415d:	6a 10                	push   $0x10
8010415f:	53                   	push   %ebx
80104160:	50                   	push   %eax
80104161:	e8 ea 14 00 00       	call   80105650 <safestrcpy>
  pid = np->pid;
80104166:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104169:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
80104170:	e8 0b 12 00 00       	call   80105380 <acquire>
  np->state = RUNNABLE;
80104175:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
8010417c:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
80104183:	e8 b8 12 00 00       	call   80105440 <release>
  return pid;
80104188:	83 c4 10             	add    $0x10,%esp
}
8010418b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010418e:	89 d8                	mov    %ebx,%eax
80104190:	5b                   	pop    %ebx
80104191:	5e                   	pop    %esi
80104192:	5f                   	pop    %edi
80104193:	5d                   	pop    %ebp
80104194:	c3                   	ret    
80104195:	8d 76 00             	lea    0x0(%esi),%esi
    copySwapFile(curproc, np);
80104198:	83 ec 08             	sub    $0x8,%esp
8010419b:	89 c7                	mov    %eax,%edi
8010419d:	50                   	push   %eax
8010419e:	53                   	push   %ebx
8010419f:	e8 4c e2 ff ff       	call   801023f0 <copySwapFile>
    copyPagesFromParent(curproc, np);
801041a4:	58                   	pop    %eax
801041a5:	5a                   	pop    %edx
801041a6:	57                   	push   %edi
801041a7:	53                   	push   %ebx
801041a8:	e8 d3 3d 00 00       	call   80107f80 <copyPagesFromParent>
    np->qhead = curproc->qhead;
801041ad:	8b 83 60 02 00 00    	mov    0x260(%ebx),%eax
    np->qsize = curproc->qsize;
801041b3:	83 c4 10             	add    $0x10,%esp
    np->qhead = curproc->qhead;
801041b6:	89 87 60 02 00 00    	mov    %eax,0x260(%edi)
    np->qtail = curproc->qtail;
801041bc:	8b 83 64 02 00 00    	mov    0x264(%ebx),%eax
801041c2:	89 87 64 02 00 00    	mov    %eax,0x264(%edi)
    np->qsize = curproc->qsize;
801041c8:	8b 83 68 02 00 00    	mov    0x268(%ebx),%eax
801041ce:	89 87 68 02 00 00    	mov    %eax,0x268(%edi)
801041d4:	e9 33 ff ff ff       	jmp    8010410c <fork+0x7c>
    return -1;
801041d9:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801041de:	eb ab                	jmp    8010418b <fork+0xfb>
    kfree(np->kstack);
801041e0:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801041e3:	83 ec 0c             	sub    $0xc,%esp
801041e6:	ff 73 08             	pushl  0x8(%ebx)
801041e9:	e8 f2 e6 ff ff       	call   801028e0 <kfree>
    np->kstack = 0;
801041ee:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
801041f5:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
801041f8:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
801041ff:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104204:	eb 85                	jmp    8010418b <fork+0xfb>
80104206:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010420d:	8d 76 00             	lea    0x0(%esi),%esi

80104210 <scheduler>:
{
80104210:	f3 0f 1e fb          	endbr32 
80104214:	55                   	push   %ebp
80104215:	89 e5                	mov    %esp,%ebp
80104217:	57                   	push   %edi
80104218:	56                   	push   %esi
80104219:	53                   	push   %ebx
8010421a:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
8010421d:	e8 2e fc ff ff       	call   80103e50 <mycpu>
  c->proc = 0;
80104222:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104229:	00 00 00 
  struct cpu *c = mycpu();
8010422c:	89 c6                	mov    %eax,%esi
  c->proc = 0;
8010422e:	8d 78 04             	lea    0x4(%eax),%edi
80104231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80104238:	fb                   	sti    
    acquire(&ptable.lock);
80104239:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010423c:	bb 74 4d 11 80       	mov    $0x80114d74,%ebx
    acquire(&ptable.lock);
80104241:	68 40 4d 11 80       	push   $0x80114d40
80104246:	e8 35 11 00 00       	call   80105380 <acquire>
8010424b:	83 c4 10             	add    $0x10,%esp
8010424e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80104250:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104254:	75 33                	jne    80104289 <scheduler+0x79>
      switchuvm(p);
80104256:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104259:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010425f:	53                   	push   %ebx
80104260:	e8 fb 35 00 00       	call   80107860 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104265:	58                   	pop    %eax
80104266:	5a                   	pop    %edx
80104267:	ff 73 1c             	pushl  0x1c(%ebx)
8010426a:	57                   	push   %edi
      p->state = RUNNING;
8010426b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104272:	e8 3c 14 00 00       	call   801056b3 <swtch>
      switchkvm();
80104277:	e8 c4 35 00 00       	call   80107840 <switchkvm>
      c->proc = 0;
8010427c:	83 c4 10             	add    $0x10,%esp
8010427f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104286:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104289:	81 c3 70 02 00 00    	add    $0x270,%ebx
8010428f:	81 fb 74 e9 11 80    	cmp    $0x8011e974,%ebx
80104295:	75 b9                	jne    80104250 <scheduler+0x40>
    release(&ptable.lock);
80104297:	83 ec 0c             	sub    $0xc,%esp
8010429a:	68 40 4d 11 80       	push   $0x80114d40
8010429f:	e8 9c 11 00 00       	call   80105440 <release>
    sti();
801042a4:	83 c4 10             	add    $0x10,%esp
801042a7:	eb 8f                	jmp    80104238 <scheduler+0x28>
801042a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801042b0 <sched>:
{
801042b0:	f3 0f 1e fb          	endbr32 
801042b4:	55                   	push   %ebp
801042b5:	89 e5                	mov    %esp,%ebp
801042b7:	56                   	push   %esi
801042b8:	53                   	push   %ebx
  pushcli();
801042b9:	e8 c2 0f 00 00       	call   80105280 <pushcli>
  c = mycpu();
801042be:	e8 8d fb ff ff       	call   80103e50 <mycpu>
  p = c->proc;
801042c3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042c9:	e8 02 10 00 00       	call   801052d0 <popcli>
  if(!holding(&ptable.lock))
801042ce:	83 ec 0c             	sub    $0xc,%esp
801042d1:	68 40 4d 11 80       	push   $0x80114d40
801042d6:	e8 55 10 00 00       	call   80105330 <holding>
801042db:	83 c4 10             	add    $0x10,%esp
801042de:	85 c0                	test   %eax,%eax
801042e0:	74 4f                	je     80104331 <sched+0x81>
  if(mycpu()->ncli != 1)
801042e2:	e8 69 fb ff ff       	call   80103e50 <mycpu>
801042e7:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801042ee:	75 68                	jne    80104358 <sched+0xa8>
  if(p->state == RUNNING)
801042f0:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801042f4:	74 55                	je     8010434b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801042f6:	9c                   	pushf  
801042f7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801042f8:	f6 c4 02             	test   $0x2,%ah
801042fb:	75 41                	jne    8010433e <sched+0x8e>
  intena = mycpu()->intena;
801042fd:	e8 4e fb ff ff       	call   80103e50 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80104302:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104305:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
8010430b:	e8 40 fb ff ff       	call   80103e50 <mycpu>
80104310:	83 ec 08             	sub    $0x8,%esp
80104313:	ff 70 04             	pushl  0x4(%eax)
80104316:	53                   	push   %ebx
80104317:	e8 97 13 00 00       	call   801056b3 <swtch>
  mycpu()->intena = intena;
8010431c:	e8 2f fb ff ff       	call   80103e50 <mycpu>
}
80104321:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104324:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
8010432a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010432d:	5b                   	pop    %ebx
8010432e:	5e                   	pop    %esi
8010432f:	5d                   	pop    %ebp
80104330:	c3                   	ret    
    panic("sched ptable.lock");
80104331:	83 ec 0c             	sub    $0xc,%esp
80104334:	68 1a 8a 10 80       	push   $0x80108a1a
80104339:	e8 52 c0 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010433e:	83 ec 0c             	sub    $0xc,%esp
80104341:	68 46 8a 10 80       	push   $0x80108a46
80104346:	e8 45 c0 ff ff       	call   80100390 <panic>
    panic("sched running");
8010434b:	83 ec 0c             	sub    $0xc,%esp
8010434e:	68 38 8a 10 80       	push   $0x80108a38
80104353:	e8 38 c0 ff ff       	call   80100390 <panic>
    panic("sched locks");
80104358:	83 ec 0c             	sub    $0xc,%esp
8010435b:	68 2c 8a 10 80       	push   $0x80108a2c
80104360:	e8 2b c0 ff ff       	call   80100390 <panic>
80104365:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010436c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104370 <exit>:
{
80104370:	f3 0f 1e fb          	endbr32 
80104374:	55                   	push   %ebp
80104375:	89 e5                	mov    %esp,%ebp
80104377:	57                   	push   %edi
80104378:	56                   	push   %esi
80104379:	53                   	push   %ebx
8010437a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
8010437d:	e8 fe 0e 00 00       	call   80105280 <pushcli>
  c = mycpu();
80104382:	e8 c9 fa ff ff       	call   80103e50 <mycpu>
  p = c->proc;
80104387:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010438d:	e8 3e 0f 00 00       	call   801052d0 <popcli>
  if(curproc == initproc)
80104392:	8d 73 28             	lea    0x28(%ebx),%esi
80104395:	8d 7b 68             	lea    0x68(%ebx),%edi
80104398:	39 1d b8 c5 10 80    	cmp    %ebx,0x8010c5b8
8010439e:	0f 84 c3 01 00 00    	je     80104567 <exit+0x1f7>
801043a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
801043a8:	8b 06                	mov    (%esi),%eax
801043aa:	85 c0                	test   %eax,%eax
801043ac:	74 12                	je     801043c0 <exit+0x50>
      fileclose(curproc->ofile[fd]);
801043ae:	83 ec 0c             	sub    $0xc,%esp
801043b1:	50                   	push   %eax
801043b2:	e8 09 cb ff ff       	call   80100ec0 <fileclose>
      curproc->ofile[fd] = 0;
801043b7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801043bd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801043c0:	83 c6 04             	add    $0x4,%esi
801043c3:	39 fe                	cmp    %edi,%esi
801043c5:	75 e1                	jne    801043a8 <exit+0x38>
  cprintf("Exiting proc %d\n", curproc->pid);
801043c7:	83 ec 08             	sub    $0x8,%esp
801043ca:	ff 73 10             	pushl  0x10(%ebx)
801043cd:	68 67 8a 10 80       	push   $0x80108a67
801043d2:	e8 d9 c2 ff ff       	call   801006b0 <cprintf>
  if(curproc->pid > 2)
801043d7:	83 c4 10             	add    $0x10,%esp
801043da:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
801043de:	0f 8f ed 00 00 00    	jg     801044d1 <exit+0x161>
  cprintf("Total page faults for proc %d = %d\n", curproc->pid, curproc->pagefaults);
801043e4:	83 ec 04             	sub    $0x4,%esp
801043e7:	ff b3 6c 02 00 00    	pushl  0x26c(%ebx)
801043ed:	ff 73 10             	pushl  0x10(%ebx)
801043f0:	68 ec 8b 10 80       	push   $0x80108bec
801043f5:	e8 b6 c2 ff ff       	call   801006b0 <cprintf>
  begin_op();
801043fa:	e8 a1 ed ff ff       	call   801031a0 <begin_op>
  iput(curproc->cwd);
801043ff:	58                   	pop    %eax
80104400:	ff 73 68             	pushl  0x68(%ebx)
80104403:	e8 88 d4 ff ff       	call   80101890 <iput>
  end_op();
80104408:	e8 03 ee ff ff       	call   80103210 <end_op>
  curproc->cwd = 0;
8010440d:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80104414:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
8010441b:	e8 60 0f 00 00       	call   80105380 <acquire>
  wakeup1(curproc->parent);
80104420:	8b 53 14             	mov    0x14(%ebx),%edx
80104423:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104426:	b8 74 4d 11 80       	mov    $0x80114d74,%eax
8010442b:	eb 0f                	jmp    8010443c <exit+0xcc>
8010442d:	8d 76 00             	lea    0x0(%esi),%esi
80104430:	05 70 02 00 00       	add    $0x270,%eax
80104435:	3d 74 e9 11 80       	cmp    $0x8011e974,%eax
8010443a:	74 1e                	je     8010445a <exit+0xea>
    if(p->state == SLEEPING && p->chan == chan)
8010443c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104440:	75 ee                	jne    80104430 <exit+0xc0>
80104442:	3b 50 20             	cmp    0x20(%eax),%edx
80104445:	75 e9                	jne    80104430 <exit+0xc0>
      p->state = RUNNABLE;
80104447:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010444e:	05 70 02 00 00       	add    $0x270,%eax
80104453:	3d 74 e9 11 80       	cmp    $0x8011e974,%eax
80104458:	75 e2                	jne    8010443c <exit+0xcc>
      p->parent = initproc;
8010445a:	8b 0d b8 c5 10 80    	mov    0x8010c5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104460:	ba 74 4d 11 80       	mov    $0x80114d74,%edx
80104465:	eb 17                	jmp    8010447e <exit+0x10e>
80104467:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010446e:	66 90                	xchg   %ax,%ax
80104470:	81 c2 70 02 00 00    	add    $0x270,%edx
80104476:	81 fa 74 e9 11 80    	cmp    $0x8011e974,%edx
8010447c:	74 3a                	je     801044b8 <exit+0x148>
    if(p->parent == curproc){
8010447e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104481:	75 ed                	jne    80104470 <exit+0x100>
      if(p->state == ZOMBIE)
80104483:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104487:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010448a:	75 e4                	jne    80104470 <exit+0x100>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010448c:	b8 74 4d 11 80       	mov    $0x80114d74,%eax
80104491:	eb 11                	jmp    801044a4 <exit+0x134>
80104493:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104497:	90                   	nop
80104498:	05 70 02 00 00       	add    $0x270,%eax
8010449d:	3d 74 e9 11 80       	cmp    $0x8011e974,%eax
801044a2:	74 cc                	je     80104470 <exit+0x100>
    if(p->state == SLEEPING && p->chan == chan)
801044a4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801044a8:	75 ee                	jne    80104498 <exit+0x128>
801044aa:	3b 48 20             	cmp    0x20(%eax),%ecx
801044ad:	75 e9                	jne    80104498 <exit+0x128>
      p->state = RUNNABLE;
801044af:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801044b6:	eb e0                	jmp    80104498 <exit+0x128>
  curproc->state = ZOMBIE;
801044b8:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
801044bf:	e8 ec fd ff ff       	call   801042b0 <sched>
  panic("zombie exit");
801044c4:	83 ec 0c             	sub    $0xc,%esp
801044c7:	68 78 8a 10 80       	push   $0x80108a78
801044cc:	e8 bf be ff ff       	call   80100390 <panic>
    removeSwapFile(curproc);
801044d1:	83 ec 0c             	sub    $0xc,%esp
801044d4:	53                   	push   %ebx
801044d5:	e8 26 dc ff ff       	call   80102100 <removeSwapFile>
    for(int i=0;i<MAX_SWAP_PAGES();i++)
801044da:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
801044e0:	8d 93 70 01 00 00    	lea    0x170(%ebx),%edx
801044e6:	83 c4 10             	add    $0x10,%esp
801044e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      p->swappedPages[i] = (struct pagemeta) {0, 0, 0, 0};
801044f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801044f6:	83 c0 10             	add    $0x10,%eax
801044f9:	c7 40 f4 00 00 00 00 	movl   $0x0,-0xc(%eax)
80104500:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
80104507:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
    for(int i=0;i<MAX_SWAP_PAGES();i++)
8010450e:	39 d0                	cmp    %edx,%eax
80104510:	75 de                	jne    801044f0 <exit+0x180>
    p->qsize = p->qhead = p->qtail = 0;
80104512:	c7 83 64 02 00 00 00 	movl   $0x0,0x264(%ebx)
80104519:	00 00 00 
8010451c:	8d 93 60 02 00 00    	lea    0x260(%ebx),%edx
80104522:	c7 83 60 02 00 00 00 	movl   $0x0,0x260(%ebx)
80104529:	00 00 00 
8010452c:	c7 83 68 02 00 00 00 	movl   $0x0,0x268(%ebx)
80104533:	00 00 00 
    for(int i=0;i<MAX_PSYC_PAGES;i++)
80104536:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010453d:	8d 76 00             	lea    0x0(%esi),%esi
      p->physicalPages[i] = (struct pagemeta) {0, 0, 0, 0};
80104540:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104546:	83 c0 10             	add    $0x10,%eax
80104549:	c7 40 f4 00 00 00 00 	movl   $0x0,-0xc(%eax)
80104550:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
80104557:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
    for(int i=0;i<MAX_PSYC_PAGES;i++)
8010455e:	39 c2                	cmp    %eax,%edx
80104560:	75 de                	jne    80104540 <exit+0x1d0>
80104562:	e9 7d fe ff ff       	jmp    801043e4 <exit+0x74>
    panic("init exiting");
80104567:	83 ec 0c             	sub    $0xc,%esp
8010456a:	68 5a 8a 10 80       	push   $0x80108a5a
8010456f:	e8 1c be ff ff       	call   80100390 <panic>
80104574:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010457b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010457f:	90                   	nop

80104580 <yield>:
{
80104580:	f3 0f 1e fb          	endbr32 
80104584:	55                   	push   %ebp
80104585:	89 e5                	mov    %esp,%ebp
80104587:	53                   	push   %ebx
80104588:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010458b:	68 40 4d 11 80       	push   $0x80114d40
80104590:	e8 eb 0d 00 00       	call   80105380 <acquire>
  pushcli();
80104595:	e8 e6 0c 00 00       	call   80105280 <pushcli>
  c = mycpu();
8010459a:	e8 b1 f8 ff ff       	call   80103e50 <mycpu>
  p = c->proc;
8010459f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801045a5:	e8 26 0d 00 00       	call   801052d0 <popcli>
  myproc()->state = RUNNABLE;
801045aa:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801045b1:	e8 fa fc ff ff       	call   801042b0 <sched>
  release(&ptable.lock);
801045b6:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
801045bd:	e8 7e 0e 00 00       	call   80105440 <release>
}
801045c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045c5:	83 c4 10             	add    $0x10,%esp
801045c8:	c9                   	leave  
801045c9:	c3                   	ret    
801045ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045d0 <sleep>:
{
801045d0:	f3 0f 1e fb          	endbr32 
801045d4:	55                   	push   %ebp
801045d5:	89 e5                	mov    %esp,%ebp
801045d7:	57                   	push   %edi
801045d8:	56                   	push   %esi
801045d9:	53                   	push   %ebx
801045da:	83 ec 0c             	sub    $0xc,%esp
801045dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801045e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801045e3:	e8 98 0c 00 00       	call   80105280 <pushcli>
  c = mycpu();
801045e8:	e8 63 f8 ff ff       	call   80103e50 <mycpu>
  p = c->proc;
801045ed:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801045f3:	e8 d8 0c 00 00       	call   801052d0 <popcli>
  if(p == 0)
801045f8:	85 db                	test   %ebx,%ebx
801045fa:	0f 84 83 00 00 00    	je     80104683 <sleep+0xb3>
  if(lk == 0)
80104600:	85 f6                	test   %esi,%esi
80104602:	74 72                	je     80104676 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104604:	81 fe 40 4d 11 80    	cmp    $0x80114d40,%esi
8010460a:	74 4c                	je     80104658 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010460c:	83 ec 0c             	sub    $0xc,%esp
8010460f:	68 40 4d 11 80       	push   $0x80114d40
80104614:	e8 67 0d 00 00       	call   80105380 <acquire>
    release(lk);
80104619:	89 34 24             	mov    %esi,(%esp)
8010461c:	e8 1f 0e 00 00       	call   80105440 <release>
  p->chan = chan;
80104621:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104624:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010462b:	e8 80 fc ff ff       	call   801042b0 <sched>
  p->chan = 0;
80104630:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104637:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
8010463e:	e8 fd 0d 00 00       	call   80105440 <release>
    acquire(lk);
80104643:	89 75 08             	mov    %esi,0x8(%ebp)
80104646:	83 c4 10             	add    $0x10,%esp
}
80104649:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010464c:	5b                   	pop    %ebx
8010464d:	5e                   	pop    %esi
8010464e:	5f                   	pop    %edi
8010464f:	5d                   	pop    %ebp
    acquire(lk);
80104650:	e9 2b 0d 00 00       	jmp    80105380 <acquire>
80104655:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104658:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010465b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104662:	e8 49 fc ff ff       	call   801042b0 <sched>
  p->chan = 0;
80104667:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010466e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104671:	5b                   	pop    %ebx
80104672:	5e                   	pop    %esi
80104673:	5f                   	pop    %edi
80104674:	5d                   	pop    %ebp
80104675:	c3                   	ret    
    panic("sleep without lk");
80104676:	83 ec 0c             	sub    $0xc,%esp
80104679:	68 8a 8a 10 80       	push   $0x80108a8a
8010467e:	e8 0d bd ff ff       	call   80100390 <panic>
    panic("sleep");
80104683:	83 ec 0c             	sub    $0xc,%esp
80104686:	68 84 8a 10 80       	push   $0x80108a84
8010468b:	e8 00 bd ff ff       	call   80100390 <panic>

80104690 <wait>:
{
80104690:	f3 0f 1e fb          	endbr32 
80104694:	55                   	push   %ebp
80104695:	89 e5                	mov    %esp,%ebp
80104697:	56                   	push   %esi
80104698:	53                   	push   %ebx
  pushcli();
80104699:	e8 e2 0b 00 00       	call   80105280 <pushcli>
  c = mycpu();
8010469e:	e8 ad f7 ff ff       	call   80103e50 <mycpu>
  p = c->proc;
801046a3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801046a9:	e8 22 0c 00 00       	call   801052d0 <popcli>
  acquire(&ptable.lock);
801046ae:	83 ec 0c             	sub    $0xc,%esp
801046b1:	68 40 4d 11 80       	push   $0x80114d40
801046b6:	e8 c5 0c 00 00       	call   80105380 <acquire>
801046bb:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801046be:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046c0:	bb 74 4d 11 80       	mov    $0x80114d74,%ebx
801046c5:	eb 17                	jmp    801046de <wait+0x4e>
801046c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046ce:	66 90                	xchg   %ax,%ax
801046d0:	81 c3 70 02 00 00    	add    $0x270,%ebx
801046d6:	81 fb 74 e9 11 80    	cmp    $0x8011e974,%ebx
801046dc:	74 1e                	je     801046fc <wait+0x6c>
      if(p->parent != curproc)
801046de:	39 73 14             	cmp    %esi,0x14(%ebx)
801046e1:	75 ed                	jne    801046d0 <wait+0x40>
      if(p->state == ZOMBIE){
801046e3:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801046e7:	74 37                	je     80104720 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046e9:	81 c3 70 02 00 00    	add    $0x270,%ebx
      havekids = 1;
801046ef:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046f4:	81 fb 74 e9 11 80    	cmp    $0x8011e974,%ebx
801046fa:	75 e2                	jne    801046de <wait+0x4e>
    if(!havekids || curproc->killed){
801046fc:	85 c0                	test   %eax,%eax
801046fe:	74 76                	je     80104776 <wait+0xe6>
80104700:	8b 46 24             	mov    0x24(%esi),%eax
80104703:	85 c0                	test   %eax,%eax
80104705:	75 6f                	jne    80104776 <wait+0xe6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104707:	83 ec 08             	sub    $0x8,%esp
8010470a:	68 40 4d 11 80       	push   $0x80114d40
8010470f:	56                   	push   %esi
80104710:	e8 bb fe ff ff       	call   801045d0 <sleep>
    havekids = 0;
80104715:	83 c4 10             	add    $0x10,%esp
80104718:	eb a4                	jmp    801046be <wait+0x2e>
8010471a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104720:	83 ec 0c             	sub    $0xc,%esp
80104723:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104726:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104729:	e8 b2 e1 ff ff       	call   801028e0 <kfree>
        freevm(p->pgdir);
8010472e:	5a                   	pop    %edx
8010472f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104732:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104739:	e8 f2 34 00 00       	call   80107c30 <freevm>
        release(&ptable.lock);
8010473e:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
        p->pid = 0;
80104745:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010474c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104753:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104757:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010475e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104765:	e8 d6 0c 00 00       	call   80105440 <release>
        return pid;
8010476a:	83 c4 10             	add    $0x10,%esp
}
8010476d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104770:	89 f0                	mov    %esi,%eax
80104772:	5b                   	pop    %ebx
80104773:	5e                   	pop    %esi
80104774:	5d                   	pop    %ebp
80104775:	c3                   	ret    
      release(&ptable.lock);
80104776:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104779:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010477e:	68 40 4d 11 80       	push   $0x80114d40
80104783:	e8 b8 0c 00 00       	call   80105440 <release>
      return -1;
80104788:	83 c4 10             	add    $0x10,%esp
8010478b:	eb e0                	jmp    8010476d <wait+0xdd>
8010478d:	8d 76 00             	lea    0x0(%esi),%esi

80104790 <wakeup>:
{
80104790:	f3 0f 1e fb          	endbr32 
80104794:	55                   	push   %ebp
80104795:	89 e5                	mov    %esp,%ebp
80104797:	53                   	push   %ebx
80104798:	83 ec 10             	sub    $0x10,%esp
8010479b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010479e:	68 40 4d 11 80       	push   $0x80114d40
801047a3:	e8 d8 0b 00 00       	call   80105380 <acquire>
801047a8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801047ab:	b8 74 4d 11 80       	mov    $0x80114d74,%eax
801047b0:	eb 12                	jmp    801047c4 <wakeup+0x34>
801047b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801047b8:	05 70 02 00 00       	add    $0x270,%eax
801047bd:	3d 74 e9 11 80       	cmp    $0x8011e974,%eax
801047c2:	74 1e                	je     801047e2 <wakeup+0x52>
    if(p->state == SLEEPING && p->chan == chan)
801047c4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801047c8:	75 ee                	jne    801047b8 <wakeup+0x28>
801047ca:	3b 58 20             	cmp    0x20(%eax),%ebx
801047cd:	75 e9                	jne    801047b8 <wakeup+0x28>
      p->state = RUNNABLE;
801047cf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801047d6:	05 70 02 00 00       	add    $0x270,%eax
801047db:	3d 74 e9 11 80       	cmp    $0x8011e974,%eax
801047e0:	75 e2                	jne    801047c4 <wakeup+0x34>
  release(&ptable.lock);
801047e2:	c7 45 08 40 4d 11 80 	movl   $0x80114d40,0x8(%ebp)
}
801047e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047ec:	c9                   	leave  
  release(&ptable.lock);
801047ed:	e9 4e 0c 00 00       	jmp    80105440 <release>
801047f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104800 <kill>:
{
80104800:	f3 0f 1e fb          	endbr32 
80104804:	55                   	push   %ebp
80104805:	89 e5                	mov    %esp,%ebp
80104807:	53                   	push   %ebx
80104808:	83 ec 10             	sub    $0x10,%esp
8010480b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010480e:	68 40 4d 11 80       	push   $0x80114d40
80104813:	e8 68 0b 00 00       	call   80105380 <acquire>
80104818:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010481b:	b8 74 4d 11 80       	mov    $0x80114d74,%eax
80104820:	eb 12                	jmp    80104834 <kill+0x34>
80104822:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104828:	05 70 02 00 00       	add    $0x270,%eax
8010482d:	3d 74 e9 11 80       	cmp    $0x8011e974,%eax
80104832:	74 34                	je     80104868 <kill+0x68>
    if(p->pid == pid){
80104834:	39 58 10             	cmp    %ebx,0x10(%eax)
80104837:	75 ef                	jne    80104828 <kill+0x28>
      if(p->state == SLEEPING)
80104839:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
8010483d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104844:	75 07                	jne    8010484d <kill+0x4d>
        p->state = RUNNABLE;
80104846:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
8010484d:	83 ec 0c             	sub    $0xc,%esp
80104850:	68 40 4d 11 80       	push   $0x80114d40
80104855:	e8 e6 0b 00 00       	call   80105440 <release>
}
8010485a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
8010485d:	83 c4 10             	add    $0x10,%esp
80104860:	31 c0                	xor    %eax,%eax
}
80104862:	c9                   	leave  
80104863:	c3                   	ret    
80104864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104868:	83 ec 0c             	sub    $0xc,%esp
8010486b:	68 40 4d 11 80       	push   $0x80114d40
80104870:	e8 cb 0b 00 00       	call   80105440 <release>
}
80104875:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104878:	83 c4 10             	add    $0x10,%esp
8010487b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104880:	c9                   	leave  
80104881:	c3                   	ret    
80104882:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104890 <procdump>:
{
80104890:	f3 0f 1e fb          	endbr32 
80104894:	55                   	push   %ebp
80104895:	89 e5                	mov    %esp,%ebp
80104897:	57                   	push   %edi
80104898:	56                   	push   %esi
80104899:	53                   	push   %ebx
8010489a:	83 ec 4c             	sub    $0x4c,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010489d:	c7 45 b4 74 4d 11 80 	movl   $0x80114d74,-0x4c(%ebp)
801048a4:	eb 15                	jmp    801048bb <procdump+0x2b>
801048a6:	81 45 b4 70 02 00 00 	addl   $0x270,-0x4c(%ebp)
801048ad:	8b 45 b4             	mov    -0x4c(%ebp),%eax
801048b0:	3d 74 e9 11 80       	cmp    $0x8011e974,%eax
801048b5:	0f 84 04 02 00 00    	je     80104abf <procdump+0x22f>
    if(p->state == UNUSED)
801048bb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
801048be:	8b 50 0c             	mov    0xc(%eax),%edx
801048c1:	85 d2                	test   %edx,%edx
801048c3:	74 e1                	je     801048a6 <procdump+0x16>
      state = "???";
801048c5:	b8 9b 8a 10 80       	mov    $0x80108a9b,%eax
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801048ca:	83 fa 05             	cmp    $0x5,%edx
801048cd:	77 11                	ja     801048e0 <procdump+0x50>
801048cf:	8b 04 95 cc 8c 10 80 	mov    -0x7fef7334(,%edx,4),%eax
      state = "???";
801048d6:	ba 9b 8a 10 80       	mov    $0x80108a9b,%edx
801048db:	85 c0                	test   %eax,%eax
801048dd:	0f 44 c2             	cmove  %edx,%eax
    cprintf("%d %s %s", p->pid, state, p->name);
801048e0:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801048e3:	8d 57 6c             	lea    0x6c(%edi),%edx
801048e6:	52                   	push   %edx
801048e7:	50                   	push   %eax
801048e8:	ff 77 10             	pushl  0x10(%edi)
801048eb:	68 9f 8a 10 80       	push   $0x80108a9f
801048f0:	e8 bb bd ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
801048f5:	83 c4 10             	add    $0x10,%esp
801048f8:	83 7f 0c 02          	cmpl   $0x2,0xc(%edi)
801048fc:	0f 84 74 01 00 00    	je     80104a76 <procdump+0x1e6>
    cprintf("\n");
80104902:	83 ec 0c             	sub    $0xc,%esp
80104905:	68 92 90 10 80       	push   $0x80109092
8010490a:	e8 a1 bd ff ff       	call   801006b0 <cprintf>
    cprintf("Page tables:\n");
8010490f:	c7 04 24 a8 8a 10 80 	movl   $0x80108aa8,(%esp)
80104916:	e8 95 bd ff ff       	call   801006b0 <cprintf>
    cprintf("\tmemory location of page directory = %p\n", V2P(*(p->pgdir)));
8010491b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
8010491e:	59                   	pop    %ecx
8010491f:	5b                   	pop    %ebx
    for(uint i=0;i<NPDENTRIES/2;i++)
80104920:	31 db                	xor    %ebx,%ebx
    cprintf("\tmemory location of page directory = %p\n", V2P(*(p->pgdir)));
80104922:	8b 40 04             	mov    0x4(%eax),%eax
80104925:	89 df                	mov    %ebx,%edi
80104927:	8b 00                	mov    (%eax),%eax
80104929:	05 00 00 00 80       	add    $0x80000000,%eax
8010492e:	50                   	push   %eax
8010492f:	68 10 8c 10 80       	push   $0x80108c10
80104934:	e8 77 bd ff ff       	call   801006b0 <cprintf>
80104939:	83 c4 10             	add    $0x10,%esp
8010493c:	eb 11                	jmp    8010494f <procdump+0xbf>
8010493e:	66 90                	xchg   %ax,%ax
    for(uint i=0;i<NPDENTRIES/2;i++)
80104940:	83 c7 01             	add    $0x1,%edi
80104943:	81 ff 00 02 00 00    	cmp    $0x200,%edi
80104949:	0f 84 89 00 00 00    	je     801049d8 <procdump+0x148>
      pde = &p->pgdir[i];
8010494f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104952:	8b 40 04             	mov    0x4(%eax),%eax
80104955:	8d 1c b8             	lea    (%eax,%edi,4),%ebx
      if((*pde & PTE_U) && (*pde & PTE_P))
80104958:	8b 33                	mov    (%ebx),%esi
8010495a:	89 f0                	mov    %esi,%eax
8010495c:	83 e0 05             	and    $0x5,%eax
8010495f:	83 f8 05             	cmp    $0x5,%eax
80104962:	75 dc                	jne    80104940 <procdump+0xb0>
        uint ppn = PTE_ADDR(*pde) >> PTXSHIFT;
80104964:	89 f0                	mov    %esi,%eax
        cprintf("\tpdir PTE %d, %d\n", i, ppn);
80104966:	83 ec 04             	sub    $0x4,%esp
        cprintf("\t\tmemory location of page table = %p\n", ppn << PTXSHIFT);
80104969:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
        uint ppn = PTE_ADDR(*pde) >> PTXSHIFT;
8010496f:	c1 e8 0c             	shr    $0xc,%eax
        cprintf("\tpdir PTE %d, %d\n", i, ppn);
80104972:	50                   	push   %eax
80104973:	57                   	push   %edi
80104974:	68 b6 8a 10 80       	push   $0x80108ab6
80104979:	e8 32 bd ff ff       	call   801006b0 <cprintf>
        cprintf("\t\tmemory location of page table = %p\n", ppn << PTXSHIFT);
8010497e:	58                   	pop    %eax
8010497f:	5a                   	pop    %edx
80104980:	56                   	push   %esi
80104981:	68 3c 8c 10 80       	push   $0x80108c3c
        for(uint j=0;j<NPTENTRIES;j++)
80104986:	31 f6                	xor    %esi,%esi
        cprintf("\t\tmemory location of page table = %p\n", ppn << PTXSHIFT);
80104988:	e8 23 bd ff ff       	call   801006b0 <cprintf>
8010498d:	83 c4 10             	add    $0x10,%esp
80104990:	eb 11                	jmp    801049a3 <procdump+0x113>
80104992:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        for(uint j=0;j<NPTENTRIES;j++)
80104998:	83 c6 01             	add    $0x1,%esi
8010499b:	81 fe 00 04 00 00    	cmp    $0x400,%esi
801049a1:	74 9d                	je     80104940 <procdump+0xb0>
            pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801049a3:	8b 03                	mov    (%ebx),%eax
801049a5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
            if((*pte & PTE_U) && (*pte & PTE_P))
801049aa:	8b 84 b0 00 00 00 80 	mov    -0x80000000(%eax,%esi,4),%eax
801049b1:	89 c2                	mov    %eax,%edx
801049b3:	83 e2 05             	and    $0x5,%edx
801049b6:	83 fa 05             	cmp    $0x5,%edx
801049b9:	75 dd                	jne    80104998 <procdump+0x108>
              cprintf("\t\tptbl PTE %d, %d, %p\n", j, ppn2, ppn2 << PTXSHIFT);
801049bb:	89 c2                	mov    %eax,%edx
              uint ppn2 =  PTE_ADDR(*pte) >> PTXSHIFT;
801049bd:	c1 e8 0c             	shr    $0xc,%eax
              cprintf("\t\tptbl PTE %d, %d, %p\n", j, ppn2, ppn2 << PTXSHIFT);
801049c0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801049c6:	52                   	push   %edx
801049c7:	50                   	push   %eax
801049c8:	56                   	push   %esi
801049c9:	68 c8 8a 10 80       	push   $0x80108ac8
801049ce:	e8 dd bc ff ff       	call   801006b0 <cprintf>
801049d3:	83 c4 10             	add    $0x10,%esp
801049d6:	eb c0                	jmp    80104998 <procdump+0x108>
    cprintf("Page mappings:\n");
801049d8:	83 ec 0c             	sub    $0xc,%esp
801049db:	31 f6                	xor    %esi,%esi
801049dd:	68 df 8a 10 80       	push   $0x80108adf
801049e2:	e8 c9 bc ff ff       	call   801006b0 <cprintf>
801049e7:	83 c4 10             	add    $0x10,%esp
801049ea:	eb 13                	jmp    801049ff <procdump+0x16f>
801049ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(uint i=0;i<NPDENTRIES/2;i++)
801049f0:	83 c6 04             	add    $0x4,%esi
801049f3:	81 fe 00 08 00 00    	cmp    $0x800,%esi
801049f9:	0f 84 a7 fe ff ff    	je     801048a6 <procdump+0x16>
      pde = &p->pgdir[i];
801049ff:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104a02:	8b 78 04             	mov    0x4(%eax),%edi
80104a05:	01 f7                	add    %esi,%edi
      if((*pde & PTE_U) && (*pde & PTE_P))
80104a07:	8b 07                	mov    (%edi),%eax
80104a09:	89 c2                	mov    %eax,%edx
80104a0b:	83 e2 05             	and    $0x5,%edx
80104a0e:	83 fa 05             	cmp    $0x5,%edx
80104a11:	75 dd                	jne    801049f0 <procdump+0x160>
80104a13:	89 f2                	mov    %esi,%edx
        for(uint j=0;j<NPTENTRIES;j++)
80104a15:	89 75 b0             	mov    %esi,-0x50(%ebp)
80104a18:	31 db                	xor    %ebx,%ebx
80104a1a:	89 fe                	mov    %edi,%esi
80104a1c:	c1 e2 08             	shl    $0x8,%edx
80104a1f:	89 d7                	mov    %edx,%edi
80104a21:	eb 12                	jmp    80104a35 <procdump+0x1a5>
80104a23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a27:	90                   	nop
80104a28:	83 c3 01             	add    $0x1,%ebx
80104a2b:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80104a31:	74 3b                	je     80104a6e <procdump+0x1de>
80104a33:	8b 06                	mov    (%esi),%eax
            pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80104a35:	25 00 f0 ff ff       	and    $0xfffff000,%eax
            if((*pte & PTE_U) && (*pte & PTE_P))
80104a3a:	8b 84 98 00 00 00 80 	mov    -0x80000000(%eax,%ebx,4),%eax
80104a41:	89 c1                	mov    %eax,%ecx
80104a43:	83 e1 05             	and    $0x5,%ecx
80104a46:	83 f9 05             	cmp    $0x5,%ecx
80104a49:	75 dd                	jne    80104a28 <procdump+0x198>
              cprintf("%d -> %d\n", (i*NPTENTRIES + j), ppn2);
80104a4b:	83 ec 04             	sub    $0x4,%esp
              uint ppn2 =  PTE_ADDR(*pte) >> PTXSHIFT;
80104a4e:	c1 e8 0c             	shr    $0xc,%eax
              cprintf("%d -> %d\n", (i*NPTENTRIES + j), ppn2);
80104a51:	50                   	push   %eax
80104a52:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
        for(uint j=0;j<NPTENTRIES;j++)
80104a55:	83 c3 01             	add    $0x1,%ebx
              cprintf("%d -> %d\n", (i*NPTENTRIES + j), ppn2);
80104a58:	50                   	push   %eax
80104a59:	68 ef 8a 10 80       	push   $0x80108aef
80104a5e:	e8 4d bc ff ff       	call   801006b0 <cprintf>
80104a63:	83 c4 10             	add    $0x10,%esp
        for(uint j=0;j<NPTENTRIES;j++)
80104a66:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80104a6c:	75 c5                	jne    80104a33 <procdump+0x1a3>
80104a6e:	8b 75 b0             	mov    -0x50(%ebp),%esi
80104a71:	e9 7a ff ff ff       	jmp    801049f0 <procdump+0x160>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104a76:	83 ec 08             	sub    $0x8,%esp
80104a79:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104a7c:	8d 5d c0             	lea    -0x40(%ebp),%ebx
80104a7f:	50                   	push   %eax
80104a80:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104a83:	8b 40 1c             	mov    0x1c(%eax),%eax
80104a86:	8b 40 0c             	mov    0xc(%eax),%eax
80104a89:	83 c0 08             	add    $0x8,%eax
80104a8c:	50                   	push   %eax
80104a8d:	e8 8e 07 00 00       	call   80105220 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104a92:	83 c4 10             	add    $0x10,%esp
80104a95:	8b 03                	mov    (%ebx),%eax
80104a97:	85 c0                	test   %eax,%eax
80104a99:	0f 84 63 fe ff ff    	je     80104902 <procdump+0x72>
        cprintf(" %p", pc[i]);
80104a9f:	83 ec 08             	sub    $0x8,%esp
80104aa2:	83 c3 04             	add    $0x4,%ebx
80104aa5:	50                   	push   %eax
80104aa6:	68 41 84 10 80       	push   $0x80108441
80104aab:	e8 00 bc ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104ab0:	8d 45 e8             	lea    -0x18(%ebp),%eax
80104ab3:	83 c4 10             	add    $0x10,%esp
80104ab6:	39 d8                	cmp    %ebx,%eax
80104ab8:	75 db                	jne    80104a95 <procdump+0x205>
80104aba:	e9 43 fe ff ff       	jmp    80104902 <procdump+0x72>
}
80104abf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ac2:	5b                   	pop    %ebx
80104ac3:	5e                   	pop    %esi
80104ac4:	5f                   	pop    %edi
80104ac5:	5d                   	pop    %ebp
80104ac6:	c3                   	ret    
80104ac7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ace:	66 90                	xchg   %ax,%ax

80104ad0 <clearPages>:
{
80104ad0:	f3 0f 1e fb          	endbr32 
80104ad4:	55                   	push   %ebp
80104ad5:	89 e5                	mov    %esp,%ebp
80104ad7:	8b 55 08             	mov    0x8(%ebp),%edx
80104ada:	8d 82 80 00 00 00    	lea    0x80(%edx),%eax
80104ae0:	8d 8a 70 01 00 00    	lea    0x170(%edx),%ecx
80104ae6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aed:	8d 76 00             	lea    0x0(%esi),%esi
      p->swappedPages[i] = (struct pagemeta) {0, 0, 0, 0};
80104af0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104af6:	83 c0 10             	add    $0x10,%eax
80104af9:	c7 40 f4 00 00 00 00 	movl   $0x0,-0xc(%eax)
80104b00:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
80104b07:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
    for(int i=0;i<MAX_SWAP_PAGES();i++)
80104b0e:	39 c8                	cmp    %ecx,%eax
80104b10:	75 de                	jne    80104af0 <clearPages+0x20>
    p->qsize = p->qhead = p->qtail = 0;
80104b12:	c7 82 64 02 00 00 00 	movl   $0x0,0x264(%edx)
80104b19:	00 00 00 
80104b1c:	81 c2 60 02 00 00    	add    $0x260,%edx
80104b22:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
80104b28:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
    for(int i=0;i<MAX_PSYC_PAGES;i++)
80104b2f:	90                   	nop
      p->physicalPages[i] = (struct pagemeta) {0, 0, 0, 0};
80104b30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104b36:	83 c0 10             	add    $0x10,%eax
80104b39:	c7 40 f4 00 00 00 00 	movl   $0x0,-0xc(%eax)
80104b40:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
80104b47:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
    for(int i=0;i<MAX_PSYC_PAGES;i++)
80104b4e:	39 d0                	cmp    %edx,%eax
80104b50:	75 de                	jne    80104b30 <clearPages+0x60>
    }

}
80104b52:	5d                   	pop    %ebp
80104b53:	c3                   	ret    
80104b54:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b5f:	90                   	nop

80104b60 <printPages>:

// print physical and 
void printPages(struct proc *p)
{
80104b60:	f3 0f 1e fb          	endbr32 
80104b64:	55                   	push   %ebp
80104b65:	89 e5                	mov    %esp,%ebp
80104b67:	57                   	push   %edi

  cprintf("proc %d: pgdir = %p\n", p->pid, V2P(*p->pgdir));

  cprintf("Pages in physical memory:\n");
  for(int i=0;i<MAX_PSYC_PAGES;i++)
80104b68:	31 ff                	xor    %edi,%edi
{
80104b6a:	56                   	push   %esi
80104b6b:	53                   	push   %ebx
80104b6c:	83 ec 10             	sub    $0x10,%esp
80104b6f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  cprintf("proc %d: pgdir = %p\n", p->pid, V2P(*p->pgdir));
80104b72:	8b 43 04             	mov    0x4(%ebx),%eax
80104b75:	8d b3 70 01 00 00    	lea    0x170(%ebx),%esi
80104b7b:	8b 00                	mov    (%eax),%eax
80104b7d:	05 00 00 00 80       	add    $0x80000000,%eax
80104b82:	50                   	push   %eax
80104b83:	ff 73 10             	pushl  0x10(%ebx)
80104b86:	68 f9 8a 10 80       	push   $0x80108af9
80104b8b:	e8 20 bb ff ff       	call   801006b0 <cprintf>
  cprintf("Pages in physical memory:\n");
80104b90:	c7 04 24 0e 8b 10 80 	movl   $0x80108b0e,(%esp)
80104b97:	e8 14 bb ff ff       	call   801006b0 <cprintf>
  for(int i=0;i<MAX_PSYC_PAGES;i++)
80104b9c:	83 c4 10             	add    $0x10,%esp
80104b9f:	eb 0f                	jmp    80104bb0 <printPages+0x50>
80104ba1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ba8:	83 c6 10             	add    $0x10,%esi
80104bab:	83 ff 0f             	cmp    $0xf,%edi
80104bae:	74 34                	je     80104be4 <printPages+0x84>
  {
    if(p->physicalPages[i].present)
80104bb0:	8b 56 08             	mov    0x8(%esi),%edx
80104bb3:	83 c7 01             	add    $0x1,%edi
80104bb6:	85 d2                	test   %edx,%edx
80104bb8:	74 ee                	je     80104ba8 <printPages+0x48>
    {
      cprintf("%d. pgdir = %p va = %d age = %d\n",i+1, V2P(*p->physicalPages[i].pgdir), p->physicalPages[i].va, p->physicalPages[i].age);
80104bba:	83 ec 0c             	sub    $0xc,%esp
80104bbd:	ff 76 0c             	pushl  0xc(%esi)
80104bc0:	83 c6 10             	add    $0x10,%esi
80104bc3:	ff 76 f4             	pushl  -0xc(%esi)
80104bc6:	8b 46 f0             	mov    -0x10(%esi),%eax
80104bc9:	8b 00                	mov    (%eax),%eax
80104bcb:	05 00 00 00 80       	add    $0x80000000,%eax
80104bd0:	50                   	push   %eax
80104bd1:	57                   	push   %edi
80104bd2:	68 64 8c 10 80       	push   $0x80108c64
80104bd7:	e8 d4 ba ff ff       	call   801006b0 <cprintf>
80104bdc:	83 c4 20             	add    $0x20,%esp
  for(int i=0;i<MAX_PSYC_PAGES;i++)
80104bdf:	83 ff 0f             	cmp    $0xf,%edi
80104be2:	75 cc                	jne    80104bb0 <printPages+0x50>
    }
  }

  cprintf("Pages in swap file:\n");
80104be4:	83 ec 0c             	sub    $0xc,%esp
80104be7:	83 eb 80             	sub    $0xffffff80,%ebx
  for(int i=0;i<MAX_SWAP_PAGES();i++)
80104bea:	31 f6                	xor    %esi,%esi
  cprintf("Pages in swap file:\n");
80104bec:	68 29 8b 10 80       	push   $0x80108b29
80104bf1:	e8 ba ba ff ff       	call   801006b0 <cprintf>
  for(int i=0;i<MAX_SWAP_PAGES();i++)
80104bf6:	83 c4 10             	add    $0x10,%esp
80104bf9:	eb 0d                	jmp    80104c08 <printPages+0xa8>
80104bfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bff:	90                   	nop
80104c00:	83 c3 10             	add    $0x10,%ebx
80104c03:	83 fe 0f             	cmp    $0xf,%esi
80104c06:	74 26                	je     80104c2e <printPages+0xce>
  {
    if(p->swappedPages[i].present)
80104c08:	8b 43 08             	mov    0x8(%ebx),%eax
80104c0b:	83 c6 01             	add    $0x1,%esi
80104c0e:	85 c0                	test   %eax,%eax
80104c10:	74 ee                	je     80104c00 <printPages+0xa0>
    {
      cprintf("%d. pgdir = %p va = %d\n", i+1, p->swappedPages[i].pgdir, p->swappedPages[i].va);
80104c12:	ff 73 04             	pushl  0x4(%ebx)
80104c15:	83 c3 10             	add    $0x10,%ebx
80104c18:	ff 73 f0             	pushl  -0x10(%ebx)
80104c1b:	56                   	push   %esi
80104c1c:	68 3e 8b 10 80       	push   $0x80108b3e
80104c21:	e8 8a ba ff ff       	call   801006b0 <cprintf>
80104c26:	83 c4 10             	add    $0x10,%esp
  for(int i=0;i<MAX_SWAP_PAGES();i++)
80104c29:	83 fe 0f             	cmp    $0xf,%esi
80104c2c:	75 da                	jne    80104c08 <printPages+0xa8>
    }
  }
  return ;
}
80104c2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c31:	5b                   	pop    %ebx
80104c32:	5e                   	pop    %esi
80104c33:	5f                   	pop    %edi
80104c34:	5d                   	pop    %ebp
80104c35:	c3                   	ret    
80104c36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c3d:	8d 76 00             	lea    0x0(%esi),%esi

80104c40 <getNextPhysicalPage>:

// get next physical page to swap out according to algorithm
int getNextPhysicalPage(struct proc *p)
{
80104c40:	f3 0f 1e fb          	endbr32 
80104c44:	55                   	push   %ebp
80104c45:	89 e5                	mov    %esp,%ebp
80104c47:	56                   	push   %esi
80104c48:	8b 45 08             	mov    0x8(%ebp),%eax
80104c4b:	53                   	push   %ebx
  if(p->qsize == 0)
80104c4c:	8b 98 68 02 00 00    	mov    0x268(%eax),%ebx
80104c52:	85 db                	test   %ebx,%ebx
80104c54:	74 61                	je     80104cb7 <getNextPhysicalPage+0x77>
  {
    return -1;
  }
  else if(algo == FIFO)
80104c56:	8b 15 04 c0 10 80    	mov    0x8010c004,%edx
80104c5c:	83 fa 01             	cmp    $0x1,%edx
80104c5f:	74 47                	je     80104ca8 <getNextPhysicalPage+0x68>
  {
    return p->qhead;
  }
  else if(algo == AGING)
80104c61:	83 fa 02             	cmp    $0x2,%edx
80104c64:	75 58                	jne    80104cbe <getNextPhysicalPage+0x7e>
80104c66:	05 7c 01 00 00       	add    $0x17c,%eax
  {
    uint min_age;
    int index = -1;
    
    for(int i=0;i<MAX_PSYC_PAGES;i++)
80104c6b:	31 d2                	xor    %edx,%edx
    int index = -1;
80104c6d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104c72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    {
      
      if(p->physicalPages[i].present && (index == -1 || min_age > p->physicalPages[i].age))
80104c78:	8b 48 fc             	mov    -0x4(%eax),%ecx
80104c7b:	85 c9                	test   %ecx,%ecx
80104c7d:	74 0f                	je     80104c8e <getNextPhysicalPage+0x4e>
80104c7f:	8b 08                	mov    (%eax),%ecx
80104c81:	83 fb ff             	cmp    $0xffffffff,%ebx
80104c84:	74 04                	je     80104c8a <getNextPhysicalPage+0x4a>
80104c86:	39 f1                	cmp    %esi,%ecx
80104c88:	73 04                	jae    80104c8e <getNextPhysicalPage+0x4e>
80104c8a:	89 d3                	mov    %edx,%ebx
80104c8c:	89 ce                	mov    %ecx,%esi
    for(int i=0;i<MAX_PSYC_PAGES;i++)
80104c8e:	83 c2 01             	add    $0x1,%edx
80104c91:	83 c0 10             	add    $0x10,%eax
80104c94:	83 fa 0f             	cmp    $0xf,%edx
80104c97:	75 df                	jne    80104c78 <getNextPhysicalPage+0x38>
  else
  {
    panic("swapping algorithm not defined!");
    return -1;
  }
}
80104c99:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c9c:	89 d8                	mov    %ebx,%eax
80104c9e:	5b                   	pop    %ebx
80104c9f:	5e                   	pop    %esi
80104ca0:	5d                   	pop    %ebp
80104ca1:	c3                   	ret    
80104ca2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return p->qhead;
80104ca8:	8b 98 60 02 00 00    	mov    0x260(%eax),%ebx
}
80104cae:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cb1:	89 d8                	mov    %ebx,%eax
80104cb3:	5b                   	pop    %ebx
80104cb4:	5e                   	pop    %esi
80104cb5:	5d                   	pop    %ebp
80104cb6:	c3                   	ret    
    return -1;
80104cb7:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104cbc:	eb db                	jmp    80104c99 <getNextPhysicalPage+0x59>
    panic("swapping algorithm not defined!");
80104cbe:	83 ec 0c             	sub    $0xc,%esp
80104cc1:	68 88 8c 10 80       	push   $0x80108c88
80104cc6:	e8 c5 b6 ff ff       	call   80100390 <panic>
80104ccb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ccf:	90                   	nop

80104cd0 <addPhysicalPage>:



// add a page to physical page list
void addPhysicalPage(struct proc *p, pde_t *pgdir, uint va)
{
80104cd0:	f3 0f 1e fb          	endbr32 
80104cd4:	55                   	push   %ebp
80104cd5:	89 e5                	mov    %esp,%ebp
80104cd7:	56                   	push   %esi
80104cd8:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104cdb:	53                   	push   %ebx
  if(p->qsize == MAX_PSYC_PAGES)
80104cdc:	8b 99 68 02 00 00    	mov    0x268(%ecx),%ebx
80104ce2:	83 fb 0f             	cmp    $0xf,%ebx
80104ce5:	0f 84 d5 00 00 00    	je     80104dc0 <addPhysicalPage+0xf0>
  {
    panic("Cant add any more pages!");
  }
  else if(algo == FIFO)
80104ceb:	a1 04 c0 10 80       	mov    0x8010c004,%eax
80104cf0:	83 f8 01             	cmp    $0x1,%eax
80104cf3:	74 2b                	je     80104d20 <addPhysicalPage+0x50>
  {
    int pos = (p->qhead + p->qsize) % MAX_PSYC_PAGES;
    p->physicalPages[pos] = (struct pagemeta) {pgdir, va, 1, 0};
    p->qsize++;
  }
  else if(algo == AGING)
80104cf5:	83 f8 02             	cmp    $0x2,%eax
80104cf8:	0f 85 cf 00 00 00    	jne    80104dcd <addPhysicalPage+0xfd>
  {

    for(int i=0;i<MAX_PSYC_PAGES;i++)
80104cfe:	31 c0                	xor    %eax,%eax
    {
      if(p->physicalPages[i].present == 0)
80104d00:	89 c2                	mov    %eax,%edx
80104d02:	c1 e2 04             	shl    $0x4,%edx
80104d05:	8b b4 11 78 01 00 00 	mov    0x178(%ecx,%edx,1),%esi
80104d0c:	85 f6                	test   %esi,%esi
80104d0e:	74 78                	je     80104d88 <addPhysicalPage+0xb8>
    for(int i=0;i<MAX_PSYC_PAGES;i++)
80104d10:	83 c0 01             	add    $0x1,%eax
80104d13:	83 f8 0f             	cmp    $0xf,%eax
80104d16:	75 e8                	jne    80104d00 <addPhysicalPage+0x30>
  else 
  {
    panic("swapping algorithm not defined!");

  }
}
80104d18:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d1b:	5b                   	pop    %ebx
80104d1c:	5e                   	pop    %esi
80104d1d:	5d                   	pop    %ebp
80104d1e:	c3                   	ret    
80104d1f:	90                   	nop
    int pos = (p->qhead + p->qsize) % MAX_PSYC_PAGES;
80104d20:	8b b1 60 02 00 00    	mov    0x260(%ecx),%esi
80104d26:	ba 89 88 88 88       	mov    $0x88888889,%edx
80104d2b:	01 de                	add    %ebx,%esi
    p->qsize++;
80104d2d:	83 c3 01             	add    $0x1,%ebx
    int pos = (p->qhead + p->qsize) % MAX_PSYC_PAGES;
80104d30:	89 f0                	mov    %esi,%eax
80104d32:	f7 ea                	imul   %edx
80104d34:	89 f0                	mov    %esi,%eax
80104d36:	c1 f8 1f             	sar    $0x1f,%eax
80104d39:	01 f2                	add    %esi,%edx
80104d3b:	c1 fa 03             	sar    $0x3,%edx
80104d3e:	29 c2                	sub    %eax,%edx
80104d40:	89 d0                	mov    %edx,%eax
80104d42:	c1 e0 04             	shl    $0x4,%eax
80104d45:	29 d0                	sub    %edx,%eax
80104d47:	29 c6                	sub    %eax,%esi
80104d49:	c1 e6 04             	shl    $0x4,%esi
80104d4c:	8d 04 31             	lea    (%ecx,%esi,1),%eax
    p->physicalPages[pos] = (struct pagemeta) {pgdir, va, 1, 0};
80104d4f:	8b 75 0c             	mov    0xc(%ebp),%esi
80104d52:	c7 80 78 01 00 00 01 	movl   $0x1,0x178(%eax)
80104d59:	00 00 00 
80104d5c:	89 b0 70 01 00 00    	mov    %esi,0x170(%eax)
80104d62:	8b 75 10             	mov    0x10(%ebp),%esi
80104d65:	c7 80 7c 01 00 00 00 	movl   $0x0,0x17c(%eax)
80104d6c:	00 00 00 
80104d6f:	89 b0 74 01 00 00    	mov    %esi,0x174(%eax)
    p->qsize++;
80104d75:	89 99 68 02 00 00    	mov    %ebx,0x268(%ecx)
}
80104d7b:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d7e:	5b                   	pop    %ebx
80104d7f:	5e                   	pop    %esi
80104d80:	5d                   	pop    %ebp
80104d81:	c3                   	ret    
80104d82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          p->physicalPages[i] = (struct pagemeta) {pgdir, va, 1, 0};
80104d88:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d8b:	01 ca                	add    %ecx,%edx
          p->qsize++;
80104d8d:	83 c3 01             	add    $0x1,%ebx
          p->physicalPages[i] = (struct pagemeta) {pgdir, va, 1, 0};
80104d90:	c7 82 78 01 00 00 01 	movl   $0x1,0x178(%edx)
80104d97:	00 00 00 
80104d9a:	89 82 70 01 00 00    	mov    %eax,0x170(%edx)
80104da0:	8b 45 10             	mov    0x10(%ebp),%eax
80104da3:	c7 82 7c 01 00 00 00 	movl   $0x0,0x17c(%edx)
80104daa:	00 00 00 
80104dad:	89 82 74 01 00 00    	mov    %eax,0x174(%edx)
          p->qsize++;
80104db3:	89 99 68 02 00 00    	mov    %ebx,0x268(%ecx)
}
80104db9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104dbc:	5b                   	pop    %ebx
80104dbd:	5e                   	pop    %esi
80104dbe:	5d                   	pop    %ebp
80104dbf:	c3                   	ret    
    panic("Cant add any more pages!");
80104dc0:	83 ec 0c             	sub    $0xc,%esp
80104dc3:	68 56 8b 10 80       	push   $0x80108b56
80104dc8:	e8 c3 b5 ff ff       	call   80100390 <panic>
    panic("swapping algorithm not defined!");
80104dcd:	83 ec 0c             	sub    $0xc,%esp
80104dd0:	68 88 8c 10 80       	push   $0x80108c88
80104dd5:	e8 b6 b5 ff ff       	call   80100390 <panic>
80104dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104de0 <removePhysicalPage>:

// remove a physical page
int removePhysicalPage(struct proc *p, int index)
{
80104de0:	f3 0f 1e fb          	endbr32 
80104de4:	55                   	push   %ebp
80104de5:	89 e5                	mov    %esp,%ebp
80104de7:	53                   	push   %ebx
80104de8:	83 ec 04             	sub    $0x4,%esp
80104deb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104dee:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104df1:	89 ca                	mov    %ecx,%edx
80104df3:	c1 e2 04             	shl    $0x4,%edx
80104df6:	01 da                	add    %ebx,%edx
  if(!p->physicalPages[index].present)
80104df8:	8b 82 78 01 00 00    	mov    0x178(%edx),%eax
80104dfe:	85 c0                	test   %eax,%eax
80104e00:	0f 84 af 00 00 00    	je     80104eb5 <removePhysicalPage+0xd5>
  {
    panic("Page not present!");
    return -1;
  }
  else if(algo == FIFO)
80104e06:	a1 04 c0 10 80       	mov    0x8010c004,%eax
80104e0b:	83 f8 01             	cmp    $0x1,%eax
80104e0e:	74 40                	je     80104e50 <removePhysicalPage+0x70>
    else 
    {
      panic("Page is not the fifo queue front!");
    }
  }
  else if(algo == AGING)
80104e10:	83 f8 02             	cmp    $0x2,%eax
80104e13:	0f 85 a9 00 00 00    	jne    80104ec2 <removePhysicalPage+0xe2>
  {
    p->physicalPages[index] = (struct pagemeta) {0, 0, 0, 0};
80104e19:	c7 82 70 01 00 00 00 	movl   $0x0,0x170(%edx)
80104e20:	00 00 00 
    panic("swapping algorithm not defined!");
    return -1;
  }
  return 0;

}
80104e23:	31 c0                	xor    %eax,%eax
    p->physicalPages[index] = (struct pagemeta) {0, 0, 0, 0};
80104e25:	c7 82 74 01 00 00 00 	movl   $0x0,0x174(%edx)
80104e2c:	00 00 00 
80104e2f:	c7 82 78 01 00 00 00 	movl   $0x0,0x178(%edx)
80104e36:	00 00 00 
80104e39:	c7 82 7c 01 00 00 00 	movl   $0x0,0x17c(%edx)
80104e40:	00 00 00 
    p->qsize--;
80104e43:	83 ab 68 02 00 00 01 	subl   $0x1,0x268(%ebx)
}
80104e4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e4d:	c9                   	leave  
80104e4e:	c3                   	ret    
80104e4f:	90                   	nop
    p->physicalPages[index] = (struct pagemeta) {0, 0, 0, 0};
80104e50:	c7 82 70 01 00 00 00 	movl   $0x0,0x170(%edx)
80104e57:	00 00 00 
80104e5a:	c7 82 74 01 00 00 00 	movl   $0x0,0x174(%edx)
80104e61:	00 00 00 
80104e64:	c7 82 78 01 00 00 00 	movl   $0x0,0x178(%edx)
80104e6b:	00 00 00 
80104e6e:	c7 82 7c 01 00 00 00 	movl   $0x0,0x17c(%edx)
80104e75:	00 00 00 
    p->qsize--;
80104e78:	83 ab 68 02 00 00 01 	subl   $0x1,0x268(%ebx)
    if(p->qhead == index)
80104e7f:	39 8b 60 02 00 00    	cmp    %ecx,0x260(%ebx)
80104e85:	75 48                	jne    80104ecf <removePhysicalPage+0xef>
      p->qhead = (p->qhead + 1) % MAX_PSYC_PAGES;
80104e87:	83 c1 01             	add    $0x1,%ecx
80104e8a:	ba 89 88 88 88       	mov    $0x88888889,%edx
80104e8f:	89 c8                	mov    %ecx,%eax
80104e91:	f7 ea                	imul   %edx
80104e93:	89 c8                	mov    %ecx,%eax
80104e95:	c1 f8 1f             	sar    $0x1f,%eax
80104e98:	01 ca                	add    %ecx,%edx
80104e9a:	c1 fa 03             	sar    $0x3,%edx
80104e9d:	29 c2                	sub    %eax,%edx
80104e9f:	89 d0                	mov    %edx,%eax
80104ea1:	c1 e0 04             	shl    $0x4,%eax
80104ea4:	29 d0                	sub    %edx,%eax
80104ea6:	29 c1                	sub    %eax,%ecx
}
80104ea8:	31 c0                	xor    %eax,%eax
      p->qhead = (p->qhead + 1) % MAX_PSYC_PAGES;
80104eaa:	89 8b 60 02 00 00    	mov    %ecx,0x260(%ebx)
}
80104eb0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104eb3:	c9                   	leave  
80104eb4:	c3                   	ret    
    panic("Page not present!");
80104eb5:	83 ec 0c             	sub    $0xc,%esp
80104eb8:	68 6f 8b 10 80       	push   $0x80108b6f
80104ebd:	e8 ce b4 ff ff       	call   80100390 <panic>
    panic("swapping algorithm not defined!");
80104ec2:	83 ec 0c             	sub    $0xc,%esp
80104ec5:	68 88 8c 10 80       	push   $0x80108c88
80104eca:	e8 c1 b4 ff ff       	call   80100390 <panic>
      panic("Page is not the fifo queue front!");
80104ecf:	83 ec 0c             	sub    $0xc,%esp
80104ed2:	68 a8 8c 10 80       	push   $0x80108ca8
80104ed7:	e8 b4 b4 ff ff       	call   80100390 <panic>
80104edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ee0 <getPhysicalPage>:
// get a physical page from list matching va, pgdir
int getPhysicalPage(struct proc *p, pde_t *pgdir, uint va)
{
80104ee0:	f3 0f 1e fb          	endbr32 
80104ee4:	55                   	push   %ebp
  for(int i=0;i<MAX_PSYC_PAGES;i++)
80104ee5:	31 d2                	xor    %edx,%edx
{
80104ee7:	89 e5                	mov    %esp,%ebp
80104ee9:	53                   	push   %ebx
80104eea:	8b 45 08             	mov    0x8(%ebp),%eax
80104eed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104ef0:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104ef3:	05 70 01 00 00       	add    $0x170,%eax
80104ef8:	eb 11                	jmp    80104f0b <getPhysicalPage+0x2b>
80104efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(int i=0;i<MAX_PSYC_PAGES;i++)
80104f00:	83 c2 01             	add    $0x1,%edx
80104f03:	83 c0 10             	add    $0x10,%eax
80104f06:	83 fa 0f             	cmp    $0xf,%edx
80104f09:	74 15                	je     80104f20 <getPhysicalPage+0x40>
  {
    if(p->physicalPages[i].present && p->physicalPages[i].pgdir == pgdir && p->physicalPages[i].va == va)
80104f0b:	83 78 08 00          	cmpl   $0x0,0x8(%eax)
80104f0f:	74 ef                	je     80104f00 <getPhysicalPage+0x20>
80104f11:	39 08                	cmp    %ecx,(%eax)
80104f13:	75 eb                	jne    80104f00 <getPhysicalPage+0x20>
80104f15:	39 58 04             	cmp    %ebx,0x4(%eax)
80104f18:	75 e6                	jne    80104f00 <getPhysicalPage+0x20>
    {
      return i;
    }
  }
  return -1;
}
80104f1a:	89 d0                	mov    %edx,%eax
80104f1c:	5b                   	pop    %ebx
80104f1d:	5d                   	pop    %ebp
80104f1e:	c3                   	ret    
80104f1f:	90                   	nop
  return -1;
80104f20:	ba ff ff ff ff       	mov    $0xffffffff,%edx
}
80104f25:	5b                   	pop    %ebx
80104f26:	5d                   	pop    %ebp
80104f27:	89 d0                	mov    %edx,%eax
80104f29:	c3                   	ret    
80104f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104f30 <getSwapPage>:

// get a swap page from list matching va, pgdir
int getSwapPage(struct proc *p, pde_t *pgdir, uint va)
{
80104f30:	f3 0f 1e fb          	endbr32 
80104f34:	55                   	push   %ebp
  for(int i=0;i<MAX_SWAP_PAGES();i++)
80104f35:	31 d2                	xor    %edx,%edx
{
80104f37:	89 e5                	mov    %esp,%ebp
80104f39:	53                   	push   %ebx
80104f3a:	8b 45 08             	mov    0x8(%ebp),%eax
80104f3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104f40:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104f43:	83 e8 80             	sub    $0xffffff80,%eax
80104f46:	eb 13                	jmp    80104f5b <getSwapPage+0x2b>
80104f48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f4f:	90                   	nop
  for(int i=0;i<MAX_SWAP_PAGES();i++)
80104f50:	83 c2 01             	add    $0x1,%edx
80104f53:	83 c0 10             	add    $0x10,%eax
80104f56:	83 fa 0f             	cmp    $0xf,%edx
80104f59:	74 15                	je     80104f70 <getSwapPage+0x40>
  {
    if(p->swappedPages[i].present && p->swappedPages[i].pgdir == pgdir && p->swappedPages[i].va == va)
80104f5b:	83 78 08 00          	cmpl   $0x0,0x8(%eax)
80104f5f:	74 ef                	je     80104f50 <getSwapPage+0x20>
80104f61:	39 08                	cmp    %ecx,(%eax)
80104f63:	75 eb                	jne    80104f50 <getSwapPage+0x20>
80104f65:	39 58 04             	cmp    %ebx,0x4(%eax)
80104f68:	75 e6                	jne    80104f50 <getSwapPage+0x20>
    {
      return i;
    }
  }
  return -1;
}
80104f6a:	89 d0                	mov    %edx,%eax
80104f6c:	5b                   	pop    %ebx
80104f6d:	5d                   	pop    %ebp
80104f6e:	c3                   	ret    
80104f6f:	90                   	nop
  return -1;
80104f70:	ba ff ff ff ff       	mov    $0xffffffff,%edx
}
80104f75:	5b                   	pop    %ebx
80104f76:	5d                   	pop    %ebp
80104f77:	89 d0                	mov    %edx,%eax
80104f79:	c3                   	ret    
80104f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104f80 <removeSwapPage>:
// remove a swap page
void removeSwapPage(struct proc *p, int index)
{
80104f80:	f3 0f 1e fb          	endbr32 
80104f84:	55                   	push   %ebp
80104f85:	89 e5                	mov    %esp,%ebp
80104f87:	83 ec 08             	sub    $0x8,%esp
80104f8a:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f8d:	c1 e0 04             	shl    $0x4,%eax
80104f90:	03 45 08             	add    0x8(%ebp),%eax
  if(p->swappedPages[index].present)
80104f93:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
80104f99:	85 d2                	test   %edx,%edx
80104f9b:	74 2a                	je     80104fc7 <removeSwapPage+0x47>
  {
    p->swappedPages[index] = (struct pagemeta) {0, 0, 0, 0};
80104f9d:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80104fa4:	00 00 00 
80104fa7:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
80104fae:	00 00 00 
80104fb1:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
80104fb8:	00 00 00 
80104fbb:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80104fc2:	00 00 00 
  else 
  {
    panic("Swap page not in list");
  }

}
80104fc5:	c9                   	leave  
80104fc6:	c3                   	ret    
    panic("Swap page not in list");
80104fc7:	83 ec 0c             	sub    $0xc,%esp
80104fca:	68 81 8b 10 80       	push   $0x80108b81
80104fcf:	e8 bc b3 ff ff       	call   80100390 <panic>
80104fd4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fdf:	90                   	nop

80104fe0 <addSwapPage>:
// add a page to swap list
void addSwapPage(struct proc *p, int index, pde_t *pgdir, uint va)
{
80104fe0:	f3 0f 1e fb          	endbr32 
80104fe4:	55                   	push   %ebp
80104fe5:	89 e5                	mov    %esp,%ebp
80104fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  p->swappedPages[index] = (struct pagemeta) {pgdir, va, 1, 0};
80104fea:	8b 55 10             	mov    0x10(%ebp),%edx
80104fed:	c1 e0 04             	shl    $0x4,%eax
80104ff0:	03 45 08             	add    0x8(%ebp),%eax
80104ff3:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
80104ff9:	8b 55 14             	mov    0x14(%ebp),%edx
80104ffc:	c7 80 88 00 00 00 01 	movl   $0x1,0x88(%eax)
80105003:	00 00 00 
80105006:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
8010500c:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80105013:	00 00 00 
}
80105016:	5d                   	pop    %ebp
80105017:	c3                   	ret    
80105018:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010501f:	90                   	nop

80105020 <getEmptySwapPosition>:

// get an empty swap position
int getEmptySwapPosition(struct proc *p)
{
80105020:	f3 0f 1e fb          	endbr32 
80105024:	55                   	push   %ebp
  for(int i=0;i<MAX_SWAP_PAGES();i++)
80105025:	31 c0                	xor    %eax,%eax
{
80105027:	89 e5                	mov    %esp,%ebp
80105029:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010502c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  {
    if(!p->swappedPages[i].present)
80105030:	89 c2                	mov    %eax,%edx
80105032:	c1 e2 04             	shl    $0x4,%edx
80105035:	8b 94 11 88 00 00 00 	mov    0x88(%ecx,%edx,1),%edx
8010503c:	85 d2                	test   %edx,%edx
8010503e:	74 0d                	je     8010504d <getEmptySwapPosition+0x2d>
  for(int i=0;i<MAX_SWAP_PAGES();i++)
80105040:	83 c0 01             	add    $0x1,%eax
80105043:	83 f8 0f             	cmp    $0xf,%eax
80105046:	75 e8                	jne    80105030 <getEmptySwapPosition+0x10>
    {
      return i;
    }
  }
  return -1;
80105048:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010504d:	5d                   	pop    %ebp
8010504e:	c3                   	ret    
8010504f:	90                   	nop

80105050 <updateAllProcessPTE>:

// update PTE_A flags for aging
void updateAllProcessPTE()
{
80105050:	f3 0f 1e fb          	endbr32 
  if(algo == FIFO)
80105054:	83 3d 04 c0 10 80 01 	cmpl   $0x1,0x8010c004
8010505b:	74 59                	je     801050b6 <updateAllProcessPTE+0x66>
{
8010505d:	55                   	push   %ebp
8010505e:	89 e5                	mov    %esp,%ebp
80105060:	53                   	push   %ebx
  {
    return ;
  }
  struct proc *p;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105061:	bb 74 4d 11 80       	mov    $0x80114d74,%ebx
{
80105066:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80105069:	68 40 4d 11 80       	push   $0x80114d40
8010506e:	e8 0d 03 00 00       	call   80105380 <acquire>
80105073:	83 c4 10             	add    $0x10,%esp
80105076:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010507d:	8d 76 00             	lea    0x0(%esi),%esi
    if(p->state == UNUSED)
80105080:	8b 43 0c             	mov    0xc(%ebx),%eax
80105083:	85 c0                	test   %eax,%eax
80105085:	74 0c                	je     80105093 <updateAllProcessPTE+0x43>
      continue;

    clearPTE_A(p);
80105087:	83 ec 0c             	sub    $0xc,%esp
8010508a:	53                   	push   %ebx
8010508b:	e8 f0 32 00 00       	call   80108380 <clearPTE_A>
80105090:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105093:	81 c3 70 02 00 00    	add    $0x270,%ebx
80105099:	81 fb 74 e9 11 80    	cmp    $0x8011e974,%ebx
8010509f:	75 df                	jne    80105080 <updateAllProcessPTE+0x30>

  }
  release(&ptable.lock);
801050a1:	83 ec 0c             	sub    $0xc,%esp
801050a4:	68 40 4d 11 80       	push   $0x80114d40
801050a9:	e8 92 03 00 00       	call   80105440 <release>
}
801050ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&ptable.lock);
801050b1:	83 c4 10             	add    $0x10,%esp
}
801050b4:	c9                   	leave  
801050b5:	c3                   	ret    
801050b6:	c3                   	ret    
801050b7:	66 90                	xchg   %ax,%ax
801050b9:	66 90                	xchg   %ax,%ax
801050bb:	66 90                	xchg   %ax,%ax
801050bd:	66 90                	xchg   %ax,%ax
801050bf:	90                   	nop

801050c0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801050c0:	f3 0f 1e fb          	endbr32 
801050c4:	55                   	push   %ebp
801050c5:	89 e5                	mov    %esp,%ebp
801050c7:	53                   	push   %ebx
801050c8:	83 ec 0c             	sub    $0xc,%esp
801050cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801050ce:	68 e4 8c 10 80       	push   $0x80108ce4
801050d3:	8d 43 04             	lea    0x4(%ebx),%eax
801050d6:	50                   	push   %eax
801050d7:	e8 24 01 00 00       	call   80105200 <initlock>
  lk->name = name;
801050dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801050df:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801050e5:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801050e8:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801050ef:	89 43 38             	mov    %eax,0x38(%ebx)
}
801050f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050f5:	c9                   	leave  
801050f6:	c3                   	ret    
801050f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050fe:	66 90                	xchg   %ax,%ax

80105100 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80105100:	f3 0f 1e fb          	endbr32 
80105104:	55                   	push   %ebp
80105105:	89 e5                	mov    %esp,%ebp
80105107:	56                   	push   %esi
80105108:	53                   	push   %ebx
80105109:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010510c:	8d 73 04             	lea    0x4(%ebx),%esi
8010510f:	83 ec 0c             	sub    $0xc,%esp
80105112:	56                   	push   %esi
80105113:	e8 68 02 00 00       	call   80105380 <acquire>
  while (lk->locked) {
80105118:	8b 13                	mov    (%ebx),%edx
8010511a:	83 c4 10             	add    $0x10,%esp
8010511d:	85 d2                	test   %edx,%edx
8010511f:	74 1a                	je     8010513b <acquiresleep+0x3b>
80105121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80105128:	83 ec 08             	sub    $0x8,%esp
8010512b:	56                   	push   %esi
8010512c:	53                   	push   %ebx
8010512d:	e8 9e f4 ff ff       	call   801045d0 <sleep>
  while (lk->locked) {
80105132:	8b 03                	mov    (%ebx),%eax
80105134:	83 c4 10             	add    $0x10,%esp
80105137:	85 c0                	test   %eax,%eax
80105139:	75 ed                	jne    80105128 <acquiresleep+0x28>
  }
  lk->locked = 1;
8010513b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80105141:	e8 9a ed ff ff       	call   80103ee0 <myproc>
80105146:	8b 40 10             	mov    0x10(%eax),%eax
80105149:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
8010514c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010514f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105152:	5b                   	pop    %ebx
80105153:	5e                   	pop    %esi
80105154:	5d                   	pop    %ebp
  release(&lk->lk);
80105155:	e9 e6 02 00 00       	jmp    80105440 <release>
8010515a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105160 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80105160:	f3 0f 1e fb          	endbr32 
80105164:	55                   	push   %ebp
80105165:	89 e5                	mov    %esp,%ebp
80105167:	56                   	push   %esi
80105168:	53                   	push   %ebx
80105169:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010516c:	8d 73 04             	lea    0x4(%ebx),%esi
8010516f:	83 ec 0c             	sub    $0xc,%esp
80105172:	56                   	push   %esi
80105173:	e8 08 02 00 00       	call   80105380 <acquire>
  lk->locked = 0;
80105178:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010517e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80105185:	89 1c 24             	mov    %ebx,(%esp)
80105188:	e8 03 f6 ff ff       	call   80104790 <wakeup>
  release(&lk->lk);
8010518d:	89 75 08             	mov    %esi,0x8(%ebp)
80105190:	83 c4 10             	add    $0x10,%esp
}
80105193:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105196:	5b                   	pop    %ebx
80105197:	5e                   	pop    %esi
80105198:	5d                   	pop    %ebp
  release(&lk->lk);
80105199:	e9 a2 02 00 00       	jmp    80105440 <release>
8010519e:	66 90                	xchg   %ax,%ax

801051a0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801051a0:	f3 0f 1e fb          	endbr32 
801051a4:	55                   	push   %ebp
801051a5:	89 e5                	mov    %esp,%ebp
801051a7:	57                   	push   %edi
801051a8:	31 ff                	xor    %edi,%edi
801051aa:	56                   	push   %esi
801051ab:	53                   	push   %ebx
801051ac:	83 ec 18             	sub    $0x18,%esp
801051af:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801051b2:	8d 73 04             	lea    0x4(%ebx),%esi
801051b5:	56                   	push   %esi
801051b6:	e8 c5 01 00 00       	call   80105380 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801051bb:	8b 03                	mov    (%ebx),%eax
801051bd:	83 c4 10             	add    $0x10,%esp
801051c0:	85 c0                	test   %eax,%eax
801051c2:	75 1c                	jne    801051e0 <holdingsleep+0x40>
  release(&lk->lk);
801051c4:	83 ec 0c             	sub    $0xc,%esp
801051c7:	56                   	push   %esi
801051c8:	e8 73 02 00 00       	call   80105440 <release>
  return r;
}
801051cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051d0:	89 f8                	mov    %edi,%eax
801051d2:	5b                   	pop    %ebx
801051d3:	5e                   	pop    %esi
801051d4:	5f                   	pop    %edi
801051d5:	5d                   	pop    %ebp
801051d6:	c3                   	ret    
801051d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051de:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
801051e0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801051e3:	e8 f8 ec ff ff       	call   80103ee0 <myproc>
801051e8:	39 58 10             	cmp    %ebx,0x10(%eax)
801051eb:	0f 94 c0             	sete   %al
801051ee:	0f b6 c0             	movzbl %al,%eax
801051f1:	89 c7                	mov    %eax,%edi
801051f3:	eb cf                	jmp    801051c4 <holdingsleep+0x24>
801051f5:	66 90                	xchg   %ax,%ax
801051f7:	66 90                	xchg   %ax,%ax
801051f9:	66 90                	xchg   %ax,%ax
801051fb:	66 90                	xchg   %ax,%ax
801051fd:	66 90                	xchg   %ax,%ax
801051ff:	90                   	nop

80105200 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105200:	f3 0f 1e fb          	endbr32 
80105204:	55                   	push   %ebp
80105205:	89 e5                	mov    %esp,%ebp
80105207:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
8010520a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
8010520d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80105213:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80105216:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010521d:	5d                   	pop    %ebp
8010521e:	c3                   	ret    
8010521f:	90                   	nop

80105220 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105220:	f3 0f 1e fb          	endbr32 
80105224:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105225:	31 d2                	xor    %edx,%edx
{
80105227:	89 e5                	mov    %esp,%ebp
80105229:	53                   	push   %ebx
  ebp = (uint*)v - 2;
8010522a:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010522d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80105230:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80105233:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105237:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105238:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010523e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80105244:	77 1a                	ja     80105260 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105246:	8b 58 04             	mov    0x4(%eax),%ebx
80105249:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010524c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
8010524f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105251:	83 fa 0a             	cmp    $0xa,%edx
80105254:	75 e2                	jne    80105238 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80105256:	5b                   	pop    %ebx
80105257:	5d                   	pop    %ebp
80105258:	c3                   	ret    
80105259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80105260:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80105263:	8d 51 28             	lea    0x28(%ecx),%edx
80105266:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010526d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80105270:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105276:	83 c0 04             	add    $0x4,%eax
80105279:	39 d0                	cmp    %edx,%eax
8010527b:	75 f3                	jne    80105270 <getcallerpcs+0x50>
}
8010527d:	5b                   	pop    %ebx
8010527e:	5d                   	pop    %ebp
8010527f:	c3                   	ret    

80105280 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105280:	f3 0f 1e fb          	endbr32 
80105284:	55                   	push   %ebp
80105285:	89 e5                	mov    %esp,%ebp
80105287:	53                   	push   %ebx
80105288:	83 ec 04             	sub    $0x4,%esp
8010528b:	9c                   	pushf  
8010528c:	5b                   	pop    %ebx
  asm volatile("cli");
8010528d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010528e:	e8 bd eb ff ff       	call   80103e50 <mycpu>
80105293:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105299:	85 c0                	test   %eax,%eax
8010529b:	74 13                	je     801052b0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
8010529d:	e8 ae eb ff ff       	call   80103e50 <mycpu>
801052a2:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801052a9:	83 c4 04             	add    $0x4,%esp
801052ac:	5b                   	pop    %ebx
801052ad:	5d                   	pop    %ebp
801052ae:	c3                   	ret    
801052af:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
801052b0:	e8 9b eb ff ff       	call   80103e50 <mycpu>
801052b5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801052bb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801052c1:	eb da                	jmp    8010529d <pushcli+0x1d>
801052c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801052d0 <popcli>:

void
popcli(void)
{
801052d0:	f3 0f 1e fb          	endbr32 
801052d4:	55                   	push   %ebp
801052d5:	89 e5                	mov    %esp,%ebp
801052d7:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801052da:	9c                   	pushf  
801052db:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801052dc:	f6 c4 02             	test   $0x2,%ah
801052df:	75 31                	jne    80105312 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801052e1:	e8 6a eb ff ff       	call   80103e50 <mycpu>
801052e6:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801052ed:	78 30                	js     8010531f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801052ef:	e8 5c eb ff ff       	call   80103e50 <mycpu>
801052f4:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801052fa:	85 d2                	test   %edx,%edx
801052fc:	74 02                	je     80105300 <popcli+0x30>
    sti();
}
801052fe:	c9                   	leave  
801052ff:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105300:	e8 4b eb ff ff       	call   80103e50 <mycpu>
80105305:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010530b:	85 c0                	test   %eax,%eax
8010530d:	74 ef                	je     801052fe <popcli+0x2e>
  asm volatile("sti");
8010530f:	fb                   	sti    
}
80105310:	c9                   	leave  
80105311:	c3                   	ret    
    panic("popcli - interruptible");
80105312:	83 ec 0c             	sub    $0xc,%esp
80105315:	68 ef 8c 10 80       	push   $0x80108cef
8010531a:	e8 71 b0 ff ff       	call   80100390 <panic>
    panic("popcli");
8010531f:	83 ec 0c             	sub    $0xc,%esp
80105322:	68 06 8d 10 80       	push   $0x80108d06
80105327:	e8 64 b0 ff ff       	call   80100390 <panic>
8010532c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105330 <holding>:
{
80105330:	f3 0f 1e fb          	endbr32 
80105334:	55                   	push   %ebp
80105335:	89 e5                	mov    %esp,%ebp
80105337:	56                   	push   %esi
80105338:	53                   	push   %ebx
80105339:	8b 75 08             	mov    0x8(%ebp),%esi
8010533c:	31 db                	xor    %ebx,%ebx
  pushcli();
8010533e:	e8 3d ff ff ff       	call   80105280 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80105343:	8b 06                	mov    (%esi),%eax
80105345:	85 c0                	test   %eax,%eax
80105347:	75 0f                	jne    80105358 <holding+0x28>
  popcli();
80105349:	e8 82 ff ff ff       	call   801052d0 <popcli>
}
8010534e:	89 d8                	mov    %ebx,%eax
80105350:	5b                   	pop    %ebx
80105351:	5e                   	pop    %esi
80105352:	5d                   	pop    %ebp
80105353:	c3                   	ret    
80105354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80105358:	8b 5e 08             	mov    0x8(%esi),%ebx
8010535b:	e8 f0 ea ff ff       	call   80103e50 <mycpu>
80105360:	39 c3                	cmp    %eax,%ebx
80105362:	0f 94 c3             	sete   %bl
  popcli();
80105365:	e8 66 ff ff ff       	call   801052d0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
8010536a:	0f b6 db             	movzbl %bl,%ebx
}
8010536d:	89 d8                	mov    %ebx,%eax
8010536f:	5b                   	pop    %ebx
80105370:	5e                   	pop    %esi
80105371:	5d                   	pop    %ebp
80105372:	c3                   	ret    
80105373:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010537a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105380 <acquire>:
{
80105380:	f3 0f 1e fb          	endbr32 
80105384:	55                   	push   %ebp
80105385:	89 e5                	mov    %esp,%ebp
80105387:	56                   	push   %esi
80105388:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80105389:	e8 f2 fe ff ff       	call   80105280 <pushcli>
  if(holding(lk))
8010538e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105391:	83 ec 0c             	sub    $0xc,%esp
80105394:	53                   	push   %ebx
80105395:	e8 96 ff ff ff       	call   80105330 <holding>
8010539a:	83 c4 10             	add    $0x10,%esp
8010539d:	85 c0                	test   %eax,%eax
8010539f:	0f 85 7f 00 00 00    	jne    80105424 <acquire+0xa4>
801053a5:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
801053a7:	ba 01 00 00 00       	mov    $0x1,%edx
801053ac:	eb 05                	jmp    801053b3 <acquire+0x33>
801053ae:	66 90                	xchg   %ax,%ax
801053b0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801053b3:	89 d0                	mov    %edx,%eax
801053b5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801053b8:	85 c0                	test   %eax,%eax
801053ba:	75 f4                	jne    801053b0 <acquire+0x30>
  __sync_synchronize();
801053bc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801053c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801053c4:	e8 87 ea ff ff       	call   80103e50 <mycpu>
801053c9:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801053cc:	89 e8                	mov    %ebp,%eax
801053ce:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801053d0:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801053d6:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
801053dc:	77 22                	ja     80105400 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
801053de:	8b 50 04             	mov    0x4(%eax),%edx
801053e1:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
801053e5:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
801053e8:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801053ea:	83 fe 0a             	cmp    $0xa,%esi
801053ed:	75 e1                	jne    801053d0 <acquire+0x50>
}
801053ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053f2:	5b                   	pop    %ebx
801053f3:	5e                   	pop    %esi
801053f4:	5d                   	pop    %ebp
801053f5:	c3                   	ret    
801053f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053fd:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80105400:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80105404:	83 c3 34             	add    $0x34,%ebx
80105407:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010540e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105410:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105416:	83 c0 04             	add    $0x4,%eax
80105419:	39 d8                	cmp    %ebx,%eax
8010541b:	75 f3                	jne    80105410 <acquire+0x90>
}
8010541d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105420:	5b                   	pop    %ebx
80105421:	5e                   	pop    %esi
80105422:	5d                   	pop    %ebp
80105423:	c3                   	ret    
    panic("acquire");
80105424:	83 ec 0c             	sub    $0xc,%esp
80105427:	68 0d 8d 10 80       	push   $0x80108d0d
8010542c:	e8 5f af ff ff       	call   80100390 <panic>
80105431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105438:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010543f:	90                   	nop

80105440 <release>:
{
80105440:	f3 0f 1e fb          	endbr32 
80105444:	55                   	push   %ebp
80105445:	89 e5                	mov    %esp,%ebp
80105447:	53                   	push   %ebx
80105448:	83 ec 10             	sub    $0x10,%esp
8010544b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010544e:	53                   	push   %ebx
8010544f:	e8 dc fe ff ff       	call   80105330 <holding>
80105454:	83 c4 10             	add    $0x10,%esp
80105457:	85 c0                	test   %eax,%eax
80105459:	74 22                	je     8010547d <release+0x3d>
  lk->pcs[0] = 0;
8010545b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80105462:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105469:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010546e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105474:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105477:	c9                   	leave  
  popcli();
80105478:	e9 53 fe ff ff       	jmp    801052d0 <popcli>
    panic("release");
8010547d:	83 ec 0c             	sub    $0xc,%esp
80105480:	68 15 8d 10 80       	push   $0x80108d15
80105485:	e8 06 af ff ff       	call   80100390 <panic>
8010548a:	66 90                	xchg   %ax,%ax
8010548c:	66 90                	xchg   %ax,%ax
8010548e:	66 90                	xchg   %ax,%ax

80105490 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105490:	f3 0f 1e fb          	endbr32 
80105494:	55                   	push   %ebp
80105495:	89 e5                	mov    %esp,%ebp
80105497:	57                   	push   %edi
80105498:	8b 55 08             	mov    0x8(%ebp),%edx
8010549b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010549e:	53                   	push   %ebx
8010549f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801054a2:	89 d7                	mov    %edx,%edi
801054a4:	09 cf                	or     %ecx,%edi
801054a6:	83 e7 03             	and    $0x3,%edi
801054a9:	75 25                	jne    801054d0 <memset+0x40>
    c &= 0xFF;
801054ab:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801054ae:	c1 e0 18             	shl    $0x18,%eax
801054b1:	89 fb                	mov    %edi,%ebx
801054b3:	c1 e9 02             	shr    $0x2,%ecx
801054b6:	c1 e3 10             	shl    $0x10,%ebx
801054b9:	09 d8                	or     %ebx,%eax
801054bb:	09 f8                	or     %edi,%eax
801054bd:	c1 e7 08             	shl    $0x8,%edi
801054c0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801054c2:	89 d7                	mov    %edx,%edi
801054c4:	fc                   	cld    
801054c5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801054c7:	5b                   	pop    %ebx
801054c8:	89 d0                	mov    %edx,%eax
801054ca:	5f                   	pop    %edi
801054cb:	5d                   	pop    %ebp
801054cc:	c3                   	ret    
801054cd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
801054d0:	89 d7                	mov    %edx,%edi
801054d2:	fc                   	cld    
801054d3:	f3 aa                	rep stos %al,%es:(%edi)
801054d5:	5b                   	pop    %ebx
801054d6:	89 d0                	mov    %edx,%eax
801054d8:	5f                   	pop    %edi
801054d9:	5d                   	pop    %ebp
801054da:	c3                   	ret    
801054db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054df:	90                   	nop

801054e0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801054e0:	f3 0f 1e fb          	endbr32 
801054e4:	55                   	push   %ebp
801054e5:	89 e5                	mov    %esp,%ebp
801054e7:	56                   	push   %esi
801054e8:	8b 75 10             	mov    0x10(%ebp),%esi
801054eb:	8b 55 08             	mov    0x8(%ebp),%edx
801054ee:	53                   	push   %ebx
801054ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801054f2:	85 f6                	test   %esi,%esi
801054f4:	74 2a                	je     80105520 <memcmp+0x40>
801054f6:	01 c6                	add    %eax,%esi
801054f8:	eb 10                	jmp    8010550a <memcmp+0x2a>
801054fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80105500:	83 c0 01             	add    $0x1,%eax
80105503:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80105506:	39 f0                	cmp    %esi,%eax
80105508:	74 16                	je     80105520 <memcmp+0x40>
    if(*s1 != *s2)
8010550a:	0f b6 0a             	movzbl (%edx),%ecx
8010550d:	0f b6 18             	movzbl (%eax),%ebx
80105510:	38 d9                	cmp    %bl,%cl
80105512:	74 ec                	je     80105500 <memcmp+0x20>
      return *s1 - *s2;
80105514:	0f b6 c1             	movzbl %cl,%eax
80105517:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80105519:	5b                   	pop    %ebx
8010551a:	5e                   	pop    %esi
8010551b:	5d                   	pop    %ebp
8010551c:	c3                   	ret    
8010551d:	8d 76 00             	lea    0x0(%esi),%esi
80105520:	5b                   	pop    %ebx
  return 0;
80105521:	31 c0                	xor    %eax,%eax
}
80105523:	5e                   	pop    %esi
80105524:	5d                   	pop    %ebp
80105525:	c3                   	ret    
80105526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010552d:	8d 76 00             	lea    0x0(%esi),%esi

80105530 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105530:	f3 0f 1e fb          	endbr32 
80105534:	55                   	push   %ebp
80105535:	89 e5                	mov    %esp,%ebp
80105537:	57                   	push   %edi
80105538:	8b 55 08             	mov    0x8(%ebp),%edx
8010553b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010553e:	56                   	push   %esi
8010553f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105542:	39 d6                	cmp    %edx,%esi
80105544:	73 2a                	jae    80105570 <memmove+0x40>
80105546:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80105549:	39 fa                	cmp    %edi,%edx
8010554b:	73 23                	jae    80105570 <memmove+0x40>
8010554d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80105550:	85 c9                	test   %ecx,%ecx
80105552:	74 13                	je     80105567 <memmove+0x37>
80105554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80105558:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
8010555c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
8010555f:	83 e8 01             	sub    $0x1,%eax
80105562:	83 f8 ff             	cmp    $0xffffffff,%eax
80105565:	75 f1                	jne    80105558 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80105567:	5e                   	pop    %esi
80105568:	89 d0                	mov    %edx,%eax
8010556a:	5f                   	pop    %edi
8010556b:	5d                   	pop    %ebp
8010556c:	c3                   	ret    
8010556d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80105570:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80105573:	89 d7                	mov    %edx,%edi
80105575:	85 c9                	test   %ecx,%ecx
80105577:	74 ee                	je     80105567 <memmove+0x37>
80105579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80105580:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80105581:	39 f0                	cmp    %esi,%eax
80105583:	75 fb                	jne    80105580 <memmove+0x50>
}
80105585:	5e                   	pop    %esi
80105586:	89 d0                	mov    %edx,%eax
80105588:	5f                   	pop    %edi
80105589:	5d                   	pop    %ebp
8010558a:	c3                   	ret    
8010558b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010558f:	90                   	nop

80105590 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105590:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80105594:	eb 9a                	jmp    80105530 <memmove>
80105596:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010559d:	8d 76 00             	lea    0x0(%esi),%esi

801055a0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801055a0:	f3 0f 1e fb          	endbr32 
801055a4:	55                   	push   %ebp
801055a5:	89 e5                	mov    %esp,%ebp
801055a7:	56                   	push   %esi
801055a8:	8b 75 10             	mov    0x10(%ebp),%esi
801055ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
801055ae:	53                   	push   %ebx
801055af:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
801055b2:	85 f6                	test   %esi,%esi
801055b4:	74 32                	je     801055e8 <strncmp+0x48>
801055b6:	01 c6                	add    %eax,%esi
801055b8:	eb 14                	jmp    801055ce <strncmp+0x2e>
801055ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801055c0:	38 da                	cmp    %bl,%dl
801055c2:	75 14                	jne    801055d8 <strncmp+0x38>
    n--, p++, q++;
801055c4:	83 c0 01             	add    $0x1,%eax
801055c7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801055ca:	39 f0                	cmp    %esi,%eax
801055cc:	74 1a                	je     801055e8 <strncmp+0x48>
801055ce:	0f b6 11             	movzbl (%ecx),%edx
801055d1:	0f b6 18             	movzbl (%eax),%ebx
801055d4:	84 d2                	test   %dl,%dl
801055d6:	75 e8                	jne    801055c0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801055d8:	0f b6 c2             	movzbl %dl,%eax
801055db:	29 d8                	sub    %ebx,%eax
}
801055dd:	5b                   	pop    %ebx
801055de:	5e                   	pop    %esi
801055df:	5d                   	pop    %ebp
801055e0:	c3                   	ret    
801055e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055e8:	5b                   	pop    %ebx
    return 0;
801055e9:	31 c0                	xor    %eax,%eax
}
801055eb:	5e                   	pop    %esi
801055ec:	5d                   	pop    %ebp
801055ed:	c3                   	ret    
801055ee:	66 90                	xchg   %ax,%ax

801055f0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801055f0:	f3 0f 1e fb          	endbr32 
801055f4:	55                   	push   %ebp
801055f5:	89 e5                	mov    %esp,%ebp
801055f7:	57                   	push   %edi
801055f8:	56                   	push   %esi
801055f9:	8b 75 08             	mov    0x8(%ebp),%esi
801055fc:	53                   	push   %ebx
801055fd:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80105600:	89 f2                	mov    %esi,%edx
80105602:	eb 1b                	jmp    8010561f <strncpy+0x2f>
80105604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105608:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
8010560c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010560f:	83 c2 01             	add    $0x1,%edx
80105612:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80105616:	89 f9                	mov    %edi,%ecx
80105618:	88 4a ff             	mov    %cl,-0x1(%edx)
8010561b:	84 c9                	test   %cl,%cl
8010561d:	74 09                	je     80105628 <strncpy+0x38>
8010561f:	89 c3                	mov    %eax,%ebx
80105621:	83 e8 01             	sub    $0x1,%eax
80105624:	85 db                	test   %ebx,%ebx
80105626:	7f e0                	jg     80105608 <strncpy+0x18>
    ;
  while(n-- > 0)
80105628:	89 d1                	mov    %edx,%ecx
8010562a:	85 c0                	test   %eax,%eax
8010562c:	7e 15                	jle    80105643 <strncpy+0x53>
8010562e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80105630:	83 c1 01             	add    $0x1,%ecx
80105633:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80105637:	89 c8                	mov    %ecx,%eax
80105639:	f7 d0                	not    %eax
8010563b:	01 d0                	add    %edx,%eax
8010563d:	01 d8                	add    %ebx,%eax
8010563f:	85 c0                	test   %eax,%eax
80105641:	7f ed                	jg     80105630 <strncpy+0x40>
  return os;
}
80105643:	5b                   	pop    %ebx
80105644:	89 f0                	mov    %esi,%eax
80105646:	5e                   	pop    %esi
80105647:	5f                   	pop    %edi
80105648:	5d                   	pop    %ebp
80105649:	c3                   	ret    
8010564a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105650 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105650:	f3 0f 1e fb          	endbr32 
80105654:	55                   	push   %ebp
80105655:	89 e5                	mov    %esp,%ebp
80105657:	56                   	push   %esi
80105658:	8b 55 10             	mov    0x10(%ebp),%edx
8010565b:	8b 75 08             	mov    0x8(%ebp),%esi
8010565e:	53                   	push   %ebx
8010565f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80105662:	85 d2                	test   %edx,%edx
80105664:	7e 21                	jle    80105687 <safestrcpy+0x37>
80105666:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
8010566a:	89 f2                	mov    %esi,%edx
8010566c:	eb 12                	jmp    80105680 <safestrcpy+0x30>
8010566e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105670:	0f b6 08             	movzbl (%eax),%ecx
80105673:	83 c0 01             	add    $0x1,%eax
80105676:	83 c2 01             	add    $0x1,%edx
80105679:	88 4a ff             	mov    %cl,-0x1(%edx)
8010567c:	84 c9                	test   %cl,%cl
8010567e:	74 04                	je     80105684 <safestrcpy+0x34>
80105680:	39 d8                	cmp    %ebx,%eax
80105682:	75 ec                	jne    80105670 <safestrcpy+0x20>
    ;
  *s = 0;
80105684:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105687:	89 f0                	mov    %esi,%eax
80105689:	5b                   	pop    %ebx
8010568a:	5e                   	pop    %esi
8010568b:	5d                   	pop    %ebp
8010568c:	c3                   	ret    
8010568d:	8d 76 00             	lea    0x0(%esi),%esi

80105690 <strlen>:

int
strlen(const char *s)
{
80105690:	f3 0f 1e fb          	endbr32 
80105694:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105695:	31 c0                	xor    %eax,%eax
{
80105697:	89 e5                	mov    %esp,%ebp
80105699:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
8010569c:	80 3a 00             	cmpb   $0x0,(%edx)
8010569f:	74 10                	je     801056b1 <strlen+0x21>
801056a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056a8:	83 c0 01             	add    $0x1,%eax
801056ab:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801056af:	75 f7                	jne    801056a8 <strlen+0x18>
    ;
  return n;
}
801056b1:	5d                   	pop    %ebp
801056b2:	c3                   	ret    

801056b3 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801056b3:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801056b7:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801056bb:	55                   	push   %ebp
  pushl %ebx
801056bc:	53                   	push   %ebx
  pushl %esi
801056bd:	56                   	push   %esi
  pushl %edi
801056be:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801056bf:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801056c1:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801056c3:	5f                   	pop    %edi
  popl %esi
801056c4:	5e                   	pop    %esi
  popl %ebx
801056c5:	5b                   	pop    %ebx
  popl %ebp
801056c6:	5d                   	pop    %ebp
  ret
801056c7:	c3                   	ret    
801056c8:	66 90                	xchg   %ax,%ax
801056ca:	66 90                	xchg   %ax,%ax
801056cc:	66 90                	xchg   %ax,%ax
801056ce:	66 90                	xchg   %ax,%ax

801056d0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801056d0:	f3 0f 1e fb          	endbr32 
801056d4:	55                   	push   %ebp
801056d5:	89 e5                	mov    %esp,%ebp
801056d7:	53                   	push   %ebx
801056d8:	83 ec 04             	sub    $0x4,%esp
801056db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801056de:	e8 fd e7 ff ff       	call   80103ee0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801056e3:	8b 00                	mov    (%eax),%eax
801056e5:	39 d8                	cmp    %ebx,%eax
801056e7:	76 17                	jbe    80105700 <fetchint+0x30>
801056e9:	8d 53 04             	lea    0x4(%ebx),%edx
801056ec:	39 d0                	cmp    %edx,%eax
801056ee:	72 10                	jb     80105700 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801056f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801056f3:	8b 13                	mov    (%ebx),%edx
801056f5:	89 10                	mov    %edx,(%eax)
  return 0;
801056f7:	31 c0                	xor    %eax,%eax
}
801056f9:	83 c4 04             	add    $0x4,%esp
801056fc:	5b                   	pop    %ebx
801056fd:	5d                   	pop    %ebp
801056fe:	c3                   	ret    
801056ff:	90                   	nop
    return -1;
80105700:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105705:	eb f2                	jmp    801056f9 <fetchint+0x29>
80105707:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010570e:	66 90                	xchg   %ax,%ax

80105710 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105710:	f3 0f 1e fb          	endbr32 
80105714:	55                   	push   %ebp
80105715:	89 e5                	mov    %esp,%ebp
80105717:	53                   	push   %ebx
80105718:	83 ec 04             	sub    $0x4,%esp
8010571b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010571e:	e8 bd e7 ff ff       	call   80103ee0 <myproc>

  if(addr >= curproc->sz)
80105723:	39 18                	cmp    %ebx,(%eax)
80105725:	76 31                	jbe    80105758 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80105727:	8b 55 0c             	mov    0xc(%ebp),%edx
8010572a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010572c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010572e:	39 d3                	cmp    %edx,%ebx
80105730:	73 26                	jae    80105758 <fetchstr+0x48>
80105732:	89 d8                	mov    %ebx,%eax
80105734:	eb 11                	jmp    80105747 <fetchstr+0x37>
80105736:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010573d:	8d 76 00             	lea    0x0(%esi),%esi
80105740:	83 c0 01             	add    $0x1,%eax
80105743:	39 c2                	cmp    %eax,%edx
80105745:	76 11                	jbe    80105758 <fetchstr+0x48>
    if(*s == 0)
80105747:	80 38 00             	cmpb   $0x0,(%eax)
8010574a:	75 f4                	jne    80105740 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
8010574c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
8010574f:	29 d8                	sub    %ebx,%eax
}
80105751:	5b                   	pop    %ebx
80105752:	5d                   	pop    %ebp
80105753:	c3                   	ret    
80105754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105758:	83 c4 04             	add    $0x4,%esp
    return -1;
8010575b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105760:	5b                   	pop    %ebx
80105761:	5d                   	pop    %ebp
80105762:	c3                   	ret    
80105763:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010576a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105770 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105770:	f3 0f 1e fb          	endbr32 
80105774:	55                   	push   %ebp
80105775:	89 e5                	mov    %esp,%ebp
80105777:	56                   	push   %esi
80105778:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105779:	e8 62 e7 ff ff       	call   80103ee0 <myproc>
8010577e:	8b 55 08             	mov    0x8(%ebp),%edx
80105781:	8b 40 18             	mov    0x18(%eax),%eax
80105784:	8b 40 44             	mov    0x44(%eax),%eax
80105787:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
8010578a:	e8 51 e7 ff ff       	call   80103ee0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010578f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105792:	8b 00                	mov    (%eax),%eax
80105794:	39 c6                	cmp    %eax,%esi
80105796:	73 18                	jae    801057b0 <argint+0x40>
80105798:	8d 53 08             	lea    0x8(%ebx),%edx
8010579b:	39 d0                	cmp    %edx,%eax
8010579d:	72 11                	jb     801057b0 <argint+0x40>
  *ip = *(int*)(addr);
8010579f:	8b 45 0c             	mov    0xc(%ebp),%eax
801057a2:	8b 53 04             	mov    0x4(%ebx),%edx
801057a5:	89 10                	mov    %edx,(%eax)
  return 0;
801057a7:	31 c0                	xor    %eax,%eax
}
801057a9:	5b                   	pop    %ebx
801057aa:	5e                   	pop    %esi
801057ab:	5d                   	pop    %ebp
801057ac:	c3                   	ret    
801057ad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801057b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801057b5:	eb f2                	jmp    801057a9 <argint+0x39>
801057b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057be:	66 90                	xchg   %ax,%ax

801057c0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801057c0:	f3 0f 1e fb          	endbr32 
801057c4:	55                   	push   %ebp
801057c5:	89 e5                	mov    %esp,%ebp
801057c7:	56                   	push   %esi
801057c8:	53                   	push   %ebx
801057c9:	83 ec 10             	sub    $0x10,%esp
801057cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801057cf:	e8 0c e7 ff ff       	call   80103ee0 <myproc>
 
  if(argint(n, &i) < 0)
801057d4:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
801057d7:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
801057d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057dc:	50                   	push   %eax
801057dd:	ff 75 08             	pushl  0x8(%ebp)
801057e0:	e8 8b ff ff ff       	call   80105770 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801057e5:	83 c4 10             	add    $0x10,%esp
801057e8:	85 c0                	test   %eax,%eax
801057ea:	78 24                	js     80105810 <argptr+0x50>
801057ec:	85 db                	test   %ebx,%ebx
801057ee:	78 20                	js     80105810 <argptr+0x50>
801057f0:	8b 16                	mov    (%esi),%edx
801057f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057f5:	39 c2                	cmp    %eax,%edx
801057f7:	76 17                	jbe    80105810 <argptr+0x50>
801057f9:	01 c3                	add    %eax,%ebx
801057fb:	39 da                	cmp    %ebx,%edx
801057fd:	72 11                	jb     80105810 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801057ff:	8b 55 0c             	mov    0xc(%ebp),%edx
80105802:	89 02                	mov    %eax,(%edx)
  return 0;
80105804:	31 c0                	xor    %eax,%eax
}
80105806:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105809:	5b                   	pop    %ebx
8010580a:	5e                   	pop    %esi
8010580b:	5d                   	pop    %ebp
8010580c:	c3                   	ret    
8010580d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105810:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105815:	eb ef                	jmp    80105806 <argptr+0x46>
80105817:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010581e:	66 90                	xchg   %ax,%ax

80105820 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105820:	f3 0f 1e fb          	endbr32 
80105824:	55                   	push   %ebp
80105825:	89 e5                	mov    %esp,%ebp
80105827:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010582a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010582d:	50                   	push   %eax
8010582e:	ff 75 08             	pushl  0x8(%ebp)
80105831:	e8 3a ff ff ff       	call   80105770 <argint>
80105836:	83 c4 10             	add    $0x10,%esp
80105839:	85 c0                	test   %eax,%eax
8010583b:	78 13                	js     80105850 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010583d:	83 ec 08             	sub    $0x8,%esp
80105840:	ff 75 0c             	pushl  0xc(%ebp)
80105843:	ff 75 f4             	pushl  -0xc(%ebp)
80105846:	e8 c5 fe ff ff       	call   80105710 <fetchstr>
8010584b:	83 c4 10             	add    $0x10,%esp
}
8010584e:	c9                   	leave  
8010584f:	c3                   	ret    
80105850:	c9                   	leave  
    return -1;
80105851:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105856:	c3                   	ret    
80105857:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010585e:	66 90                	xchg   %ax,%ax

80105860 <syscall>:

};

void
syscall(void)
{
80105860:	f3 0f 1e fb          	endbr32 
80105864:	55                   	push   %ebp
80105865:	89 e5                	mov    %esp,%ebp
80105867:	53                   	push   %ebx
80105868:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
8010586b:	e8 70 e6 ff ff       	call   80103ee0 <myproc>
80105870:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105872:	8b 40 18             	mov    0x18(%eax),%eax
80105875:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105878:	8d 50 ff             	lea    -0x1(%eax),%edx
8010587b:	83 fa 15             	cmp    $0x15,%edx
8010587e:	77 20                	ja     801058a0 <syscall+0x40>
80105880:	8b 14 85 40 8d 10 80 	mov    -0x7fef72c0(,%eax,4),%edx
80105887:	85 d2                	test   %edx,%edx
80105889:	74 15                	je     801058a0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
8010588b:	ff d2                	call   *%edx
8010588d:	89 c2                	mov    %eax,%edx
8010588f:	8b 43 18             	mov    0x18(%ebx),%eax
80105892:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105895:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105898:	c9                   	leave  
80105899:	c3                   	ret    
8010589a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
801058a0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801058a1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801058a4:	50                   	push   %eax
801058a5:	ff 73 10             	pushl  0x10(%ebx)
801058a8:	68 1d 8d 10 80       	push   $0x80108d1d
801058ad:	e8 fe ad ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
801058b2:	8b 43 18             	mov    0x18(%ebx),%eax
801058b5:	83 c4 10             	add    $0x10,%esp
801058b8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801058bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058c2:	c9                   	leave  
801058c3:	c3                   	ret    
801058c4:	66 90                	xchg   %ax,%ax
801058c6:	66 90                	xchg   %ax,%ax
801058c8:	66 90                	xchg   %ax,%ax
801058ca:	66 90                	xchg   %ax,%ax
801058cc:	66 90                	xchg   %ax,%ax
801058ce:	66 90                	xchg   %ax,%ax

801058d0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
801058d0:	55                   	push   %ebp
801058d1:	89 e5                	mov    %esp,%ebp
801058d3:	56                   	push   %esi
801058d4:	89 d6                	mov    %edx,%esi
801058d6:	53                   	push   %ebx
801058d7:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801058d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
801058dc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801058df:	50                   	push   %eax
801058e0:	6a 00                	push   $0x0
801058e2:	e8 89 fe ff ff       	call   80105770 <argint>
801058e7:	83 c4 10             	add    $0x10,%esp
801058ea:	85 c0                	test   %eax,%eax
801058ec:	78 2a                	js     80105918 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801058ee:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801058f2:	77 24                	ja     80105918 <argfd.constprop.0+0x48>
801058f4:	e8 e7 e5 ff ff       	call   80103ee0 <myproc>
801058f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801058fc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105900:	85 c0                	test   %eax,%eax
80105902:	74 14                	je     80105918 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
80105904:	85 db                	test   %ebx,%ebx
80105906:	74 02                	je     8010590a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105908:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
8010590a:	89 06                	mov    %eax,(%esi)
  return 0;
8010590c:	31 c0                	xor    %eax,%eax
}
8010590e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105911:	5b                   	pop    %ebx
80105912:	5e                   	pop    %esi
80105913:	5d                   	pop    %ebp
80105914:	c3                   	ret    
80105915:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105918:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010591d:	eb ef                	jmp    8010590e <argfd.constprop.0+0x3e>
8010591f:	90                   	nop

80105920 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80105920:	f3 0f 1e fb          	endbr32 
80105924:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105925:	31 c0                	xor    %eax,%eax
{
80105927:	89 e5                	mov    %esp,%ebp
80105929:	56                   	push   %esi
8010592a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
8010592b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010592e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80105931:	e8 9a ff ff ff       	call   801058d0 <argfd.constprop.0>
80105936:	85 c0                	test   %eax,%eax
80105938:	78 1e                	js     80105958 <sys_dup+0x38>
    return -1;
  if((fd=fdalloc(f)) < 0)
8010593a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
8010593d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010593f:	e8 9c e5 ff ff       	call   80103ee0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105948:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
8010594c:	85 d2                	test   %edx,%edx
8010594e:	74 20                	je     80105970 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80105950:	83 c3 01             	add    $0x1,%ebx
80105953:	83 fb 10             	cmp    $0x10,%ebx
80105956:	75 f0                	jne    80105948 <sys_dup+0x28>
    return -1;
  filedup(f);
  return fd;
}
80105958:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010595b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105960:	89 d8                	mov    %ebx,%eax
80105962:	5b                   	pop    %ebx
80105963:	5e                   	pop    %esi
80105964:	5d                   	pop    %ebp
80105965:	c3                   	ret    
80105966:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010596d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105970:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105974:	83 ec 0c             	sub    $0xc,%esp
80105977:	ff 75 f4             	pushl  -0xc(%ebp)
8010597a:	e8 f1 b4 ff ff       	call   80100e70 <filedup>
  return fd;
8010597f:	83 c4 10             	add    $0x10,%esp
}
80105982:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105985:	89 d8                	mov    %ebx,%eax
80105987:	5b                   	pop    %ebx
80105988:	5e                   	pop    %esi
80105989:	5d                   	pop    %ebp
8010598a:	c3                   	ret    
8010598b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010598f:	90                   	nop

80105990 <sys_read>:

int
sys_read(void)
{
80105990:	f3 0f 1e fb          	endbr32 
80105994:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105995:	31 c0                	xor    %eax,%eax
{
80105997:	89 e5                	mov    %esp,%ebp
80105999:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010599c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010599f:	e8 2c ff ff ff       	call   801058d0 <argfd.constprop.0>
801059a4:	85 c0                	test   %eax,%eax
801059a6:	78 48                	js     801059f0 <sys_read+0x60>
801059a8:	83 ec 08             	sub    $0x8,%esp
801059ab:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059ae:	50                   	push   %eax
801059af:	6a 02                	push   $0x2
801059b1:	e8 ba fd ff ff       	call   80105770 <argint>
801059b6:	83 c4 10             	add    $0x10,%esp
801059b9:	85 c0                	test   %eax,%eax
801059bb:	78 33                	js     801059f0 <sys_read+0x60>
801059bd:	83 ec 04             	sub    $0x4,%esp
801059c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059c3:	ff 75 f0             	pushl  -0x10(%ebp)
801059c6:	50                   	push   %eax
801059c7:	6a 01                	push   $0x1
801059c9:	e8 f2 fd ff ff       	call   801057c0 <argptr>
801059ce:	83 c4 10             	add    $0x10,%esp
801059d1:	85 c0                	test   %eax,%eax
801059d3:	78 1b                	js     801059f0 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
801059d5:	83 ec 04             	sub    $0x4,%esp
801059d8:	ff 75 f0             	pushl  -0x10(%ebp)
801059db:	ff 75 f4             	pushl  -0xc(%ebp)
801059de:	ff 75 ec             	pushl  -0x14(%ebp)
801059e1:	e8 0a b6 ff ff       	call   80100ff0 <fileread>
801059e6:	83 c4 10             	add    $0x10,%esp
}
801059e9:	c9                   	leave  
801059ea:	c3                   	ret    
801059eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059ef:	90                   	nop
801059f0:	c9                   	leave  
    return -1;
801059f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059f6:	c3                   	ret    
801059f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059fe:	66 90                	xchg   %ax,%ax

80105a00 <sys_write>:

int
sys_write(void)
{
80105a00:	f3 0f 1e fb          	endbr32 
80105a04:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105a05:	31 c0                	xor    %eax,%eax
{
80105a07:	89 e5                	mov    %esp,%ebp
80105a09:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105a0c:	8d 55 ec             	lea    -0x14(%ebp),%edx
80105a0f:	e8 bc fe ff ff       	call   801058d0 <argfd.constprop.0>
80105a14:	85 c0                	test   %eax,%eax
80105a16:	78 48                	js     80105a60 <sys_write+0x60>
80105a18:	83 ec 08             	sub    $0x8,%esp
80105a1b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a1e:	50                   	push   %eax
80105a1f:	6a 02                	push   $0x2
80105a21:	e8 4a fd ff ff       	call   80105770 <argint>
80105a26:	83 c4 10             	add    $0x10,%esp
80105a29:	85 c0                	test   %eax,%eax
80105a2b:	78 33                	js     80105a60 <sys_write+0x60>
80105a2d:	83 ec 04             	sub    $0x4,%esp
80105a30:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a33:	ff 75 f0             	pushl  -0x10(%ebp)
80105a36:	50                   	push   %eax
80105a37:	6a 01                	push   $0x1
80105a39:	e8 82 fd ff ff       	call   801057c0 <argptr>
80105a3e:	83 c4 10             	add    $0x10,%esp
80105a41:	85 c0                	test   %eax,%eax
80105a43:	78 1b                	js     80105a60 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80105a45:	83 ec 04             	sub    $0x4,%esp
80105a48:	ff 75 f0             	pushl  -0x10(%ebp)
80105a4b:	ff 75 f4             	pushl  -0xc(%ebp)
80105a4e:	ff 75 ec             	pushl  -0x14(%ebp)
80105a51:	e8 3a b6 ff ff       	call   80101090 <filewrite>
80105a56:	83 c4 10             	add    $0x10,%esp
}
80105a59:	c9                   	leave  
80105a5a:	c3                   	ret    
80105a5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a5f:	90                   	nop
80105a60:	c9                   	leave  
    return -1;
80105a61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a66:	c3                   	ret    
80105a67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a6e:	66 90                	xchg   %ax,%ax

80105a70 <sys_close>:

int
sys_close(void)
{
80105a70:	f3 0f 1e fb          	endbr32 
80105a74:	55                   	push   %ebp
80105a75:	89 e5                	mov    %esp,%ebp
80105a77:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105a7a:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105a7d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a80:	e8 4b fe ff ff       	call   801058d0 <argfd.constprop.0>
80105a85:	85 c0                	test   %eax,%eax
80105a87:	78 27                	js     80105ab0 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80105a89:	e8 52 e4 ff ff       	call   80103ee0 <myproc>
80105a8e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105a91:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105a94:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105a9b:	00 
  fileclose(f);
80105a9c:	ff 75 f4             	pushl  -0xc(%ebp)
80105a9f:	e8 1c b4 ff ff       	call   80100ec0 <fileclose>
  return 0;
80105aa4:	83 c4 10             	add    $0x10,%esp
80105aa7:	31 c0                	xor    %eax,%eax
}
80105aa9:	c9                   	leave  
80105aaa:	c3                   	ret    
80105aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105aaf:	90                   	nop
80105ab0:	c9                   	leave  
    return -1;
80105ab1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ab6:	c3                   	ret    
80105ab7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105abe:	66 90                	xchg   %ax,%ax

80105ac0 <sys_fstat>:

int
sys_fstat(void)
{
80105ac0:	f3 0f 1e fb          	endbr32 
80105ac4:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105ac5:	31 c0                	xor    %eax,%eax
{
80105ac7:	89 e5                	mov    %esp,%ebp
80105ac9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105acc:	8d 55 f0             	lea    -0x10(%ebp),%edx
80105acf:	e8 fc fd ff ff       	call   801058d0 <argfd.constprop.0>
80105ad4:	85 c0                	test   %eax,%eax
80105ad6:	78 30                	js     80105b08 <sys_fstat+0x48>
80105ad8:	83 ec 04             	sub    $0x4,%esp
80105adb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ade:	6a 14                	push   $0x14
80105ae0:	50                   	push   %eax
80105ae1:	6a 01                	push   $0x1
80105ae3:	e8 d8 fc ff ff       	call   801057c0 <argptr>
80105ae8:	83 c4 10             	add    $0x10,%esp
80105aeb:	85 c0                	test   %eax,%eax
80105aed:	78 19                	js     80105b08 <sys_fstat+0x48>
    return -1;
  return filestat(f, st);
80105aef:	83 ec 08             	sub    $0x8,%esp
80105af2:	ff 75 f4             	pushl  -0xc(%ebp)
80105af5:	ff 75 f0             	pushl  -0x10(%ebp)
80105af8:	e8 a3 b4 ff ff       	call   80100fa0 <filestat>
80105afd:	83 c4 10             	add    $0x10,%esp
}
80105b00:	c9                   	leave  
80105b01:	c3                   	ret    
80105b02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105b08:	c9                   	leave  
    return -1;
80105b09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b0e:	c3                   	ret    
80105b0f:	90                   	nop

80105b10 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105b10:	f3 0f 1e fb          	endbr32 
80105b14:	55                   	push   %ebp
80105b15:	89 e5                	mov    %esp,%ebp
80105b17:	57                   	push   %edi
80105b18:	56                   	push   %esi
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105b19:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105b1c:	53                   	push   %ebx
80105b1d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105b20:	50                   	push   %eax
80105b21:	6a 00                	push   $0x0
80105b23:	e8 f8 fc ff ff       	call   80105820 <argstr>
80105b28:	83 c4 10             	add    $0x10,%esp
80105b2b:	85 c0                	test   %eax,%eax
80105b2d:	0f 88 ff 00 00 00    	js     80105c32 <sys_link+0x122>
80105b33:	83 ec 08             	sub    $0x8,%esp
80105b36:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105b39:	50                   	push   %eax
80105b3a:	6a 01                	push   $0x1
80105b3c:	e8 df fc ff ff       	call   80105820 <argstr>
80105b41:	83 c4 10             	add    $0x10,%esp
80105b44:	85 c0                	test   %eax,%eax
80105b46:	0f 88 e6 00 00 00    	js     80105c32 <sys_link+0x122>
    return -1;

  begin_op();
80105b4c:	e8 4f d6 ff ff       	call   801031a0 <begin_op>
  if((ip = namei(old)) == 0){
80105b51:	83 ec 0c             	sub    $0xc,%esp
80105b54:	ff 75 d4             	pushl  -0x2c(%ebp)
80105b57:	e8 d4 c4 ff ff       	call   80102030 <namei>
80105b5c:	83 c4 10             	add    $0x10,%esp
80105b5f:	89 c3                	mov    %eax,%ebx
80105b61:	85 c0                	test   %eax,%eax
80105b63:	0f 84 e8 00 00 00    	je     80105c51 <sys_link+0x141>
    end_op();
    return -1;
  }

  ilock(ip);
80105b69:	83 ec 0c             	sub    $0xc,%esp
80105b6c:	50                   	push   %eax
80105b6d:	e8 ee bb ff ff       	call   80101760 <ilock>
  if(ip->type == T_DIR){
80105b72:	83 c4 10             	add    $0x10,%esp
80105b75:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105b7a:	0f 84 b9 00 00 00    	je     80105c39 <sys_link+0x129>
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80105b80:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105b83:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105b88:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105b8b:	53                   	push   %ebx
80105b8c:	e8 0f bb ff ff       	call   801016a0 <iupdate>
  iunlock(ip);
80105b91:	89 1c 24             	mov    %ebx,(%esp)
80105b94:	e8 a7 bc ff ff       	call   80101840 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105b99:	58                   	pop    %eax
80105b9a:	5a                   	pop    %edx
80105b9b:	57                   	push   %edi
80105b9c:	ff 75 d0             	pushl  -0x30(%ebp)
80105b9f:	e8 ac c4 ff ff       	call   80102050 <nameiparent>
80105ba4:	83 c4 10             	add    $0x10,%esp
80105ba7:	89 c6                	mov    %eax,%esi
80105ba9:	85 c0                	test   %eax,%eax
80105bab:	74 5f                	je     80105c0c <sys_link+0xfc>
    goto bad;
  ilock(dp);
80105bad:	83 ec 0c             	sub    $0xc,%esp
80105bb0:	50                   	push   %eax
80105bb1:	e8 aa bb ff ff       	call   80101760 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105bb6:	8b 03                	mov    (%ebx),%eax
80105bb8:	83 c4 10             	add    $0x10,%esp
80105bbb:	39 06                	cmp    %eax,(%esi)
80105bbd:	75 41                	jne    80105c00 <sys_link+0xf0>
80105bbf:	83 ec 04             	sub    $0x4,%esp
80105bc2:	ff 73 04             	pushl  0x4(%ebx)
80105bc5:	57                   	push   %edi
80105bc6:	56                   	push   %esi
80105bc7:	e8 a4 c3 ff ff       	call   80101f70 <dirlink>
80105bcc:	83 c4 10             	add    $0x10,%esp
80105bcf:	85 c0                	test   %eax,%eax
80105bd1:	78 2d                	js     80105c00 <sys_link+0xf0>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80105bd3:	83 ec 0c             	sub    $0xc,%esp
80105bd6:	56                   	push   %esi
80105bd7:	e8 24 be ff ff       	call   80101a00 <iunlockput>
  iput(ip);
80105bdc:	89 1c 24             	mov    %ebx,(%esp)
80105bdf:	e8 ac bc ff ff       	call   80101890 <iput>

  end_op();
80105be4:	e8 27 d6 ff ff       	call   80103210 <end_op>

  return 0;
80105be9:	83 c4 10             	add    $0x10,%esp
80105bec:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80105bee:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bf1:	5b                   	pop    %ebx
80105bf2:	5e                   	pop    %esi
80105bf3:	5f                   	pop    %edi
80105bf4:	5d                   	pop    %ebp
80105bf5:	c3                   	ret    
80105bf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bfd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105c00:	83 ec 0c             	sub    $0xc,%esp
80105c03:	56                   	push   %esi
80105c04:	e8 f7 bd ff ff       	call   80101a00 <iunlockput>
    goto bad;
80105c09:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105c0c:	83 ec 0c             	sub    $0xc,%esp
80105c0f:	53                   	push   %ebx
80105c10:	e8 4b bb ff ff       	call   80101760 <ilock>
  ip->nlink--;
80105c15:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105c1a:	89 1c 24             	mov    %ebx,(%esp)
80105c1d:	e8 7e ba ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80105c22:	89 1c 24             	mov    %ebx,(%esp)
80105c25:	e8 d6 bd ff ff       	call   80101a00 <iunlockput>
  end_op();
80105c2a:	e8 e1 d5 ff ff       	call   80103210 <end_op>
  return -1;
80105c2f:	83 c4 10             	add    $0x10,%esp
80105c32:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c37:	eb b5                	jmp    80105bee <sys_link+0xde>
    iunlockput(ip);
80105c39:	83 ec 0c             	sub    $0xc,%esp
80105c3c:	53                   	push   %ebx
80105c3d:	e8 be bd ff ff       	call   80101a00 <iunlockput>
    end_op();
80105c42:	e8 c9 d5 ff ff       	call   80103210 <end_op>
    return -1;
80105c47:	83 c4 10             	add    $0x10,%esp
80105c4a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c4f:	eb 9d                	jmp    80105bee <sys_link+0xde>
    end_op();
80105c51:	e8 ba d5 ff ff       	call   80103210 <end_op>
    return -1;
80105c56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c5b:	eb 91                	jmp    80105bee <sys_link+0xde>
80105c5d:	8d 76 00             	lea    0x0(%esi),%esi

80105c60 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
80105c60:	f3 0f 1e fb          	endbr32 
80105c64:	55                   	push   %ebp
80105c65:	89 e5                	mov    %esp,%ebp
80105c67:	57                   	push   %edi
80105c68:	56                   	push   %esi
80105c69:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105c6c:	53                   	push   %ebx
80105c6d:	bb 20 00 00 00       	mov    $0x20,%ebx
80105c72:	83 ec 1c             	sub    $0x1c,%esp
80105c75:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105c78:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
80105c7c:	77 0a                	ja     80105c88 <isdirempty+0x28>
80105c7e:	eb 30                	jmp    80105cb0 <isdirempty+0x50>
80105c80:	83 c3 10             	add    $0x10,%ebx
80105c83:	39 5e 58             	cmp    %ebx,0x58(%esi)
80105c86:	76 28                	jbe    80105cb0 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105c88:	6a 10                	push   $0x10
80105c8a:	53                   	push   %ebx
80105c8b:	57                   	push   %edi
80105c8c:	56                   	push   %esi
80105c8d:	e8 ce bd ff ff       	call   80101a60 <readi>
80105c92:	83 c4 10             	add    $0x10,%esp
80105c95:	83 f8 10             	cmp    $0x10,%eax
80105c98:	75 23                	jne    80105cbd <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
80105c9a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105c9f:	74 df                	je     80105c80 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
80105ca1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80105ca4:	31 c0                	xor    %eax,%eax
}
80105ca6:	5b                   	pop    %ebx
80105ca7:	5e                   	pop    %esi
80105ca8:	5f                   	pop    %edi
80105ca9:	5d                   	pop    %ebp
80105caa:	c3                   	ret    
80105cab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105caf:	90                   	nop
80105cb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
80105cb3:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105cb8:	5b                   	pop    %ebx
80105cb9:	5e                   	pop    %esi
80105cba:	5f                   	pop    %edi
80105cbb:	5d                   	pop    %ebp
80105cbc:	c3                   	ret    
      panic("isdirempty: readi");
80105cbd:	83 ec 0c             	sub    $0xc,%esp
80105cc0:	68 9c 8d 10 80       	push   $0x80108d9c
80105cc5:	e8 c6 a6 ff ff       	call   80100390 <panic>
80105cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105cd0 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105cd0:	f3 0f 1e fb          	endbr32 
80105cd4:	55                   	push   %ebp
80105cd5:	89 e5                	mov    %esp,%ebp
80105cd7:	57                   	push   %edi
80105cd8:	56                   	push   %esi
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105cd9:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105cdc:	53                   	push   %ebx
80105cdd:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80105ce0:	50                   	push   %eax
80105ce1:	6a 00                	push   $0x0
80105ce3:	e8 38 fb ff ff       	call   80105820 <argstr>
80105ce8:	83 c4 10             	add    $0x10,%esp
80105ceb:	85 c0                	test   %eax,%eax
80105ced:	0f 88 5d 01 00 00    	js     80105e50 <sys_unlink+0x180>
    return -1;

  begin_op();
80105cf3:	e8 a8 d4 ff ff       	call   801031a0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105cf8:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105cfb:	83 ec 08             	sub    $0x8,%esp
80105cfe:	53                   	push   %ebx
80105cff:	ff 75 c0             	pushl  -0x40(%ebp)
80105d02:	e8 49 c3 ff ff       	call   80102050 <nameiparent>
80105d07:	83 c4 10             	add    $0x10,%esp
80105d0a:	89 c6                	mov    %eax,%esi
80105d0c:	85 c0                	test   %eax,%eax
80105d0e:	0f 84 43 01 00 00    	je     80105e57 <sys_unlink+0x187>
    end_op();
    return -1;
  }

  ilock(dp);
80105d14:	83 ec 0c             	sub    $0xc,%esp
80105d17:	50                   	push   %eax
80105d18:	e8 43 ba ff ff       	call   80101760 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105d1d:	58                   	pop    %eax
80105d1e:	5a                   	pop    %edx
80105d1f:	68 7d 85 10 80       	push   $0x8010857d
80105d24:	53                   	push   %ebx
80105d25:	e8 66 bf ff ff       	call   80101c90 <namecmp>
80105d2a:	83 c4 10             	add    $0x10,%esp
80105d2d:	85 c0                	test   %eax,%eax
80105d2f:	0f 84 db 00 00 00    	je     80105e10 <sys_unlink+0x140>
80105d35:	83 ec 08             	sub    $0x8,%esp
80105d38:	68 7c 85 10 80       	push   $0x8010857c
80105d3d:	53                   	push   %ebx
80105d3e:	e8 4d bf ff ff       	call   80101c90 <namecmp>
80105d43:	83 c4 10             	add    $0x10,%esp
80105d46:	85 c0                	test   %eax,%eax
80105d48:	0f 84 c2 00 00 00    	je     80105e10 <sys_unlink+0x140>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105d4e:	83 ec 04             	sub    $0x4,%esp
80105d51:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105d54:	50                   	push   %eax
80105d55:	53                   	push   %ebx
80105d56:	56                   	push   %esi
80105d57:	e8 54 bf ff ff       	call   80101cb0 <dirlookup>
80105d5c:	83 c4 10             	add    $0x10,%esp
80105d5f:	89 c3                	mov    %eax,%ebx
80105d61:	85 c0                	test   %eax,%eax
80105d63:	0f 84 a7 00 00 00    	je     80105e10 <sys_unlink+0x140>
    goto bad;
  ilock(ip);
80105d69:	83 ec 0c             	sub    $0xc,%esp
80105d6c:	50                   	push   %eax
80105d6d:	e8 ee b9 ff ff       	call   80101760 <ilock>

  if(ip->nlink < 1)
80105d72:	83 c4 10             	add    $0x10,%esp
80105d75:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105d7a:	0f 8e f3 00 00 00    	jle    80105e73 <sys_unlink+0x1a3>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80105d80:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105d85:	74 69                	je     80105df0 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80105d87:	83 ec 04             	sub    $0x4,%esp
80105d8a:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105d8d:	6a 10                	push   $0x10
80105d8f:	6a 00                	push   $0x0
80105d91:	57                   	push   %edi
80105d92:	e8 f9 f6 ff ff       	call   80105490 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105d97:	6a 10                	push   $0x10
80105d99:	ff 75 c4             	pushl  -0x3c(%ebp)
80105d9c:	57                   	push   %edi
80105d9d:	56                   	push   %esi
80105d9e:	e8 bd bd ff ff       	call   80101b60 <writei>
80105da3:	83 c4 20             	add    $0x20,%esp
80105da6:	83 f8 10             	cmp    $0x10,%eax
80105da9:	0f 85 b7 00 00 00    	jne    80105e66 <sys_unlink+0x196>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80105daf:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105db4:	74 7a                	je     80105e30 <sys_unlink+0x160>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105db6:	83 ec 0c             	sub    $0xc,%esp
80105db9:	56                   	push   %esi
80105dba:	e8 41 bc ff ff       	call   80101a00 <iunlockput>

  ip->nlink--;
80105dbf:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105dc4:	89 1c 24             	mov    %ebx,(%esp)
80105dc7:	e8 d4 b8 ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80105dcc:	89 1c 24             	mov    %ebx,(%esp)
80105dcf:	e8 2c bc ff ff       	call   80101a00 <iunlockput>

  end_op();
80105dd4:	e8 37 d4 ff ff       	call   80103210 <end_op>

  return 0;
80105dd9:	83 c4 10             	add    $0x10,%esp
80105ddc:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80105dde:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105de1:	5b                   	pop    %ebx
80105de2:	5e                   	pop    %esi
80105de3:	5f                   	pop    %edi
80105de4:	5d                   	pop    %ebp
80105de5:	c3                   	ret    
80105de6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ded:	8d 76 00             	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
80105df0:	83 ec 0c             	sub    $0xc,%esp
80105df3:	53                   	push   %ebx
80105df4:	e8 67 fe ff ff       	call   80105c60 <isdirempty>
80105df9:	83 c4 10             	add    $0x10,%esp
80105dfc:	85 c0                	test   %eax,%eax
80105dfe:	75 87                	jne    80105d87 <sys_unlink+0xb7>
    iunlockput(ip);
80105e00:	83 ec 0c             	sub    $0xc,%esp
80105e03:	53                   	push   %ebx
80105e04:	e8 f7 bb ff ff       	call   80101a00 <iunlockput>
    goto bad;
80105e09:	83 c4 10             	add    $0x10,%esp
80105e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
80105e10:	83 ec 0c             	sub    $0xc,%esp
80105e13:	56                   	push   %esi
80105e14:	e8 e7 bb ff ff       	call   80101a00 <iunlockput>
  end_op();
80105e19:	e8 f2 d3 ff ff       	call   80103210 <end_op>
  return -1;
80105e1e:	83 c4 10             	add    $0x10,%esp
80105e21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e26:	eb b6                	jmp    80105dde <sys_unlink+0x10e>
80105e28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e2f:	90                   	nop
    iupdate(dp);
80105e30:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105e33:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105e38:	56                   	push   %esi
80105e39:	e8 62 b8 ff ff       	call   801016a0 <iupdate>
80105e3e:	83 c4 10             	add    $0x10,%esp
80105e41:	e9 70 ff ff ff       	jmp    80105db6 <sys_unlink+0xe6>
80105e46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e4d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105e50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e55:	eb 87                	jmp    80105dde <sys_unlink+0x10e>
    end_op();
80105e57:	e8 b4 d3 ff ff       	call   80103210 <end_op>
    return -1;
80105e5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e61:	e9 78 ff ff ff       	jmp    80105dde <sys_unlink+0x10e>
    panic("unlink: writei");
80105e66:	83 ec 0c             	sub    $0xc,%esp
80105e69:	68 91 85 10 80       	push   $0x80108591
80105e6e:	e8 1d a5 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105e73:	83 ec 0c             	sub    $0xc,%esp
80105e76:	68 7f 85 10 80       	push   $0x8010857f
80105e7b:	e8 10 a5 ff ff       	call   80100390 <panic>

80105e80 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
80105e80:	f3 0f 1e fb          	endbr32 
80105e84:	55                   	push   %ebp
80105e85:	89 e5                	mov    %esp,%ebp
80105e87:	57                   	push   %edi
80105e88:	56                   	push   %esi
80105e89:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105e8a:	8d 5d da             	lea    -0x26(%ebp),%ebx
{
80105e8d:	83 ec 34             	sub    $0x34,%esp
80105e90:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e93:	8b 55 10             	mov    0x10(%ebp),%edx
  if((dp = nameiparent(path, name)) == 0)
80105e96:	53                   	push   %ebx
{
80105e97:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105e9a:	ff 75 08             	pushl  0x8(%ebp)
{
80105e9d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80105ea0:	89 55 d0             	mov    %edx,-0x30(%ebp)
80105ea3:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105ea6:	e8 a5 c1 ff ff       	call   80102050 <nameiparent>
80105eab:	83 c4 10             	add    $0x10,%esp
80105eae:	85 c0                	test   %eax,%eax
80105eb0:	0f 84 3a 01 00 00    	je     80105ff0 <create+0x170>
    return 0;
  ilock(dp);
80105eb6:	83 ec 0c             	sub    $0xc,%esp
80105eb9:	89 c6                	mov    %eax,%esi
80105ebb:	50                   	push   %eax
80105ebc:	e8 9f b8 ff ff       	call   80101760 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105ec1:	83 c4 0c             	add    $0xc,%esp
80105ec4:	6a 00                	push   $0x0
80105ec6:	53                   	push   %ebx
80105ec7:	56                   	push   %esi
80105ec8:	e8 e3 bd ff ff       	call   80101cb0 <dirlookup>
80105ecd:	83 c4 10             	add    $0x10,%esp
80105ed0:	89 c7                	mov    %eax,%edi
80105ed2:	85 c0                	test   %eax,%eax
80105ed4:	74 4a                	je     80105f20 <create+0xa0>
    iunlockput(dp);
80105ed6:	83 ec 0c             	sub    $0xc,%esp
80105ed9:	56                   	push   %esi
80105eda:	e8 21 bb ff ff       	call   80101a00 <iunlockput>
    ilock(ip);
80105edf:	89 3c 24             	mov    %edi,(%esp)
80105ee2:	e8 79 b8 ff ff       	call   80101760 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105ee7:	83 c4 10             	add    $0x10,%esp
80105eea:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105eef:	75 17                	jne    80105f08 <create+0x88>
80105ef1:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105ef6:	75 10                	jne    80105f08 <create+0x88>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105ef8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105efb:	89 f8                	mov    %edi,%eax
80105efd:	5b                   	pop    %ebx
80105efe:	5e                   	pop    %esi
80105eff:	5f                   	pop    %edi
80105f00:	5d                   	pop    %ebp
80105f01:	c3                   	ret    
80105f02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105f08:	83 ec 0c             	sub    $0xc,%esp
80105f0b:	57                   	push   %edi
    return 0;
80105f0c:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105f0e:	e8 ed ba ff ff       	call   80101a00 <iunlockput>
    return 0;
80105f13:	83 c4 10             	add    $0x10,%esp
}
80105f16:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f19:	89 f8                	mov    %edi,%eax
80105f1b:	5b                   	pop    %ebx
80105f1c:	5e                   	pop    %esi
80105f1d:	5f                   	pop    %edi
80105f1e:	5d                   	pop    %ebp
80105f1f:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80105f20:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105f24:	83 ec 08             	sub    $0x8,%esp
80105f27:	50                   	push   %eax
80105f28:	ff 36                	pushl  (%esi)
80105f2a:	e8 b1 b6 ff ff       	call   801015e0 <ialloc>
80105f2f:	83 c4 10             	add    $0x10,%esp
80105f32:	89 c7                	mov    %eax,%edi
80105f34:	85 c0                	test   %eax,%eax
80105f36:	0f 84 cd 00 00 00    	je     80106009 <create+0x189>
  ilock(ip);
80105f3c:	83 ec 0c             	sub    $0xc,%esp
80105f3f:	50                   	push   %eax
80105f40:	e8 1b b8 ff ff       	call   80101760 <ilock>
  ip->major = major;
80105f45:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105f49:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80105f4d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105f51:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105f55:	b8 01 00 00 00       	mov    $0x1,%eax
80105f5a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80105f5e:	89 3c 24             	mov    %edi,(%esp)
80105f61:	e8 3a b7 ff ff       	call   801016a0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105f66:	83 c4 10             	add    $0x10,%esp
80105f69:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105f6e:	74 30                	je     80105fa0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105f70:	83 ec 04             	sub    $0x4,%esp
80105f73:	ff 77 04             	pushl  0x4(%edi)
80105f76:	53                   	push   %ebx
80105f77:	56                   	push   %esi
80105f78:	e8 f3 bf ff ff       	call   80101f70 <dirlink>
80105f7d:	83 c4 10             	add    $0x10,%esp
80105f80:	85 c0                	test   %eax,%eax
80105f82:	78 78                	js     80105ffc <create+0x17c>
  iunlockput(dp);
80105f84:	83 ec 0c             	sub    $0xc,%esp
80105f87:	56                   	push   %esi
80105f88:	e8 73 ba ff ff       	call   80101a00 <iunlockput>
  return ip;
80105f8d:	83 c4 10             	add    $0x10,%esp
}
80105f90:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f93:	89 f8                	mov    %edi,%eax
80105f95:	5b                   	pop    %ebx
80105f96:	5e                   	pop    %esi
80105f97:	5f                   	pop    %edi
80105f98:	5d                   	pop    %ebp
80105f99:	c3                   	ret    
80105f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105fa0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105fa3:	66 83 46 56 01       	addw   $0x1,0x56(%esi)
    iupdate(dp);
80105fa8:	56                   	push   %esi
80105fa9:	e8 f2 b6 ff ff       	call   801016a0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105fae:	83 c4 0c             	add    $0xc,%esp
80105fb1:	ff 77 04             	pushl  0x4(%edi)
80105fb4:	68 7d 85 10 80       	push   $0x8010857d
80105fb9:	57                   	push   %edi
80105fba:	e8 b1 bf ff ff       	call   80101f70 <dirlink>
80105fbf:	83 c4 10             	add    $0x10,%esp
80105fc2:	85 c0                	test   %eax,%eax
80105fc4:	78 18                	js     80105fde <create+0x15e>
80105fc6:	83 ec 04             	sub    $0x4,%esp
80105fc9:	ff 76 04             	pushl  0x4(%esi)
80105fcc:	68 7c 85 10 80       	push   $0x8010857c
80105fd1:	57                   	push   %edi
80105fd2:	e8 99 bf ff ff       	call   80101f70 <dirlink>
80105fd7:	83 c4 10             	add    $0x10,%esp
80105fda:	85 c0                	test   %eax,%eax
80105fdc:	79 92                	jns    80105f70 <create+0xf0>
      panic("create dots");
80105fde:	83 ec 0c             	sub    $0xc,%esp
80105fe1:	68 bd 8d 10 80       	push   $0x80108dbd
80105fe6:	e8 a5 a3 ff ff       	call   80100390 <panic>
80105feb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105fef:	90                   	nop
}
80105ff0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105ff3:	31 ff                	xor    %edi,%edi
}
80105ff5:	5b                   	pop    %ebx
80105ff6:	89 f8                	mov    %edi,%eax
80105ff8:	5e                   	pop    %esi
80105ff9:	5f                   	pop    %edi
80105ffa:	5d                   	pop    %ebp
80105ffb:	c3                   	ret    
    panic("create: dirlink");
80105ffc:	83 ec 0c             	sub    $0xc,%esp
80105fff:	68 c9 8d 10 80       	push   $0x80108dc9
80106004:	e8 87 a3 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80106009:	83 ec 0c             	sub    $0xc,%esp
8010600c:	68 ae 8d 10 80       	push   $0x80108dae
80106011:	e8 7a a3 ff ff       	call   80100390 <panic>
80106016:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010601d:	8d 76 00             	lea    0x0(%esi),%esi

80106020 <sys_open>:

int
sys_open(void)
{
80106020:	f3 0f 1e fb          	endbr32 
80106024:	55                   	push   %ebp
80106025:	89 e5                	mov    %esp,%ebp
80106027:	57                   	push   %edi
80106028:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106029:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
8010602c:	53                   	push   %ebx
8010602d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106030:	50                   	push   %eax
80106031:	6a 00                	push   $0x0
80106033:	e8 e8 f7 ff ff       	call   80105820 <argstr>
80106038:	83 c4 10             	add    $0x10,%esp
8010603b:	85 c0                	test   %eax,%eax
8010603d:	0f 88 8a 00 00 00    	js     801060cd <sys_open+0xad>
80106043:	83 ec 08             	sub    $0x8,%esp
80106046:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106049:	50                   	push   %eax
8010604a:	6a 01                	push   $0x1
8010604c:	e8 1f f7 ff ff       	call   80105770 <argint>
80106051:	83 c4 10             	add    $0x10,%esp
80106054:	85 c0                	test   %eax,%eax
80106056:	78 75                	js     801060cd <sys_open+0xad>
    return -1;

  begin_op();
80106058:	e8 43 d1 ff ff       	call   801031a0 <begin_op>

  if(omode & O_CREATE){
8010605d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80106061:	75 75                	jne    801060d8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80106063:	83 ec 0c             	sub    $0xc,%esp
80106066:	ff 75 e0             	pushl  -0x20(%ebp)
80106069:	e8 c2 bf ff ff       	call   80102030 <namei>
8010606e:	83 c4 10             	add    $0x10,%esp
80106071:	89 c6                	mov    %eax,%esi
80106073:	85 c0                	test   %eax,%eax
80106075:	74 78                	je     801060ef <sys_open+0xcf>
      end_op();
      return -1;
    }
    ilock(ip);
80106077:	83 ec 0c             	sub    $0xc,%esp
8010607a:	50                   	push   %eax
8010607b:	e8 e0 b6 ff ff       	call   80101760 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80106080:	83 c4 10             	add    $0x10,%esp
80106083:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80106088:	0f 84 ba 00 00 00    	je     80106148 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010608e:	e8 6d ad ff ff       	call   80100e00 <filealloc>
80106093:	89 c7                	mov    %eax,%edi
80106095:	85 c0                	test   %eax,%eax
80106097:	74 23                	je     801060bc <sys_open+0x9c>
  struct proc *curproc = myproc();
80106099:	e8 42 de ff ff       	call   80103ee0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010609e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801060a0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801060a4:	85 d2                	test   %edx,%edx
801060a6:	74 58                	je     80106100 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
801060a8:	83 c3 01             	add    $0x1,%ebx
801060ab:	83 fb 10             	cmp    $0x10,%ebx
801060ae:	75 f0                	jne    801060a0 <sys_open+0x80>
    if(f)
      fileclose(f);
801060b0:	83 ec 0c             	sub    $0xc,%esp
801060b3:	57                   	push   %edi
801060b4:	e8 07 ae ff ff       	call   80100ec0 <fileclose>
801060b9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801060bc:	83 ec 0c             	sub    $0xc,%esp
801060bf:	56                   	push   %esi
801060c0:	e8 3b b9 ff ff       	call   80101a00 <iunlockput>
    end_op();
801060c5:	e8 46 d1 ff ff       	call   80103210 <end_op>
    return -1;
801060ca:	83 c4 10             	add    $0x10,%esp
801060cd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801060d2:	eb 65                	jmp    80106139 <sys_open+0x119>
801060d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801060d8:	6a 00                	push   $0x0
801060da:	6a 00                	push   $0x0
801060dc:	6a 02                	push   $0x2
801060de:	ff 75 e0             	pushl  -0x20(%ebp)
801060e1:	e8 9a fd ff ff       	call   80105e80 <create>
    if(ip == 0){
801060e6:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801060e9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801060eb:	85 c0                	test   %eax,%eax
801060ed:	75 9f                	jne    8010608e <sys_open+0x6e>
      end_op();
801060ef:	e8 1c d1 ff ff       	call   80103210 <end_op>
      return -1;
801060f4:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801060f9:	eb 3e                	jmp    80106139 <sys_open+0x119>
801060fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801060ff:	90                   	nop
  }
  iunlock(ip);
80106100:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80106103:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80106107:	56                   	push   %esi
80106108:	e8 33 b7 ff ff       	call   80101840 <iunlock>
  end_op();
8010610d:	e8 fe d0 ff ff       	call   80103210 <end_op>

  f->type = FD_INODE;
80106112:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80106118:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010611b:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
8010611e:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80106121:	89 d0                	mov    %edx,%eax
  f->off = 0;
80106123:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010612a:	f7 d0                	not    %eax
8010612c:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010612f:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80106132:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106135:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80106139:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010613c:	89 d8                	mov    %ebx,%eax
8010613e:	5b                   	pop    %ebx
8010613f:	5e                   	pop    %esi
80106140:	5f                   	pop    %edi
80106141:	5d                   	pop    %ebp
80106142:	c3                   	ret    
80106143:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106147:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80106148:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010614b:	85 c9                	test   %ecx,%ecx
8010614d:	0f 84 3b ff ff ff    	je     8010608e <sys_open+0x6e>
80106153:	e9 64 ff ff ff       	jmp    801060bc <sys_open+0x9c>
80106158:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010615f:	90                   	nop

80106160 <sys_mkdir>:

int
sys_mkdir(void)
{
80106160:	f3 0f 1e fb          	endbr32 
80106164:	55                   	push   %ebp
80106165:	89 e5                	mov    %esp,%ebp
80106167:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010616a:	e8 31 d0 ff ff       	call   801031a0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010616f:	83 ec 08             	sub    $0x8,%esp
80106172:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106175:	50                   	push   %eax
80106176:	6a 00                	push   $0x0
80106178:	e8 a3 f6 ff ff       	call   80105820 <argstr>
8010617d:	83 c4 10             	add    $0x10,%esp
80106180:	85 c0                	test   %eax,%eax
80106182:	78 2c                	js     801061b0 <sys_mkdir+0x50>
80106184:	6a 00                	push   $0x0
80106186:	6a 00                	push   $0x0
80106188:	6a 01                	push   $0x1
8010618a:	ff 75 f4             	pushl  -0xc(%ebp)
8010618d:	e8 ee fc ff ff       	call   80105e80 <create>
80106192:	83 c4 10             	add    $0x10,%esp
80106195:	85 c0                	test   %eax,%eax
80106197:	74 17                	je     801061b0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80106199:	83 ec 0c             	sub    $0xc,%esp
8010619c:	50                   	push   %eax
8010619d:	e8 5e b8 ff ff       	call   80101a00 <iunlockput>
  end_op();
801061a2:	e8 69 d0 ff ff       	call   80103210 <end_op>
  return 0;
801061a7:	83 c4 10             	add    $0x10,%esp
801061aa:	31 c0                	xor    %eax,%eax
}
801061ac:	c9                   	leave  
801061ad:	c3                   	ret    
801061ae:	66 90                	xchg   %ax,%ax
    end_op();
801061b0:	e8 5b d0 ff ff       	call   80103210 <end_op>
    return -1;
801061b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801061ba:	c9                   	leave  
801061bb:	c3                   	ret    
801061bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801061c0 <sys_mknod>:

int
sys_mknod(void)
{
801061c0:	f3 0f 1e fb          	endbr32 
801061c4:	55                   	push   %ebp
801061c5:	89 e5                	mov    %esp,%ebp
801061c7:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801061ca:	e8 d1 cf ff ff       	call   801031a0 <begin_op>
  if((argstr(0, &path)) < 0 ||
801061cf:	83 ec 08             	sub    $0x8,%esp
801061d2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801061d5:	50                   	push   %eax
801061d6:	6a 00                	push   $0x0
801061d8:	e8 43 f6 ff ff       	call   80105820 <argstr>
801061dd:	83 c4 10             	add    $0x10,%esp
801061e0:	85 c0                	test   %eax,%eax
801061e2:	78 5c                	js     80106240 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801061e4:	83 ec 08             	sub    $0x8,%esp
801061e7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801061ea:	50                   	push   %eax
801061eb:	6a 01                	push   $0x1
801061ed:	e8 7e f5 ff ff       	call   80105770 <argint>
  if((argstr(0, &path)) < 0 ||
801061f2:	83 c4 10             	add    $0x10,%esp
801061f5:	85 c0                	test   %eax,%eax
801061f7:	78 47                	js     80106240 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801061f9:	83 ec 08             	sub    $0x8,%esp
801061fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801061ff:	50                   	push   %eax
80106200:	6a 02                	push   $0x2
80106202:	e8 69 f5 ff ff       	call   80105770 <argint>
     argint(1, &major) < 0 ||
80106207:	83 c4 10             	add    $0x10,%esp
8010620a:	85 c0                	test   %eax,%eax
8010620c:	78 32                	js     80106240 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010620e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80106212:	50                   	push   %eax
80106213:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
80106217:	50                   	push   %eax
80106218:	6a 03                	push   $0x3
8010621a:	ff 75 ec             	pushl  -0x14(%ebp)
8010621d:	e8 5e fc ff ff       	call   80105e80 <create>
     argint(2, &minor) < 0 ||
80106222:	83 c4 10             	add    $0x10,%esp
80106225:	85 c0                	test   %eax,%eax
80106227:	74 17                	je     80106240 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80106229:	83 ec 0c             	sub    $0xc,%esp
8010622c:	50                   	push   %eax
8010622d:	e8 ce b7 ff ff       	call   80101a00 <iunlockput>
  end_op();
80106232:	e8 d9 cf ff ff       	call   80103210 <end_op>
  return 0;
80106237:	83 c4 10             	add    $0x10,%esp
8010623a:	31 c0                	xor    %eax,%eax
}
8010623c:	c9                   	leave  
8010623d:	c3                   	ret    
8010623e:	66 90                	xchg   %ax,%ax
    end_op();
80106240:	e8 cb cf ff ff       	call   80103210 <end_op>
    return -1;
80106245:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010624a:	c9                   	leave  
8010624b:	c3                   	ret    
8010624c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106250 <sys_chdir>:

int
sys_chdir(void)
{
80106250:	f3 0f 1e fb          	endbr32 
80106254:	55                   	push   %ebp
80106255:	89 e5                	mov    %esp,%ebp
80106257:	56                   	push   %esi
80106258:	53                   	push   %ebx
80106259:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
8010625c:	e8 7f dc ff ff       	call   80103ee0 <myproc>
80106261:	89 c6                	mov    %eax,%esi
  
  begin_op();
80106263:	e8 38 cf ff ff       	call   801031a0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106268:	83 ec 08             	sub    $0x8,%esp
8010626b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010626e:	50                   	push   %eax
8010626f:	6a 00                	push   $0x0
80106271:	e8 aa f5 ff ff       	call   80105820 <argstr>
80106276:	83 c4 10             	add    $0x10,%esp
80106279:	85 c0                	test   %eax,%eax
8010627b:	78 73                	js     801062f0 <sys_chdir+0xa0>
8010627d:	83 ec 0c             	sub    $0xc,%esp
80106280:	ff 75 f4             	pushl  -0xc(%ebp)
80106283:	e8 a8 bd ff ff       	call   80102030 <namei>
80106288:	83 c4 10             	add    $0x10,%esp
8010628b:	89 c3                	mov    %eax,%ebx
8010628d:	85 c0                	test   %eax,%eax
8010628f:	74 5f                	je     801062f0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80106291:	83 ec 0c             	sub    $0xc,%esp
80106294:	50                   	push   %eax
80106295:	e8 c6 b4 ff ff       	call   80101760 <ilock>
  if(ip->type != T_DIR){
8010629a:	83 c4 10             	add    $0x10,%esp
8010629d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801062a2:	75 2c                	jne    801062d0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801062a4:	83 ec 0c             	sub    $0xc,%esp
801062a7:	53                   	push   %ebx
801062a8:	e8 93 b5 ff ff       	call   80101840 <iunlock>
  iput(curproc->cwd);
801062ad:	58                   	pop    %eax
801062ae:	ff 76 68             	pushl  0x68(%esi)
801062b1:	e8 da b5 ff ff       	call   80101890 <iput>
  end_op();
801062b6:	e8 55 cf ff ff       	call   80103210 <end_op>
  curproc->cwd = ip;
801062bb:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801062be:	83 c4 10             	add    $0x10,%esp
801062c1:	31 c0                	xor    %eax,%eax
}
801062c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801062c6:	5b                   	pop    %ebx
801062c7:	5e                   	pop    %esi
801062c8:	5d                   	pop    %ebp
801062c9:	c3                   	ret    
801062ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
801062d0:	83 ec 0c             	sub    $0xc,%esp
801062d3:	53                   	push   %ebx
801062d4:	e8 27 b7 ff ff       	call   80101a00 <iunlockput>
    end_op();
801062d9:	e8 32 cf ff ff       	call   80103210 <end_op>
    return -1;
801062de:	83 c4 10             	add    $0x10,%esp
801062e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062e6:	eb db                	jmp    801062c3 <sys_chdir+0x73>
801062e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062ef:	90                   	nop
    end_op();
801062f0:	e8 1b cf ff ff       	call   80103210 <end_op>
    return -1;
801062f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062fa:	eb c7                	jmp    801062c3 <sys_chdir+0x73>
801062fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106300 <sys_exec>:

int
sys_exec(void)
{
80106300:	f3 0f 1e fb          	endbr32 
80106304:	55                   	push   %ebp
80106305:	89 e5                	mov    %esp,%ebp
80106307:	57                   	push   %edi
80106308:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106309:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010630f:	53                   	push   %ebx
80106310:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106316:	50                   	push   %eax
80106317:	6a 00                	push   $0x0
80106319:	e8 02 f5 ff ff       	call   80105820 <argstr>
8010631e:	83 c4 10             	add    $0x10,%esp
80106321:	85 c0                	test   %eax,%eax
80106323:	0f 88 8b 00 00 00    	js     801063b4 <sys_exec+0xb4>
80106329:	83 ec 08             	sub    $0x8,%esp
8010632c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80106332:	50                   	push   %eax
80106333:	6a 01                	push   $0x1
80106335:	e8 36 f4 ff ff       	call   80105770 <argint>
8010633a:	83 c4 10             	add    $0x10,%esp
8010633d:	85 c0                	test   %eax,%eax
8010633f:	78 73                	js     801063b4 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80106341:	83 ec 04             	sub    $0x4,%esp
80106344:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010634a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
8010634c:	68 80 00 00 00       	push   $0x80
80106351:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80106357:	6a 00                	push   $0x0
80106359:	50                   	push   %eax
8010635a:	e8 31 f1 ff ff       	call   80105490 <memset>
8010635f:	83 c4 10             	add    $0x10,%esp
80106362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106368:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
8010636e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80106375:	83 ec 08             	sub    $0x8,%esp
80106378:	57                   	push   %edi
80106379:	01 f0                	add    %esi,%eax
8010637b:	50                   	push   %eax
8010637c:	e8 4f f3 ff ff       	call   801056d0 <fetchint>
80106381:	83 c4 10             	add    $0x10,%esp
80106384:	85 c0                	test   %eax,%eax
80106386:	78 2c                	js     801063b4 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80106388:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010638e:	85 c0                	test   %eax,%eax
80106390:	74 36                	je     801063c8 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106392:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80106398:	83 ec 08             	sub    $0x8,%esp
8010639b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
8010639e:	52                   	push   %edx
8010639f:	50                   	push   %eax
801063a0:	e8 6b f3 ff ff       	call   80105710 <fetchstr>
801063a5:	83 c4 10             	add    $0x10,%esp
801063a8:	85 c0                	test   %eax,%eax
801063aa:	78 08                	js     801063b4 <sys_exec+0xb4>
  for(i=0;; i++){
801063ac:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801063af:	83 fb 20             	cmp    $0x20,%ebx
801063b2:	75 b4                	jne    80106368 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
801063b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801063b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801063bc:	5b                   	pop    %ebx
801063bd:	5e                   	pop    %esi
801063be:	5f                   	pop    %edi
801063bf:	5d                   	pop    %ebp
801063c0:	c3                   	ret    
801063c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
801063c8:	83 ec 08             	sub    $0x8,%esp
801063cb:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
801063d1:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801063d8:	00 00 00 00 
  return exec(path, argv);
801063dc:	50                   	push   %eax
801063dd:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801063e3:	e8 98 a6 ff ff       	call   80100a80 <exec>
801063e8:	83 c4 10             	add    $0x10,%esp
}
801063eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063ee:	5b                   	pop    %ebx
801063ef:	5e                   	pop    %esi
801063f0:	5f                   	pop    %edi
801063f1:	5d                   	pop    %ebp
801063f2:	c3                   	ret    
801063f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106400 <sys_pipe>:

int
sys_pipe(void)
{
80106400:	f3 0f 1e fb          	endbr32 
80106404:	55                   	push   %ebp
80106405:	89 e5                	mov    %esp,%ebp
80106407:	57                   	push   %edi
80106408:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106409:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
8010640c:	53                   	push   %ebx
8010640d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106410:	6a 08                	push   $0x8
80106412:	50                   	push   %eax
80106413:	6a 00                	push   $0x0
80106415:	e8 a6 f3 ff ff       	call   801057c0 <argptr>
8010641a:	83 c4 10             	add    $0x10,%esp
8010641d:	85 c0                	test   %eax,%eax
8010641f:	78 4e                	js     8010646f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80106421:	83 ec 08             	sub    $0x8,%esp
80106424:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106427:	50                   	push   %eax
80106428:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010642b:	50                   	push   %eax
8010642c:	e8 2f d4 ff ff       	call   80103860 <pipealloc>
80106431:	83 c4 10             	add    $0x10,%esp
80106434:	85 c0                	test   %eax,%eax
80106436:	78 37                	js     8010646f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106438:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010643b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010643d:	e8 9e da ff ff       	call   80103ee0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80106442:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80106448:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010644c:	85 f6                	test   %esi,%esi
8010644e:	74 30                	je     80106480 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80106450:	83 c3 01             	add    $0x1,%ebx
80106453:	83 fb 10             	cmp    $0x10,%ebx
80106456:	75 f0                	jne    80106448 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80106458:	83 ec 0c             	sub    $0xc,%esp
8010645b:	ff 75 e0             	pushl  -0x20(%ebp)
8010645e:	e8 5d aa ff ff       	call   80100ec0 <fileclose>
    fileclose(wf);
80106463:	58                   	pop    %eax
80106464:	ff 75 e4             	pushl  -0x1c(%ebp)
80106467:	e8 54 aa ff ff       	call   80100ec0 <fileclose>
    return -1;
8010646c:	83 c4 10             	add    $0x10,%esp
8010646f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106474:	eb 5b                	jmp    801064d1 <sys_pipe+0xd1>
80106476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010647d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80106480:	8d 73 08             	lea    0x8(%ebx),%esi
80106483:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106487:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010648a:	e8 51 da ff ff       	call   80103ee0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010648f:	31 d2                	xor    %edx,%edx
80106491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80106498:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010649c:	85 c9                	test   %ecx,%ecx
8010649e:	74 20                	je     801064c0 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
801064a0:	83 c2 01             	add    $0x1,%edx
801064a3:	83 fa 10             	cmp    $0x10,%edx
801064a6:	75 f0                	jne    80106498 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
801064a8:	e8 33 da ff ff       	call   80103ee0 <myproc>
801064ad:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801064b4:	00 
801064b5:	eb a1                	jmp    80106458 <sys_pipe+0x58>
801064b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064be:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801064c0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801064c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801064c7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801064c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801064cc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801064cf:	31 c0                	xor    %eax,%eax
}
801064d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064d4:	5b                   	pop    %ebx
801064d5:	5e                   	pop    %esi
801064d6:	5f                   	pop    %edi
801064d7:	5d                   	pop    %ebp
801064d8:	c3                   	ret    
801064d9:	66 90                	xchg   %ax,%ax
801064db:	66 90                	xchg   %ax,%ax
801064dd:	66 90                	xchg   %ax,%ax
801064df:	90                   	nop

801064e0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801064e0:	f3 0f 1e fb          	endbr32 
  return fork();
801064e4:	e9 a7 db ff ff       	jmp    80104090 <fork>
801064e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801064f0 <sys_exit>:
}

int
sys_exit(void)
{
801064f0:	f3 0f 1e fb          	endbr32 
801064f4:	55                   	push   %ebp
801064f5:	89 e5                	mov    %esp,%ebp
801064f7:	83 ec 08             	sub    $0x8,%esp
  exit();
801064fa:	e8 71 de ff ff       	call   80104370 <exit>
  return 0;  // not reached
}
801064ff:	31 c0                	xor    %eax,%eax
80106501:	c9                   	leave  
80106502:	c3                   	ret    
80106503:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010650a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106510 <sys_wait>:

int
sys_wait(void)
{
80106510:	f3 0f 1e fb          	endbr32 
  return wait();
80106514:	e9 77 e1 ff ff       	jmp    80104690 <wait>
80106519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106520 <sys_kill>:
}

int
sys_kill(void)
{
80106520:	f3 0f 1e fb          	endbr32 
80106524:	55                   	push   %ebp
80106525:	89 e5                	mov    %esp,%ebp
80106527:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010652a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010652d:	50                   	push   %eax
8010652e:	6a 00                	push   $0x0
80106530:	e8 3b f2 ff ff       	call   80105770 <argint>
80106535:	83 c4 10             	add    $0x10,%esp
80106538:	85 c0                	test   %eax,%eax
8010653a:	78 14                	js     80106550 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010653c:	83 ec 0c             	sub    $0xc,%esp
8010653f:	ff 75 f4             	pushl  -0xc(%ebp)
80106542:	e8 b9 e2 ff ff       	call   80104800 <kill>
80106547:	83 c4 10             	add    $0x10,%esp
}
8010654a:	c9                   	leave  
8010654b:	c3                   	ret    
8010654c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106550:	c9                   	leave  
    return -1;
80106551:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106556:	c3                   	ret    
80106557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010655e:	66 90                	xchg   %ax,%ax

80106560 <sys_getpid>:

int
sys_getpid(void)
{
80106560:	f3 0f 1e fb          	endbr32 
80106564:	55                   	push   %ebp
80106565:	89 e5                	mov    %esp,%ebp
80106567:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
8010656a:	e8 71 d9 ff ff       	call   80103ee0 <myproc>
8010656f:	8b 40 10             	mov    0x10(%eax),%eax
}
80106572:	c9                   	leave  
80106573:	c3                   	ret    
80106574:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010657b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010657f:	90                   	nop

80106580 <sys_sbrk>:

int
sys_sbrk(void)
{
80106580:	f3 0f 1e fb          	endbr32 
80106584:	55                   	push   %ebp
80106585:	89 e5                	mov    %esp,%ebp
80106587:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106588:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010658b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010658e:	50                   	push   %eax
8010658f:	6a 00                	push   $0x0
80106591:	e8 da f1 ff ff       	call   80105770 <argint>
80106596:	83 c4 10             	add    $0x10,%esp
80106599:	85 c0                	test   %eax,%eax
8010659b:	78 23                	js     801065c0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010659d:	e8 3e d9 ff ff       	call   80103ee0 <myproc>
  if(growproc(n) < 0)
801065a2:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801065a5:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801065a7:	ff 75 f4             	pushl  -0xc(%ebp)
801065aa:	e8 61 da ff ff       	call   80104010 <growproc>
801065af:	83 c4 10             	add    $0x10,%esp
801065b2:	85 c0                	test   %eax,%eax
801065b4:	78 0a                	js     801065c0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801065b6:	89 d8                	mov    %ebx,%eax
801065b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801065bb:	c9                   	leave  
801065bc:	c3                   	ret    
801065bd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801065c0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801065c5:	eb ef                	jmp    801065b6 <sys_sbrk+0x36>
801065c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065ce:	66 90                	xchg   %ax,%ax

801065d0 <sys_sleep>:

int
sys_sleep(void)
{
801065d0:	f3 0f 1e fb          	endbr32 
801065d4:	55                   	push   %ebp
801065d5:	89 e5                	mov    %esp,%ebp
801065d7:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801065d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801065db:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801065de:	50                   	push   %eax
801065df:	6a 00                	push   $0x0
801065e1:	e8 8a f1 ff ff       	call   80105770 <argint>
801065e6:	83 c4 10             	add    $0x10,%esp
801065e9:	85 c0                	test   %eax,%eax
801065eb:	0f 88 86 00 00 00    	js     80106677 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801065f1:	83 ec 0c             	sub    $0xc,%esp
801065f4:	68 80 e9 11 80       	push   $0x8011e980
801065f9:	e8 82 ed ff ff       	call   80105380 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801065fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80106601:	8b 1d c0 f1 11 80    	mov    0x8011f1c0,%ebx
  while(ticks - ticks0 < n){
80106607:	83 c4 10             	add    $0x10,%esp
8010660a:	85 d2                	test   %edx,%edx
8010660c:	75 23                	jne    80106631 <sys_sleep+0x61>
8010660e:	eb 50                	jmp    80106660 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106610:	83 ec 08             	sub    $0x8,%esp
80106613:	68 80 e9 11 80       	push   $0x8011e980
80106618:	68 c0 f1 11 80       	push   $0x8011f1c0
8010661d:	e8 ae df ff ff       	call   801045d0 <sleep>
  while(ticks - ticks0 < n){
80106622:	a1 c0 f1 11 80       	mov    0x8011f1c0,%eax
80106627:	83 c4 10             	add    $0x10,%esp
8010662a:	29 d8                	sub    %ebx,%eax
8010662c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010662f:	73 2f                	jae    80106660 <sys_sleep+0x90>
    if(myproc()->killed){
80106631:	e8 aa d8 ff ff       	call   80103ee0 <myproc>
80106636:	8b 40 24             	mov    0x24(%eax),%eax
80106639:	85 c0                	test   %eax,%eax
8010663b:	74 d3                	je     80106610 <sys_sleep+0x40>
      release(&tickslock);
8010663d:	83 ec 0c             	sub    $0xc,%esp
80106640:	68 80 e9 11 80       	push   $0x8011e980
80106645:	e8 f6 ed ff ff       	call   80105440 <release>
  }
  release(&tickslock);
  return 0;
}
8010664a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010664d:	83 c4 10             	add    $0x10,%esp
80106650:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106655:	c9                   	leave  
80106656:	c3                   	ret    
80106657:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010665e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106660:	83 ec 0c             	sub    $0xc,%esp
80106663:	68 80 e9 11 80       	push   $0x8011e980
80106668:	e8 d3 ed ff ff       	call   80105440 <release>
  return 0;
8010666d:	83 c4 10             	add    $0x10,%esp
80106670:	31 c0                	xor    %eax,%eax
}
80106672:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106675:	c9                   	leave  
80106676:	c3                   	ret    
    return -1;
80106677:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010667c:	eb f4                	jmp    80106672 <sys_sleep+0xa2>
8010667e:	66 90                	xchg   %ax,%ax

80106680 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106680:	f3 0f 1e fb          	endbr32 
80106684:	55                   	push   %ebp
80106685:	89 e5                	mov    %esp,%ebp
80106687:	53                   	push   %ebx
80106688:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
8010668b:	68 80 e9 11 80       	push   $0x8011e980
80106690:	e8 eb ec ff ff       	call   80105380 <acquire>
  xticks = ticks;
80106695:	8b 1d c0 f1 11 80    	mov    0x8011f1c0,%ebx
  release(&tickslock);
8010669b:	c7 04 24 80 e9 11 80 	movl   $0x8011e980,(%esp)
801066a2:	e8 99 ed ff ff       	call   80105440 <release>
  return xticks;
}
801066a7:	89 d8                	mov    %ebx,%eax
801066a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801066ac:	c9                   	leave  
801066ad:	c3                   	ret    
801066ae:	66 90                	xchg   %ax,%ax

801066b0 <sys_aging>:

int
sys_aging(void)
{
801066b0:	f3 0f 1e fb          	endbr32 
801066b4:	55                   	push   %ebp
801066b5:	89 e5                	mov    %esp,%ebp
801066b7:	83 ec 08             	sub    $0x8,%esp
  enableaging();
801066ba:	e8 61 d7 ff ff       	call   80103e20 <enableaging>
  return 0;
}
801066bf:	31 c0                	xor    %eax,%eax
801066c1:	c9                   	leave  
801066c2:	c3                   	ret    

801066c3 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801066c3:	1e                   	push   %ds
  pushl %es
801066c4:	06                   	push   %es
  pushl %fs
801066c5:	0f a0                	push   %fs
  pushl %gs
801066c7:	0f a8                	push   %gs
  pushal
801066c9:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801066ca:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801066ce:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801066d0:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801066d2:	54                   	push   %esp
  call trap
801066d3:	e8 c8 00 00 00       	call   801067a0 <trap>
  addl $4, %esp
801066d8:	83 c4 04             	add    $0x4,%esp

801066db <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801066db:	61                   	popa   
  popl %gs
801066dc:	0f a9                	pop    %gs
  popl %fs
801066de:	0f a1                	pop    %fs
  popl %es
801066e0:	07                   	pop    %es
  popl %ds
801066e1:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801066e2:	83 c4 08             	add    $0x8,%esp
  iret
801066e5:	cf                   	iret   
801066e6:	66 90                	xchg   %ax,%ax
801066e8:	66 90                	xchg   %ax,%ax
801066ea:	66 90                	xchg   %ax,%ax
801066ec:	66 90                	xchg   %ax,%ax
801066ee:	66 90                	xchg   %ax,%ax

801066f0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801066f0:	f3 0f 1e fb          	endbr32 
801066f4:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801066f5:	31 c0                	xor    %eax,%eax
{
801066f7:	89 e5                	mov    %esp,%ebp
801066f9:	83 ec 08             	sub    $0x8,%esp
801066fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106700:	8b 14 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%edx
80106707:	c7 04 c5 c2 e9 11 80 	movl   $0x8e000008,-0x7fee163e(,%eax,8)
8010670e:	08 00 00 8e 
80106712:	66 89 14 c5 c0 e9 11 	mov    %dx,-0x7fee1640(,%eax,8)
80106719:	80 
8010671a:	c1 ea 10             	shr    $0x10,%edx
8010671d:	66 89 14 c5 c6 e9 11 	mov    %dx,-0x7fee163a(,%eax,8)
80106724:	80 
  for(i = 0; i < 256; i++)
80106725:	83 c0 01             	add    $0x1,%eax
80106728:	3d 00 01 00 00       	cmp    $0x100,%eax
8010672d:	75 d1                	jne    80106700 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010672f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106732:	a1 0c c1 10 80       	mov    0x8010c10c,%eax
80106737:	c7 05 c2 eb 11 80 08 	movl   $0xef000008,0x8011ebc2
8010673e:	00 00 ef 
  initlock(&tickslock, "time");
80106741:	68 d9 8d 10 80       	push   $0x80108dd9
80106746:	68 80 e9 11 80       	push   $0x8011e980
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010674b:	66 a3 c0 eb 11 80    	mov    %ax,0x8011ebc0
80106751:	c1 e8 10             	shr    $0x10,%eax
80106754:	66 a3 c6 eb 11 80    	mov    %ax,0x8011ebc6
  initlock(&tickslock, "time");
8010675a:	e8 a1 ea ff ff       	call   80105200 <initlock>
}
8010675f:	83 c4 10             	add    $0x10,%esp
80106762:	c9                   	leave  
80106763:	c3                   	ret    
80106764:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010676b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010676f:	90                   	nop

80106770 <idtinit>:

void
idtinit(void)
{
80106770:	f3 0f 1e fb          	endbr32 
80106774:	55                   	push   %ebp
  pd[0] = size-1;
80106775:	b8 ff 07 00 00       	mov    $0x7ff,%eax
8010677a:	89 e5                	mov    %esp,%ebp
8010677c:	83 ec 10             	sub    $0x10,%esp
8010677f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106783:	b8 c0 e9 11 80       	mov    $0x8011e9c0,%eax
80106788:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010678c:	c1 e8 10             	shr    $0x10,%eax
8010678f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106793:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106796:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106799:	c9                   	leave  
8010679a:	c3                   	ret    
8010679b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010679f:	90                   	nop

801067a0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801067a0:	f3 0f 1e fb          	endbr32 
801067a4:	55                   	push   %ebp
801067a5:	89 e5                	mov    %esp,%ebp
801067a7:	57                   	push   %edi
801067a8:	56                   	push   %esi
801067a9:	53                   	push   %ebx
801067aa:	83 ec 1c             	sub    $0x1c,%esp
801067ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801067b0:	8b 43 30             	mov    0x30(%ebx),%eax
801067b3:	83 f8 40             	cmp    $0x40,%eax
801067b6:	0f 84 6c 02 00 00    	je     80106a28 <trap+0x288>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801067bc:	83 e8 0e             	sub    $0xe,%eax
801067bf:	83 f8 31             	cmp    $0x31,%eax
801067c2:	0f 87 e8 00 00 00    	ja     801068b0 <trap+0x110>
801067c8:	3e ff 24 85 90 8e 10 	notrack jmp *-0x7fef7170(,%eax,4)
801067cf:	80 
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
    break;
  case T_PGFLT:{

    struct proc *p = myproc();
801067d0:	e8 0b d7 ff ff       	call   80103ee0 <myproc>
801067d5:	89 c6                	mov    %eax,%esi
    
    if(p && p->pid > 2 && ((tf->cs & 3) == 3)){
801067d7:	85 c0                	test   %eax,%eax
801067d9:	0f 84 c1 00 00 00    	je     801068a0 <trap+0x100>
801067df:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
801067e3:	0f 8e b7 00 00 00    	jle    801068a0 <trap+0x100>
801067e9:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801067ed:	83 e0 03             	and    $0x3,%eax
801067f0:	66 83 f8 03          	cmp    $0x3,%ax
801067f4:	0f 85 a6 00 00 00    	jne    801068a0 <trap+0x100>
       p->pagefaults++;
801067fa:	83 86 6c 02 00 00 01 	addl   $0x1,0x26c(%esi)

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106801:	0f 20 d0             	mov    %cr2,%eax
      if(checkPageOut(p, rcr2()))
80106804:	83 ec 08             	sub    $0x8,%esp
80106807:	50                   	push   %eax
80106808:	56                   	push   %esi
80106809:	e8 22 1b 00 00       	call   80108330 <checkPageOut>
8010680e:	83 c4 10             	add    $0x10,%esp
80106811:	85 c0                	test   %eax,%eax
80106813:	0f 84 97 00 00 00    	je     801068b0 <trap+0x110>
80106819:	0f 20 d0             	mov    %cr2,%eax
      {
        swapin(p, rcr2());
8010681c:	83 ec 08             	sub    $0x8,%esp
8010681f:	50                   	push   %eax
80106820:	56                   	push   %esi
80106821:	e8 3a 1a 00 00       	call   80108260 <swapin>
        break;
80106826:	83 c4 10             	add    $0x10,%esp
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106829:	e8 b2 d6 ff ff       	call   80103ee0 <myproc>
8010682e:	85 c0                	test   %eax,%eax
80106830:	74 23                	je     80106855 <trap+0xb5>
80106832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106838:	e8 a3 d6 ff ff       	call   80103ee0 <myproc>
8010683d:	8b 50 24             	mov    0x24(%eax),%edx
80106840:	85 d2                	test   %edx,%edx
80106842:	74 11                	je     80106855 <trap+0xb5>
80106844:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106848:	83 e0 03             	and    $0x3,%eax
8010684b:	66 83 f8 03          	cmp    $0x3,%ax
8010684f:	0f 84 0b 02 00 00    	je     80106a60 <trap+0x2c0>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106855:	e8 86 d6 ff ff       	call   80103ee0 <myproc>
8010685a:	85 c0                	test   %eax,%eax
8010685c:	74 0f                	je     8010686d <trap+0xcd>
8010685e:	e8 7d d6 ff ff       	call   80103ee0 <myproc>
80106863:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106867:	0f 84 a3 01 00 00    	je     80106a10 <trap+0x270>

      yield();
    }

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010686d:	e8 6e d6 ff ff       	call   80103ee0 <myproc>
80106872:	85 c0                	test   %eax,%eax
80106874:	74 1d                	je     80106893 <trap+0xf3>
80106876:	e8 65 d6 ff ff       	call   80103ee0 <myproc>
8010687b:	8b 40 24             	mov    0x24(%eax),%eax
8010687e:	85 c0                	test   %eax,%eax
80106880:	74 11                	je     80106893 <trap+0xf3>
80106882:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106886:	83 e0 03             	and    $0x3,%eax
80106889:	66 83 f8 03          	cmp    $0x3,%ax
8010688d:	0f 84 be 01 00 00    	je     80106a51 <trap+0x2b1>
    exit();
}
80106893:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106896:	5b                   	pop    %ebx
80106897:	5e                   	pop    %esi
80106898:	5f                   	pop    %edi
80106899:	5d                   	pop    %ebp
8010689a:	c3                   	ret    
8010689b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010689f:	90                   	nop
      cprintf("Hard Page fault\n");
801068a0:	83 ec 0c             	sub    $0xc,%esp
801068a3:	68 de 8d 10 80       	push   $0x80108dde
801068a8:	e8 03 9e ff ff       	call   801006b0 <cprintf>
801068ad:	83 c4 10             	add    $0x10,%esp
    if(myproc() == 0 || (tf->cs&3) == 0){
801068b0:	e8 2b d6 ff ff       	call   80103ee0 <myproc>
801068b5:	8b 7b 38             	mov    0x38(%ebx),%edi
801068b8:	85 c0                	test   %eax,%eax
801068ba:	0f 84 b7 01 00 00    	je     80106a77 <trap+0x2d7>
801068c0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801068c4:	0f 84 ad 01 00 00    	je     80106a77 <trap+0x2d7>
801068ca:	0f 20 d1             	mov    %cr2,%ecx
801068cd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801068d0:	e8 eb d5 ff ff       	call   80103ec0 <cpuid>
801068d5:	8b 73 30             	mov    0x30(%ebx),%esi
801068d8:	89 45 dc             	mov    %eax,-0x24(%ebp)
801068db:	8b 43 34             	mov    0x34(%ebx),%eax
801068de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
801068e1:	e8 fa d5 ff ff       	call   80103ee0 <myproc>
801068e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801068e9:	e8 f2 d5 ff ff       	call   80103ee0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801068ee:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801068f1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801068f4:	51                   	push   %ecx
801068f5:	57                   	push   %edi
801068f6:	52                   	push   %edx
801068f7:	ff 75 e4             	pushl  -0x1c(%ebp)
801068fa:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801068fb:	8b 75 e0             	mov    -0x20(%ebp),%esi
801068fe:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106901:	56                   	push   %esi
80106902:	ff 70 10             	pushl  0x10(%eax)
80106905:	68 4c 8e 10 80       	push   $0x80108e4c
8010690a:	e8 a1 9d ff ff       	call   801006b0 <cprintf>
    myproc()->killed = 1;
8010690f:	83 c4 20             	add    $0x20,%esp
80106912:	e8 c9 d5 ff ff       	call   80103ee0 <myproc>
80106917:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010691e:	e8 bd d5 ff ff       	call   80103ee0 <myproc>
80106923:	85 c0                	test   %eax,%eax
80106925:	0f 85 0d ff ff ff    	jne    80106838 <trap+0x98>
8010692b:	e9 25 ff ff ff       	jmp    80106855 <trap+0xb5>
    ideintr();
80106930:	e8 1b bd ff ff       	call   80102650 <ideintr>
    lapiceoi();
80106935:	e8 f6 c3 ff ff       	call   80102d30 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010693a:	e8 a1 d5 ff ff       	call   80103ee0 <myproc>
8010693f:	85 c0                	test   %eax,%eax
80106941:	0f 85 f1 fe ff ff    	jne    80106838 <trap+0x98>
80106947:	e9 09 ff ff ff       	jmp    80106855 <trap+0xb5>
    if(cpuid() == 0){
8010694c:	e8 6f d5 ff ff       	call   80103ec0 <cpuid>
80106951:	85 c0                	test   %eax,%eax
80106953:	75 e0                	jne    80106935 <trap+0x195>
      acquire(&tickslock);
80106955:	83 ec 0c             	sub    $0xc,%esp
80106958:	68 80 e9 11 80       	push   $0x8011e980
8010695d:	e8 1e ea ff ff       	call   80105380 <acquire>
      wakeup(&ticks);
80106962:	c7 04 24 c0 f1 11 80 	movl   $0x8011f1c0,(%esp)
      ticks++;
80106969:	83 05 c0 f1 11 80 01 	addl   $0x1,0x8011f1c0
      wakeup(&ticks);
80106970:	e8 1b de ff ff       	call   80104790 <wakeup>
      release(&tickslock);
80106975:	c7 04 24 80 e9 11 80 	movl   $0x8011e980,(%esp)
8010697c:	e8 bf ea ff ff       	call   80105440 <release>
      if(myproc() && myproc()->pid > 2)
80106981:	e8 5a d5 ff ff       	call   80103ee0 <myproc>
80106986:	83 c4 10             	add    $0x10,%esp
80106989:	85 c0                	test   %eax,%eax
8010698b:	74 a8                	je     80106935 <trap+0x195>
8010698d:	e8 4e d5 ff ff       	call   80103ee0 <myproc>
80106992:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80106996:	7e 9d                	jle    80106935 <trap+0x195>
        updateAllProcessPTE();
80106998:	e8 b3 e6 ff ff       	call   80105050 <updateAllProcessPTE>
    lapiceoi();
8010699d:	eb 96                	jmp    80106935 <trap+0x195>
    uartintr();
8010699f:	e8 6c 02 00 00       	call   80106c10 <uartintr>
    lapiceoi();
801069a4:	e8 87 c3 ff ff       	call   80102d30 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801069a9:	e8 32 d5 ff ff       	call   80103ee0 <myproc>
801069ae:	85 c0                	test   %eax,%eax
801069b0:	0f 85 82 fe ff ff    	jne    80106838 <trap+0x98>
801069b6:	e9 9a fe ff ff       	jmp    80106855 <trap+0xb5>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801069bb:	8b 7b 38             	mov    0x38(%ebx),%edi
801069be:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801069c2:	e8 f9 d4 ff ff       	call   80103ec0 <cpuid>
801069c7:	57                   	push   %edi
801069c8:	56                   	push   %esi
801069c9:	50                   	push   %eax
801069ca:	68 f4 8d 10 80       	push   $0x80108df4
801069cf:	e8 dc 9c ff ff       	call   801006b0 <cprintf>
    lapiceoi();
801069d4:	e8 57 c3 ff ff       	call   80102d30 <lapiceoi>
    break;
801069d9:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801069dc:	e8 ff d4 ff ff       	call   80103ee0 <myproc>
801069e1:	85 c0                	test   %eax,%eax
801069e3:	0f 85 4f fe ff ff    	jne    80106838 <trap+0x98>
801069e9:	e9 67 fe ff ff       	jmp    80106855 <trap+0xb5>
    kbdintr();
801069ee:	e8 fd c1 ff ff       	call   80102bf0 <kbdintr>
    lapiceoi();
801069f3:	e8 38 c3 ff ff       	call   80102d30 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801069f8:	e8 e3 d4 ff ff       	call   80103ee0 <myproc>
801069fd:	85 c0                	test   %eax,%eax
801069ff:	0f 85 33 fe ff ff    	jne    80106838 <trap+0x98>
80106a05:	e9 4b fe ff ff       	jmp    80106855 <trap+0xb5>
80106a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106a10:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106a14:	0f 85 53 fe ff ff    	jne    8010686d <trap+0xcd>
      yield();
80106a1a:	e8 61 db ff ff       	call   80104580 <yield>
80106a1f:	e9 49 fe ff ff       	jmp    8010686d <trap+0xcd>
80106a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106a28:	e8 b3 d4 ff ff       	call   80103ee0 <myproc>
80106a2d:	8b 70 24             	mov    0x24(%eax),%esi
80106a30:	85 f6                	test   %esi,%esi
80106a32:	75 3c                	jne    80106a70 <trap+0x2d0>
    myproc()->tf = tf;
80106a34:	e8 a7 d4 ff ff       	call   80103ee0 <myproc>
80106a39:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106a3c:	e8 1f ee ff ff       	call   80105860 <syscall>
    if(myproc()->killed)
80106a41:	e8 9a d4 ff ff       	call   80103ee0 <myproc>
80106a46:	8b 48 24             	mov    0x24(%eax),%ecx
80106a49:	85 c9                	test   %ecx,%ecx
80106a4b:	0f 84 42 fe ff ff    	je     80106893 <trap+0xf3>
}
80106a51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a54:	5b                   	pop    %ebx
80106a55:	5e                   	pop    %esi
80106a56:	5f                   	pop    %edi
80106a57:	5d                   	pop    %ebp
      exit();
80106a58:	e9 13 d9 ff ff       	jmp    80104370 <exit>
80106a5d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106a60:	e8 0b d9 ff ff       	call   80104370 <exit>
80106a65:	e9 eb fd ff ff       	jmp    80106855 <trap+0xb5>
80106a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106a70:	e8 fb d8 ff ff       	call   80104370 <exit>
80106a75:	eb bd                	jmp    80106a34 <trap+0x294>
80106a77:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106a7a:	e8 41 d4 ff ff       	call   80103ec0 <cpuid>
80106a7f:	83 ec 0c             	sub    $0xc,%esp
80106a82:	56                   	push   %esi
80106a83:	57                   	push   %edi
80106a84:	50                   	push   %eax
80106a85:	ff 73 30             	pushl  0x30(%ebx)
80106a88:	68 18 8e 10 80       	push   $0x80108e18
80106a8d:	e8 1e 9c ff ff       	call   801006b0 <cprintf>
      panic("trap");
80106a92:	83 c4 14             	add    $0x14,%esp
80106a95:	68 ef 8d 10 80       	push   $0x80108def
80106a9a:	e8 f1 98 ff ff       	call   80100390 <panic>
80106a9f:	90                   	nop

80106aa0 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106aa0:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106aa4:	a1 c0 c5 10 80       	mov    0x8010c5c0,%eax
80106aa9:	85 c0                	test   %eax,%eax
80106aab:	74 1b                	je     80106ac8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106aad:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106ab2:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106ab3:	a8 01                	test   $0x1,%al
80106ab5:	74 11                	je     80106ac8 <uartgetc+0x28>
80106ab7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106abc:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106abd:	0f b6 c0             	movzbl %al,%eax
80106ac0:	c3                   	ret    
80106ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106ac8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106acd:	c3                   	ret    
80106ace:	66 90                	xchg   %ax,%ax

80106ad0 <uartputc.part.0>:
uartputc(int c)
80106ad0:	55                   	push   %ebp
80106ad1:	89 e5                	mov    %esp,%ebp
80106ad3:	57                   	push   %edi
80106ad4:	89 c7                	mov    %eax,%edi
80106ad6:	56                   	push   %esi
80106ad7:	be fd 03 00 00       	mov    $0x3fd,%esi
80106adc:	53                   	push   %ebx
80106add:	bb 80 00 00 00       	mov    $0x80,%ebx
80106ae2:	83 ec 0c             	sub    $0xc,%esp
80106ae5:	eb 1b                	jmp    80106b02 <uartputc.part.0+0x32>
80106ae7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106aee:	66 90                	xchg   %ax,%ax
    microdelay(10);
80106af0:	83 ec 0c             	sub    $0xc,%esp
80106af3:	6a 0a                	push   $0xa
80106af5:	e8 56 c2 ff ff       	call   80102d50 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106afa:	83 c4 10             	add    $0x10,%esp
80106afd:	83 eb 01             	sub    $0x1,%ebx
80106b00:	74 07                	je     80106b09 <uartputc.part.0+0x39>
80106b02:	89 f2                	mov    %esi,%edx
80106b04:	ec                   	in     (%dx),%al
80106b05:	a8 20                	test   $0x20,%al
80106b07:	74 e7                	je     80106af0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106b09:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106b0e:	89 f8                	mov    %edi,%eax
80106b10:	ee                   	out    %al,(%dx)
}
80106b11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b14:	5b                   	pop    %ebx
80106b15:	5e                   	pop    %esi
80106b16:	5f                   	pop    %edi
80106b17:	5d                   	pop    %ebp
80106b18:	c3                   	ret    
80106b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106b20 <uartinit>:
{
80106b20:	f3 0f 1e fb          	endbr32 
80106b24:	55                   	push   %ebp
80106b25:	31 c9                	xor    %ecx,%ecx
80106b27:	89 c8                	mov    %ecx,%eax
80106b29:	89 e5                	mov    %esp,%ebp
80106b2b:	57                   	push   %edi
80106b2c:	56                   	push   %esi
80106b2d:	53                   	push   %ebx
80106b2e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106b33:	89 da                	mov    %ebx,%edx
80106b35:	83 ec 0c             	sub    $0xc,%esp
80106b38:	ee                   	out    %al,(%dx)
80106b39:	bf fb 03 00 00       	mov    $0x3fb,%edi
80106b3e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106b43:	89 fa                	mov    %edi,%edx
80106b45:	ee                   	out    %al,(%dx)
80106b46:	b8 0c 00 00 00       	mov    $0xc,%eax
80106b4b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106b50:	ee                   	out    %al,(%dx)
80106b51:	be f9 03 00 00       	mov    $0x3f9,%esi
80106b56:	89 c8                	mov    %ecx,%eax
80106b58:	89 f2                	mov    %esi,%edx
80106b5a:	ee                   	out    %al,(%dx)
80106b5b:	b8 03 00 00 00       	mov    $0x3,%eax
80106b60:	89 fa                	mov    %edi,%edx
80106b62:	ee                   	out    %al,(%dx)
80106b63:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106b68:	89 c8                	mov    %ecx,%eax
80106b6a:	ee                   	out    %al,(%dx)
80106b6b:	b8 01 00 00 00       	mov    $0x1,%eax
80106b70:	89 f2                	mov    %esi,%edx
80106b72:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106b73:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106b78:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106b79:	3c ff                	cmp    $0xff,%al
80106b7b:	74 52                	je     80106bcf <uartinit+0xaf>
  uart = 1;
80106b7d:	c7 05 c0 c5 10 80 01 	movl   $0x1,0x8010c5c0
80106b84:	00 00 00 
80106b87:	89 da                	mov    %ebx,%edx
80106b89:	ec                   	in     (%dx),%al
80106b8a:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106b8f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106b90:	83 ec 08             	sub    $0x8,%esp
80106b93:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80106b98:	bb 58 8f 10 80       	mov    $0x80108f58,%ebx
  ioapicenable(IRQ_COM1, 0);
80106b9d:	6a 00                	push   $0x0
80106b9f:	6a 04                	push   $0x4
80106ba1:	e8 fa bc ff ff       	call   801028a0 <ioapicenable>
80106ba6:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106ba9:	b8 78 00 00 00       	mov    $0x78,%eax
80106bae:	eb 04                	jmp    80106bb4 <uartinit+0x94>
80106bb0:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106bb4:	8b 15 c0 c5 10 80    	mov    0x8010c5c0,%edx
80106bba:	85 d2                	test   %edx,%edx
80106bbc:	74 08                	je     80106bc6 <uartinit+0xa6>
    uartputc(*p);
80106bbe:	0f be c0             	movsbl %al,%eax
80106bc1:	e8 0a ff ff ff       	call   80106ad0 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80106bc6:	89 f0                	mov    %esi,%eax
80106bc8:	83 c3 01             	add    $0x1,%ebx
80106bcb:	84 c0                	test   %al,%al
80106bcd:	75 e1                	jne    80106bb0 <uartinit+0x90>
}
80106bcf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bd2:	5b                   	pop    %ebx
80106bd3:	5e                   	pop    %esi
80106bd4:	5f                   	pop    %edi
80106bd5:	5d                   	pop    %ebp
80106bd6:	c3                   	ret    
80106bd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bde:	66 90                	xchg   %ax,%ax

80106be0 <uartputc>:
{
80106be0:	f3 0f 1e fb          	endbr32 
80106be4:	55                   	push   %ebp
  if(!uart)
80106be5:	8b 15 c0 c5 10 80    	mov    0x8010c5c0,%edx
{
80106beb:	89 e5                	mov    %esp,%ebp
80106bed:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106bf0:	85 d2                	test   %edx,%edx
80106bf2:	74 0c                	je     80106c00 <uartputc+0x20>
}
80106bf4:	5d                   	pop    %ebp
80106bf5:	e9 d6 fe ff ff       	jmp    80106ad0 <uartputc.part.0>
80106bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c00:	5d                   	pop    %ebp
80106c01:	c3                   	ret    
80106c02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c10 <uartintr>:

void
uartintr(void)
{
80106c10:	f3 0f 1e fb          	endbr32 
80106c14:	55                   	push   %ebp
80106c15:	89 e5                	mov    %esp,%ebp
80106c17:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106c1a:	68 a0 6a 10 80       	push   $0x80106aa0
80106c1f:	e8 3c 9c ff ff       	call   80100860 <consoleintr>
}
80106c24:	83 c4 10             	add    $0x10,%esp
80106c27:	c9                   	leave  
80106c28:	c3                   	ret    

80106c29 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106c29:	6a 00                	push   $0x0
  pushl $0
80106c2b:	6a 00                	push   $0x0
  jmp alltraps
80106c2d:	e9 91 fa ff ff       	jmp    801066c3 <alltraps>

80106c32 <vector1>:
.globl vector1
vector1:
  pushl $0
80106c32:	6a 00                	push   $0x0
  pushl $1
80106c34:	6a 01                	push   $0x1
  jmp alltraps
80106c36:	e9 88 fa ff ff       	jmp    801066c3 <alltraps>

80106c3b <vector2>:
.globl vector2
vector2:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $2
80106c3d:	6a 02                	push   $0x2
  jmp alltraps
80106c3f:	e9 7f fa ff ff       	jmp    801066c3 <alltraps>

80106c44 <vector3>:
.globl vector3
vector3:
  pushl $0
80106c44:	6a 00                	push   $0x0
  pushl $3
80106c46:	6a 03                	push   $0x3
  jmp alltraps
80106c48:	e9 76 fa ff ff       	jmp    801066c3 <alltraps>

80106c4d <vector4>:
.globl vector4
vector4:
  pushl $0
80106c4d:	6a 00                	push   $0x0
  pushl $4
80106c4f:	6a 04                	push   $0x4
  jmp alltraps
80106c51:	e9 6d fa ff ff       	jmp    801066c3 <alltraps>

80106c56 <vector5>:
.globl vector5
vector5:
  pushl $0
80106c56:	6a 00                	push   $0x0
  pushl $5
80106c58:	6a 05                	push   $0x5
  jmp alltraps
80106c5a:	e9 64 fa ff ff       	jmp    801066c3 <alltraps>

80106c5f <vector6>:
.globl vector6
vector6:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $6
80106c61:	6a 06                	push   $0x6
  jmp alltraps
80106c63:	e9 5b fa ff ff       	jmp    801066c3 <alltraps>

80106c68 <vector7>:
.globl vector7
vector7:
  pushl $0
80106c68:	6a 00                	push   $0x0
  pushl $7
80106c6a:	6a 07                	push   $0x7
  jmp alltraps
80106c6c:	e9 52 fa ff ff       	jmp    801066c3 <alltraps>

80106c71 <vector8>:
.globl vector8
vector8:
  pushl $8
80106c71:	6a 08                	push   $0x8
  jmp alltraps
80106c73:	e9 4b fa ff ff       	jmp    801066c3 <alltraps>

80106c78 <vector9>:
.globl vector9
vector9:
  pushl $0
80106c78:	6a 00                	push   $0x0
  pushl $9
80106c7a:	6a 09                	push   $0x9
  jmp alltraps
80106c7c:	e9 42 fa ff ff       	jmp    801066c3 <alltraps>

80106c81 <vector10>:
.globl vector10
vector10:
  pushl $10
80106c81:	6a 0a                	push   $0xa
  jmp alltraps
80106c83:	e9 3b fa ff ff       	jmp    801066c3 <alltraps>

80106c88 <vector11>:
.globl vector11
vector11:
  pushl $11
80106c88:	6a 0b                	push   $0xb
  jmp alltraps
80106c8a:	e9 34 fa ff ff       	jmp    801066c3 <alltraps>

80106c8f <vector12>:
.globl vector12
vector12:
  pushl $12
80106c8f:	6a 0c                	push   $0xc
  jmp alltraps
80106c91:	e9 2d fa ff ff       	jmp    801066c3 <alltraps>

80106c96 <vector13>:
.globl vector13
vector13:
  pushl $13
80106c96:	6a 0d                	push   $0xd
  jmp alltraps
80106c98:	e9 26 fa ff ff       	jmp    801066c3 <alltraps>

80106c9d <vector14>:
.globl vector14
vector14:
  pushl $14
80106c9d:	6a 0e                	push   $0xe
  jmp alltraps
80106c9f:	e9 1f fa ff ff       	jmp    801066c3 <alltraps>

80106ca4 <vector15>:
.globl vector15
vector15:
  pushl $0
80106ca4:	6a 00                	push   $0x0
  pushl $15
80106ca6:	6a 0f                	push   $0xf
  jmp alltraps
80106ca8:	e9 16 fa ff ff       	jmp    801066c3 <alltraps>

80106cad <vector16>:
.globl vector16
vector16:
  pushl $0
80106cad:	6a 00                	push   $0x0
  pushl $16
80106caf:	6a 10                	push   $0x10
  jmp alltraps
80106cb1:	e9 0d fa ff ff       	jmp    801066c3 <alltraps>

80106cb6 <vector17>:
.globl vector17
vector17:
  pushl $17
80106cb6:	6a 11                	push   $0x11
  jmp alltraps
80106cb8:	e9 06 fa ff ff       	jmp    801066c3 <alltraps>

80106cbd <vector18>:
.globl vector18
vector18:
  pushl $0
80106cbd:	6a 00                	push   $0x0
  pushl $18
80106cbf:	6a 12                	push   $0x12
  jmp alltraps
80106cc1:	e9 fd f9 ff ff       	jmp    801066c3 <alltraps>

80106cc6 <vector19>:
.globl vector19
vector19:
  pushl $0
80106cc6:	6a 00                	push   $0x0
  pushl $19
80106cc8:	6a 13                	push   $0x13
  jmp alltraps
80106cca:	e9 f4 f9 ff ff       	jmp    801066c3 <alltraps>

80106ccf <vector20>:
.globl vector20
vector20:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $20
80106cd1:	6a 14                	push   $0x14
  jmp alltraps
80106cd3:	e9 eb f9 ff ff       	jmp    801066c3 <alltraps>

80106cd8 <vector21>:
.globl vector21
vector21:
  pushl $0
80106cd8:	6a 00                	push   $0x0
  pushl $21
80106cda:	6a 15                	push   $0x15
  jmp alltraps
80106cdc:	e9 e2 f9 ff ff       	jmp    801066c3 <alltraps>

80106ce1 <vector22>:
.globl vector22
vector22:
  pushl $0
80106ce1:	6a 00                	push   $0x0
  pushl $22
80106ce3:	6a 16                	push   $0x16
  jmp alltraps
80106ce5:	e9 d9 f9 ff ff       	jmp    801066c3 <alltraps>

80106cea <vector23>:
.globl vector23
vector23:
  pushl $0
80106cea:	6a 00                	push   $0x0
  pushl $23
80106cec:	6a 17                	push   $0x17
  jmp alltraps
80106cee:	e9 d0 f9 ff ff       	jmp    801066c3 <alltraps>

80106cf3 <vector24>:
.globl vector24
vector24:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $24
80106cf5:	6a 18                	push   $0x18
  jmp alltraps
80106cf7:	e9 c7 f9 ff ff       	jmp    801066c3 <alltraps>

80106cfc <vector25>:
.globl vector25
vector25:
  pushl $0
80106cfc:	6a 00                	push   $0x0
  pushl $25
80106cfe:	6a 19                	push   $0x19
  jmp alltraps
80106d00:	e9 be f9 ff ff       	jmp    801066c3 <alltraps>

80106d05 <vector26>:
.globl vector26
vector26:
  pushl $0
80106d05:	6a 00                	push   $0x0
  pushl $26
80106d07:	6a 1a                	push   $0x1a
  jmp alltraps
80106d09:	e9 b5 f9 ff ff       	jmp    801066c3 <alltraps>

80106d0e <vector27>:
.globl vector27
vector27:
  pushl $0
80106d0e:	6a 00                	push   $0x0
  pushl $27
80106d10:	6a 1b                	push   $0x1b
  jmp alltraps
80106d12:	e9 ac f9 ff ff       	jmp    801066c3 <alltraps>

80106d17 <vector28>:
.globl vector28
vector28:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $28
80106d19:	6a 1c                	push   $0x1c
  jmp alltraps
80106d1b:	e9 a3 f9 ff ff       	jmp    801066c3 <alltraps>

80106d20 <vector29>:
.globl vector29
vector29:
  pushl $0
80106d20:	6a 00                	push   $0x0
  pushl $29
80106d22:	6a 1d                	push   $0x1d
  jmp alltraps
80106d24:	e9 9a f9 ff ff       	jmp    801066c3 <alltraps>

80106d29 <vector30>:
.globl vector30
vector30:
  pushl $0
80106d29:	6a 00                	push   $0x0
  pushl $30
80106d2b:	6a 1e                	push   $0x1e
  jmp alltraps
80106d2d:	e9 91 f9 ff ff       	jmp    801066c3 <alltraps>

80106d32 <vector31>:
.globl vector31
vector31:
  pushl $0
80106d32:	6a 00                	push   $0x0
  pushl $31
80106d34:	6a 1f                	push   $0x1f
  jmp alltraps
80106d36:	e9 88 f9 ff ff       	jmp    801066c3 <alltraps>

80106d3b <vector32>:
.globl vector32
vector32:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $32
80106d3d:	6a 20                	push   $0x20
  jmp alltraps
80106d3f:	e9 7f f9 ff ff       	jmp    801066c3 <alltraps>

80106d44 <vector33>:
.globl vector33
vector33:
  pushl $0
80106d44:	6a 00                	push   $0x0
  pushl $33
80106d46:	6a 21                	push   $0x21
  jmp alltraps
80106d48:	e9 76 f9 ff ff       	jmp    801066c3 <alltraps>

80106d4d <vector34>:
.globl vector34
vector34:
  pushl $0
80106d4d:	6a 00                	push   $0x0
  pushl $34
80106d4f:	6a 22                	push   $0x22
  jmp alltraps
80106d51:	e9 6d f9 ff ff       	jmp    801066c3 <alltraps>

80106d56 <vector35>:
.globl vector35
vector35:
  pushl $0
80106d56:	6a 00                	push   $0x0
  pushl $35
80106d58:	6a 23                	push   $0x23
  jmp alltraps
80106d5a:	e9 64 f9 ff ff       	jmp    801066c3 <alltraps>

80106d5f <vector36>:
.globl vector36
vector36:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $36
80106d61:	6a 24                	push   $0x24
  jmp alltraps
80106d63:	e9 5b f9 ff ff       	jmp    801066c3 <alltraps>

80106d68 <vector37>:
.globl vector37
vector37:
  pushl $0
80106d68:	6a 00                	push   $0x0
  pushl $37
80106d6a:	6a 25                	push   $0x25
  jmp alltraps
80106d6c:	e9 52 f9 ff ff       	jmp    801066c3 <alltraps>

80106d71 <vector38>:
.globl vector38
vector38:
  pushl $0
80106d71:	6a 00                	push   $0x0
  pushl $38
80106d73:	6a 26                	push   $0x26
  jmp alltraps
80106d75:	e9 49 f9 ff ff       	jmp    801066c3 <alltraps>

80106d7a <vector39>:
.globl vector39
vector39:
  pushl $0
80106d7a:	6a 00                	push   $0x0
  pushl $39
80106d7c:	6a 27                	push   $0x27
  jmp alltraps
80106d7e:	e9 40 f9 ff ff       	jmp    801066c3 <alltraps>

80106d83 <vector40>:
.globl vector40
vector40:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $40
80106d85:	6a 28                	push   $0x28
  jmp alltraps
80106d87:	e9 37 f9 ff ff       	jmp    801066c3 <alltraps>

80106d8c <vector41>:
.globl vector41
vector41:
  pushl $0
80106d8c:	6a 00                	push   $0x0
  pushl $41
80106d8e:	6a 29                	push   $0x29
  jmp alltraps
80106d90:	e9 2e f9 ff ff       	jmp    801066c3 <alltraps>

80106d95 <vector42>:
.globl vector42
vector42:
  pushl $0
80106d95:	6a 00                	push   $0x0
  pushl $42
80106d97:	6a 2a                	push   $0x2a
  jmp alltraps
80106d99:	e9 25 f9 ff ff       	jmp    801066c3 <alltraps>

80106d9e <vector43>:
.globl vector43
vector43:
  pushl $0
80106d9e:	6a 00                	push   $0x0
  pushl $43
80106da0:	6a 2b                	push   $0x2b
  jmp alltraps
80106da2:	e9 1c f9 ff ff       	jmp    801066c3 <alltraps>

80106da7 <vector44>:
.globl vector44
vector44:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $44
80106da9:	6a 2c                	push   $0x2c
  jmp alltraps
80106dab:	e9 13 f9 ff ff       	jmp    801066c3 <alltraps>

80106db0 <vector45>:
.globl vector45
vector45:
  pushl $0
80106db0:	6a 00                	push   $0x0
  pushl $45
80106db2:	6a 2d                	push   $0x2d
  jmp alltraps
80106db4:	e9 0a f9 ff ff       	jmp    801066c3 <alltraps>

80106db9 <vector46>:
.globl vector46
vector46:
  pushl $0
80106db9:	6a 00                	push   $0x0
  pushl $46
80106dbb:	6a 2e                	push   $0x2e
  jmp alltraps
80106dbd:	e9 01 f9 ff ff       	jmp    801066c3 <alltraps>

80106dc2 <vector47>:
.globl vector47
vector47:
  pushl $0
80106dc2:	6a 00                	push   $0x0
  pushl $47
80106dc4:	6a 2f                	push   $0x2f
  jmp alltraps
80106dc6:	e9 f8 f8 ff ff       	jmp    801066c3 <alltraps>

80106dcb <vector48>:
.globl vector48
vector48:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $48
80106dcd:	6a 30                	push   $0x30
  jmp alltraps
80106dcf:	e9 ef f8 ff ff       	jmp    801066c3 <alltraps>

80106dd4 <vector49>:
.globl vector49
vector49:
  pushl $0
80106dd4:	6a 00                	push   $0x0
  pushl $49
80106dd6:	6a 31                	push   $0x31
  jmp alltraps
80106dd8:	e9 e6 f8 ff ff       	jmp    801066c3 <alltraps>

80106ddd <vector50>:
.globl vector50
vector50:
  pushl $0
80106ddd:	6a 00                	push   $0x0
  pushl $50
80106ddf:	6a 32                	push   $0x32
  jmp alltraps
80106de1:	e9 dd f8 ff ff       	jmp    801066c3 <alltraps>

80106de6 <vector51>:
.globl vector51
vector51:
  pushl $0
80106de6:	6a 00                	push   $0x0
  pushl $51
80106de8:	6a 33                	push   $0x33
  jmp alltraps
80106dea:	e9 d4 f8 ff ff       	jmp    801066c3 <alltraps>

80106def <vector52>:
.globl vector52
vector52:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $52
80106df1:	6a 34                	push   $0x34
  jmp alltraps
80106df3:	e9 cb f8 ff ff       	jmp    801066c3 <alltraps>

80106df8 <vector53>:
.globl vector53
vector53:
  pushl $0
80106df8:	6a 00                	push   $0x0
  pushl $53
80106dfa:	6a 35                	push   $0x35
  jmp alltraps
80106dfc:	e9 c2 f8 ff ff       	jmp    801066c3 <alltraps>

80106e01 <vector54>:
.globl vector54
vector54:
  pushl $0
80106e01:	6a 00                	push   $0x0
  pushl $54
80106e03:	6a 36                	push   $0x36
  jmp alltraps
80106e05:	e9 b9 f8 ff ff       	jmp    801066c3 <alltraps>

80106e0a <vector55>:
.globl vector55
vector55:
  pushl $0
80106e0a:	6a 00                	push   $0x0
  pushl $55
80106e0c:	6a 37                	push   $0x37
  jmp alltraps
80106e0e:	e9 b0 f8 ff ff       	jmp    801066c3 <alltraps>

80106e13 <vector56>:
.globl vector56
vector56:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $56
80106e15:	6a 38                	push   $0x38
  jmp alltraps
80106e17:	e9 a7 f8 ff ff       	jmp    801066c3 <alltraps>

80106e1c <vector57>:
.globl vector57
vector57:
  pushl $0
80106e1c:	6a 00                	push   $0x0
  pushl $57
80106e1e:	6a 39                	push   $0x39
  jmp alltraps
80106e20:	e9 9e f8 ff ff       	jmp    801066c3 <alltraps>

80106e25 <vector58>:
.globl vector58
vector58:
  pushl $0
80106e25:	6a 00                	push   $0x0
  pushl $58
80106e27:	6a 3a                	push   $0x3a
  jmp alltraps
80106e29:	e9 95 f8 ff ff       	jmp    801066c3 <alltraps>

80106e2e <vector59>:
.globl vector59
vector59:
  pushl $0
80106e2e:	6a 00                	push   $0x0
  pushl $59
80106e30:	6a 3b                	push   $0x3b
  jmp alltraps
80106e32:	e9 8c f8 ff ff       	jmp    801066c3 <alltraps>

80106e37 <vector60>:
.globl vector60
vector60:
  pushl $0
80106e37:	6a 00                	push   $0x0
  pushl $60
80106e39:	6a 3c                	push   $0x3c
  jmp alltraps
80106e3b:	e9 83 f8 ff ff       	jmp    801066c3 <alltraps>

80106e40 <vector61>:
.globl vector61
vector61:
  pushl $0
80106e40:	6a 00                	push   $0x0
  pushl $61
80106e42:	6a 3d                	push   $0x3d
  jmp alltraps
80106e44:	e9 7a f8 ff ff       	jmp    801066c3 <alltraps>

80106e49 <vector62>:
.globl vector62
vector62:
  pushl $0
80106e49:	6a 00                	push   $0x0
  pushl $62
80106e4b:	6a 3e                	push   $0x3e
  jmp alltraps
80106e4d:	e9 71 f8 ff ff       	jmp    801066c3 <alltraps>

80106e52 <vector63>:
.globl vector63
vector63:
  pushl $0
80106e52:	6a 00                	push   $0x0
  pushl $63
80106e54:	6a 3f                	push   $0x3f
  jmp alltraps
80106e56:	e9 68 f8 ff ff       	jmp    801066c3 <alltraps>

80106e5b <vector64>:
.globl vector64
vector64:
  pushl $0
80106e5b:	6a 00                	push   $0x0
  pushl $64
80106e5d:	6a 40                	push   $0x40
  jmp alltraps
80106e5f:	e9 5f f8 ff ff       	jmp    801066c3 <alltraps>

80106e64 <vector65>:
.globl vector65
vector65:
  pushl $0
80106e64:	6a 00                	push   $0x0
  pushl $65
80106e66:	6a 41                	push   $0x41
  jmp alltraps
80106e68:	e9 56 f8 ff ff       	jmp    801066c3 <alltraps>

80106e6d <vector66>:
.globl vector66
vector66:
  pushl $0
80106e6d:	6a 00                	push   $0x0
  pushl $66
80106e6f:	6a 42                	push   $0x42
  jmp alltraps
80106e71:	e9 4d f8 ff ff       	jmp    801066c3 <alltraps>

80106e76 <vector67>:
.globl vector67
vector67:
  pushl $0
80106e76:	6a 00                	push   $0x0
  pushl $67
80106e78:	6a 43                	push   $0x43
  jmp alltraps
80106e7a:	e9 44 f8 ff ff       	jmp    801066c3 <alltraps>

80106e7f <vector68>:
.globl vector68
vector68:
  pushl $0
80106e7f:	6a 00                	push   $0x0
  pushl $68
80106e81:	6a 44                	push   $0x44
  jmp alltraps
80106e83:	e9 3b f8 ff ff       	jmp    801066c3 <alltraps>

80106e88 <vector69>:
.globl vector69
vector69:
  pushl $0
80106e88:	6a 00                	push   $0x0
  pushl $69
80106e8a:	6a 45                	push   $0x45
  jmp alltraps
80106e8c:	e9 32 f8 ff ff       	jmp    801066c3 <alltraps>

80106e91 <vector70>:
.globl vector70
vector70:
  pushl $0
80106e91:	6a 00                	push   $0x0
  pushl $70
80106e93:	6a 46                	push   $0x46
  jmp alltraps
80106e95:	e9 29 f8 ff ff       	jmp    801066c3 <alltraps>

80106e9a <vector71>:
.globl vector71
vector71:
  pushl $0
80106e9a:	6a 00                	push   $0x0
  pushl $71
80106e9c:	6a 47                	push   $0x47
  jmp alltraps
80106e9e:	e9 20 f8 ff ff       	jmp    801066c3 <alltraps>

80106ea3 <vector72>:
.globl vector72
vector72:
  pushl $0
80106ea3:	6a 00                	push   $0x0
  pushl $72
80106ea5:	6a 48                	push   $0x48
  jmp alltraps
80106ea7:	e9 17 f8 ff ff       	jmp    801066c3 <alltraps>

80106eac <vector73>:
.globl vector73
vector73:
  pushl $0
80106eac:	6a 00                	push   $0x0
  pushl $73
80106eae:	6a 49                	push   $0x49
  jmp alltraps
80106eb0:	e9 0e f8 ff ff       	jmp    801066c3 <alltraps>

80106eb5 <vector74>:
.globl vector74
vector74:
  pushl $0
80106eb5:	6a 00                	push   $0x0
  pushl $74
80106eb7:	6a 4a                	push   $0x4a
  jmp alltraps
80106eb9:	e9 05 f8 ff ff       	jmp    801066c3 <alltraps>

80106ebe <vector75>:
.globl vector75
vector75:
  pushl $0
80106ebe:	6a 00                	push   $0x0
  pushl $75
80106ec0:	6a 4b                	push   $0x4b
  jmp alltraps
80106ec2:	e9 fc f7 ff ff       	jmp    801066c3 <alltraps>

80106ec7 <vector76>:
.globl vector76
vector76:
  pushl $0
80106ec7:	6a 00                	push   $0x0
  pushl $76
80106ec9:	6a 4c                	push   $0x4c
  jmp alltraps
80106ecb:	e9 f3 f7 ff ff       	jmp    801066c3 <alltraps>

80106ed0 <vector77>:
.globl vector77
vector77:
  pushl $0
80106ed0:	6a 00                	push   $0x0
  pushl $77
80106ed2:	6a 4d                	push   $0x4d
  jmp alltraps
80106ed4:	e9 ea f7 ff ff       	jmp    801066c3 <alltraps>

80106ed9 <vector78>:
.globl vector78
vector78:
  pushl $0
80106ed9:	6a 00                	push   $0x0
  pushl $78
80106edb:	6a 4e                	push   $0x4e
  jmp alltraps
80106edd:	e9 e1 f7 ff ff       	jmp    801066c3 <alltraps>

80106ee2 <vector79>:
.globl vector79
vector79:
  pushl $0
80106ee2:	6a 00                	push   $0x0
  pushl $79
80106ee4:	6a 4f                	push   $0x4f
  jmp alltraps
80106ee6:	e9 d8 f7 ff ff       	jmp    801066c3 <alltraps>

80106eeb <vector80>:
.globl vector80
vector80:
  pushl $0
80106eeb:	6a 00                	push   $0x0
  pushl $80
80106eed:	6a 50                	push   $0x50
  jmp alltraps
80106eef:	e9 cf f7 ff ff       	jmp    801066c3 <alltraps>

80106ef4 <vector81>:
.globl vector81
vector81:
  pushl $0
80106ef4:	6a 00                	push   $0x0
  pushl $81
80106ef6:	6a 51                	push   $0x51
  jmp alltraps
80106ef8:	e9 c6 f7 ff ff       	jmp    801066c3 <alltraps>

80106efd <vector82>:
.globl vector82
vector82:
  pushl $0
80106efd:	6a 00                	push   $0x0
  pushl $82
80106eff:	6a 52                	push   $0x52
  jmp alltraps
80106f01:	e9 bd f7 ff ff       	jmp    801066c3 <alltraps>

80106f06 <vector83>:
.globl vector83
vector83:
  pushl $0
80106f06:	6a 00                	push   $0x0
  pushl $83
80106f08:	6a 53                	push   $0x53
  jmp alltraps
80106f0a:	e9 b4 f7 ff ff       	jmp    801066c3 <alltraps>

80106f0f <vector84>:
.globl vector84
vector84:
  pushl $0
80106f0f:	6a 00                	push   $0x0
  pushl $84
80106f11:	6a 54                	push   $0x54
  jmp alltraps
80106f13:	e9 ab f7 ff ff       	jmp    801066c3 <alltraps>

80106f18 <vector85>:
.globl vector85
vector85:
  pushl $0
80106f18:	6a 00                	push   $0x0
  pushl $85
80106f1a:	6a 55                	push   $0x55
  jmp alltraps
80106f1c:	e9 a2 f7 ff ff       	jmp    801066c3 <alltraps>

80106f21 <vector86>:
.globl vector86
vector86:
  pushl $0
80106f21:	6a 00                	push   $0x0
  pushl $86
80106f23:	6a 56                	push   $0x56
  jmp alltraps
80106f25:	e9 99 f7 ff ff       	jmp    801066c3 <alltraps>

80106f2a <vector87>:
.globl vector87
vector87:
  pushl $0
80106f2a:	6a 00                	push   $0x0
  pushl $87
80106f2c:	6a 57                	push   $0x57
  jmp alltraps
80106f2e:	e9 90 f7 ff ff       	jmp    801066c3 <alltraps>

80106f33 <vector88>:
.globl vector88
vector88:
  pushl $0
80106f33:	6a 00                	push   $0x0
  pushl $88
80106f35:	6a 58                	push   $0x58
  jmp alltraps
80106f37:	e9 87 f7 ff ff       	jmp    801066c3 <alltraps>

80106f3c <vector89>:
.globl vector89
vector89:
  pushl $0
80106f3c:	6a 00                	push   $0x0
  pushl $89
80106f3e:	6a 59                	push   $0x59
  jmp alltraps
80106f40:	e9 7e f7 ff ff       	jmp    801066c3 <alltraps>

80106f45 <vector90>:
.globl vector90
vector90:
  pushl $0
80106f45:	6a 00                	push   $0x0
  pushl $90
80106f47:	6a 5a                	push   $0x5a
  jmp alltraps
80106f49:	e9 75 f7 ff ff       	jmp    801066c3 <alltraps>

80106f4e <vector91>:
.globl vector91
vector91:
  pushl $0
80106f4e:	6a 00                	push   $0x0
  pushl $91
80106f50:	6a 5b                	push   $0x5b
  jmp alltraps
80106f52:	e9 6c f7 ff ff       	jmp    801066c3 <alltraps>

80106f57 <vector92>:
.globl vector92
vector92:
  pushl $0
80106f57:	6a 00                	push   $0x0
  pushl $92
80106f59:	6a 5c                	push   $0x5c
  jmp alltraps
80106f5b:	e9 63 f7 ff ff       	jmp    801066c3 <alltraps>

80106f60 <vector93>:
.globl vector93
vector93:
  pushl $0
80106f60:	6a 00                	push   $0x0
  pushl $93
80106f62:	6a 5d                	push   $0x5d
  jmp alltraps
80106f64:	e9 5a f7 ff ff       	jmp    801066c3 <alltraps>

80106f69 <vector94>:
.globl vector94
vector94:
  pushl $0
80106f69:	6a 00                	push   $0x0
  pushl $94
80106f6b:	6a 5e                	push   $0x5e
  jmp alltraps
80106f6d:	e9 51 f7 ff ff       	jmp    801066c3 <alltraps>

80106f72 <vector95>:
.globl vector95
vector95:
  pushl $0
80106f72:	6a 00                	push   $0x0
  pushl $95
80106f74:	6a 5f                	push   $0x5f
  jmp alltraps
80106f76:	e9 48 f7 ff ff       	jmp    801066c3 <alltraps>

80106f7b <vector96>:
.globl vector96
vector96:
  pushl $0
80106f7b:	6a 00                	push   $0x0
  pushl $96
80106f7d:	6a 60                	push   $0x60
  jmp alltraps
80106f7f:	e9 3f f7 ff ff       	jmp    801066c3 <alltraps>

80106f84 <vector97>:
.globl vector97
vector97:
  pushl $0
80106f84:	6a 00                	push   $0x0
  pushl $97
80106f86:	6a 61                	push   $0x61
  jmp alltraps
80106f88:	e9 36 f7 ff ff       	jmp    801066c3 <alltraps>

80106f8d <vector98>:
.globl vector98
vector98:
  pushl $0
80106f8d:	6a 00                	push   $0x0
  pushl $98
80106f8f:	6a 62                	push   $0x62
  jmp alltraps
80106f91:	e9 2d f7 ff ff       	jmp    801066c3 <alltraps>

80106f96 <vector99>:
.globl vector99
vector99:
  pushl $0
80106f96:	6a 00                	push   $0x0
  pushl $99
80106f98:	6a 63                	push   $0x63
  jmp alltraps
80106f9a:	e9 24 f7 ff ff       	jmp    801066c3 <alltraps>

80106f9f <vector100>:
.globl vector100
vector100:
  pushl $0
80106f9f:	6a 00                	push   $0x0
  pushl $100
80106fa1:	6a 64                	push   $0x64
  jmp alltraps
80106fa3:	e9 1b f7 ff ff       	jmp    801066c3 <alltraps>

80106fa8 <vector101>:
.globl vector101
vector101:
  pushl $0
80106fa8:	6a 00                	push   $0x0
  pushl $101
80106faa:	6a 65                	push   $0x65
  jmp alltraps
80106fac:	e9 12 f7 ff ff       	jmp    801066c3 <alltraps>

80106fb1 <vector102>:
.globl vector102
vector102:
  pushl $0
80106fb1:	6a 00                	push   $0x0
  pushl $102
80106fb3:	6a 66                	push   $0x66
  jmp alltraps
80106fb5:	e9 09 f7 ff ff       	jmp    801066c3 <alltraps>

80106fba <vector103>:
.globl vector103
vector103:
  pushl $0
80106fba:	6a 00                	push   $0x0
  pushl $103
80106fbc:	6a 67                	push   $0x67
  jmp alltraps
80106fbe:	e9 00 f7 ff ff       	jmp    801066c3 <alltraps>

80106fc3 <vector104>:
.globl vector104
vector104:
  pushl $0
80106fc3:	6a 00                	push   $0x0
  pushl $104
80106fc5:	6a 68                	push   $0x68
  jmp alltraps
80106fc7:	e9 f7 f6 ff ff       	jmp    801066c3 <alltraps>

80106fcc <vector105>:
.globl vector105
vector105:
  pushl $0
80106fcc:	6a 00                	push   $0x0
  pushl $105
80106fce:	6a 69                	push   $0x69
  jmp alltraps
80106fd0:	e9 ee f6 ff ff       	jmp    801066c3 <alltraps>

80106fd5 <vector106>:
.globl vector106
vector106:
  pushl $0
80106fd5:	6a 00                	push   $0x0
  pushl $106
80106fd7:	6a 6a                	push   $0x6a
  jmp alltraps
80106fd9:	e9 e5 f6 ff ff       	jmp    801066c3 <alltraps>

80106fde <vector107>:
.globl vector107
vector107:
  pushl $0
80106fde:	6a 00                	push   $0x0
  pushl $107
80106fe0:	6a 6b                	push   $0x6b
  jmp alltraps
80106fe2:	e9 dc f6 ff ff       	jmp    801066c3 <alltraps>

80106fe7 <vector108>:
.globl vector108
vector108:
  pushl $0
80106fe7:	6a 00                	push   $0x0
  pushl $108
80106fe9:	6a 6c                	push   $0x6c
  jmp alltraps
80106feb:	e9 d3 f6 ff ff       	jmp    801066c3 <alltraps>

80106ff0 <vector109>:
.globl vector109
vector109:
  pushl $0
80106ff0:	6a 00                	push   $0x0
  pushl $109
80106ff2:	6a 6d                	push   $0x6d
  jmp alltraps
80106ff4:	e9 ca f6 ff ff       	jmp    801066c3 <alltraps>

80106ff9 <vector110>:
.globl vector110
vector110:
  pushl $0
80106ff9:	6a 00                	push   $0x0
  pushl $110
80106ffb:	6a 6e                	push   $0x6e
  jmp alltraps
80106ffd:	e9 c1 f6 ff ff       	jmp    801066c3 <alltraps>

80107002 <vector111>:
.globl vector111
vector111:
  pushl $0
80107002:	6a 00                	push   $0x0
  pushl $111
80107004:	6a 6f                	push   $0x6f
  jmp alltraps
80107006:	e9 b8 f6 ff ff       	jmp    801066c3 <alltraps>

8010700b <vector112>:
.globl vector112
vector112:
  pushl $0
8010700b:	6a 00                	push   $0x0
  pushl $112
8010700d:	6a 70                	push   $0x70
  jmp alltraps
8010700f:	e9 af f6 ff ff       	jmp    801066c3 <alltraps>

80107014 <vector113>:
.globl vector113
vector113:
  pushl $0
80107014:	6a 00                	push   $0x0
  pushl $113
80107016:	6a 71                	push   $0x71
  jmp alltraps
80107018:	e9 a6 f6 ff ff       	jmp    801066c3 <alltraps>

8010701d <vector114>:
.globl vector114
vector114:
  pushl $0
8010701d:	6a 00                	push   $0x0
  pushl $114
8010701f:	6a 72                	push   $0x72
  jmp alltraps
80107021:	e9 9d f6 ff ff       	jmp    801066c3 <alltraps>

80107026 <vector115>:
.globl vector115
vector115:
  pushl $0
80107026:	6a 00                	push   $0x0
  pushl $115
80107028:	6a 73                	push   $0x73
  jmp alltraps
8010702a:	e9 94 f6 ff ff       	jmp    801066c3 <alltraps>

8010702f <vector116>:
.globl vector116
vector116:
  pushl $0
8010702f:	6a 00                	push   $0x0
  pushl $116
80107031:	6a 74                	push   $0x74
  jmp alltraps
80107033:	e9 8b f6 ff ff       	jmp    801066c3 <alltraps>

80107038 <vector117>:
.globl vector117
vector117:
  pushl $0
80107038:	6a 00                	push   $0x0
  pushl $117
8010703a:	6a 75                	push   $0x75
  jmp alltraps
8010703c:	e9 82 f6 ff ff       	jmp    801066c3 <alltraps>

80107041 <vector118>:
.globl vector118
vector118:
  pushl $0
80107041:	6a 00                	push   $0x0
  pushl $118
80107043:	6a 76                	push   $0x76
  jmp alltraps
80107045:	e9 79 f6 ff ff       	jmp    801066c3 <alltraps>

8010704a <vector119>:
.globl vector119
vector119:
  pushl $0
8010704a:	6a 00                	push   $0x0
  pushl $119
8010704c:	6a 77                	push   $0x77
  jmp alltraps
8010704e:	e9 70 f6 ff ff       	jmp    801066c3 <alltraps>

80107053 <vector120>:
.globl vector120
vector120:
  pushl $0
80107053:	6a 00                	push   $0x0
  pushl $120
80107055:	6a 78                	push   $0x78
  jmp alltraps
80107057:	e9 67 f6 ff ff       	jmp    801066c3 <alltraps>

8010705c <vector121>:
.globl vector121
vector121:
  pushl $0
8010705c:	6a 00                	push   $0x0
  pushl $121
8010705e:	6a 79                	push   $0x79
  jmp alltraps
80107060:	e9 5e f6 ff ff       	jmp    801066c3 <alltraps>

80107065 <vector122>:
.globl vector122
vector122:
  pushl $0
80107065:	6a 00                	push   $0x0
  pushl $122
80107067:	6a 7a                	push   $0x7a
  jmp alltraps
80107069:	e9 55 f6 ff ff       	jmp    801066c3 <alltraps>

8010706e <vector123>:
.globl vector123
vector123:
  pushl $0
8010706e:	6a 00                	push   $0x0
  pushl $123
80107070:	6a 7b                	push   $0x7b
  jmp alltraps
80107072:	e9 4c f6 ff ff       	jmp    801066c3 <alltraps>

80107077 <vector124>:
.globl vector124
vector124:
  pushl $0
80107077:	6a 00                	push   $0x0
  pushl $124
80107079:	6a 7c                	push   $0x7c
  jmp alltraps
8010707b:	e9 43 f6 ff ff       	jmp    801066c3 <alltraps>

80107080 <vector125>:
.globl vector125
vector125:
  pushl $0
80107080:	6a 00                	push   $0x0
  pushl $125
80107082:	6a 7d                	push   $0x7d
  jmp alltraps
80107084:	e9 3a f6 ff ff       	jmp    801066c3 <alltraps>

80107089 <vector126>:
.globl vector126
vector126:
  pushl $0
80107089:	6a 00                	push   $0x0
  pushl $126
8010708b:	6a 7e                	push   $0x7e
  jmp alltraps
8010708d:	e9 31 f6 ff ff       	jmp    801066c3 <alltraps>

80107092 <vector127>:
.globl vector127
vector127:
  pushl $0
80107092:	6a 00                	push   $0x0
  pushl $127
80107094:	6a 7f                	push   $0x7f
  jmp alltraps
80107096:	e9 28 f6 ff ff       	jmp    801066c3 <alltraps>

8010709b <vector128>:
.globl vector128
vector128:
  pushl $0
8010709b:	6a 00                	push   $0x0
  pushl $128
8010709d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801070a2:	e9 1c f6 ff ff       	jmp    801066c3 <alltraps>

801070a7 <vector129>:
.globl vector129
vector129:
  pushl $0
801070a7:	6a 00                	push   $0x0
  pushl $129
801070a9:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801070ae:	e9 10 f6 ff ff       	jmp    801066c3 <alltraps>

801070b3 <vector130>:
.globl vector130
vector130:
  pushl $0
801070b3:	6a 00                	push   $0x0
  pushl $130
801070b5:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801070ba:	e9 04 f6 ff ff       	jmp    801066c3 <alltraps>

801070bf <vector131>:
.globl vector131
vector131:
  pushl $0
801070bf:	6a 00                	push   $0x0
  pushl $131
801070c1:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801070c6:	e9 f8 f5 ff ff       	jmp    801066c3 <alltraps>

801070cb <vector132>:
.globl vector132
vector132:
  pushl $0
801070cb:	6a 00                	push   $0x0
  pushl $132
801070cd:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801070d2:	e9 ec f5 ff ff       	jmp    801066c3 <alltraps>

801070d7 <vector133>:
.globl vector133
vector133:
  pushl $0
801070d7:	6a 00                	push   $0x0
  pushl $133
801070d9:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801070de:	e9 e0 f5 ff ff       	jmp    801066c3 <alltraps>

801070e3 <vector134>:
.globl vector134
vector134:
  pushl $0
801070e3:	6a 00                	push   $0x0
  pushl $134
801070e5:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801070ea:	e9 d4 f5 ff ff       	jmp    801066c3 <alltraps>

801070ef <vector135>:
.globl vector135
vector135:
  pushl $0
801070ef:	6a 00                	push   $0x0
  pushl $135
801070f1:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801070f6:	e9 c8 f5 ff ff       	jmp    801066c3 <alltraps>

801070fb <vector136>:
.globl vector136
vector136:
  pushl $0
801070fb:	6a 00                	push   $0x0
  pushl $136
801070fd:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107102:	e9 bc f5 ff ff       	jmp    801066c3 <alltraps>

80107107 <vector137>:
.globl vector137
vector137:
  pushl $0
80107107:	6a 00                	push   $0x0
  pushl $137
80107109:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010710e:	e9 b0 f5 ff ff       	jmp    801066c3 <alltraps>

80107113 <vector138>:
.globl vector138
vector138:
  pushl $0
80107113:	6a 00                	push   $0x0
  pushl $138
80107115:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010711a:	e9 a4 f5 ff ff       	jmp    801066c3 <alltraps>

8010711f <vector139>:
.globl vector139
vector139:
  pushl $0
8010711f:	6a 00                	push   $0x0
  pushl $139
80107121:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107126:	e9 98 f5 ff ff       	jmp    801066c3 <alltraps>

8010712b <vector140>:
.globl vector140
vector140:
  pushl $0
8010712b:	6a 00                	push   $0x0
  pushl $140
8010712d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107132:	e9 8c f5 ff ff       	jmp    801066c3 <alltraps>

80107137 <vector141>:
.globl vector141
vector141:
  pushl $0
80107137:	6a 00                	push   $0x0
  pushl $141
80107139:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010713e:	e9 80 f5 ff ff       	jmp    801066c3 <alltraps>

80107143 <vector142>:
.globl vector142
vector142:
  pushl $0
80107143:	6a 00                	push   $0x0
  pushl $142
80107145:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010714a:	e9 74 f5 ff ff       	jmp    801066c3 <alltraps>

8010714f <vector143>:
.globl vector143
vector143:
  pushl $0
8010714f:	6a 00                	push   $0x0
  pushl $143
80107151:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107156:	e9 68 f5 ff ff       	jmp    801066c3 <alltraps>

8010715b <vector144>:
.globl vector144
vector144:
  pushl $0
8010715b:	6a 00                	push   $0x0
  pushl $144
8010715d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107162:	e9 5c f5 ff ff       	jmp    801066c3 <alltraps>

80107167 <vector145>:
.globl vector145
vector145:
  pushl $0
80107167:	6a 00                	push   $0x0
  pushl $145
80107169:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010716e:	e9 50 f5 ff ff       	jmp    801066c3 <alltraps>

80107173 <vector146>:
.globl vector146
vector146:
  pushl $0
80107173:	6a 00                	push   $0x0
  pushl $146
80107175:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010717a:	e9 44 f5 ff ff       	jmp    801066c3 <alltraps>

8010717f <vector147>:
.globl vector147
vector147:
  pushl $0
8010717f:	6a 00                	push   $0x0
  pushl $147
80107181:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107186:	e9 38 f5 ff ff       	jmp    801066c3 <alltraps>

8010718b <vector148>:
.globl vector148
vector148:
  pushl $0
8010718b:	6a 00                	push   $0x0
  pushl $148
8010718d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107192:	e9 2c f5 ff ff       	jmp    801066c3 <alltraps>

80107197 <vector149>:
.globl vector149
vector149:
  pushl $0
80107197:	6a 00                	push   $0x0
  pushl $149
80107199:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010719e:	e9 20 f5 ff ff       	jmp    801066c3 <alltraps>

801071a3 <vector150>:
.globl vector150
vector150:
  pushl $0
801071a3:	6a 00                	push   $0x0
  pushl $150
801071a5:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801071aa:	e9 14 f5 ff ff       	jmp    801066c3 <alltraps>

801071af <vector151>:
.globl vector151
vector151:
  pushl $0
801071af:	6a 00                	push   $0x0
  pushl $151
801071b1:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801071b6:	e9 08 f5 ff ff       	jmp    801066c3 <alltraps>

801071bb <vector152>:
.globl vector152
vector152:
  pushl $0
801071bb:	6a 00                	push   $0x0
  pushl $152
801071bd:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801071c2:	e9 fc f4 ff ff       	jmp    801066c3 <alltraps>

801071c7 <vector153>:
.globl vector153
vector153:
  pushl $0
801071c7:	6a 00                	push   $0x0
  pushl $153
801071c9:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801071ce:	e9 f0 f4 ff ff       	jmp    801066c3 <alltraps>

801071d3 <vector154>:
.globl vector154
vector154:
  pushl $0
801071d3:	6a 00                	push   $0x0
  pushl $154
801071d5:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801071da:	e9 e4 f4 ff ff       	jmp    801066c3 <alltraps>

801071df <vector155>:
.globl vector155
vector155:
  pushl $0
801071df:	6a 00                	push   $0x0
  pushl $155
801071e1:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801071e6:	e9 d8 f4 ff ff       	jmp    801066c3 <alltraps>

801071eb <vector156>:
.globl vector156
vector156:
  pushl $0
801071eb:	6a 00                	push   $0x0
  pushl $156
801071ed:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801071f2:	e9 cc f4 ff ff       	jmp    801066c3 <alltraps>

801071f7 <vector157>:
.globl vector157
vector157:
  pushl $0
801071f7:	6a 00                	push   $0x0
  pushl $157
801071f9:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801071fe:	e9 c0 f4 ff ff       	jmp    801066c3 <alltraps>

80107203 <vector158>:
.globl vector158
vector158:
  pushl $0
80107203:	6a 00                	push   $0x0
  pushl $158
80107205:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010720a:	e9 b4 f4 ff ff       	jmp    801066c3 <alltraps>

8010720f <vector159>:
.globl vector159
vector159:
  pushl $0
8010720f:	6a 00                	push   $0x0
  pushl $159
80107211:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107216:	e9 a8 f4 ff ff       	jmp    801066c3 <alltraps>

8010721b <vector160>:
.globl vector160
vector160:
  pushl $0
8010721b:	6a 00                	push   $0x0
  pushl $160
8010721d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107222:	e9 9c f4 ff ff       	jmp    801066c3 <alltraps>

80107227 <vector161>:
.globl vector161
vector161:
  pushl $0
80107227:	6a 00                	push   $0x0
  pushl $161
80107229:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010722e:	e9 90 f4 ff ff       	jmp    801066c3 <alltraps>

80107233 <vector162>:
.globl vector162
vector162:
  pushl $0
80107233:	6a 00                	push   $0x0
  pushl $162
80107235:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010723a:	e9 84 f4 ff ff       	jmp    801066c3 <alltraps>

8010723f <vector163>:
.globl vector163
vector163:
  pushl $0
8010723f:	6a 00                	push   $0x0
  pushl $163
80107241:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107246:	e9 78 f4 ff ff       	jmp    801066c3 <alltraps>

8010724b <vector164>:
.globl vector164
vector164:
  pushl $0
8010724b:	6a 00                	push   $0x0
  pushl $164
8010724d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107252:	e9 6c f4 ff ff       	jmp    801066c3 <alltraps>

80107257 <vector165>:
.globl vector165
vector165:
  pushl $0
80107257:	6a 00                	push   $0x0
  pushl $165
80107259:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010725e:	e9 60 f4 ff ff       	jmp    801066c3 <alltraps>

80107263 <vector166>:
.globl vector166
vector166:
  pushl $0
80107263:	6a 00                	push   $0x0
  pushl $166
80107265:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010726a:	e9 54 f4 ff ff       	jmp    801066c3 <alltraps>

8010726f <vector167>:
.globl vector167
vector167:
  pushl $0
8010726f:	6a 00                	push   $0x0
  pushl $167
80107271:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107276:	e9 48 f4 ff ff       	jmp    801066c3 <alltraps>

8010727b <vector168>:
.globl vector168
vector168:
  pushl $0
8010727b:	6a 00                	push   $0x0
  pushl $168
8010727d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107282:	e9 3c f4 ff ff       	jmp    801066c3 <alltraps>

80107287 <vector169>:
.globl vector169
vector169:
  pushl $0
80107287:	6a 00                	push   $0x0
  pushl $169
80107289:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010728e:	e9 30 f4 ff ff       	jmp    801066c3 <alltraps>

80107293 <vector170>:
.globl vector170
vector170:
  pushl $0
80107293:	6a 00                	push   $0x0
  pushl $170
80107295:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010729a:	e9 24 f4 ff ff       	jmp    801066c3 <alltraps>

8010729f <vector171>:
.globl vector171
vector171:
  pushl $0
8010729f:	6a 00                	push   $0x0
  pushl $171
801072a1:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801072a6:	e9 18 f4 ff ff       	jmp    801066c3 <alltraps>

801072ab <vector172>:
.globl vector172
vector172:
  pushl $0
801072ab:	6a 00                	push   $0x0
  pushl $172
801072ad:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801072b2:	e9 0c f4 ff ff       	jmp    801066c3 <alltraps>

801072b7 <vector173>:
.globl vector173
vector173:
  pushl $0
801072b7:	6a 00                	push   $0x0
  pushl $173
801072b9:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801072be:	e9 00 f4 ff ff       	jmp    801066c3 <alltraps>

801072c3 <vector174>:
.globl vector174
vector174:
  pushl $0
801072c3:	6a 00                	push   $0x0
  pushl $174
801072c5:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801072ca:	e9 f4 f3 ff ff       	jmp    801066c3 <alltraps>

801072cf <vector175>:
.globl vector175
vector175:
  pushl $0
801072cf:	6a 00                	push   $0x0
  pushl $175
801072d1:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801072d6:	e9 e8 f3 ff ff       	jmp    801066c3 <alltraps>

801072db <vector176>:
.globl vector176
vector176:
  pushl $0
801072db:	6a 00                	push   $0x0
  pushl $176
801072dd:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801072e2:	e9 dc f3 ff ff       	jmp    801066c3 <alltraps>

801072e7 <vector177>:
.globl vector177
vector177:
  pushl $0
801072e7:	6a 00                	push   $0x0
  pushl $177
801072e9:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801072ee:	e9 d0 f3 ff ff       	jmp    801066c3 <alltraps>

801072f3 <vector178>:
.globl vector178
vector178:
  pushl $0
801072f3:	6a 00                	push   $0x0
  pushl $178
801072f5:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801072fa:	e9 c4 f3 ff ff       	jmp    801066c3 <alltraps>

801072ff <vector179>:
.globl vector179
vector179:
  pushl $0
801072ff:	6a 00                	push   $0x0
  pushl $179
80107301:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107306:	e9 b8 f3 ff ff       	jmp    801066c3 <alltraps>

8010730b <vector180>:
.globl vector180
vector180:
  pushl $0
8010730b:	6a 00                	push   $0x0
  pushl $180
8010730d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107312:	e9 ac f3 ff ff       	jmp    801066c3 <alltraps>

80107317 <vector181>:
.globl vector181
vector181:
  pushl $0
80107317:	6a 00                	push   $0x0
  pushl $181
80107319:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010731e:	e9 a0 f3 ff ff       	jmp    801066c3 <alltraps>

80107323 <vector182>:
.globl vector182
vector182:
  pushl $0
80107323:	6a 00                	push   $0x0
  pushl $182
80107325:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010732a:	e9 94 f3 ff ff       	jmp    801066c3 <alltraps>

8010732f <vector183>:
.globl vector183
vector183:
  pushl $0
8010732f:	6a 00                	push   $0x0
  pushl $183
80107331:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107336:	e9 88 f3 ff ff       	jmp    801066c3 <alltraps>

8010733b <vector184>:
.globl vector184
vector184:
  pushl $0
8010733b:	6a 00                	push   $0x0
  pushl $184
8010733d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107342:	e9 7c f3 ff ff       	jmp    801066c3 <alltraps>

80107347 <vector185>:
.globl vector185
vector185:
  pushl $0
80107347:	6a 00                	push   $0x0
  pushl $185
80107349:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010734e:	e9 70 f3 ff ff       	jmp    801066c3 <alltraps>

80107353 <vector186>:
.globl vector186
vector186:
  pushl $0
80107353:	6a 00                	push   $0x0
  pushl $186
80107355:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010735a:	e9 64 f3 ff ff       	jmp    801066c3 <alltraps>

8010735f <vector187>:
.globl vector187
vector187:
  pushl $0
8010735f:	6a 00                	push   $0x0
  pushl $187
80107361:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107366:	e9 58 f3 ff ff       	jmp    801066c3 <alltraps>

8010736b <vector188>:
.globl vector188
vector188:
  pushl $0
8010736b:	6a 00                	push   $0x0
  pushl $188
8010736d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107372:	e9 4c f3 ff ff       	jmp    801066c3 <alltraps>

80107377 <vector189>:
.globl vector189
vector189:
  pushl $0
80107377:	6a 00                	push   $0x0
  pushl $189
80107379:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010737e:	e9 40 f3 ff ff       	jmp    801066c3 <alltraps>

80107383 <vector190>:
.globl vector190
vector190:
  pushl $0
80107383:	6a 00                	push   $0x0
  pushl $190
80107385:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010738a:	e9 34 f3 ff ff       	jmp    801066c3 <alltraps>

8010738f <vector191>:
.globl vector191
vector191:
  pushl $0
8010738f:	6a 00                	push   $0x0
  pushl $191
80107391:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107396:	e9 28 f3 ff ff       	jmp    801066c3 <alltraps>

8010739b <vector192>:
.globl vector192
vector192:
  pushl $0
8010739b:	6a 00                	push   $0x0
  pushl $192
8010739d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801073a2:	e9 1c f3 ff ff       	jmp    801066c3 <alltraps>

801073a7 <vector193>:
.globl vector193
vector193:
  pushl $0
801073a7:	6a 00                	push   $0x0
  pushl $193
801073a9:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801073ae:	e9 10 f3 ff ff       	jmp    801066c3 <alltraps>

801073b3 <vector194>:
.globl vector194
vector194:
  pushl $0
801073b3:	6a 00                	push   $0x0
  pushl $194
801073b5:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801073ba:	e9 04 f3 ff ff       	jmp    801066c3 <alltraps>

801073bf <vector195>:
.globl vector195
vector195:
  pushl $0
801073bf:	6a 00                	push   $0x0
  pushl $195
801073c1:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801073c6:	e9 f8 f2 ff ff       	jmp    801066c3 <alltraps>

801073cb <vector196>:
.globl vector196
vector196:
  pushl $0
801073cb:	6a 00                	push   $0x0
  pushl $196
801073cd:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801073d2:	e9 ec f2 ff ff       	jmp    801066c3 <alltraps>

801073d7 <vector197>:
.globl vector197
vector197:
  pushl $0
801073d7:	6a 00                	push   $0x0
  pushl $197
801073d9:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801073de:	e9 e0 f2 ff ff       	jmp    801066c3 <alltraps>

801073e3 <vector198>:
.globl vector198
vector198:
  pushl $0
801073e3:	6a 00                	push   $0x0
  pushl $198
801073e5:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801073ea:	e9 d4 f2 ff ff       	jmp    801066c3 <alltraps>

801073ef <vector199>:
.globl vector199
vector199:
  pushl $0
801073ef:	6a 00                	push   $0x0
  pushl $199
801073f1:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801073f6:	e9 c8 f2 ff ff       	jmp    801066c3 <alltraps>

801073fb <vector200>:
.globl vector200
vector200:
  pushl $0
801073fb:	6a 00                	push   $0x0
  pushl $200
801073fd:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107402:	e9 bc f2 ff ff       	jmp    801066c3 <alltraps>

80107407 <vector201>:
.globl vector201
vector201:
  pushl $0
80107407:	6a 00                	push   $0x0
  pushl $201
80107409:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010740e:	e9 b0 f2 ff ff       	jmp    801066c3 <alltraps>

80107413 <vector202>:
.globl vector202
vector202:
  pushl $0
80107413:	6a 00                	push   $0x0
  pushl $202
80107415:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010741a:	e9 a4 f2 ff ff       	jmp    801066c3 <alltraps>

8010741f <vector203>:
.globl vector203
vector203:
  pushl $0
8010741f:	6a 00                	push   $0x0
  pushl $203
80107421:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107426:	e9 98 f2 ff ff       	jmp    801066c3 <alltraps>

8010742b <vector204>:
.globl vector204
vector204:
  pushl $0
8010742b:	6a 00                	push   $0x0
  pushl $204
8010742d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107432:	e9 8c f2 ff ff       	jmp    801066c3 <alltraps>

80107437 <vector205>:
.globl vector205
vector205:
  pushl $0
80107437:	6a 00                	push   $0x0
  pushl $205
80107439:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010743e:	e9 80 f2 ff ff       	jmp    801066c3 <alltraps>

80107443 <vector206>:
.globl vector206
vector206:
  pushl $0
80107443:	6a 00                	push   $0x0
  pushl $206
80107445:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010744a:	e9 74 f2 ff ff       	jmp    801066c3 <alltraps>

8010744f <vector207>:
.globl vector207
vector207:
  pushl $0
8010744f:	6a 00                	push   $0x0
  pushl $207
80107451:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107456:	e9 68 f2 ff ff       	jmp    801066c3 <alltraps>

8010745b <vector208>:
.globl vector208
vector208:
  pushl $0
8010745b:	6a 00                	push   $0x0
  pushl $208
8010745d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107462:	e9 5c f2 ff ff       	jmp    801066c3 <alltraps>

80107467 <vector209>:
.globl vector209
vector209:
  pushl $0
80107467:	6a 00                	push   $0x0
  pushl $209
80107469:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010746e:	e9 50 f2 ff ff       	jmp    801066c3 <alltraps>

80107473 <vector210>:
.globl vector210
vector210:
  pushl $0
80107473:	6a 00                	push   $0x0
  pushl $210
80107475:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010747a:	e9 44 f2 ff ff       	jmp    801066c3 <alltraps>

8010747f <vector211>:
.globl vector211
vector211:
  pushl $0
8010747f:	6a 00                	push   $0x0
  pushl $211
80107481:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107486:	e9 38 f2 ff ff       	jmp    801066c3 <alltraps>

8010748b <vector212>:
.globl vector212
vector212:
  pushl $0
8010748b:	6a 00                	push   $0x0
  pushl $212
8010748d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107492:	e9 2c f2 ff ff       	jmp    801066c3 <alltraps>

80107497 <vector213>:
.globl vector213
vector213:
  pushl $0
80107497:	6a 00                	push   $0x0
  pushl $213
80107499:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010749e:	e9 20 f2 ff ff       	jmp    801066c3 <alltraps>

801074a3 <vector214>:
.globl vector214
vector214:
  pushl $0
801074a3:	6a 00                	push   $0x0
  pushl $214
801074a5:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801074aa:	e9 14 f2 ff ff       	jmp    801066c3 <alltraps>

801074af <vector215>:
.globl vector215
vector215:
  pushl $0
801074af:	6a 00                	push   $0x0
  pushl $215
801074b1:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801074b6:	e9 08 f2 ff ff       	jmp    801066c3 <alltraps>

801074bb <vector216>:
.globl vector216
vector216:
  pushl $0
801074bb:	6a 00                	push   $0x0
  pushl $216
801074bd:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801074c2:	e9 fc f1 ff ff       	jmp    801066c3 <alltraps>

801074c7 <vector217>:
.globl vector217
vector217:
  pushl $0
801074c7:	6a 00                	push   $0x0
  pushl $217
801074c9:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801074ce:	e9 f0 f1 ff ff       	jmp    801066c3 <alltraps>

801074d3 <vector218>:
.globl vector218
vector218:
  pushl $0
801074d3:	6a 00                	push   $0x0
  pushl $218
801074d5:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801074da:	e9 e4 f1 ff ff       	jmp    801066c3 <alltraps>

801074df <vector219>:
.globl vector219
vector219:
  pushl $0
801074df:	6a 00                	push   $0x0
  pushl $219
801074e1:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801074e6:	e9 d8 f1 ff ff       	jmp    801066c3 <alltraps>

801074eb <vector220>:
.globl vector220
vector220:
  pushl $0
801074eb:	6a 00                	push   $0x0
  pushl $220
801074ed:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801074f2:	e9 cc f1 ff ff       	jmp    801066c3 <alltraps>

801074f7 <vector221>:
.globl vector221
vector221:
  pushl $0
801074f7:	6a 00                	push   $0x0
  pushl $221
801074f9:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801074fe:	e9 c0 f1 ff ff       	jmp    801066c3 <alltraps>

80107503 <vector222>:
.globl vector222
vector222:
  pushl $0
80107503:	6a 00                	push   $0x0
  pushl $222
80107505:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010750a:	e9 b4 f1 ff ff       	jmp    801066c3 <alltraps>

8010750f <vector223>:
.globl vector223
vector223:
  pushl $0
8010750f:	6a 00                	push   $0x0
  pushl $223
80107511:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107516:	e9 a8 f1 ff ff       	jmp    801066c3 <alltraps>

8010751b <vector224>:
.globl vector224
vector224:
  pushl $0
8010751b:	6a 00                	push   $0x0
  pushl $224
8010751d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107522:	e9 9c f1 ff ff       	jmp    801066c3 <alltraps>

80107527 <vector225>:
.globl vector225
vector225:
  pushl $0
80107527:	6a 00                	push   $0x0
  pushl $225
80107529:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010752e:	e9 90 f1 ff ff       	jmp    801066c3 <alltraps>

80107533 <vector226>:
.globl vector226
vector226:
  pushl $0
80107533:	6a 00                	push   $0x0
  pushl $226
80107535:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010753a:	e9 84 f1 ff ff       	jmp    801066c3 <alltraps>

8010753f <vector227>:
.globl vector227
vector227:
  pushl $0
8010753f:	6a 00                	push   $0x0
  pushl $227
80107541:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107546:	e9 78 f1 ff ff       	jmp    801066c3 <alltraps>

8010754b <vector228>:
.globl vector228
vector228:
  pushl $0
8010754b:	6a 00                	push   $0x0
  pushl $228
8010754d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107552:	e9 6c f1 ff ff       	jmp    801066c3 <alltraps>

80107557 <vector229>:
.globl vector229
vector229:
  pushl $0
80107557:	6a 00                	push   $0x0
  pushl $229
80107559:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010755e:	e9 60 f1 ff ff       	jmp    801066c3 <alltraps>

80107563 <vector230>:
.globl vector230
vector230:
  pushl $0
80107563:	6a 00                	push   $0x0
  pushl $230
80107565:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010756a:	e9 54 f1 ff ff       	jmp    801066c3 <alltraps>

8010756f <vector231>:
.globl vector231
vector231:
  pushl $0
8010756f:	6a 00                	push   $0x0
  pushl $231
80107571:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107576:	e9 48 f1 ff ff       	jmp    801066c3 <alltraps>

8010757b <vector232>:
.globl vector232
vector232:
  pushl $0
8010757b:	6a 00                	push   $0x0
  pushl $232
8010757d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107582:	e9 3c f1 ff ff       	jmp    801066c3 <alltraps>

80107587 <vector233>:
.globl vector233
vector233:
  pushl $0
80107587:	6a 00                	push   $0x0
  pushl $233
80107589:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010758e:	e9 30 f1 ff ff       	jmp    801066c3 <alltraps>

80107593 <vector234>:
.globl vector234
vector234:
  pushl $0
80107593:	6a 00                	push   $0x0
  pushl $234
80107595:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010759a:	e9 24 f1 ff ff       	jmp    801066c3 <alltraps>

8010759f <vector235>:
.globl vector235
vector235:
  pushl $0
8010759f:	6a 00                	push   $0x0
  pushl $235
801075a1:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801075a6:	e9 18 f1 ff ff       	jmp    801066c3 <alltraps>

801075ab <vector236>:
.globl vector236
vector236:
  pushl $0
801075ab:	6a 00                	push   $0x0
  pushl $236
801075ad:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801075b2:	e9 0c f1 ff ff       	jmp    801066c3 <alltraps>

801075b7 <vector237>:
.globl vector237
vector237:
  pushl $0
801075b7:	6a 00                	push   $0x0
  pushl $237
801075b9:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801075be:	e9 00 f1 ff ff       	jmp    801066c3 <alltraps>

801075c3 <vector238>:
.globl vector238
vector238:
  pushl $0
801075c3:	6a 00                	push   $0x0
  pushl $238
801075c5:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801075ca:	e9 f4 f0 ff ff       	jmp    801066c3 <alltraps>

801075cf <vector239>:
.globl vector239
vector239:
  pushl $0
801075cf:	6a 00                	push   $0x0
  pushl $239
801075d1:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801075d6:	e9 e8 f0 ff ff       	jmp    801066c3 <alltraps>

801075db <vector240>:
.globl vector240
vector240:
  pushl $0
801075db:	6a 00                	push   $0x0
  pushl $240
801075dd:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801075e2:	e9 dc f0 ff ff       	jmp    801066c3 <alltraps>

801075e7 <vector241>:
.globl vector241
vector241:
  pushl $0
801075e7:	6a 00                	push   $0x0
  pushl $241
801075e9:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801075ee:	e9 d0 f0 ff ff       	jmp    801066c3 <alltraps>

801075f3 <vector242>:
.globl vector242
vector242:
  pushl $0
801075f3:	6a 00                	push   $0x0
  pushl $242
801075f5:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801075fa:	e9 c4 f0 ff ff       	jmp    801066c3 <alltraps>

801075ff <vector243>:
.globl vector243
vector243:
  pushl $0
801075ff:	6a 00                	push   $0x0
  pushl $243
80107601:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107606:	e9 b8 f0 ff ff       	jmp    801066c3 <alltraps>

8010760b <vector244>:
.globl vector244
vector244:
  pushl $0
8010760b:	6a 00                	push   $0x0
  pushl $244
8010760d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107612:	e9 ac f0 ff ff       	jmp    801066c3 <alltraps>

80107617 <vector245>:
.globl vector245
vector245:
  pushl $0
80107617:	6a 00                	push   $0x0
  pushl $245
80107619:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010761e:	e9 a0 f0 ff ff       	jmp    801066c3 <alltraps>

80107623 <vector246>:
.globl vector246
vector246:
  pushl $0
80107623:	6a 00                	push   $0x0
  pushl $246
80107625:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010762a:	e9 94 f0 ff ff       	jmp    801066c3 <alltraps>

8010762f <vector247>:
.globl vector247
vector247:
  pushl $0
8010762f:	6a 00                	push   $0x0
  pushl $247
80107631:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107636:	e9 88 f0 ff ff       	jmp    801066c3 <alltraps>

8010763b <vector248>:
.globl vector248
vector248:
  pushl $0
8010763b:	6a 00                	push   $0x0
  pushl $248
8010763d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107642:	e9 7c f0 ff ff       	jmp    801066c3 <alltraps>

80107647 <vector249>:
.globl vector249
vector249:
  pushl $0
80107647:	6a 00                	push   $0x0
  pushl $249
80107649:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010764e:	e9 70 f0 ff ff       	jmp    801066c3 <alltraps>

80107653 <vector250>:
.globl vector250
vector250:
  pushl $0
80107653:	6a 00                	push   $0x0
  pushl $250
80107655:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010765a:	e9 64 f0 ff ff       	jmp    801066c3 <alltraps>

8010765f <vector251>:
.globl vector251
vector251:
  pushl $0
8010765f:	6a 00                	push   $0x0
  pushl $251
80107661:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107666:	e9 58 f0 ff ff       	jmp    801066c3 <alltraps>

8010766b <vector252>:
.globl vector252
vector252:
  pushl $0
8010766b:	6a 00                	push   $0x0
  pushl $252
8010766d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107672:	e9 4c f0 ff ff       	jmp    801066c3 <alltraps>

80107677 <vector253>:
.globl vector253
vector253:
  pushl $0
80107677:	6a 00                	push   $0x0
  pushl $253
80107679:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010767e:	e9 40 f0 ff ff       	jmp    801066c3 <alltraps>

80107683 <vector254>:
.globl vector254
vector254:
  pushl $0
80107683:	6a 00                	push   $0x0
  pushl $254
80107685:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010768a:	e9 34 f0 ff ff       	jmp    801066c3 <alltraps>

8010768f <vector255>:
.globl vector255
vector255:
  pushl $0
8010768f:	6a 00                	push   $0x0
  pushl $255
80107691:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107696:	e9 28 f0 ff ff       	jmp    801066c3 <alltraps>
8010769b:	66 90                	xchg   %ax,%ax
8010769d:	66 90                	xchg   %ax,%ax
8010769f:	90                   	nop

801076a0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801076a0:	55                   	push   %ebp
801076a1:	89 e5                	mov    %esp,%ebp
801076a3:	57                   	push   %edi
801076a4:	56                   	push   %esi
801076a5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801076a7:	c1 ea 16             	shr    $0x16,%edx
{
801076aa:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
801076ab:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
801076ae:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801076b1:	8b 1f                	mov    (%edi),%ebx
801076b3:	f6 c3 01             	test   $0x1,%bl
801076b6:	74 28                	je     801076e0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801076b8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801076be:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801076c4:	89 f0                	mov    %esi,%eax
}
801076c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801076c9:	c1 e8 0a             	shr    $0xa,%eax
801076cc:	25 fc 0f 00 00       	and    $0xffc,%eax
801076d1:	01 d8                	add    %ebx,%eax
}
801076d3:	5b                   	pop    %ebx
801076d4:	5e                   	pop    %esi
801076d5:	5f                   	pop    %edi
801076d6:	5d                   	pop    %ebp
801076d7:	c3                   	ret    
801076d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076df:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801076e0:	85 c9                	test   %ecx,%ecx
801076e2:	74 2c                	je     80107710 <walkpgdir+0x70>
801076e4:	e8 b7 b3 ff ff       	call   80102aa0 <kalloc>
801076e9:	89 c3                	mov    %eax,%ebx
801076eb:	85 c0                	test   %eax,%eax
801076ed:	74 21                	je     80107710 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801076ef:	83 ec 04             	sub    $0x4,%esp
801076f2:	68 00 10 00 00       	push   $0x1000
801076f7:	6a 00                	push   $0x0
801076f9:	50                   	push   %eax
801076fa:	e8 91 dd ff ff       	call   80105490 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801076ff:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107705:	83 c4 10             	add    $0x10,%esp
80107708:	83 c8 07             	or     $0x7,%eax
8010770b:	89 07                	mov    %eax,(%edi)
8010770d:	eb b5                	jmp    801076c4 <walkpgdir+0x24>
8010770f:	90                   	nop
}
80107710:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107713:	31 c0                	xor    %eax,%eax
}
80107715:	5b                   	pop    %ebx
80107716:	5e                   	pop    %esi
80107717:	5f                   	pop    %edi
80107718:	5d                   	pop    %ebp
80107719:	c3                   	ret    
8010771a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107720 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107720:	55                   	push   %ebp
80107721:	89 e5                	mov    %esp,%ebp
80107723:	57                   	push   %edi
80107724:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107726:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
8010772a:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010772b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80107730:	89 d6                	mov    %edx,%esi
{
80107732:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107733:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80107739:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010773c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010773f:	8b 45 08             	mov    0x8(%ebp),%eax
80107742:	29 f0                	sub    %esi,%eax
80107744:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107747:	eb 1f                	jmp    80107768 <mappages+0x48>
80107749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80107750:	f6 00 01             	testb  $0x1,(%eax)
80107753:	75 45                	jne    8010779a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80107755:	0b 5d 0c             	or     0xc(%ebp),%ebx
80107758:	83 cb 01             	or     $0x1,%ebx
8010775b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
8010775d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80107760:	74 2e                	je     80107790 <mappages+0x70>
      break;
    a += PGSIZE;
80107762:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80107768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010776b:	b9 01 00 00 00       	mov    $0x1,%ecx
80107770:	89 f2                	mov    %esi,%edx
80107772:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80107775:	89 f8                	mov    %edi,%eax
80107777:	e8 24 ff ff ff       	call   801076a0 <walkpgdir>
8010777c:	85 c0                	test   %eax,%eax
8010777e:	75 d0                	jne    80107750 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107780:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107783:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107788:	5b                   	pop    %ebx
80107789:	5e                   	pop    %esi
8010778a:	5f                   	pop    %edi
8010778b:	5d                   	pop    %ebp
8010778c:	c3                   	ret    
8010778d:	8d 76 00             	lea    0x0(%esi),%esi
80107790:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107793:	31 c0                	xor    %eax,%eax
}
80107795:	5b                   	pop    %ebx
80107796:	5e                   	pop    %esi
80107797:	5f                   	pop    %edi
80107798:	5d                   	pop    %ebp
80107799:	c3                   	ret    
      panic("remap");
8010779a:	83 ec 0c             	sub    $0xc,%esp
8010779d:	68 60 8f 10 80       	push   $0x80108f60
801077a2:	e8 e9 8b ff ff       	call   80100390 <panic>
801077a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077ae:	66 90                	xchg   %ax,%ax

801077b0 <seginit>:
{
801077b0:	f3 0f 1e fb          	endbr32 
801077b4:	55                   	push   %ebp
801077b5:	89 e5                	mov    %esp,%ebp
801077b7:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801077ba:	e8 01 c7 ff ff       	call   80103ec0 <cpuid>
  pd[0] = size-1;
801077bf:	ba 2f 00 00 00       	mov    $0x2f,%edx
801077c4:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801077ca:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801077ce:	c7 80 18 48 11 80 ff 	movl   $0xffff,-0x7feeb7e8(%eax)
801077d5:	ff 00 00 
801077d8:	c7 80 1c 48 11 80 00 	movl   $0xcf9a00,-0x7feeb7e4(%eax)
801077df:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801077e2:	c7 80 20 48 11 80 ff 	movl   $0xffff,-0x7feeb7e0(%eax)
801077e9:	ff 00 00 
801077ec:	c7 80 24 48 11 80 00 	movl   $0xcf9200,-0x7feeb7dc(%eax)
801077f3:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801077f6:	c7 80 28 48 11 80 ff 	movl   $0xffff,-0x7feeb7d8(%eax)
801077fd:	ff 00 00 
80107800:	c7 80 2c 48 11 80 00 	movl   $0xcffa00,-0x7feeb7d4(%eax)
80107807:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010780a:	c7 80 30 48 11 80 ff 	movl   $0xffff,-0x7feeb7d0(%eax)
80107811:	ff 00 00 
80107814:	c7 80 34 48 11 80 00 	movl   $0xcff200,-0x7feeb7cc(%eax)
8010781b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010781e:	05 10 48 11 80       	add    $0x80114810,%eax
  pd[1] = (uint)p;
80107823:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107827:	c1 e8 10             	shr    $0x10,%eax
8010782a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010782e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107831:	0f 01 10             	lgdtl  (%eax)
}
80107834:	c9                   	leave  
80107835:	c3                   	ret    
80107836:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010783d:	8d 76 00             	lea    0x0(%esi),%esi

80107840 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107840:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107844:	a1 c4 f1 11 80       	mov    0x8011f1c4,%eax
80107849:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010784e:	0f 22 d8             	mov    %eax,%cr3
}
80107851:	c3                   	ret    
80107852:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107860 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107860:	f3 0f 1e fb          	endbr32 
80107864:	55                   	push   %ebp
80107865:	89 e5                	mov    %esp,%ebp
80107867:	57                   	push   %edi
80107868:	56                   	push   %esi
80107869:	53                   	push   %ebx
8010786a:	83 ec 1c             	sub    $0x1c,%esp
8010786d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107870:	85 f6                	test   %esi,%esi
80107872:	0f 84 cb 00 00 00    	je     80107943 <switchuvm+0xe3>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80107878:	8b 46 08             	mov    0x8(%esi),%eax
8010787b:	85 c0                	test   %eax,%eax
8010787d:	0f 84 da 00 00 00    	je     8010795d <switchuvm+0xfd>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80107883:	8b 46 04             	mov    0x4(%esi),%eax
80107886:	85 c0                	test   %eax,%eax
80107888:	0f 84 c2 00 00 00    	je     80107950 <switchuvm+0xf0>
    panic("switchuvm: no pgdir");

  pushcli();
8010788e:	e8 ed d9 ff ff       	call   80105280 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107893:	e8 b8 c5 ff ff       	call   80103e50 <mycpu>
80107898:	89 c3                	mov    %eax,%ebx
8010789a:	e8 b1 c5 ff ff       	call   80103e50 <mycpu>
8010789f:	89 c7                	mov    %eax,%edi
801078a1:	e8 aa c5 ff ff       	call   80103e50 <mycpu>
801078a6:	83 c7 08             	add    $0x8,%edi
801078a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801078ac:	e8 9f c5 ff ff       	call   80103e50 <mycpu>
801078b1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801078b4:	ba 67 00 00 00       	mov    $0x67,%edx
801078b9:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801078c0:	83 c0 08             	add    $0x8,%eax
801078c3:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801078ca:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801078cf:	83 c1 08             	add    $0x8,%ecx
801078d2:	c1 e8 18             	shr    $0x18,%eax
801078d5:	c1 e9 10             	shr    $0x10,%ecx
801078d8:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801078de:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801078e4:	b9 99 40 00 00       	mov    $0x4099,%ecx
801078e9:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801078f0:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801078f5:	e8 56 c5 ff ff       	call   80103e50 <mycpu>
801078fa:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107901:	e8 4a c5 ff ff       	call   80103e50 <mycpu>
80107906:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010790a:	8b 5e 08             	mov    0x8(%esi),%ebx
8010790d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107913:	e8 38 c5 ff ff       	call   80103e50 <mycpu>
80107918:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010791b:	e8 30 c5 ff ff       	call   80103e50 <mycpu>
80107920:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107924:	b8 28 00 00 00       	mov    $0x28,%eax
80107929:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010792c:	8b 46 04             	mov    0x4(%esi),%eax
8010792f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107934:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80107937:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010793a:	5b                   	pop    %ebx
8010793b:	5e                   	pop    %esi
8010793c:	5f                   	pop    %edi
8010793d:	5d                   	pop    %ebp
  popcli();
8010793e:	e9 8d d9 ff ff       	jmp    801052d0 <popcli>
    panic("switchuvm: no process");
80107943:	83 ec 0c             	sub    $0xc,%esp
80107946:	68 66 8f 10 80       	push   $0x80108f66
8010794b:	e8 40 8a ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107950:	83 ec 0c             	sub    $0xc,%esp
80107953:	68 91 8f 10 80       	push   $0x80108f91
80107958:	e8 33 8a ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
8010795d:	83 ec 0c             	sub    $0xc,%esp
80107960:	68 7c 8f 10 80       	push   $0x80108f7c
80107965:	e8 26 8a ff ff       	call   80100390 <panic>
8010796a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107970 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107970:	f3 0f 1e fb          	endbr32 
80107974:	55                   	push   %ebp
80107975:	89 e5                	mov    %esp,%ebp
80107977:	57                   	push   %edi
80107978:	56                   	push   %esi
80107979:	53                   	push   %ebx
8010797a:	83 ec 1c             	sub    $0x1c,%esp
8010797d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107980:	8b 75 10             	mov    0x10(%ebp),%esi
80107983:	8b 7d 08             	mov    0x8(%ebp),%edi
80107986:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
80107989:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010798f:	77 4b                	ja     801079dc <inituvm+0x6c>
    panic("inituvm: more than a page");
  mem = kalloc();
80107991:	e8 0a b1 ff ff       	call   80102aa0 <kalloc>
  memset(mem, 0, PGSIZE);
80107996:	83 ec 04             	sub    $0x4,%esp
80107999:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010799e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801079a0:	6a 00                	push   $0x0
801079a2:	50                   	push   %eax
801079a3:	e8 e8 da ff ff       	call   80105490 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801079a8:	58                   	pop    %eax
801079a9:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801079af:	5a                   	pop    %edx
801079b0:	6a 06                	push   $0x6
801079b2:	b9 00 10 00 00       	mov    $0x1000,%ecx
801079b7:	31 d2                	xor    %edx,%edx
801079b9:	50                   	push   %eax
801079ba:	89 f8                	mov    %edi,%eax
801079bc:	e8 5f fd ff ff       	call   80107720 <mappages>
  memmove(mem, init, sz);
801079c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801079c4:	89 75 10             	mov    %esi,0x10(%ebp)
801079c7:	83 c4 10             	add    $0x10,%esp
801079ca:	89 5d 08             	mov    %ebx,0x8(%ebp)
801079cd:	89 45 0c             	mov    %eax,0xc(%ebp)
}
801079d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079d3:	5b                   	pop    %ebx
801079d4:	5e                   	pop    %esi
801079d5:	5f                   	pop    %edi
801079d6:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801079d7:	e9 54 db ff ff       	jmp    80105530 <memmove>
    panic("inituvm: more than a page");
801079dc:	83 ec 0c             	sub    $0xc,%esp
801079df:	68 a5 8f 10 80       	push   $0x80108fa5
801079e4:	e8 a7 89 ff ff       	call   80100390 <panic>
801079e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801079f0 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801079f0:	f3 0f 1e fb          	endbr32 
801079f4:	55                   	push   %ebp
801079f5:	89 e5                	mov    %esp,%ebp
801079f7:	57                   	push   %edi
801079f8:	56                   	push   %esi
801079f9:	53                   	push   %ebx
801079fa:	83 ec 1c             	sub    $0x1c,%esp
801079fd:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a00:	8b 75 18             	mov    0x18(%ebp),%esi
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107a03:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107a08:	0f 85 99 00 00 00    	jne    80107aa7 <loaduvm+0xb7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107a0e:	01 f0                	add    %esi,%eax
80107a10:	89 f3                	mov    %esi,%ebx
80107a12:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107a15:	8b 45 14             	mov    0x14(%ebp),%eax
80107a18:	01 f0                	add    %esi,%eax
80107a1a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107a1d:	85 f6                	test   %esi,%esi
80107a1f:	75 15                	jne    80107a36 <loaduvm+0x46>
80107a21:	eb 6d                	jmp    80107a90 <loaduvm+0xa0>
80107a23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107a27:	90                   	nop
80107a28:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107a2e:	89 f0                	mov    %esi,%eax
80107a30:	29 d8                	sub    %ebx,%eax
80107a32:	39 c6                	cmp    %eax,%esi
80107a34:	76 5a                	jbe    80107a90 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107a36:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107a39:	8b 45 08             	mov    0x8(%ebp),%eax
80107a3c:	31 c9                	xor    %ecx,%ecx
80107a3e:	29 da                	sub    %ebx,%edx
80107a40:	e8 5b fc ff ff       	call   801076a0 <walkpgdir>
80107a45:	85 c0                	test   %eax,%eax
80107a47:	74 51                	je     80107a9a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80107a49:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107a4b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80107a4e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107a53:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107a58:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80107a5e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107a61:	29 d9                	sub    %ebx,%ecx
80107a63:	05 00 00 00 80       	add    $0x80000000,%eax
80107a68:	57                   	push   %edi
80107a69:	51                   	push   %ecx
80107a6a:	50                   	push   %eax
80107a6b:	ff 75 10             	pushl  0x10(%ebp)
80107a6e:	e8 ed 9f ff ff       	call   80101a60 <readi>
80107a73:	83 c4 10             	add    $0x10,%esp
80107a76:	39 f8                	cmp    %edi,%eax
80107a78:	74 ae                	je     80107a28 <loaduvm+0x38>
      return -1;
  }
  return 0;
}
80107a7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107a7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107a82:	5b                   	pop    %ebx
80107a83:	5e                   	pop    %esi
80107a84:	5f                   	pop    %edi
80107a85:	5d                   	pop    %ebp
80107a86:	c3                   	ret    
80107a87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a8e:	66 90                	xchg   %ax,%ax
80107a90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107a93:	31 c0                	xor    %eax,%eax
}
80107a95:	5b                   	pop    %ebx
80107a96:	5e                   	pop    %esi
80107a97:	5f                   	pop    %edi
80107a98:	5d                   	pop    %ebp
80107a99:	c3                   	ret    
      panic("loaduvm: address should exist");
80107a9a:	83 ec 0c             	sub    $0xc,%esp
80107a9d:	68 bf 8f 10 80       	push   $0x80108fbf
80107aa2:	e8 e9 88 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107aa7:	83 ec 0c             	sub    $0xc,%esp
80107aaa:	68 94 90 10 80       	push   $0x80109094
80107aaf:	e8 dc 88 ff ff       	call   80100390 <panic>
80107ab4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107abb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107abf:	90                   	nop

80107ac0 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107ac0:	f3 0f 1e fb          	endbr32 
80107ac4:	55                   	push   %ebp
80107ac5:	89 e5                	mov    %esp,%ebp
80107ac7:	57                   	push   %edi
80107ac8:	56                   	push   %esi
80107ac9:	53                   	push   %ebx
80107aca:	83 ec 1c             	sub    $0x1c,%esp
80107acd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pte_t *pte;
  uint a, pa;

  struct proc *p = myproc();
80107ad0:	e8 0b c4 ff ff       	call   80103ee0 <myproc>
80107ad5:	89 c7                	mov    %eax,%edi
  if(newsz >= oldsz)
80107ad7:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ada:	39 45 10             	cmp    %eax,0x10(%ebp)
80107add:	0f 83 bb 00 00 00    	jae    80107b9e <deallocuvm+0xde>
    return oldsz;

  a = PGROUNDUP(newsz);
80107ae3:	8b 45 10             	mov    0x10(%ebp),%eax
80107ae6:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80107aec:	89 d6                	mov    %edx,%esi
80107aee:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a  < oldsz; a += PGSIZE){
80107af4:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107af7:	0f 86 9e 00 00 00    	jbe    80107b9b <deallocuvm+0xdb>
80107afd:	89 f0                	mov    %esi,%eax
80107aff:	89 fe                	mov    %edi,%esi
80107b01:	89 c7                	mov    %eax,%edi
80107b03:	eb 1c                	jmp    80107b21 <deallocuvm+0x61>
80107b05:	8d 76 00             	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_PG) != 0 && p->pid > 2)
80107b08:	83 7e 10 02          	cmpl   $0x2,0x10(%esi)
80107b0c:	0f 8f b6 00 00 00    	jg     80107bc8 <deallocuvm+0x108>
      if(swapPageIndex != -1)
      {
        removeSwapPage(p, swapPageIndex); 
      }
    }
    else if((*pte & PTE_P) != 0){
80107b12:	a8 01                	test   $0x1,%al
80107b14:	75 52                	jne    80107b68 <deallocuvm+0xa8>
80107b16:	81 c7 00 10 00 00    	add    $0x1000,%edi
  for(; a  < oldsz; a += PGSIZE){
80107b1c:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107b1f:	76 7a                	jbe    80107b9b <deallocuvm+0xdb>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107b21:	31 c9                	xor    %ecx,%ecx
80107b23:	89 fa                	mov    %edi,%edx
80107b25:	89 d8                	mov    %ebx,%eax
80107b27:	e8 74 fb ff ff       	call   801076a0 <walkpgdir>
80107b2c:	89 c1                	mov    %eax,%ecx
    if(!pte)
80107b2e:	85 c0                	test   %eax,%eax
80107b30:	74 7e                	je     80107bb0 <deallocuvm+0xf0>
    else if((*pte & PTE_PG) != 0 && p->pid > 2)
80107b32:	8b 00                	mov    (%eax),%eax
80107b34:	f6 c4 02             	test   $0x2,%ah
80107b37:	75 cf                	jne    80107b08 <deallocuvm+0x48>
    else if((*pte & PTE_P) != 0){
80107b39:	a8 01                	test   $0x1,%al
80107b3b:	74 d9                	je     80107b16 <deallocuvm+0x56>
      
      if(p->pid > 2)
80107b3d:	83 7e 10 02          	cmpl   $0x2,0x10(%esi)
80107b41:	7e 25                	jle    80107b68 <deallocuvm+0xa8>
      {
        int phyPageIndex = getPhysicalPage(p, pgdir, a);
80107b43:	83 ec 04             	sub    $0x4,%esp
80107b46:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107b49:	57                   	push   %edi
80107b4a:	53                   	push   %ebx
80107b4b:	56                   	push   %esi
80107b4c:	e8 8f d3 ff ff       	call   80104ee0 <getPhysicalPage>
        if(phyPageIndex != -1)
80107b51:	83 c4 10             	add    $0x10,%esp
80107b54:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107b57:	83 f8 ff             	cmp    $0xffffffff,%eax
80107b5a:	0f 85 a0 00 00 00    	jne    80107c00 <deallocuvm+0x140>
80107b60:	8b 01                	mov    (%ecx),%eax
80107b62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        }
        
      }

      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107b68:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107b6d:	0f 84 a7 00 00 00    	je     80107c1a <deallocuvm+0x15a>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107b73:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80107b76:	05 00 00 00 80       	add    $0x80000000,%eax
80107b7b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      kfree(v);
80107b7e:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107b84:	50                   	push   %eax
80107b85:	e8 56 ad ff ff       	call   801028e0 <kfree>
      *pte = 0;
80107b8a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107b8d:	83 c4 10             	add    $0x10,%esp
80107b90:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
  for(; a  < oldsz; a += PGSIZE){
80107b96:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107b99:	77 86                	ja     80107b21 <deallocuvm+0x61>
      
    }
  }
  return newsz;
80107b9b:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107b9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ba1:	5b                   	pop    %ebx
80107ba2:	5e                   	pop    %esi
80107ba3:	5f                   	pop    %edi
80107ba4:	5d                   	pop    %ebp
80107ba5:	c3                   	ret    
80107ba6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107bad:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107bb0:	89 fa                	mov    %edi,%edx
80107bb2:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80107bb8:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
80107bbe:	e9 59 ff ff ff       	jmp    80107b1c <deallocuvm+0x5c>
80107bc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107bc7:	90                   	nop
      int swapPageIndex = getSwapPage(p, pgdir, a);
80107bc8:	83 ec 04             	sub    $0x4,%esp
80107bcb:	57                   	push   %edi
80107bcc:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107bd2:	53                   	push   %ebx
80107bd3:	56                   	push   %esi
80107bd4:	e8 57 d3 ff ff       	call   80104f30 <getSwapPage>
      if(swapPageIndex != -1)
80107bd9:	83 c4 10             	add    $0x10,%esp
80107bdc:	83 f8 ff             	cmp    $0xffffffff,%eax
80107bdf:	0f 84 37 ff ff ff    	je     80107b1c <deallocuvm+0x5c>
        removeSwapPage(p, swapPageIndex); 
80107be5:	83 ec 08             	sub    $0x8,%esp
80107be8:	50                   	push   %eax
80107be9:	56                   	push   %esi
80107bea:	e8 91 d3 ff ff       	call   80104f80 <removeSwapPage>
80107bef:	83 c4 10             	add    $0x10,%esp
80107bf2:	e9 25 ff ff ff       	jmp    80107b1c <deallocuvm+0x5c>
80107bf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107bfe:	66 90                	xchg   %ax,%ax
          removePhysicalPage(p, phyPageIndex);
80107c00:	83 ec 08             	sub    $0x8,%esp
80107c03:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107c06:	50                   	push   %eax
80107c07:	56                   	push   %esi
80107c08:	e8 d3 d1 ff ff       	call   80104de0 <removePhysicalPage>
80107c0d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107c10:	83 c4 10             	add    $0x10,%esp
80107c13:	8b 01                	mov    (%ecx),%eax
80107c15:	e9 4e ff ff ff       	jmp    80107b68 <deallocuvm+0xa8>
        panic("kfree");
80107c1a:	83 ec 0c             	sub    $0xc,%esp
80107c1d:	68 da 86 10 80       	push   $0x801086da
80107c22:	e8 69 87 ff ff       	call   80100390 <panic>
80107c27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c2e:	66 90                	xchg   %ax,%ax

80107c30 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107c30:	f3 0f 1e fb          	endbr32 
80107c34:	55                   	push   %ebp
80107c35:	89 e5                	mov    %esp,%ebp
80107c37:	57                   	push   %edi
80107c38:	56                   	push   %esi
80107c39:	53                   	push   %ebx
80107c3a:	83 ec 0c             	sub    $0xc,%esp
80107c3d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107c40:	85 f6                	test   %esi,%esi
80107c42:	74 5d                	je     80107ca1 <freevm+0x71>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
80107c44:	83 ec 04             	sub    $0x4,%esp
80107c47:	89 f3                	mov    %esi,%ebx
80107c49:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107c4f:	6a 00                	push   $0x0
80107c51:	68 00 00 00 80       	push   $0x80000000
80107c56:	56                   	push   %esi
80107c57:	e8 64 fe ff ff       	call   80107ac0 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80107c5c:	83 c4 10             	add    $0x10,%esp
80107c5f:	eb 0e                	jmp    80107c6f <freevm+0x3f>
80107c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c68:	83 c3 04             	add    $0x4,%ebx
80107c6b:	39 df                	cmp    %ebx,%edi
80107c6d:	74 23                	je     80107c92 <freevm+0x62>
    if(pgdir[i] & PTE_P){
80107c6f:	8b 03                	mov    (%ebx),%eax
80107c71:	a8 01                	test   $0x1,%al
80107c73:	74 f3                	je     80107c68 <freevm+0x38>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107c75:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107c7a:	83 ec 0c             	sub    $0xc,%esp
80107c7d:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107c80:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107c85:	50                   	push   %eax
80107c86:	e8 55 ac ff ff       	call   801028e0 <kfree>
80107c8b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107c8e:	39 df                	cmp    %ebx,%edi
80107c90:	75 dd                	jne    80107c6f <freevm+0x3f>
    }
  }
  kfree((char*)pgdir);
80107c92:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107c95:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c98:	5b                   	pop    %ebx
80107c99:	5e                   	pop    %esi
80107c9a:	5f                   	pop    %edi
80107c9b:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107c9c:	e9 3f ac ff ff       	jmp    801028e0 <kfree>
    panic("freevm: no pgdir");
80107ca1:	83 ec 0c             	sub    $0xc,%esp
80107ca4:	68 dd 8f 10 80       	push   $0x80108fdd
80107ca9:	e8 e2 86 ff ff       	call   80100390 <panic>
80107cae:	66 90                	xchg   %ax,%ax

80107cb0 <setupkvm>:
{
80107cb0:	f3 0f 1e fb          	endbr32 
80107cb4:	55                   	push   %ebp
80107cb5:	89 e5                	mov    %esp,%ebp
80107cb7:	56                   	push   %esi
80107cb8:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107cb9:	e8 e2 ad ff ff       	call   80102aa0 <kalloc>
80107cbe:	89 c6                	mov    %eax,%esi
80107cc0:	85 c0                	test   %eax,%eax
80107cc2:	74 42                	je     80107d06 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80107cc4:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107cc7:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
80107ccc:	68 00 10 00 00       	push   $0x1000
80107cd1:	6a 00                	push   $0x0
80107cd3:	50                   	push   %eax
80107cd4:	e8 b7 d7 ff ff       	call   80105490 <memset>
80107cd9:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107cdc:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107cdf:	83 ec 08             	sub    $0x8,%esp
80107ce2:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107ce5:	ff 73 0c             	pushl  0xc(%ebx)
80107ce8:	8b 13                	mov    (%ebx),%edx
80107cea:	50                   	push   %eax
80107ceb:	29 c1                	sub    %eax,%ecx
80107ced:	89 f0                	mov    %esi,%eax
80107cef:	e8 2c fa ff ff       	call   80107720 <mappages>
80107cf4:	83 c4 10             	add    $0x10,%esp
80107cf7:	85 c0                	test   %eax,%eax
80107cf9:	78 15                	js     80107d10 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107cfb:	83 c3 10             	add    $0x10,%ebx
80107cfe:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
80107d04:	75 d6                	jne    80107cdc <setupkvm+0x2c>
}
80107d06:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107d09:	89 f0                	mov    %esi,%eax
80107d0b:	5b                   	pop    %ebx
80107d0c:	5e                   	pop    %esi
80107d0d:	5d                   	pop    %ebp
80107d0e:	c3                   	ret    
80107d0f:	90                   	nop
      freevm(pgdir);
80107d10:	83 ec 0c             	sub    $0xc,%esp
80107d13:	56                   	push   %esi
      return 0;
80107d14:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107d16:	e8 15 ff ff ff       	call   80107c30 <freevm>
      return 0;
80107d1b:	83 c4 10             	add    $0x10,%esp
}
80107d1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107d21:	89 f0                	mov    %esi,%eax
80107d23:	5b                   	pop    %ebx
80107d24:	5e                   	pop    %esi
80107d25:	5d                   	pop    %ebp
80107d26:	c3                   	ret    
80107d27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d2e:	66 90                	xchg   %ax,%ax

80107d30 <kvmalloc>:
{
80107d30:	f3 0f 1e fb          	endbr32 
80107d34:	55                   	push   %ebp
80107d35:	89 e5                	mov    %esp,%ebp
80107d37:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107d3a:	e8 71 ff ff ff       	call   80107cb0 <setupkvm>
80107d3f:	a3 c4 f1 11 80       	mov    %eax,0x8011f1c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107d44:	05 00 00 00 80       	add    $0x80000000,%eax
80107d49:	0f 22 d8             	mov    %eax,%cr3
}
80107d4c:	c9                   	leave  
80107d4d:	c3                   	ret    
80107d4e:	66 90                	xchg   %ax,%ax

80107d50 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107d50:	f3 0f 1e fb          	endbr32 
80107d54:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107d55:	31 c9                	xor    %ecx,%ecx
{
80107d57:	89 e5                	mov    %esp,%ebp
80107d59:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107d5c:	8b 55 0c             	mov    0xc(%ebp),%edx
80107d5f:	8b 45 08             	mov    0x8(%ebp),%eax
80107d62:	e8 39 f9 ff ff       	call   801076a0 <walkpgdir>
  if(pte == 0)
80107d67:	85 c0                	test   %eax,%eax
80107d69:	74 05                	je     80107d70 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107d6b:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107d6e:	c9                   	leave  
80107d6f:	c3                   	ret    
    panic("clearpteu");
80107d70:	83 ec 0c             	sub    $0xc,%esp
80107d73:	68 ee 8f 10 80       	push   $0x80108fee
80107d78:	e8 13 86 ff ff       	call   80100390 <panic>
80107d7d:	8d 76 00             	lea    0x0(%esi),%esi

80107d80 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107d80:	f3 0f 1e fb          	endbr32 
80107d84:	55                   	push   %ebp
80107d85:	89 e5                	mov    %esp,%ebp
80107d87:	57                   	push   %edi
80107d88:	56                   	push   %esi
80107d89:	53                   	push   %ebx
80107d8a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107d8d:	e8 1e ff ff ff       	call   80107cb0 <setupkvm>
80107d92:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107d95:	85 c0                	test   %eax,%eax
80107d97:	0f 84 ba 00 00 00    	je     80107e57 <copyuvm+0xd7>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107d9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107da0:	85 c9                	test   %ecx,%ecx
80107da2:	0f 84 af 00 00 00    	je     80107e57 <copyuvm+0xd7>
80107da8:	31 f6                	xor    %esi,%esi
80107daa:	eb 6d                	jmp    80107e19 <copyuvm+0x99>
80107dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      uint flags = (PTE_FLAGS(*pte2) | PTE_PG | PTE_U | PTE_W) & (~PTE_P);
      *pte2 = flags;
      continue;

    }
    if(!(*pte & PTE_P))
80107db0:	a8 01                	test   $0x1,%al
80107db2:	0f 84 e9 00 00 00    	je     80107ea1 <copyuvm+0x121>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107db8:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107dba:	25 ff 0f 00 00       	and    $0xfff,%eax
80107dbf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107dc2:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107dc8:	e8 d3 ac ff ff       	call   80102aa0 <kalloc>
80107dcd:	89 c3                	mov    %eax,%ebx
80107dcf:	85 c0                	test   %eax,%eax
80107dd1:	0f 84 9d 00 00 00    	je     80107e74 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107dd7:	83 ec 04             	sub    $0x4,%esp
80107dda:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107de0:	68 00 10 00 00       	push   $0x1000
80107de5:	57                   	push   %edi
80107de6:	50                   	push   %eax
80107de7:	e8 44 d7 ff ff       	call   80105530 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107dec:	58                   	pop    %eax
80107ded:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107df3:	5a                   	pop    %edx
80107df4:	ff 75 e4             	pushl  -0x1c(%ebp)
80107df7:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107dfc:	89 f2                	mov    %esi,%edx
80107dfe:	50                   	push   %eax
80107dff:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107e02:	e8 19 f9 ff ff       	call   80107720 <mappages>
80107e07:	83 c4 10             	add    $0x10,%esp
80107e0a:	85 c0                	test   %eax,%eax
80107e0c:	78 5a                	js     80107e68 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107e0e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107e14:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107e17:	76 3e                	jbe    80107e57 <copyuvm+0xd7>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107e19:	8b 45 08             	mov    0x8(%ebp),%eax
80107e1c:	31 c9                	xor    %ecx,%ecx
80107e1e:	89 f2                	mov    %esi,%edx
80107e20:	e8 7b f8 ff ff       	call   801076a0 <walkpgdir>
80107e25:	85 c0                	test   %eax,%eax
80107e27:	74 6b                	je     80107e94 <copyuvm+0x114>
    if((*pte & PTE_PG))
80107e29:	8b 00                	mov    (%eax),%eax
80107e2b:	f6 c4 02             	test   $0x2,%ah
80107e2e:	74 80                	je     80107db0 <copyuvm+0x30>
      pte_t *pte2 = walkpgdir(d, (char *)i, 0);
80107e30:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107e33:	89 f2                	mov    %esi,%edx
80107e35:	31 c9                	xor    %ecx,%ecx
  for(i = 0; i < sz; i += PGSIZE){
80107e37:	81 c6 00 10 00 00    	add    $0x1000,%esi
      pte_t *pte2 = walkpgdir(d, (char *)i, 0);
80107e3d:	e8 5e f8 ff ff       	call   801076a0 <walkpgdir>
      uint flags = (PTE_FLAGS(*pte2) | PTE_PG | PTE_U | PTE_W) & (~PTE_P);
80107e42:	8b 10                	mov    (%eax),%edx
80107e44:	81 e2 f8 0d 00 00    	and    $0xdf8,%edx
80107e4a:	81 ca 06 02 00 00    	or     $0x206,%edx
80107e50:	89 10                	mov    %edx,(%eax)
  for(i = 0; i < sz; i += PGSIZE){
80107e52:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107e55:	77 c2                	ja     80107e19 <copyuvm+0x99>
  return d;

bad:
  freevm(d);
  return 0;
}
80107e57:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107e5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e5d:	5b                   	pop    %ebx
80107e5e:	5e                   	pop    %esi
80107e5f:	5f                   	pop    %edi
80107e60:	5d                   	pop    %ebp
80107e61:	c3                   	ret    
80107e62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      kfree(mem);
80107e68:	83 ec 0c             	sub    $0xc,%esp
80107e6b:	53                   	push   %ebx
80107e6c:	e8 6f aa ff ff       	call   801028e0 <kfree>
      goto bad;
80107e71:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107e74:	83 ec 0c             	sub    $0xc,%esp
80107e77:	ff 75 e0             	pushl  -0x20(%ebp)
80107e7a:	e8 b1 fd ff ff       	call   80107c30 <freevm>
  return 0;
80107e7f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107e86:	83 c4 10             	add    $0x10,%esp
}
80107e89:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107e8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e8f:	5b                   	pop    %ebx
80107e90:	5e                   	pop    %esi
80107e91:	5f                   	pop    %edi
80107e92:	5d                   	pop    %ebp
80107e93:	c3                   	ret    
      panic("copyuvm: pte should exist");
80107e94:	83 ec 0c             	sub    $0xc,%esp
80107e97:	68 f8 8f 10 80       	push   $0x80108ff8
80107e9c:	e8 ef 84 ff ff       	call   80100390 <panic>
      panic("copyuvm: page not present");
80107ea1:	83 ec 0c             	sub    $0xc,%esp
80107ea4:	68 12 90 10 80       	push   $0x80109012
80107ea9:	e8 e2 84 ff ff       	call   80100390 <panic>
80107eae:	66 90                	xchg   %ax,%ax

80107eb0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107eb0:	f3 0f 1e fb          	endbr32 
80107eb4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107eb5:	31 c9                	xor    %ecx,%ecx
{
80107eb7:	89 e5                	mov    %esp,%ebp
80107eb9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107ebc:	8b 55 0c             	mov    0xc(%ebp),%edx
80107ebf:	8b 45 08             	mov    0x8(%ebp),%eax
80107ec2:	e8 d9 f7 ff ff       	call   801076a0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107ec7:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107ec9:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107eca:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107ecc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107ed1:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107ed4:	05 00 00 00 80       	add    $0x80000000,%eax
80107ed9:	83 fa 05             	cmp    $0x5,%edx
80107edc:	ba 00 00 00 00       	mov    $0x0,%edx
80107ee1:	0f 45 c2             	cmovne %edx,%eax
}
80107ee4:	c3                   	ret    
80107ee5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107ef0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107ef0:	f3 0f 1e fb          	endbr32 
80107ef4:	55                   	push   %ebp
80107ef5:	89 e5                	mov    %esp,%ebp
80107ef7:	57                   	push   %edi
80107ef8:	56                   	push   %esi
80107ef9:	53                   	push   %ebx
80107efa:	83 ec 0c             	sub    $0xc,%esp
80107efd:	8b 75 14             	mov    0x14(%ebp),%esi
80107f00:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107f03:	85 f6                	test   %esi,%esi
80107f05:	75 3c                	jne    80107f43 <copyout+0x53>
80107f07:	eb 67                	jmp    80107f70 <copyout+0x80>
80107f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107f10:	8b 55 0c             	mov    0xc(%ebp),%edx
80107f13:	89 fb                	mov    %edi,%ebx
80107f15:	29 d3                	sub    %edx,%ebx
80107f17:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80107f1d:	39 f3                	cmp    %esi,%ebx
80107f1f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107f22:	29 fa                	sub    %edi,%edx
80107f24:	83 ec 04             	sub    $0x4,%esp
80107f27:	01 c2                	add    %eax,%edx
80107f29:	53                   	push   %ebx
80107f2a:	ff 75 10             	pushl  0x10(%ebp)
80107f2d:	52                   	push   %edx
80107f2e:	e8 fd d5 ff ff       	call   80105530 <memmove>
    len -= n;
    buf += n;
80107f33:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107f36:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
80107f3c:	83 c4 10             	add    $0x10,%esp
80107f3f:	29 de                	sub    %ebx,%esi
80107f41:	74 2d                	je     80107f70 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107f43:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107f45:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107f48:	89 55 0c             	mov    %edx,0xc(%ebp)
80107f4b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107f51:	57                   	push   %edi
80107f52:	ff 75 08             	pushl  0x8(%ebp)
80107f55:	e8 56 ff ff ff       	call   80107eb0 <uva2ka>
    if(pa0 == 0)
80107f5a:	83 c4 10             	add    $0x10,%esp
80107f5d:	85 c0                	test   %eax,%eax
80107f5f:	75 af                	jne    80107f10 <copyout+0x20>
  }
  return 0;
}
80107f61:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107f64:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107f69:	5b                   	pop    %ebx
80107f6a:	5e                   	pop    %esi
80107f6b:	5f                   	pop    %edi
80107f6c:	5d                   	pop    %ebp
80107f6d:	c3                   	ret    
80107f6e:	66 90                	xchg   %ax,%ax
80107f70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107f73:	31 c0                	xor    %eax,%eax
}
80107f75:	5b                   	pop    %ebx
80107f76:	5e                   	pop    %esi
80107f77:	5f                   	pop    %edi
80107f78:	5d                   	pop    %ebp
80107f79:	c3                   	ret    
80107f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107f80 <copyPagesFromParent>:

// ========================= functions for supporting paging framework ============================== //

// copy page meta data from parent to child
void copyPagesFromParent(struct proc *parent, struct proc *child)
{
80107f80:	f3 0f 1e fb          	endbr32 
80107f84:	55                   	push   %ebp
80107f85:	89 e5                	mov    %esp,%ebp
80107f87:	57                   	push   %edi
80107f88:	56                   	push   %esi
80107f89:	53                   	push   %ebx
80107f8a:	83 ec 04             	sub    $0x4,%esp
  for(int i=0;i<MAX_PSYC_PAGES;i++)
  {
    child->physicalPages[i] = (struct pagemeta) {child->pgdir, parent->physicalPages[i].va, parent->physicalPages[i].present, 0};
80107f8d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f90:	8b 7d 08             	mov    0x8(%ebp),%edi
80107f93:	8b 48 04             	mov    0x4(%eax),%ecx
80107f96:	8b 45 08             	mov    0x8(%ebp),%eax
80107f99:	81 c7 64 02 00 00    	add    $0x264,%edi
80107f9f:	8d b0 74 01 00 00    	lea    0x174(%eax),%esi
80107fa5:	8b 45 0c             	mov    0xc(%ebp),%eax
80107fa8:	89 75 f0             	mov    %esi,-0x10(%ebp)
80107fab:	89 f2                	mov    %esi,%edx
80107fad:	05 70 01 00 00       	add    $0x170,%eax
80107fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107fb8:	8b 1a                	mov    (%edx),%ebx
80107fba:	8b 72 04             	mov    0x4(%edx),%esi
80107fbd:	83 c2 10             	add    $0x10,%edx
80107fc0:	89 08                	mov    %ecx,(%eax)
80107fc2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  for(int i=0;i<MAX_PSYC_PAGES;i++)
80107fc9:	83 c0 10             	add    $0x10,%eax
    child->physicalPages[i] = (struct pagemeta) {child->pgdir, parent->physicalPages[i].va, parent->physicalPages[i].present, 0};
80107fcc:	89 70 f8             	mov    %esi,-0x8(%eax)
80107fcf:	89 58 f4             	mov    %ebx,-0xc(%eax)
  for(int i=0;i<MAX_PSYC_PAGES;i++)
80107fd2:	39 fa                	cmp    %edi,%edx
80107fd4:	75 e2                	jne    80107fb8 <copyPagesFromParent+0x38>
80107fd6:	8b 45 08             	mov    0x8(%ebp),%eax
80107fd9:	8b 75 f0             	mov    -0x10(%ebp),%esi
80107fdc:	8d 90 84 00 00 00    	lea    0x84(%eax),%edx
80107fe2:	8b 45 0c             	mov    0xc(%ebp),%eax
80107fe5:	83 e8 80             	sub    $0xffffff80,%eax
80107fe8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107fef:	90                   	nop
    
  }
  for(int i=0;i<MAX_SWAP_PAGES();i++)
  {
    child->swappedPages[i] = (struct pagemeta) {child->pgdir, parent->swappedPages[i].va, parent->swappedPages[i].present, 0};
80107ff0:	8b 3a                	mov    (%edx),%edi
80107ff2:	8b 5a 04             	mov    0x4(%edx),%ebx
80107ff5:	83 c2 10             	add    $0x10,%edx
80107ff8:	89 08                	mov    %ecx,(%eax)
80107ffa:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  for(int i=0;i<MAX_SWAP_PAGES();i++)
80108001:	83 c0 10             	add    $0x10,%eax
    child->swappedPages[i] = (struct pagemeta) {child->pgdir, parent->swappedPages[i].va, parent->swappedPages[i].present, 0};
80108004:	89 78 f4             	mov    %edi,-0xc(%eax)
80108007:	89 58 f8             	mov    %ebx,-0x8(%eax)
  for(int i=0;i<MAX_SWAP_PAGES();i++)
8010800a:	39 f2                	cmp    %esi,%edx
8010800c:	75 e2                	jne    80107ff0 <copyPagesFromParent+0x70>
    
  }
}
8010800e:	83 c4 04             	add    $0x4,%esp
80108011:	5b                   	pop    %ebx
80108012:	5e                   	pop    %esi
80108013:	5f                   	pop    %edi
80108014:	5d                   	pop    %ebp
80108015:	c3                   	ret    
80108016:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010801d:	8d 76 00             	lea    0x0(%esi),%esi

80108020 <swapout>:

void swapout(struct proc *p)
{
80108020:	f3 0f 1e fb          	endbr32 
80108024:	55                   	push   %ebp
80108025:	89 e5                	mov    %esp,%ebp
80108027:	57                   	push   %edi
80108028:	56                   	push   %esi
80108029:	53                   	push   %ebx
8010802a:	83 ec 28             	sub    $0x28,%esp
8010802d:	8b 5d 08             	mov    0x8(%ebp),%ebx

  
  // get the next swap out page from physical page list
  int swapoutIndex = getNextPhysicalPage(p);
80108030:	53                   	push   %ebx
80108031:	e8 0a cc ff ff       	call   80104c40 <getNextPhysicalPage>

  if(swapoutIndex == -1)
80108036:	83 c4 10             	add    $0x10,%esp
80108039:	83 f8 ff             	cmp    $0xffffffff,%eax
8010803c:	0f 84 a1 00 00 00    	je     801080e3 <swapout+0xc3>
80108042:	89 c6                	mov    %eax,%esi
  {
    panic("Can't find page to swap out!");
    return ;
  }
  struct pagemeta swapoutpage = p->physicalPages[swapoutIndex];
80108044:	8d 40 17             	lea    0x17(%eax),%eax

  //cprintf("Swapping out %d for proc %d pgdir %p\n", swapoutpage.va, p->pid, V2P(*swapoutpage.pgdir));


  // get place in swap file to write this page
  int swapOutPosition = getEmptySwapPosition(p);
80108047:	83 ec 0c             	sub    $0xc,%esp
  struct pagemeta swapoutpage = p->physicalPages[swapoutIndex];
8010804a:	c1 e0 04             	shl    $0x4,%eax
8010804d:	01 d8                	add    %ebx,%eax
8010804f:	8b 38                	mov    (%eax),%edi
80108051:	89 7d e0             	mov    %edi,-0x20(%ebp)
80108054:	8b 78 04             	mov    0x4(%eax),%edi
  int swapOutPosition = getEmptySwapPosition(p);
80108057:	53                   	push   %ebx
80108058:	e8 c3 cf ff ff       	call   80105020 <getEmptySwapPosition>

  if(swapOutPosition == -1)
8010805d:	83 c4 10             	add    $0x10,%esp
  int swapOutPosition = getEmptySwapPosition(p);
80108060:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(swapOutPosition == -1)
80108063:	83 f8 ff             	cmp    $0xffffffff,%eax
80108066:	0f 84 84 00 00 00    	je     801080f0 <swapout+0xd0>
  {
    panic("No place in swap file!");
    return;

  }
  pte_t *pte = walkpgdir(swapoutpage.pgdir, (char *)swapoutpage.va, 0);
8010806c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010806f:	89 fa                	mov    %edi,%edx
80108071:	31 c9                	xor    %ecx,%ecx
80108073:	e8 28 f6 ff ff       	call   801076a0 <walkpgdir>
80108078:	89 c2                	mov    %eax,%edx
  
  // update pagetable
  uint pa = PTE_ADDR(*pte);
8010807a:	8b 00                	mov    (%eax),%eax
  uint flags = (PTE_FLAGS(*pte) | PTE_PG | PTE_U | PTE_W) & (~PTE_P);
  *(pte) = (pa | flags);
8010807c:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010807f:	89 c1                	mov    %eax,%ecx
  uint pa = PTE_ADDR(*pte);
80108081:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  *(pte) = (pa | flags);
80108086:	81 e1 f8 fd ff ff    	and    $0xfffffdf8,%ecx

  // write to swap file
  writeToSwapFile(p, (char *)P2V(PTE_ADDR(*pte)), swapOutPosition*PGSIZE, PGSIZE);
8010808c:	05 00 00 00 80       	add    $0x80000000,%eax
  *(pte) = (pa | flags);
80108091:	81 c9 06 02 00 00    	or     $0x206,%ecx
80108097:	89 0a                	mov    %ecx,(%edx)
  writeToSwapFile(p, (char *)P2V(PTE_ADDR(*pte)), swapOutPosition*PGSIZE, PGSIZE);
80108099:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010809c:	68 00 10 00 00       	push   $0x1000
801080a1:	c1 e1 0c             	shl    $0xc,%ecx
801080a4:	51                   	push   %ecx
801080a5:	50                   	push   %eax
801080a6:	53                   	push   %ebx
801080a7:	e8 e4 a2 ff ff       	call   80102390 <writeToSwapFile>

  // remove from physical page list
  removePhysicalPage(p, swapoutIndex);
801080ac:	58                   	pop    %eax
801080ad:	5a                   	pop    %edx
801080ae:	56                   	push   %esi
801080af:	53                   	push   %ebx
801080b0:	e8 2b cd ff ff       	call   80104de0 <removePhysicalPage>

  // add to swap page list
  addSwapPage(p, swapOutPosition, swapoutpage.pgdir, swapoutpage.va);
801080b5:	57                   	push   %edi
801080b6:	ff 75 e0             	pushl  -0x20(%ebp)
801080b9:	ff 75 e4             	pushl  -0x1c(%ebp)
801080bc:	53                   	push   %ebx
801080bd:	e8 1e cf ff ff       	call   80104fe0 <addSwapPage>

  //cprintf("Done swapping out %d for proc %d pgdir %p\n", swapoutpage.va, p->pid, V2P(*swapoutpage.pgdir));
  

  // free the memory
  char *remv = (char *) P2V(PTE_ADDR(*pte));
801080c2:	8b 55 dc             	mov    -0x24(%ebp),%edx

  kfree(remv);
801080c5:	83 c4 20             	add    $0x20,%esp
  char *remv = (char *) P2V(PTE_ADDR(*pte));
801080c8:	8b 02                	mov    (%edx),%eax
801080ca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801080cf:	05 00 00 00 80       	add    $0x80000000,%eax
  kfree(remv);
801080d4:	89 45 08             	mov    %eax,0x8(%ebp)

  //cprintf("Freed memory\n");
  return ;
}
801080d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801080da:	5b                   	pop    %ebx
801080db:	5e                   	pop    %esi
801080dc:	5f                   	pop    %edi
801080dd:	5d                   	pop    %ebp
  kfree(remv);
801080de:	e9 fd a7 ff ff       	jmp    801028e0 <kfree>
    panic("Can't find page to swap out!");
801080e3:	83 ec 0c             	sub    $0xc,%esp
801080e6:	68 2c 90 10 80       	push   $0x8010902c
801080eb:	e8 a0 82 ff ff       	call   80100390 <panic>
    panic("No place in swap file!");
801080f0:	83 ec 0c             	sub    $0xc,%esp
801080f3:	68 49 90 10 80       	push   $0x80109049
801080f8:	e8 93 82 ff ff       	call   80100390 <panic>
801080fd:	8d 76 00             	lea    0x0(%esi),%esi

80108100 <allocuvm>:
{
80108100:	f3 0f 1e fb          	endbr32 
80108104:	55                   	push   %ebp
80108105:	89 e5                	mov    %esp,%ebp
80108107:	57                   	push   %edi
80108108:	56                   	push   %esi
80108109:	53                   	push   %ebx
8010810a:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
8010810d:	8b 45 10             	mov    0x10(%ebp),%eax
80108110:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108113:	85 c0                	test   %eax,%eax
80108115:	0f 88 b5 00 00 00    	js     801081d0 <allocuvm+0xd0>
  if(newsz < oldsz)
8010811b:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010811e:	73 18                	jae    80108138 <allocuvm+0x38>
    return oldsz;
80108120:	8b 45 0c             	mov    0xc(%ebp),%eax
80108123:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80108126:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108129:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010812c:	5b                   	pop    %ebx
8010812d:	5e                   	pop    %esi
8010812e:	5f                   	pop    %edi
8010812f:	5d                   	pop    %ebp
80108130:	c3                   	ret    
80108131:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *p = myproc();
80108138:	e8 a3 bd ff ff       	call   80103ee0 <myproc>
8010813d:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(oldsz);
8010813f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108142:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80108148:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
8010814e:	39 75 10             	cmp    %esi,0x10(%ebp)
80108151:	77 20                	ja     80108173 <allocuvm+0x73>
80108153:	eb d1                	jmp    80108126 <allocuvm+0x26>
80108155:	8d 76 00             	lea    0x0(%esi),%esi
      addPhysicalPage(p, pgdir, (uint) a);
80108158:	83 ec 04             	sub    $0x4,%esp
8010815b:	56                   	push   %esi
8010815c:	ff 75 08             	pushl  0x8(%ebp)
8010815f:	57                   	push   %edi
80108160:	e8 6b cb ff ff       	call   80104cd0 <addPhysicalPage>
80108165:	83 c4 10             	add    $0x10,%esp
  for(; a < newsz; a += PGSIZE){
80108168:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010816e:	39 75 10             	cmp    %esi,0x10(%ebp)
80108171:	76 b3                	jbe    80108126 <allocuvm+0x26>
    mem = kalloc();
80108173:	e8 28 a9 ff ff       	call   80102aa0 <kalloc>
80108178:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
8010817a:	85 c0                	test   %eax,%eax
8010817c:	74 6a                	je     801081e8 <allocuvm+0xe8>
    memset(mem, 0, PGSIZE);
8010817e:	83 ec 04             	sub    $0x4,%esp
80108181:	68 00 10 00 00       	push   $0x1000
80108186:	6a 00                	push   $0x0
80108188:	50                   	push   %eax
80108189:	e8 02 d3 ff ff       	call   80105490 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
8010818e:	58                   	pop    %eax
8010818f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80108195:	5a                   	pop    %edx
80108196:	6a 06                	push   $0x6
80108198:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010819d:	89 f2                	mov    %esi,%edx
8010819f:	50                   	push   %eax
801081a0:	8b 45 08             	mov    0x8(%ebp),%eax
801081a3:	e8 78 f5 ff ff       	call   80107720 <mappages>
801081a8:	83 c4 10             	add    $0x10,%esp
801081ab:	85 c0                	test   %eax,%eax
801081ad:	78 71                	js     80108220 <allocuvm+0x120>
    if(p->pid > 2)
801081af:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
801081b3:	7e b3                	jle    80108168 <allocuvm+0x68>
      if(p->qsize == MAX_PSYC_PAGES)
801081b5:	83 bf 68 02 00 00 0f 	cmpl   $0xf,0x268(%edi)
801081bc:	75 9a                	jne    80108158 <allocuvm+0x58>
        swapout(p);
801081be:	83 ec 0c             	sub    $0xc,%esp
801081c1:	57                   	push   %edi
801081c2:	e8 59 fe ff ff       	call   80108020 <swapout>
801081c7:	83 c4 10             	add    $0x10,%esp
801081ca:	eb 8c                	jmp    80108158 <allocuvm+0x58>
801081cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
801081d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801081d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801081da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801081dd:	5b                   	pop    %ebx
801081de:	5e                   	pop    %esi
801081df:	5f                   	pop    %edi
801081e0:	5d                   	pop    %ebp
801081e1:	c3                   	ret    
801081e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory\n");
801081e8:	83 ec 0c             	sub    $0xc,%esp
801081eb:	68 60 90 10 80       	push   $0x80109060
801081f0:	e8 bb 84 ff ff       	call   801006b0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801081f5:	83 c4 0c             	add    $0xc,%esp
801081f8:	ff 75 0c             	pushl  0xc(%ebp)
801081fb:	ff 75 10             	pushl  0x10(%ebp)
801081fe:	ff 75 08             	pushl  0x8(%ebp)
80108201:	e8 ba f8 ff ff       	call   80107ac0 <deallocuvm>
      return 0;
80108206:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010820d:	83 c4 10             	add    $0x10,%esp
}
80108210:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108213:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108216:	5b                   	pop    %ebx
80108217:	5e                   	pop    %esi
80108218:	5f                   	pop    %edi
80108219:	5d                   	pop    %ebp
8010821a:	c3                   	ret    
8010821b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010821f:	90                   	nop
      cprintf("allocuvm out of memory (2)\n");
80108220:	83 ec 0c             	sub    $0xc,%esp
80108223:	68 78 90 10 80       	push   $0x80109078
80108228:	e8 83 84 ff ff       	call   801006b0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010822d:	83 c4 0c             	add    $0xc,%esp
80108230:	ff 75 0c             	pushl  0xc(%ebp)
80108233:	ff 75 10             	pushl  0x10(%ebp)
80108236:	ff 75 08             	pushl  0x8(%ebp)
80108239:	e8 82 f8 ff ff       	call   80107ac0 <deallocuvm>
      kfree(mem);
8010823e:	89 1c 24             	mov    %ebx,(%esp)
80108241:	e8 9a a6 ff ff       	call   801028e0 <kfree>
      return 0;
80108246:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010824d:	83 c4 10             	add    $0x10,%esp
}
80108250:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108253:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108256:	5b                   	pop    %ebx
80108257:	5e                   	pop    %esi
80108258:	5f                   	pop    %edi
80108259:	5d                   	pop    %ebp
8010825a:	c3                   	ret    
8010825b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010825f:	90                   	nop

80108260 <swapin>:

void swapin(struct proc *p, uint va)
{
80108260:	f3 0f 1e fb          	endbr32 
80108264:	55                   	push   %ebp
80108265:	89 e5                	mov    %esp,%ebp
80108267:	57                   	push   %edi
80108268:	56                   	push   %esi
80108269:	53                   	push   %ebx
8010826a:	83 ec 20             	sub    $0x20,%esp
  va = PGROUNDDOWN(va);
8010826d:	8b 45 0c             	mov    0xc(%ebp),%eax
{
80108270:	8b 5d 08             	mov    0x8(%ebp),%ebx
  va = PGROUNDDOWN(va);
80108273:	25 00 f0 ff ff       	and    $0xfffff000,%eax

  //cprintf("Swapping in %d for proc %d pgdir %p\n", va, p->pid, V2P(*p->pgdir));
  
  // get the page to swap in from proc's list
  int swapinIndex = getSwapPage(p, p->pgdir, va);
80108278:	50                   	push   %eax
80108279:	ff 73 04             	pushl  0x4(%ebx)
8010827c:	53                   	push   %ebx
8010827d:	e8 ae cc ff ff       	call   80104f30 <getSwapPage>
  if(swapinIndex == -1)
80108282:	83 c4 10             	add    $0x10,%esp
80108285:	83 f8 ff             	cmp    $0xffffffff,%eax
80108288:	0f 84 90 00 00 00    	je     8010831e <swapin+0xbe>
8010828e:	89 c6                	mov    %eax,%esi
  {
    panic("Cant Swap in! Page not in list!");
    return ;
  }
  struct pagemeta swapinpage = p->swappedPages[swapinIndex];
80108290:	8d 40 08             	lea    0x8(%eax),%eax
80108293:	c1 e0 04             	shl    $0x4,%eax
80108296:	01 d8                	add    %ebx,%eax
80108298:	8b 38                	mov    (%eax),%edi
8010829a:	89 7d e0             	mov    %edi,-0x20(%ebp)
8010829d:	8b 78 04             	mov    0x4(%eax),%edi

  // allocate space for the new page
  char *mem = kalloc();
801082a0:	e8 fb a7 ff ff       	call   80102aa0 <kalloc>
  readFromSwapFile(p, mem, swapinIndex * PGSIZE, PGSIZE);
801082a5:	68 00 10 00 00       	push   $0x1000
  char *mem = kalloc();
801082aa:	89 c1                	mov    %eax,%ecx
  readFromSwapFile(p, mem, swapinIndex * PGSIZE, PGSIZE);
801082ac:	89 f0                	mov    %esi,%eax
801082ae:	c1 e0 0c             	shl    $0xc,%eax
801082b1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801082b4:	50                   	push   %eax
801082b5:	51                   	push   %ecx
801082b6:	53                   	push   %ebx
801082b7:	e8 04 a1 ff ff       	call   801023c0 <readFromSwapFile>

  // remove from swap page list
  removeSwapPage(p, swapinIndex);
801082bc:	58                   	pop    %eax
801082bd:	5a                   	pop    %edx
801082be:	56                   	push   %esi
801082bf:	53                   	push   %ebx
801082c0:	e8 bb cc ff ff       	call   80104f80 <removeSwapPage>

  // update page table
  // try map pages if this doesnt work
  pte_t *pte = walkpgdir(swapinpage.pgdir, (char *)swapinpage.va, 0);
801082c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801082c8:	31 c9                	xor    %ecx,%ecx
801082ca:	89 fa                	mov    %edi,%edx
801082cc:	e8 cf f3 ff ff       	call   801076a0 <walkpgdir>
  uint pa = V2P(mem);
801082d1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  uint flags = (PTE_FLAGS(*pte) | PTE_P | PTE_U | PTE_W) & (~PTE_PG);
  *(pte) = (pa | flags);

  
  // check if swapping out is needed
  if(p->qsize == MAX_PSYC_PAGES)
801082d4:	83 c4 10             	add    $0x10,%esp
  uint flags = (PTE_FLAGS(*pte) | PTE_P | PTE_U | PTE_W) & (~PTE_PG);
801082d7:	8b 10                	mov    (%eax),%edx
  uint pa = V2P(mem);
801082d9:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
  uint flags = (PTE_FLAGS(*pte) | PTE_P | PTE_U | PTE_W) & (~PTE_PG);
801082df:	81 e2 f8 0d 00 00    	and    $0xdf8,%edx
  *(pte) = (pa | flags);
801082e5:	09 ca                	or     %ecx,%edx
801082e7:	83 ca 07             	or     $0x7,%edx
801082ea:	89 10                	mov    %edx,(%eax)
  if(p->qsize == MAX_PSYC_PAGES)
801082ec:	83 bb 68 02 00 00 0f 	cmpl   $0xf,0x268(%ebx)
801082f3:	74 1b                	je     80108310 <swapin+0xb0>
  }

  

  // add to physical page list
  addPhysicalPage(p, swapinpage.pgdir, swapinpage.va);
801082f5:	83 ec 04             	sub    $0x4,%esp
801082f8:	57                   	push   %edi
801082f9:	ff 75 e0             	pushl  -0x20(%ebp)
801082fc:	53                   	push   %ebx
801082fd:	e8 ce c9 ff ff       	call   80104cd0 <addPhysicalPage>
80108302:	83 c4 10             	add    $0x10,%esp

  //cprintf("Done Swapping in %d for proc %d pgdir %p\n", va, p->pid, V2P(*p->pgdir));
  
  

}
80108305:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108308:	5b                   	pop    %ebx
80108309:	5e                   	pop    %esi
8010830a:	5f                   	pop    %edi
8010830b:	5d                   	pop    %ebp
8010830c:	c3                   	ret    
8010830d:	8d 76 00             	lea    0x0(%esi),%esi
    swapout(p);
80108310:	83 ec 0c             	sub    $0xc,%esp
80108313:	53                   	push   %ebx
80108314:	e8 07 fd ff ff       	call   80108020 <swapout>
80108319:	83 c4 10             	add    $0x10,%esp
8010831c:	eb d7                	jmp    801082f5 <swapin+0x95>
    panic("Cant Swap in! Page not in list!");
8010831e:	83 ec 0c             	sub    $0xc,%esp
80108321:	68 b8 90 10 80       	push   $0x801090b8
80108326:	e8 65 80 ff ff       	call   80100390 <panic>
8010832b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010832f:	90                   	nop

80108330 <checkPageOut>:

// check if the address is in swap file
int checkPageOut(struct proc *p, uint va)
{
80108330:	f3 0f 1e fb          	endbr32 
80108334:	55                   	push   %ebp
80108335:	89 e5                	mov    %esp,%ebp
80108337:	83 ec 08             	sub    $0x8,%esp
8010833a:	8b 45 08             	mov    0x8(%ebp),%eax
  //cprintf("checking page out for %d proc %d...\n", va, p->pid);
  
  if(p->pid > 2){
8010833d:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80108341:	7f 0d                	jg     80108350 <checkPageOut+0x20>
    
    if(pte && (*pte & PTE_PG) && !(*pte & PTE_P))
      return 1;
  }
  return 0;
}
80108343:	c9                   	leave  
  return 0;
80108344:	31 c0                	xor    %eax,%eax
}
80108346:	c3                   	ret    
80108347:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010834e:	66 90                	xchg   %ax,%ax
    va = PGROUNDDOWN(va);
80108350:	8b 55 0c             	mov    0xc(%ebp),%edx
    pte_t *pte = walkpgdir(p->pgdir, (char *)va, 0);
80108353:	8b 40 04             	mov    0x4(%eax),%eax
80108356:	31 c9                	xor    %ecx,%ecx
    va = PGROUNDDOWN(va);
80108358:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
    pte_t *pte = walkpgdir(p->pgdir, (char *)va, 0);
8010835e:	e8 3d f3 ff ff       	call   801076a0 <walkpgdir>
    if(pte && (*pte & PTE_PG) && !(*pte & PTE_P))
80108363:	85 c0                	test   %eax,%eax
80108365:	74 dc                	je     80108343 <checkPageOut+0x13>
80108367:	8b 00                	mov    (%eax),%eax
}
80108369:	c9                   	leave  
    if(pte && (*pte & PTE_PG) && !(*pte & PTE_P))
8010836a:	25 01 02 00 00       	and    $0x201,%eax
8010836f:	3d 00 02 00 00       	cmp    $0x200,%eax
80108374:	0f 94 c0             	sete   %al
80108377:	0f b6 c0             	movzbl %al,%eax
}
8010837a:	c3                   	ret    
8010837b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010837f:	90                   	nop

80108380 <clearPTE_A>:

// clears the PTE_A flag for all processes
void clearPTE_A(struct proc *p)
{
80108380:	f3 0f 1e fb          	endbr32 
80108384:	55                   	push   %ebp
80108385:	89 e5                	mov    %esp,%ebp
80108387:	56                   	push   %esi
80108388:	8b 75 08             	mov    0x8(%ebp),%esi
8010838b:	53                   	push   %ebx
8010838c:	8d 9e 70 01 00 00    	lea    0x170(%esi),%ebx
80108392:	81 c6 60 02 00 00    	add    $0x260,%esi
80108398:	eb 0d                	jmp    801083a7 <clearPTE_A+0x27>
8010839a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 
    for(int i=0;i<MAX_PSYC_PAGES;i++)
801083a0:	83 c3 10             	add    $0x10,%ebx
801083a3:	39 f3                	cmp    %esi,%ebx
801083a5:	74 36                	je     801083dd <clearPTE_A+0x5d>
    {
      if(p->physicalPages[i].present)
801083a7:	8b 43 08             	mov    0x8(%ebx),%eax
801083aa:	85 c0                	test   %eax,%eax
801083ac:	74 f2                	je     801083a0 <clearPTE_A+0x20>
      {
        pte_t *pte = walkpgdir(p->physicalPages[i].pgdir, (char *) p->physicalPages[i].va, 0);
801083ae:	8b 53 04             	mov    0x4(%ebx),%edx
801083b1:	8b 03                	mov    (%ebx),%eax
801083b3:	31 c9                	xor    %ecx,%ecx
801083b5:	e8 e6 f2 ff ff       	call   801076a0 <walkpgdir>
        p->physicalPages[i].age >>= 1;
801083ba:	8b 4b 0c             	mov    0xc(%ebx),%ecx
801083bd:	d1 e9                	shr    %ecx
801083bf:	89 4b 0c             	mov    %ecx,0xc(%ebx)
        if((*pte) & PTE_A)
801083c2:	8b 10                	mov    (%eax),%edx
801083c4:	f6 c2 20             	test   $0x20,%dl
801083c7:	74 08                	je     801083d1 <clearPTE_A+0x51>
        {
          p->physicalPages[i].age |= (1<<(AGE_BITS-1));
801083c9:	80 c9 80             	or     $0x80,%cl
801083cc:	89 4b 0c             	mov    %ecx,0xc(%ebx)
801083cf:	8b 10                	mov    (%eax),%edx
        }
        (*pte) &= (~PTE_A);
801083d1:	83 e2 df             	and    $0xffffffdf,%edx
801083d4:	83 c3 10             	add    $0x10,%ebx
801083d7:	89 10                	mov    %edx,(%eax)
    for(int i=0;i<MAX_PSYC_PAGES;i++)
801083d9:	39 f3                	cmp    %esi,%ebx
801083db:	75 ca                	jne    801083a7 <clearPTE_A+0x27>
      }
    }

  
}
801083dd:	5b                   	pop    %ebx
801083de:	5e                   	pop    %esi
801083df:	5d                   	pop    %ebp
801083e0:	c3                   	ret    
