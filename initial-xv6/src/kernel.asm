
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
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
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
80100028:	bc d0 54 11 80       	mov    $0x801154d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 c0 30 10 80       	mov    $0x801030c0,%eax
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
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 a5 10 80       	mov    $0x8010a554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 00 72 10 80       	push   $0x80107200
80100051:	68 20 a5 10 80       	push   $0x8010a520
80100056:	e8 e5 43 00 00       	call   80104440 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c ec 10 80       	mov    $0x8010ec1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec6c
8010006a:	ec 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec70
80100074:	ec 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 07 72 10 80       	push   $0x80107207
80100097:	50                   	push   %eax
80100098:	e8 73 42 00 00       	call   80104310 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 e9 10 80    	cmp    $0x8010e9c0,%ebx
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
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 a5 10 80       	push   $0x8010a520
801000e4:	e8 37 45 00 00       	call   80104620 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 ec 10 80    	mov    0x8010ec70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c ec 10 80    	mov    0x8010ec6c,%ebx
80100126:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 a5 10 80       	push   $0x8010a520
80100162:	e8 59 44 00 00       	call   801045c0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 de 41 00 00       	call   80104350 <acquiresleep>
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
8010018c:	e8 bf 21 00 00       	call   80102350 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 0e 72 10 80       	push   $0x8010720e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 2d 42 00 00       	call   801043f0 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave
  iderw(b);
801001d4:	e9 77 21 00 00       	jmp    80102350 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 1f 72 10 80       	push   $0x8010721f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 ec 41 00 00       	call   801043f0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 9c 41 00 00       	call   801043b0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010021b:	e8 00 44 00 00       	call   80104620 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2c                	jne    8010025c <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 53 54             	mov    0x54(%ebx),%edx
80100233:	8b 43 50             	mov    0x50(%ebx),%eax
80100236:	89 42 50             	mov    %eax,0x50(%edx)
    b->prev->next = b->next;
80100239:	8b 53 54             	mov    0x54(%ebx),%edx
8010023c:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
8010023f:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
    b->prev = &bcache.head;
80100244:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024b:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
8010024e:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100253:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100256:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  }
  
  release(&bcache.lock);
8010025c:	c7 45 08 20 a5 10 80 	movl   $0x8010a520,0x8(%ebp)
}
80100263:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100266:	5b                   	pop    %ebx
80100267:	5e                   	pop    %esi
80100268:	5d                   	pop    %ebp
  release(&bcache.lock);
80100269:	e9 52 43 00 00       	jmp    801045c0 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 26 72 10 80       	push   $0x80107226
80100276:	e8 05 01 00 00       	call   80100380 <panic>
8010027b:	66 90                	xchg   %ax,%ax
8010027d:	66 90                	xchg   %ax,%ax
8010027f:	90                   	nop

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 17 16 00 00       	call   801018b0 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801002a0:	e8 7b 43 00 00       	call   80104620 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002b5:	39 05 04 ef 10 80    	cmp    %eax,0x8010ef04
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ef 10 80       	push   $0x8010ef20
801002c8:	68 00 ef 10 80       	push   $0x8010ef00
801002cd:	e8 de 3d 00 00       	call   801040b0 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 09 37 00 00       	call   801039f0 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ef 10 80       	push   $0x8010ef20
801002f6:	e8 c5 42 00 00       	call   801045c0 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 cc 14 00 00       	call   801017d0 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ef 10 80    	mov    %edx,0x8010ef00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 ee 10 80 	movsbl -0x7fef1180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ef 10 80       	push   $0x8010ef20
8010034c:	e8 6f 42 00 00       	call   801045c0 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 76 14 00 00       	call   801017d0 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ef 10 80       	mov    %eax,0x8010ef00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli
  cons.locking = 0;
80100389:	c7 05 54 ef 10 80 00 	movl   $0x0,0x8010ef54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 c2 25 00 00       	call   80102960 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 2d 72 10 80       	push   $0x8010722d
801003a7:	e8 04 03 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 fb 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 5b 7b 10 80 	movl   $0x80107b5b,(%esp)
801003bc:	e8 ef 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 93 40 00 00       	call   80104460 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 41 72 10 80       	push   $0x80107241
801003dd:	e8 ce 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ef 10 80 01 	movl   $0x1,0x8010ef58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
80100409:	3d 00 01 00 00       	cmp    $0x100,%eax
8010040e:	0f 84 cc 00 00 00    	je     801004e0 <consputc.part.0+0xe0>
    uartputc(c);
80100414:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100417:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010041c:	89 c3                	mov    %eax,%ebx
8010041e:	50                   	push   %eax
8010041f:	e8 1c 59 00 00       	call   80105d40 <uartputc>
80100424:	b8 0e 00 00 00       	mov    $0xe,%eax
80100429:	89 fa                	mov    %edi,%edx
8010042b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042c:	be d5 03 00 00       	mov    $0x3d5,%esi
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100434:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100437:	89 fa                	mov    %edi,%edx
80100439:	b8 0f 00 00 00       	mov    $0xf,%eax
8010043e:	c1 e1 08             	shl    $0x8,%ecx
80100441:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100442:	89 f2                	mov    %esi,%edx
80100444:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100445:	0f b6 c0             	movzbl %al,%eax
  if(c == '\n')
80100448:	83 c4 10             	add    $0x10,%esp
  pos |= inb(CRTPORT+1);
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	75 76                	jne    801004c8 <consputc.part.0+0xc8>
    pos += 80 - pos%80;
80100452:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100457:	f7 e2                	mul    %edx
80100459:	c1 ea 06             	shr    $0x6,%edx
8010045c:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010045f:	c1 e0 04             	shl    $0x4,%eax
80100462:	8d 70 50             	lea    0x50(%eax),%esi
  if(pos < 0 || pos > 25*80)
80100465:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
8010046b:	0f 8f 2f 01 00 00    	jg     801005a0 <consputc.part.0+0x1a0>
  if((pos/80) >= 24){  // Scroll up.
80100471:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100477:	0f 8f c3 00 00 00    	jg     80100540 <consputc.part.0+0x140>
  outb(CRTPORT+1, pos>>8);
8010047d:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
8010047f:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100486:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100489:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010048c:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100491:	b8 0e 00 00 00       	mov    $0xe,%eax
80100496:	89 da                	mov    %ebx,%edx
80100498:	ee                   	out    %al,(%dx)
80100499:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010049e:	89 f8                	mov    %edi,%eax
801004a0:	89 ca                	mov    %ecx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b8 0f 00 00 00       	mov    $0xf,%eax
801004a8:	89 da                	mov    %ebx,%edx
801004aa:	ee                   	out    %al,(%dx)
801004ab:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004af:	89 ca                	mov    %ecx,%edx
801004b1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004b2:	b8 20 07 00 00       	mov    $0x720,%eax
801004b7:	66 89 06             	mov    %ax,(%esi)
}
801004ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004bd:	5b                   	pop    %ebx
801004be:	5e                   	pop    %esi
801004bf:	5f                   	pop    %edi
801004c0:	5d                   	pop    %ebp
801004c1:	c3                   	ret
801004c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801004c8:	0f b6 db             	movzbl %bl,%ebx
801004cb:	8d 70 01             	lea    0x1(%eax),%esi
801004ce:	80 cf 07             	or     $0x7,%bh
801004d1:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
801004d8:	80 
801004d9:	eb 8a                	jmp    80100465 <consputc.part.0+0x65>
801004db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801004df:	90                   	nop
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e0:	83 ec 0c             	sub    $0xc,%esp
801004e3:	be d4 03 00 00       	mov    $0x3d4,%esi
801004e8:	6a 08                	push   $0x8
801004ea:	e8 51 58 00 00       	call   80105d40 <uartputc>
801004ef:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f6:	e8 45 58 00 00       	call   80105d40 <uartputc>
801004fb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100502:	e8 39 58 00 00       	call   80105d40 <uartputc>
80100507:	b8 0e 00 00 00       	mov    $0xe,%eax
8010050c:	89 f2                	mov    %esi,%edx
8010050e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010050f:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100514:	89 da                	mov    %ebx,%edx
80100516:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100517:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010051a:	89 f2                	mov    %esi,%edx
8010051c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100521:	c1 e1 08             	shl    $0x8,%ecx
80100524:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100525:	89 da                	mov    %ebx,%edx
80100527:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100528:	0f b6 f0             	movzbl %al,%esi
    if(pos > 0) --pos;
8010052b:	83 c4 10             	add    $0x10,%esp
8010052e:	09 ce                	or     %ecx,%esi
80100530:	74 5e                	je     80100590 <consputc.part.0+0x190>
80100532:	83 ee 01             	sub    $0x1,%esi
80100535:	e9 2b ff ff ff       	jmp    80100465 <consputc.part.0+0x65>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 2a 42 00 00       	call   80104790 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 85 41 00 00       	call   80104700 <memset>
  outb(CRTPORT+1, pos);
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 06 ff ff ff       	jmp    8010048c <consputc.part.0+0x8c>
80100586:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058d:	8d 76 00             	lea    0x0(%esi),%esi
80100590:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
80100594:	be 00 80 0b 80       	mov    $0x800b8000,%esi
80100599:	31 ff                	xor    %edi,%edi
8010059b:	e9 ec fe ff ff       	jmp    8010048c <consputc.part.0+0x8c>
    panic("pos under/overflow");
801005a0:	83 ec 0c             	sub    $0xc,%esp
801005a3:	68 45 72 10 80       	push   $0x80107245
801005a8:	e8 d3 fd ff ff       	call   80100380 <panic>
801005ad:	8d 76 00             	lea    0x0(%esi),%esi

801005b0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005b0:	55                   	push   %ebp
801005b1:	89 e5                	mov    %esp,%ebp
801005b3:	57                   	push   %edi
801005b4:	56                   	push   %esi
801005b5:	53                   	push   %ebx
801005b6:	83 ec 18             	sub    $0x18,%esp
801005b9:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005bc:	ff 75 08             	push   0x8(%ebp)
801005bf:	e8 ec 12 00 00       	call   801018b0 <iunlock>
  acquire(&cons.lock);
801005c4:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801005cb:	e8 50 40 00 00       	call   80104620 <acquire>
  for(i = 0; i < n; i++)
801005d0:	83 c4 10             	add    $0x10,%esp
801005d3:	85 f6                	test   %esi,%esi
801005d5:	7e 25                	jle    801005fc <consolewrite+0x4c>
801005d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005da:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005dd:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
    consputc(buf[i] & 0xff);
801005e3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005e6:	85 d2                	test   %edx,%edx
801005e8:	74 06                	je     801005f0 <consolewrite+0x40>
  asm volatile("cli");
801005ea:	fa                   	cli
    for(;;)
801005eb:	eb fe                	jmp    801005eb <consolewrite+0x3b>
801005ed:	8d 76 00             	lea    0x0(%esi),%esi
801005f0:	e8 0b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005f5:	83 c3 01             	add    $0x1,%ebx
801005f8:	39 df                	cmp    %ebx,%edi
801005fa:	75 e1                	jne    801005dd <consolewrite+0x2d>
  release(&cons.lock);
801005fc:	83 ec 0c             	sub    $0xc,%esp
801005ff:	68 20 ef 10 80       	push   $0x8010ef20
80100604:	e8 b7 3f 00 00       	call   801045c0 <release>
  ilock(ip);
80100609:	58                   	pop    %eax
8010060a:	ff 75 08             	push   0x8(%ebp)
8010060d:	e8 be 11 00 00       	call   801017d0 <ilock>

  return n;
}
80100612:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100615:	89 f0                	mov    %esi,%eax
80100617:	5b                   	pop    %ebx
80100618:	5e                   	pop    %esi
80100619:	5f                   	pop    %edi
8010061a:	5d                   	pop    %ebp
8010061b:	c3                   	ret
8010061c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100620 <printint>:
{
80100620:	55                   	push   %ebp
80100621:	89 e5                	mov    %esp,%ebp
80100623:	57                   	push   %edi
80100624:	56                   	push   %esi
80100625:	89 c6                	mov    %eax,%esi
80100627:	53                   	push   %ebx
80100628:	89 d3                	mov    %edx,%ebx
8010062a:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010062d:	85 c9                	test   %ecx,%ecx
8010062f:	74 04                	je     80100635 <printint+0x15>
80100631:	85 c0                	test   %eax,%eax
80100633:	78 63                	js     80100698 <printint+0x78>
    x = xx;
80100635:	89 f1                	mov    %esi,%ecx
80100637:	31 c0                	xor    %eax,%eax
  i = 0;
80100639:	89 45 d4             	mov    %eax,-0x2c(%ebp)
8010063c:	31 f6                	xor    %esi,%esi
8010063e:	66 90                	xchg   %ax,%ax
    buf[i++] = digits[x % base];
80100640:	89 c8                	mov    %ecx,%eax
80100642:	31 d2                	xor    %edx,%edx
80100644:	89 f7                	mov    %esi,%edi
80100646:	f7 f3                	div    %ebx
80100648:	8d 76 01             	lea    0x1(%esi),%esi
8010064b:	0f b6 92 70 72 10 80 	movzbl -0x7fef8d90(%edx),%edx
80100652:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
80100656:	89 ca                	mov    %ecx,%edx
80100658:	89 c1                	mov    %eax,%ecx
8010065a:	39 da                	cmp    %ebx,%edx
8010065c:	73 e2                	jae    80100640 <printint+0x20>
  if(sign)
8010065e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100661:	85 c0                	test   %eax,%eax
80100663:	74 07                	je     8010066c <printint+0x4c>
    buf[i++] = '-';
80100665:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
    buf[i++] = digits[x % base];
8010066a:	89 f7                	mov    %esi,%edi
8010066c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
8010066f:	01 df                	add    %ebx,%edi
  if(panicked){
80100671:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
    consputc(buf[i]);
80100677:	0f be 07             	movsbl (%edi),%eax
  if(panicked){
8010067a:	85 d2                	test   %edx,%edx
8010067c:	74 0a                	je     80100688 <printint+0x68>
8010067e:	fa                   	cli
    for(;;)
8010067f:	eb fe                	jmp    8010067f <printint+0x5f>
80100681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100688:	e8 73 fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
8010068d:	8d 47 ff             	lea    -0x1(%edi),%eax
80100690:	39 df                	cmp    %ebx,%edi
80100692:	74 0c                	je     801006a0 <printint+0x80>
80100694:	89 c7                	mov    %eax,%edi
80100696:	eb d9                	jmp    80100671 <printint+0x51>
80100698:	89 c8                	mov    %ecx,%eax
    x = -xx;
8010069a:	89 f1                	mov    %esi,%ecx
8010069c:	f7 d9                	neg    %ecx
8010069e:	eb 99                	jmp    80100639 <printint+0x19>
}
801006a0:	83 c4 2c             	add    $0x2c,%esp
801006a3:	5b                   	pop    %ebx
801006a4:	5e                   	pop    %esi
801006a5:	5f                   	pop    %edi
801006a6:	5d                   	pop    %ebp
801006a7:	c3                   	ret
801006a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801006af:	90                   	nop

801006b0 <cprintf>:
{
801006b0:	55                   	push   %ebp
801006b1:	89 e5                	mov    %esp,%ebp
801006b3:	57                   	push   %edi
801006b4:	56                   	push   %esi
801006b5:	53                   	push   %ebx
801006b6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006b9:	8b 3d 54 ef 10 80    	mov    0x8010ef54,%edi
  if (fmt == 0)
801006bf:	8b 75 08             	mov    0x8(%ebp),%esi
  if(locking)
801006c2:	85 ff                	test   %edi,%edi
801006c4:	0f 85 36 01 00 00    	jne    80100800 <cprintf+0x150>
  if (fmt == 0)
801006ca:	85 f6                	test   %esi,%esi
801006cc:	0f 84 e0 01 00 00    	je     801008b2 <cprintf+0x202>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006d2:	0f b6 06             	movzbl (%esi),%eax
801006d5:	85 c0                	test   %eax,%eax
801006d7:	74 6b                	je     80100744 <cprintf+0x94>
  argp = (uint*)(void*)(&fmt + 1);
801006d9:	8d 55 0c             	lea    0xc(%ebp),%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006dc:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801006df:	31 db                	xor    %ebx,%ebx
801006e1:	89 d7                	mov    %edx,%edi
    if(c != '%'){
801006e3:	83 f8 25             	cmp    $0x25,%eax
801006e6:	0f 85 dc 00 00 00    	jne    801007c8 <cprintf+0x118>
    c = fmt[++i] & 0xff;
801006ec:	83 c3 01             	add    $0x1,%ebx
801006ef:	0f b6 0c 1e          	movzbl (%esi,%ebx,1),%ecx
    if(c == 0)
801006f3:	85 c9                	test   %ecx,%ecx
801006f5:	74 42                	je     80100739 <cprintf+0x89>
    switch(c){
801006f7:	83 f9 70             	cmp    $0x70,%ecx
801006fa:	0f 84 99 00 00 00    	je     80100799 <cprintf+0xe9>
80100700:	7f 4e                	jg     80100750 <cprintf+0xa0>
80100702:	83 f9 25             	cmp    $0x25,%ecx
80100705:	0f 84 cd 00 00 00    	je     801007d8 <cprintf+0x128>
8010070b:	83 f9 64             	cmp    $0x64,%ecx
8010070e:	0f 85 24 01 00 00    	jne    80100838 <cprintf+0x188>
      printint(*argp++, 10, 1);
80100714:	8d 47 04             	lea    0x4(%edi),%eax
80100717:	b9 01 00 00 00       	mov    $0x1,%ecx
8010071c:	ba 0a 00 00 00       	mov    $0xa,%edx
80100721:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100724:	8b 07                	mov    (%edi),%eax
80100726:	e8 f5 fe ff ff       	call   80100620 <printint>
8010072b:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010072e:	83 c3 01             	add    $0x1,%ebx
80100731:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100735:	85 c0                	test   %eax,%eax
80100737:	75 aa                	jne    801006e3 <cprintf+0x33>
80100739:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if(locking)
8010073c:	85 ff                	test   %edi,%edi
8010073e:	0f 85 df 00 00 00    	jne    80100823 <cprintf+0x173>
}
80100744:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100747:	5b                   	pop    %ebx
80100748:	5e                   	pop    %esi
80100749:	5f                   	pop    %edi
8010074a:	5d                   	pop    %ebp
8010074b:	c3                   	ret
8010074c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100750:	83 f9 73             	cmp    $0x73,%ecx
80100753:	75 3b                	jne    80100790 <cprintf+0xe0>
      if((s = (char*)*argp++) == 0)
80100755:	8b 17                	mov    (%edi),%edx
80100757:	8d 47 04             	lea    0x4(%edi),%eax
8010075a:	85 d2                	test   %edx,%edx
8010075c:	0f 85 0e 01 00 00    	jne    80100870 <cprintf+0x1c0>
80100762:	b9 28 00 00 00       	mov    $0x28,%ecx
        s = "(null)";
80100767:	bf 58 72 10 80       	mov    $0x80107258,%edi
8010076c:	89 5d e0             	mov    %ebx,-0x20(%ebp)
8010076f:	89 fb                	mov    %edi,%ebx
80100771:	89 f7                	mov    %esi,%edi
80100773:	89 c6                	mov    %eax,%esi
80100775:	0f be c1             	movsbl %cl,%eax
  if(panicked){
80100778:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
8010077e:	85 d2                	test   %edx,%edx
80100780:	0f 84 fe 00 00 00    	je     80100884 <cprintf+0x1d4>
80100786:	fa                   	cli
    for(;;)
80100787:	eb fe                	jmp    80100787 <cprintf+0xd7>
80100789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100790:	83 f9 78             	cmp    $0x78,%ecx
80100793:	0f 85 9f 00 00 00    	jne    80100838 <cprintf+0x188>
      printint(*argp++, 16, 0);
80100799:	8d 47 04             	lea    0x4(%edi),%eax
8010079c:	31 c9                	xor    %ecx,%ecx
8010079e:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007a3:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
801007a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801007a9:	8b 07                	mov    (%edi),%eax
801007ab:	e8 70 fe ff ff       	call   80100620 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007b0:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
801007b4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007b7:	85 c0                	test   %eax,%eax
801007b9:	0f 85 24 ff ff ff    	jne    801006e3 <cprintf+0x33>
801007bf:	e9 75 ff ff ff       	jmp    80100739 <cprintf+0x89>
801007c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007c8:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801007ce:	85 c9                	test   %ecx,%ecx
801007d0:	74 15                	je     801007e7 <cprintf+0x137>
801007d2:	fa                   	cli
    for(;;)
801007d3:	eb fe                	jmp    801007d3 <cprintf+0x123>
801007d5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007d8:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801007de:	85 c9                	test   %ecx,%ecx
801007e0:	75 7e                	jne    80100860 <cprintf+0x1b0>
801007e2:	b8 25 00 00 00       	mov    $0x25,%eax
801007e7:	e8 14 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007ec:	83 c3 01             	add    $0x1,%ebx
801007ef:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007f3:	85 c0                	test   %eax,%eax
801007f5:	0f 85 e8 fe ff ff    	jne    801006e3 <cprintf+0x33>
801007fb:	e9 39 ff ff ff       	jmp    80100739 <cprintf+0x89>
    acquire(&cons.lock);
80100800:	83 ec 0c             	sub    $0xc,%esp
80100803:	68 20 ef 10 80       	push   $0x8010ef20
80100808:	e8 13 3e 00 00       	call   80104620 <acquire>
  if (fmt == 0)
8010080d:	83 c4 10             	add    $0x10,%esp
80100810:	85 f6                	test   %esi,%esi
80100812:	0f 84 9a 00 00 00    	je     801008b2 <cprintf+0x202>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100818:	0f b6 06             	movzbl (%esi),%eax
8010081b:	85 c0                	test   %eax,%eax
8010081d:	0f 85 b6 fe ff ff    	jne    801006d9 <cprintf+0x29>
    release(&cons.lock);
80100823:	83 ec 0c             	sub    $0xc,%esp
80100826:	68 20 ef 10 80       	push   $0x8010ef20
8010082b:	e8 90 3d 00 00       	call   801045c0 <release>
80100830:	83 c4 10             	add    $0x10,%esp
80100833:	e9 0c ff ff ff       	jmp    80100744 <cprintf+0x94>
  if(panicked){
80100838:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
8010083e:	85 d2                	test   %edx,%edx
80100840:	75 26                	jne    80100868 <cprintf+0x1b8>
80100842:	b8 25 00 00 00       	mov    $0x25,%eax
80100847:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010084a:	e8 b1 fb ff ff       	call   80100400 <consputc.part.0>
8010084f:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
80100854:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80100857:	85 c0                	test   %eax,%eax
80100859:	74 4b                	je     801008a6 <cprintf+0x1f6>
8010085b:	fa                   	cli
    for(;;)
8010085c:	eb fe                	jmp    8010085c <cprintf+0x1ac>
8010085e:	66 90                	xchg   %ax,%ax
80100860:	fa                   	cli
80100861:	eb fe                	jmp    80100861 <cprintf+0x1b1>
80100863:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100867:	90                   	nop
80100868:	fa                   	cli
80100869:	eb fe                	jmp    80100869 <cprintf+0x1b9>
8010086b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010086f:	90                   	nop
      for(; *s; s++)
80100870:	0f b6 0a             	movzbl (%edx),%ecx
      if((s = (char*)*argp++) == 0)
80100873:	89 d7                	mov    %edx,%edi
      for(; *s; s++)
80100875:	84 c9                	test   %cl,%cl
80100877:	0f 85 ef fe ff ff    	jne    8010076c <cprintf+0xbc>
      if((s = (char*)*argp++) == 0)
8010087d:	89 c7                	mov    %eax,%edi
8010087f:	e9 aa fe ff ff       	jmp    8010072e <cprintf+0x7e>
80100884:	e8 77 fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100889:	0f be 43 01          	movsbl 0x1(%ebx),%eax
8010088d:	83 c3 01             	add    $0x1,%ebx
80100890:	84 c0                	test   %al,%al
80100892:	0f 85 e0 fe ff ff    	jne    80100778 <cprintf+0xc8>
      if((s = (char*)*argp++) == 0)
80100898:	89 f0                	mov    %esi,%eax
8010089a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
8010089d:	89 fe                	mov    %edi,%esi
8010089f:	89 c7                	mov    %eax,%edi
801008a1:	e9 88 fe ff ff       	jmp    8010072e <cprintf+0x7e>
801008a6:	89 c8                	mov    %ecx,%eax
801008a8:	e8 53 fb ff ff       	call   80100400 <consputc.part.0>
801008ad:	e9 7c fe ff ff       	jmp    8010072e <cprintf+0x7e>
    panic("null fmt");
801008b2:	83 ec 0c             	sub    $0xc,%esp
801008b5:	68 5f 72 10 80       	push   $0x8010725f
801008ba:	e8 c1 fa ff ff       	call   80100380 <panic>
801008bf:	90                   	nop

801008c0 <consoleintr>:
{
801008c0:	55                   	push   %ebp
801008c1:	89 e5                	mov    %esp,%ebp
801008c3:	57                   	push   %edi
801008c4:	56                   	push   %esi
  int c, doprocdump = 0;
801008c5:	31 f6                	xor    %esi,%esi
{
801008c7:	53                   	push   %ebx
801008c8:	83 ec 18             	sub    $0x18,%esp
801008cb:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
801008ce:	68 20 ef 10 80       	push   $0x8010ef20
801008d3:	e8 48 3d 00 00       	call   80104620 <acquire>
  while((c = getc()) >= 0){
801008d8:	83 c4 10             	add    $0x10,%esp
801008db:	eb 1a                	jmp    801008f7 <consoleintr+0x37>
801008dd:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801008e0:	83 fb 08             	cmp    $0x8,%ebx
801008e3:	0f 84 d7 00 00 00    	je     801009c0 <consoleintr+0x100>
801008e9:	83 fb 10             	cmp    $0x10,%ebx
801008ec:	0f 85 2d 01 00 00    	jne    80100a1f <consoleintr+0x15f>
801008f2:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801008f7:	ff d7                	call   *%edi
801008f9:	89 c3                	mov    %eax,%ebx
801008fb:	85 c0                	test   %eax,%eax
801008fd:	0f 88 e5 00 00 00    	js     801009e8 <consoleintr+0x128>
    switch(c){
80100903:	83 fb 15             	cmp    $0x15,%ebx
80100906:	74 7a                	je     80100982 <consoleintr+0xc2>
80100908:	7e d6                	jle    801008e0 <consoleintr+0x20>
8010090a:	83 fb 7f             	cmp    $0x7f,%ebx
8010090d:	0f 84 ad 00 00 00    	je     801009c0 <consoleintr+0x100>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100913:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100918:	89 c2                	mov    %eax,%edx
8010091a:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
80100920:	83 fa 7f             	cmp    $0x7f,%edx
80100923:	77 d2                	ja     801008f7 <consoleintr+0x37>
  if(panicked){
80100925:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
8010092b:	8d 48 01             	lea    0x1(%eax),%ecx
8010092e:	83 e0 7f             	and    $0x7f,%eax
80100931:	89 0d 08 ef 10 80    	mov    %ecx,0x8010ef08
80100937:	88 98 80 ee 10 80    	mov    %bl,-0x7fef1180(%eax)
  if(panicked){
8010093d:	85 d2                	test   %edx,%edx
8010093f:	0f 85 47 01 00 00    	jne    80100a8c <consoleintr+0x1cc>
80100945:	89 d8                	mov    %ebx,%eax
80100947:	e8 b4 fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010094c:	83 fb 0a             	cmp    $0xa,%ebx
8010094f:	0f 84 18 01 00 00    	je     80100a6d <consoleintr+0x1ad>
80100955:	83 fb 04             	cmp    $0x4,%ebx
80100958:	0f 84 0f 01 00 00    	je     80100a6d <consoleintr+0x1ad>
8010095e:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
80100963:	83 e8 80             	sub    $0xffffff80,%eax
80100966:	39 05 08 ef 10 80    	cmp    %eax,0x8010ef08
8010096c:	75 89                	jne    801008f7 <consoleintr+0x37>
8010096e:	e9 ff 00 00 00       	jmp    80100a72 <consoleintr+0x1b2>
80100973:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100977:	90                   	nop
80100978:	b8 00 01 00 00       	mov    $0x100,%eax
8010097d:	e8 7e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
80100982:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100987:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
8010098d:	0f 84 64 ff ff ff    	je     801008f7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100993:	83 e8 01             	sub    $0x1,%eax
80100996:	89 c2                	mov    %eax,%edx
80100998:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
8010099b:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
801009a2:	0f 84 4f ff ff ff    	je     801008f7 <consoleintr+0x37>
  if(panicked){
801009a8:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.e--;
801009ae:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
801009b3:	85 d2                	test   %edx,%edx
801009b5:	74 c1                	je     80100978 <consoleintr+0xb8>
801009b7:	fa                   	cli
    for(;;)
801009b8:	eb fe                	jmp    801009b8 <consoleintr+0xf8>
801009ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(input.e != input.w){
801009c0:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801009c5:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801009cb:	0f 84 26 ff ff ff    	je     801008f7 <consoleintr+0x37>
        input.e--;
801009d1:	83 e8 01             	sub    $0x1,%eax
801009d4:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
801009d9:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
801009de:	85 c0                	test   %eax,%eax
801009e0:	74 22                	je     80100a04 <consoleintr+0x144>
801009e2:	fa                   	cli
    for(;;)
801009e3:	eb fe                	jmp    801009e3 <consoleintr+0x123>
801009e5:	8d 76 00             	lea    0x0(%esi),%esi
  release(&cons.lock);
801009e8:	83 ec 0c             	sub    $0xc,%esp
801009eb:	68 20 ef 10 80       	push   $0x8010ef20
801009f0:	e8 cb 3b 00 00       	call   801045c0 <release>
  if(doprocdump) {
801009f5:	83 c4 10             	add    $0x10,%esp
801009f8:	85 f6                	test   %esi,%esi
801009fa:	75 17                	jne    80100a13 <consoleintr+0x153>
}
801009fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009ff:	5b                   	pop    %ebx
80100a00:	5e                   	pop    %esi
80100a01:	5f                   	pop    %edi
80100a02:	5d                   	pop    %ebp
80100a03:	c3                   	ret
80100a04:	b8 00 01 00 00       	mov    $0x100,%eax
80100a09:	e8 f2 f9 ff ff       	call   80100400 <consputc.part.0>
80100a0e:	e9 e4 fe ff ff       	jmp    801008f7 <consoleintr+0x37>
80100a13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a16:	5b                   	pop    %ebx
80100a17:	5e                   	pop    %esi
80100a18:	5f                   	pop    %edi
80100a19:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a1a:	e9 31 38 00 00       	jmp    80104250 <procdump>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100a1f:	85 db                	test   %ebx,%ebx
80100a21:	0f 84 d0 fe ff ff    	je     801008f7 <consoleintr+0x37>
80100a27:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100a2c:	89 c2                	mov    %eax,%edx
80100a2e:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
80100a34:	83 fa 7f             	cmp    $0x7f,%edx
80100a37:	0f 87 ba fe ff ff    	ja     801008f7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a3d:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
80100a40:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
80100a46:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100a49:	83 fb 0d             	cmp    $0xd,%ebx
80100a4c:	0f 85 df fe ff ff    	jne    80100931 <consoleintr+0x71>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a52:	89 0d 08 ef 10 80    	mov    %ecx,0x8010ef08
80100a58:	c6 80 80 ee 10 80 0a 	movb   $0xa,-0x7fef1180(%eax)
  if(panicked){
80100a5f:	85 d2                	test   %edx,%edx
80100a61:	75 29                	jne    80100a8c <consoleintr+0x1cc>
80100a63:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a68:	e8 93 f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a6d:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
          wakeup(&input.r);
80100a72:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a75:	a3 04 ef 10 80       	mov    %eax,0x8010ef04
          wakeup(&input.r);
80100a7a:	68 00 ef 10 80       	push   $0x8010ef00
80100a7f:	e8 ec 36 00 00       	call   80104170 <wakeup>
80100a84:	83 c4 10             	add    $0x10,%esp
80100a87:	e9 6b fe ff ff       	jmp    801008f7 <consoleintr+0x37>
80100a8c:	fa                   	cli
    for(;;)
80100a8d:	eb fe                	jmp    80100a8d <consoleintr+0x1cd>
80100a8f:	90                   	nop

80100a90 <consoleinit>:

void
consoleinit(void)
{
80100a90:	55                   	push   %ebp
80100a91:	89 e5                	mov    %esp,%ebp
80100a93:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a96:	68 68 72 10 80       	push   $0x80107268
80100a9b:	68 20 ef 10 80       	push   $0x8010ef20
80100aa0:	e8 9b 39 00 00       	call   80104440 <initlock>

  devsw[CONSOLE].write = consolewrite;
80100aa5:	c7 05 0c f9 10 80 b0 	movl   $0x801005b0,0x8010f90c
80100aac:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100aaf:	c7 05 08 f9 10 80 80 	movl   $0x80100280,0x8010f908
80100ab6:	02 10 80 
  cons.locking = 1;
80100ab9:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
80100ac0:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100ac3:	58                   	pop    %eax
80100ac4:	5a                   	pop    %edx
80100ac5:	6a 00                	push   $0x0
80100ac7:	6a 01                	push   $0x1
80100ac9:	e8 12 1a 00 00       	call   801024e0 <ioapicenable>
}
80100ace:	83 c4 10             	add    $0x10,%esp
80100ad1:	c9                   	leave
80100ad2:	c3                   	ret
80100ad3:	66 90                	xchg   %ax,%ax
80100ad5:	66 90                	xchg   %ax,%ax
80100ad7:	66 90                	xchg   %ax,%ax
80100ad9:	66 90                	xchg   %ax,%ax
80100adb:	66 90                	xchg   %ax,%ax
80100add:	66 90                	xchg   %ax,%ax
80100adf:	90                   	nop

80100ae0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ae0:	55                   	push   %ebp
80100ae1:	89 e5                	mov    %esp,%ebp
80100ae3:	57                   	push   %edi
80100ae4:	56                   	push   %esi
80100ae5:	53                   	push   %ebx
80100ae6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100aec:	e8 ff 2e 00 00       	call   801039f0 <myproc>
80100af1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100af7:	e8 d4 22 00 00       	call   80102dd0 <begin_op>

  if((ip = namei(path)) == 0){
80100afc:	83 ec 0c             	sub    $0xc,%esp
80100aff:	ff 75 08             	push   0x8(%ebp)
80100b02:	e8 f9 15 00 00       	call   80102100 <namei>
80100b07:	83 c4 10             	add    $0x10,%esp
80100b0a:	85 c0                	test   %eax,%eax
80100b0c:	0f 84 30 03 00 00    	je     80100e42 <exec+0x362>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100b12:	83 ec 0c             	sub    $0xc,%esp
80100b15:	89 c7                	mov    %eax,%edi
80100b17:	50                   	push   %eax
80100b18:	e8 b3 0c 00 00       	call   801017d0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100b1d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100b23:	6a 34                	push   $0x34
80100b25:	6a 00                	push   $0x0
80100b27:	50                   	push   %eax
80100b28:	57                   	push   %edi
80100b29:	e8 b2 0f 00 00       	call   80101ae0 <readi>
80100b2e:	83 c4 20             	add    $0x20,%esp
80100b31:	83 f8 34             	cmp    $0x34,%eax
80100b34:	0f 85 01 01 00 00    	jne    80100c3b <exec+0x15b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b3a:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b41:	45 4c 46 
80100b44:	0f 85 f1 00 00 00    	jne    80100c3b <exec+0x15b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100b4a:	e8 61 63 00 00       	call   80106eb0 <setupkvm>
80100b4f:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b55:	85 c0                	test   %eax,%eax
80100b57:	0f 84 de 00 00 00    	je     80100c3b <exec+0x15b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b5d:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b64:	00 
80100b65:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b6b:	0f 84 a1 02 00 00    	je     80100e12 <exec+0x332>
  sz = 0;
80100b71:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b78:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b7b:	31 db                	xor    %ebx,%ebx
80100b7d:	e9 8c 00 00 00       	jmp    80100c0e <exec+0x12e>
80100b82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100b88:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b8f:	75 6c                	jne    80100bfd <exec+0x11d>
      continue;
    if(ph.memsz < ph.filesz)
80100b91:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b97:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b9d:	0f 82 87 00 00 00    	jb     80100c2a <exec+0x14a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ba3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ba9:	72 7f                	jb     80100c2a <exec+0x14a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100bab:	83 ec 04             	sub    $0x4,%esp
80100bae:	50                   	push   %eax
80100baf:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100bb5:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bbb:	e8 20 61 00 00       	call   80106ce0 <allocuvm>
80100bc0:	83 c4 10             	add    $0x10,%esp
80100bc3:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bc9:	85 c0                	test   %eax,%eax
80100bcb:	74 5d                	je     80100c2a <exec+0x14a>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100bcd:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bd3:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bd8:	75 50                	jne    80100c2a <exec+0x14a>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bda:	83 ec 0c             	sub    $0xc,%esp
80100bdd:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100be3:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100be9:	57                   	push   %edi
80100bea:	50                   	push   %eax
80100beb:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bf1:	e8 1a 60 00 00       	call   80106c10 <loaduvm>
80100bf6:	83 c4 20             	add    $0x20,%esp
80100bf9:	85 c0                	test   %eax,%eax
80100bfb:	78 2d                	js     80100c2a <exec+0x14a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bfd:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100c04:	83 c3 01             	add    $0x1,%ebx
80100c07:	83 c6 20             	add    $0x20,%esi
80100c0a:	39 d8                	cmp    %ebx,%eax
80100c0c:	7e 52                	jle    80100c60 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c0e:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100c14:	6a 20                	push   $0x20
80100c16:	56                   	push   %esi
80100c17:	50                   	push   %eax
80100c18:	57                   	push   %edi
80100c19:	e8 c2 0e 00 00       	call   80101ae0 <readi>
80100c1e:	83 c4 10             	add    $0x10,%esp
80100c21:	83 f8 20             	cmp    $0x20,%eax
80100c24:	0f 84 5e ff ff ff    	je     80100b88 <exec+0xa8>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100c2a:	83 ec 0c             	sub    $0xc,%esp
80100c2d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c33:	e8 f8 61 00 00       	call   80106e30 <freevm>
  if(ip){
80100c38:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80100c3b:	83 ec 0c             	sub    $0xc,%esp
80100c3e:	57                   	push   %edi
80100c3f:	e8 1c 0e 00 00       	call   80101a60 <iunlockput>
    end_op();
80100c44:	e8 f7 21 00 00       	call   80102e40 <end_op>
80100c49:	83 c4 10             	add    $0x10,%esp
    return -1;
80100c4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
80100c51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c54:	5b                   	pop    %ebx
80100c55:	5e                   	pop    %esi
80100c56:	5f                   	pop    %edi
80100c57:	5d                   	pop    %ebp
80100c58:	c3                   	ret
80100c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = PGROUNDUP(sz);
80100c60:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c66:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100c6c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c72:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80100c78:	83 ec 0c             	sub    $0xc,%esp
80100c7b:	57                   	push   %edi
80100c7c:	e8 df 0d 00 00       	call   80101a60 <iunlockput>
  end_op();
80100c81:	e8 ba 21 00 00       	call   80102e40 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c86:	83 c4 0c             	add    $0xc,%esp
80100c89:	53                   	push   %ebx
80100c8a:	56                   	push   %esi
80100c8b:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c91:	56                   	push   %esi
80100c92:	e8 49 60 00 00       	call   80106ce0 <allocuvm>
80100c97:	83 c4 10             	add    $0x10,%esp
80100c9a:	89 c7                	mov    %eax,%edi
80100c9c:	85 c0                	test   %eax,%eax
80100c9e:	0f 84 86 00 00 00    	je     80100d2a <exec+0x24a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100ca4:	83 ec 08             	sub    $0x8,%esp
80100ca7:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100cad:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100caf:	50                   	push   %eax
80100cb0:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80100cb1:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cb3:	e8 98 62 00 00       	call   80106f50 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100cb8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cbb:	83 c4 10             	add    $0x10,%esp
80100cbe:	8b 10                	mov    (%eax),%edx
80100cc0:	85 d2                	test   %edx,%edx
80100cc2:	0f 84 56 01 00 00    	je     80100e1e <exec+0x33e>
80100cc8:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
80100cce:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100cd1:	eb 23                	jmp    80100cf6 <exec+0x216>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
80100cd8:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
80100cdb:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
80100ce2:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100ce8:	8b 14 87             	mov    (%edi,%eax,4),%edx
80100ceb:	85 d2                	test   %edx,%edx
80100ced:	74 51                	je     80100d40 <exec+0x260>
    if(argc >= MAXARG)
80100cef:	83 f8 20             	cmp    $0x20,%eax
80100cf2:	74 36                	je     80100d2a <exec+0x24a>
  for(argc = 0; argv[argc]; argc++) {
80100cf4:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cf6:	83 ec 0c             	sub    $0xc,%esp
80100cf9:	52                   	push   %edx
80100cfa:	e8 f1 3b 00 00       	call   801048f0 <strlen>
80100cff:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d01:	58                   	pop    %eax
80100d02:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d05:	83 eb 01             	sub    $0x1,%ebx
80100d08:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d0b:	e8 e0 3b 00 00       	call   801048f0 <strlen>
80100d10:	83 c0 01             	add    $0x1,%eax
80100d13:	50                   	push   %eax
80100d14:	ff 34 b7             	push   (%edi,%esi,4)
80100d17:	53                   	push   %ebx
80100d18:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d1e:	e8 fd 63 00 00       	call   80107120 <copyout>
80100d23:	83 c4 20             	add    $0x20,%esp
80100d26:	85 c0                	test   %eax,%eax
80100d28:	79 ae                	jns    80100cd8 <exec+0x1f8>
    freevm(pgdir);
80100d2a:	83 ec 0c             	sub    $0xc,%esp
80100d2d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d33:	e8 f8 60 00 00       	call   80106e30 <freevm>
80100d38:	83 c4 10             	add    $0x10,%esp
80100d3b:	e9 0c ff ff ff       	jmp    80100c4c <exec+0x16c>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d40:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
80100d47:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100d4d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100d53:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
80100d56:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
80100d59:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80100d60:	00 00 00 00 
  ustack[1] = argc;
80100d64:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
80100d6a:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d71:	ff ff ff 
  ustack[1] = argc;
80100d74:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d7a:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
80100d7c:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d7e:	29 d0                	sub    %edx,%eax
80100d80:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d86:	56                   	push   %esi
80100d87:	51                   	push   %ecx
80100d88:	53                   	push   %ebx
80100d89:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d8f:	e8 8c 63 00 00       	call   80107120 <copyout>
80100d94:	83 c4 10             	add    $0x10,%esp
80100d97:	85 c0                	test   %eax,%eax
80100d99:	78 8f                	js     80100d2a <exec+0x24a>
  for(last=s=path; *s; s++)
80100d9b:	8b 45 08             	mov    0x8(%ebp),%eax
80100d9e:	8b 55 08             	mov    0x8(%ebp),%edx
80100da1:	0f b6 00             	movzbl (%eax),%eax
80100da4:	84 c0                	test   %al,%al
80100da6:	74 17                	je     80100dbf <exec+0x2df>
80100da8:	89 d1                	mov    %edx,%ecx
80100daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
80100db0:	83 c1 01             	add    $0x1,%ecx
80100db3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100db5:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100db8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100dbb:	84 c0                	test   %al,%al
80100dbd:	75 f1                	jne    80100db0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100dbf:	83 ec 04             	sub    $0x4,%esp
80100dc2:	6a 10                	push   $0x10
80100dc4:	52                   	push   %edx
80100dc5:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100dcb:	8d 46 6c             	lea    0x6c(%esi),%eax
80100dce:	50                   	push   %eax
80100dcf:	e8 dc 3a 00 00       	call   801048b0 <safestrcpy>
  curproc->pgdir = pgdir;
80100dd4:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dda:	89 f0                	mov    %esi,%eax
80100ddc:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->sz = sz;
80100ddf:	89 38                	mov    %edi,(%eax)
  curproc->pgdir = pgdir;
80100de1:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100de4:	89 c1                	mov    %eax,%ecx
80100de6:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dec:	8b 40 18             	mov    0x18(%eax),%eax
80100def:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100df2:	8b 41 18             	mov    0x18(%ecx),%eax
80100df5:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100df8:	89 0c 24             	mov    %ecx,(%esp)
80100dfb:	e8 80 5c 00 00       	call   80106a80 <switchuvm>
  freevm(oldpgdir);
80100e00:	89 34 24             	mov    %esi,(%esp)
80100e03:	e8 28 60 00 00       	call   80106e30 <freevm>
  return 0;
80100e08:	83 c4 10             	add    $0x10,%esp
80100e0b:	31 c0                	xor    %eax,%eax
80100e0d:	e9 3f fe ff ff       	jmp    80100c51 <exec+0x171>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e12:	bb 00 20 00 00       	mov    $0x2000,%ebx
80100e17:	31 f6                	xor    %esi,%esi
80100e19:	e9 5a fe ff ff       	jmp    80100c78 <exec+0x198>
  for(argc = 0; argv[argc]; argc++) {
80100e1e:	be 10 00 00 00       	mov    $0x10,%esi
80100e23:	ba 04 00 00 00       	mov    $0x4,%edx
80100e28:	b8 03 00 00 00       	mov    $0x3,%eax
80100e2d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100e34:	00 00 00 
80100e37:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100e3d:	e9 17 ff ff ff       	jmp    80100d59 <exec+0x279>
    end_op();
80100e42:	e8 f9 1f 00 00       	call   80102e40 <end_op>
    cprintf("exec: fail\n");
80100e47:	83 ec 0c             	sub    $0xc,%esp
80100e4a:	68 81 72 10 80       	push   $0x80107281
80100e4f:	e8 5c f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100e54:	83 c4 10             	add    $0x10,%esp
80100e57:	e9 f0 fd ff ff       	jmp    80100c4c <exec+0x16c>
80100e5c:	66 90                	xchg   %ax,%ax
80100e5e:	66 90                	xchg   %ax,%ax

80100e60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e60:	55                   	push   %ebp
80100e61:	89 e5                	mov    %esp,%ebp
80100e63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e66:	68 8d 72 10 80       	push   $0x8010728d
80100e6b:	68 60 ef 10 80       	push   $0x8010ef60
80100e70:	e8 cb 35 00 00       	call   80104440 <initlock>
}
80100e75:	83 c4 10             	add    $0x10,%esp
80100e78:	c9                   	leave
80100e79:	c3                   	ret
80100e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e80:	55                   	push   %ebp
80100e81:	89 e5                	mov    %esp,%ebp
80100e83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e84:	bb 94 ef 10 80       	mov    $0x8010ef94,%ebx
{
80100e89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e8c:	68 60 ef 10 80       	push   $0x8010ef60
80100e91:	e8 8a 37 00 00       	call   80104620 <acquire>
80100e96:	83 c4 10             	add    $0x10,%esp
80100e99:	eb 10                	jmp    80100eab <filealloc+0x2b>
80100e9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e9f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ea0:	83 c3 18             	add    $0x18,%ebx
80100ea3:	81 fb f4 f8 10 80    	cmp    $0x8010f8f4,%ebx
80100ea9:	74 25                	je     80100ed0 <filealloc+0x50>
    if(f->ref == 0){
80100eab:	8b 43 04             	mov    0x4(%ebx),%eax
80100eae:	85 c0                	test   %eax,%eax
80100eb0:	75 ee                	jne    80100ea0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100eb2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100eb5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100ebc:	68 60 ef 10 80       	push   $0x8010ef60
80100ec1:	e8 fa 36 00 00       	call   801045c0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100ec6:	89 d8                	mov    %ebx,%eax
      return f;
80100ec8:	83 c4 10             	add    $0x10,%esp
}
80100ecb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ece:	c9                   	leave
80100ecf:	c3                   	ret
  release(&ftable.lock);
80100ed0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100ed3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100ed5:	68 60 ef 10 80       	push   $0x8010ef60
80100eda:	e8 e1 36 00 00       	call   801045c0 <release>
}
80100edf:	89 d8                	mov    %ebx,%eax
  return 0;
80100ee1:	83 c4 10             	add    $0x10,%esp
}
80100ee4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ee7:	c9                   	leave
80100ee8:	c3                   	ret
80100ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	53                   	push   %ebx
80100ef4:	83 ec 10             	sub    $0x10,%esp
80100ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100efa:	68 60 ef 10 80       	push   $0x8010ef60
80100eff:	e8 1c 37 00 00       	call   80104620 <acquire>
  if(f->ref < 1)
80100f04:	8b 43 04             	mov    0x4(%ebx),%eax
80100f07:	83 c4 10             	add    $0x10,%esp
80100f0a:	85 c0                	test   %eax,%eax
80100f0c:	7e 1a                	jle    80100f28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100f0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100f11:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100f14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100f17:	68 60 ef 10 80       	push   $0x8010ef60
80100f1c:	e8 9f 36 00 00       	call   801045c0 <release>
  return f;
}
80100f21:	89 d8                	mov    %ebx,%eax
80100f23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f26:	c9                   	leave
80100f27:	c3                   	ret
    panic("filedup");
80100f28:	83 ec 0c             	sub    $0xc,%esp
80100f2b:	68 94 72 10 80       	push   $0x80107294
80100f30:	e8 4b f4 ff ff       	call   80100380 <panic>
80100f35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	57                   	push   %edi
80100f44:	56                   	push   %esi
80100f45:	53                   	push   %ebx
80100f46:	83 ec 28             	sub    $0x28,%esp
80100f49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f4c:	68 60 ef 10 80       	push   $0x8010ef60
80100f51:	e8 ca 36 00 00       	call   80104620 <acquire>
  if(f->ref < 1)
80100f56:	8b 53 04             	mov    0x4(%ebx),%edx
80100f59:	83 c4 10             	add    $0x10,%esp
80100f5c:	85 d2                	test   %edx,%edx
80100f5e:	0f 8e a5 00 00 00    	jle    80101009 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f64:	83 ea 01             	sub    $0x1,%edx
80100f67:	89 53 04             	mov    %edx,0x4(%ebx)
80100f6a:	75 44                	jne    80100fb0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f6c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f70:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f73:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f75:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f7b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f7e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f81:	8b 43 10             	mov    0x10(%ebx),%eax
80100f84:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f87:	68 60 ef 10 80       	push   $0x8010ef60
80100f8c:	e8 2f 36 00 00       	call   801045c0 <release>

  if(ff.type == FD_PIPE)
80100f91:	83 c4 10             	add    $0x10,%esp
80100f94:	83 ff 01             	cmp    $0x1,%edi
80100f97:	74 57                	je     80100ff0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f99:	83 ff 02             	cmp    $0x2,%edi
80100f9c:	74 2a                	je     80100fc8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fa1:	5b                   	pop    %ebx
80100fa2:	5e                   	pop    %esi
80100fa3:	5f                   	pop    %edi
80100fa4:	5d                   	pop    %ebp
80100fa5:	c3                   	ret
80100fa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fad:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100fb0:	c7 45 08 60 ef 10 80 	movl   $0x8010ef60,0x8(%ebp)
}
80100fb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fba:	5b                   	pop    %ebx
80100fbb:	5e                   	pop    %esi
80100fbc:	5f                   	pop    %edi
80100fbd:	5d                   	pop    %ebp
    release(&ftable.lock);
80100fbe:	e9 fd 35 00 00       	jmp    801045c0 <release>
80100fc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100fc7:	90                   	nop
    begin_op();
80100fc8:	e8 03 1e 00 00       	call   80102dd0 <begin_op>
    iput(ff.ip);
80100fcd:	83 ec 0c             	sub    $0xc,%esp
80100fd0:	ff 75 e0             	push   -0x20(%ebp)
80100fd3:	e8 28 09 00 00       	call   80101900 <iput>
    end_op();
80100fd8:	83 c4 10             	add    $0x10,%esp
}
80100fdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fde:	5b                   	pop    %ebx
80100fdf:	5e                   	pop    %esi
80100fe0:	5f                   	pop    %edi
80100fe1:	5d                   	pop    %ebp
    end_op();
80100fe2:	e9 59 1e 00 00       	jmp    80102e40 <end_op>
80100fe7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fee:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100ff0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ff4:	83 ec 08             	sub    $0x8,%esp
80100ff7:	53                   	push   %ebx
80100ff8:	56                   	push   %esi
80100ff9:	e8 92 25 00 00       	call   80103590 <pipeclose>
80100ffe:	83 c4 10             	add    $0x10,%esp
}
80101001:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101004:	5b                   	pop    %ebx
80101005:	5e                   	pop    %esi
80101006:	5f                   	pop    %edi
80101007:	5d                   	pop    %ebp
80101008:	c3                   	ret
    panic("fileclose");
80101009:	83 ec 0c             	sub    $0xc,%esp
8010100c:	68 9c 72 10 80       	push   $0x8010729c
80101011:	e8 6a f3 ff ff       	call   80100380 <panic>
80101016:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010101d:	8d 76 00             	lea    0x0(%esi),%esi

80101020 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	53                   	push   %ebx
80101024:	83 ec 04             	sub    $0x4,%esp
80101027:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010102a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010102d:	75 31                	jne    80101060 <filestat+0x40>
    ilock(f->ip);
8010102f:	83 ec 0c             	sub    $0xc,%esp
80101032:	ff 73 10             	push   0x10(%ebx)
80101035:	e8 96 07 00 00       	call   801017d0 <ilock>
    stati(f->ip, st);
8010103a:	58                   	pop    %eax
8010103b:	5a                   	pop    %edx
8010103c:	ff 75 0c             	push   0xc(%ebp)
8010103f:	ff 73 10             	push   0x10(%ebx)
80101042:	e8 69 0a 00 00       	call   80101ab0 <stati>
    iunlock(f->ip);
80101047:	59                   	pop    %ecx
80101048:	ff 73 10             	push   0x10(%ebx)
8010104b:	e8 60 08 00 00       	call   801018b0 <iunlock>
    return 0;
  }
  return -1;
}
80101050:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101053:	83 c4 10             	add    $0x10,%esp
80101056:	31 c0                	xor    %eax,%eax
}
80101058:	c9                   	leave
80101059:	c3                   	ret
8010105a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101060:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101063:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101068:	c9                   	leave
80101069:	c3                   	ret
8010106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101070 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101070:	55                   	push   %ebp
80101071:	89 e5                	mov    %esp,%ebp
80101073:	57                   	push   %edi
80101074:	56                   	push   %esi
80101075:	53                   	push   %ebx
80101076:	83 ec 0c             	sub    $0xc,%esp
80101079:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010107c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010107f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101082:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101086:	74 60                	je     801010e8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101088:	8b 03                	mov    (%ebx),%eax
8010108a:	83 f8 01             	cmp    $0x1,%eax
8010108d:	74 41                	je     801010d0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010108f:	83 f8 02             	cmp    $0x2,%eax
80101092:	75 5b                	jne    801010ef <fileread+0x7f>
    ilock(f->ip);
80101094:	83 ec 0c             	sub    $0xc,%esp
80101097:	ff 73 10             	push   0x10(%ebx)
8010109a:	e8 31 07 00 00       	call   801017d0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010109f:	57                   	push   %edi
801010a0:	ff 73 14             	push   0x14(%ebx)
801010a3:	56                   	push   %esi
801010a4:	ff 73 10             	push   0x10(%ebx)
801010a7:	e8 34 0a 00 00       	call   80101ae0 <readi>
801010ac:	83 c4 20             	add    $0x20,%esp
801010af:	89 c6                	mov    %eax,%esi
801010b1:	85 c0                	test   %eax,%eax
801010b3:	7e 03                	jle    801010b8 <fileread+0x48>
      f->off += r;
801010b5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801010b8:	83 ec 0c             	sub    $0xc,%esp
801010bb:	ff 73 10             	push   0x10(%ebx)
801010be:	e8 ed 07 00 00       	call   801018b0 <iunlock>
    return r;
801010c3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801010c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c9:	89 f0                	mov    %esi,%eax
801010cb:	5b                   	pop    %ebx
801010cc:	5e                   	pop    %esi
801010cd:	5f                   	pop    %edi
801010ce:	5d                   	pop    %ebp
801010cf:	c3                   	ret
    return piperead(f->pipe, addr, n);
801010d0:	8b 43 0c             	mov    0xc(%ebx),%eax
801010d3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d9:	5b                   	pop    %ebx
801010da:	5e                   	pop    %esi
801010db:	5f                   	pop    %edi
801010dc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010dd:	e9 6e 26 00 00       	jmp    80103750 <piperead>
801010e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010e8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010ed:	eb d7                	jmp    801010c6 <fileread+0x56>
  panic("fileread");
801010ef:	83 ec 0c             	sub    $0xc,%esp
801010f2:	68 a6 72 10 80       	push   $0x801072a6
801010f7:	e8 84 f2 ff ff       	call   80100380 <panic>
801010fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101100 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	57                   	push   %edi
80101104:	56                   	push   %esi
80101105:	53                   	push   %ebx
80101106:	83 ec 1c             	sub    $0x1c,%esp
80101109:	8b 45 0c             	mov    0xc(%ebp),%eax
8010110c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010110f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101112:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101115:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101119:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010111c:	0f 84 bb 00 00 00    	je     801011dd <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
80101122:	8b 03                	mov    (%ebx),%eax
80101124:	83 f8 01             	cmp    $0x1,%eax
80101127:	0f 84 bf 00 00 00    	je     801011ec <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010112d:	83 f8 02             	cmp    $0x2,%eax
80101130:	0f 85 c8 00 00 00    	jne    801011fe <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101136:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101139:	31 f6                	xor    %esi,%esi
    while(i < n){
8010113b:	85 c0                	test   %eax,%eax
8010113d:	7f 30                	jg     8010116f <filewrite+0x6f>
8010113f:	e9 94 00 00 00       	jmp    801011d8 <filewrite+0xd8>
80101144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101148:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010114b:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
8010114e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101151:	ff 73 10             	push   0x10(%ebx)
80101154:	e8 57 07 00 00       	call   801018b0 <iunlock>
      end_op();
80101159:	e8 e2 1c 00 00       	call   80102e40 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010115e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101161:	83 c4 10             	add    $0x10,%esp
80101164:	39 c7                	cmp    %eax,%edi
80101166:	75 5c                	jne    801011c4 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101168:	01 fe                	add    %edi,%esi
    while(i < n){
8010116a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010116d:	7e 69                	jle    801011d8 <filewrite+0xd8>
      int n1 = n - i;
8010116f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      if(n1 > max)
80101172:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
80101177:	29 f7                	sub    %esi,%edi
      if(n1 > max)
80101179:	39 c7                	cmp    %eax,%edi
8010117b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010117e:	e8 4d 1c 00 00       	call   80102dd0 <begin_op>
      ilock(f->ip);
80101183:	83 ec 0c             	sub    $0xc,%esp
80101186:	ff 73 10             	push   0x10(%ebx)
80101189:	e8 42 06 00 00       	call   801017d0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010118e:	57                   	push   %edi
8010118f:	ff 73 14             	push   0x14(%ebx)
80101192:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101195:	01 f0                	add    %esi,%eax
80101197:	50                   	push   %eax
80101198:	ff 73 10             	push   0x10(%ebx)
8010119b:	e8 40 0a 00 00       	call   80101be0 <writei>
801011a0:	83 c4 20             	add    $0x20,%esp
801011a3:	85 c0                	test   %eax,%eax
801011a5:	7f a1                	jg     80101148 <filewrite+0x48>
801011a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801011aa:	83 ec 0c             	sub    $0xc,%esp
801011ad:	ff 73 10             	push   0x10(%ebx)
801011b0:	e8 fb 06 00 00       	call   801018b0 <iunlock>
      end_op();
801011b5:	e8 86 1c 00 00       	call   80102e40 <end_op>
      if(r < 0)
801011ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011bd:	83 c4 10             	add    $0x10,%esp
801011c0:	85 c0                	test   %eax,%eax
801011c2:	75 14                	jne    801011d8 <filewrite+0xd8>
        panic("short filewrite");
801011c4:	83 ec 0c             	sub    $0xc,%esp
801011c7:	68 af 72 10 80       	push   $0x801072af
801011cc:	e8 af f1 ff ff       	call   80100380 <panic>
801011d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
801011d8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801011db:	74 05                	je     801011e2 <filewrite+0xe2>
    return -1;
801011dd:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
801011e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011e5:	89 f0                	mov    %esi,%eax
801011e7:	5b                   	pop    %ebx
801011e8:	5e                   	pop    %esi
801011e9:	5f                   	pop    %edi
801011ea:	5d                   	pop    %ebp
801011eb:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
801011ec:	8b 43 0c             	mov    0xc(%ebx),%eax
801011ef:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011f5:	5b                   	pop    %ebx
801011f6:	5e                   	pop    %esi
801011f7:	5f                   	pop    %edi
801011f8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011f9:	e9 32 24 00 00       	jmp    80103630 <pipewrite>
  panic("filewrite");
801011fe:	83 ec 0c             	sub    $0xc,%esp
80101201:	68 b5 72 10 80       	push   $0x801072b5
80101206:	e8 75 f1 ff ff       	call   80100380 <panic>
8010120b:	66 90                	xchg   %ax,%ax
8010120d:	66 90                	xchg   %ax,%ax
8010120f:	90                   	nop

80101210 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101210:	55                   	push   %ebp
80101211:	89 e5                	mov    %esp,%ebp
80101213:	57                   	push   %edi
80101214:	56                   	push   %esi
80101215:	53                   	push   %ebx
80101216:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101219:	8b 0d b4 15 11 80    	mov    0x801115b4,%ecx
{
8010121f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101222:	85 c9                	test   %ecx,%ecx
80101224:	0f 84 8c 00 00 00    	je     801012b6 <balloc+0xa6>
8010122a:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
8010122c:	89 f8                	mov    %edi,%eax
8010122e:	83 ec 08             	sub    $0x8,%esp
80101231:	89 fe                	mov    %edi,%esi
80101233:	c1 f8 0c             	sar    $0xc,%eax
80101236:	03 05 cc 15 11 80    	add    0x801115cc,%eax
8010123c:	50                   	push   %eax
8010123d:	ff 75 dc             	push   -0x24(%ebp)
80101240:	e8 8b ee ff ff       	call   801000d0 <bread>
80101245:	89 7d d8             	mov    %edi,-0x28(%ebp)
80101248:	83 c4 10             	add    $0x10,%esp
8010124b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010124e:	a1 b4 15 11 80       	mov    0x801115b4,%eax
80101253:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101256:	31 c0                	xor    %eax,%eax
80101258:	eb 32                	jmp    8010128c <balloc+0x7c>
8010125a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101260:	89 c1                	mov    %eax,%ecx
80101262:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101267:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
8010126a:	83 e1 07             	and    $0x7,%ecx
8010126d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010126f:	89 c1                	mov    %eax,%ecx
80101271:	c1 f9 03             	sar    $0x3,%ecx
80101274:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
80101279:	89 fa                	mov    %edi,%edx
8010127b:	85 df                	test   %ebx,%edi
8010127d:	74 49                	je     801012c8 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010127f:	83 c0 01             	add    $0x1,%eax
80101282:	83 c6 01             	add    $0x1,%esi
80101285:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010128a:	74 07                	je     80101293 <balloc+0x83>
8010128c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010128f:	39 d6                	cmp    %edx,%esi
80101291:	72 cd                	jb     80101260 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101293:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101296:	83 ec 0c             	sub    $0xc,%esp
80101299:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010129c:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
801012a2:	e8 49 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012a7:	83 c4 10             	add    $0x10,%esp
801012aa:	3b 3d b4 15 11 80    	cmp    0x801115b4,%edi
801012b0:	0f 82 76 ff ff ff    	jb     8010122c <balloc+0x1c>
  }
  panic("balloc: out of blocks");
801012b6:	83 ec 0c             	sub    $0xc,%esp
801012b9:	68 bf 72 10 80       	push   $0x801072bf
801012be:	e8 bd f0 ff ff       	call   80100380 <panic>
801012c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801012c7:	90                   	nop
        bp->data[bi/8] |= m;  // Mark block in use.
801012c8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012cb:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012ce:	09 da                	or     %ebx,%edx
801012d0:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012d4:	57                   	push   %edi
801012d5:	e8 d6 1c 00 00       	call   80102fb0 <log_write>
        brelse(bp);
801012da:	89 3c 24             	mov    %edi,(%esp)
801012dd:	e8 0e ef ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801012e2:	58                   	pop    %eax
801012e3:	5a                   	pop    %edx
801012e4:	56                   	push   %esi
801012e5:	ff 75 dc             	push   -0x24(%ebp)
801012e8:	e8 e3 ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801012ed:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801012f0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801012f2:	8d 40 5c             	lea    0x5c(%eax),%eax
801012f5:	68 00 02 00 00       	push   $0x200
801012fa:	6a 00                	push   $0x0
801012fc:	50                   	push   %eax
801012fd:	e8 fe 33 00 00       	call   80104700 <memset>
  log_write(bp);
80101302:	89 1c 24             	mov    %ebx,(%esp)
80101305:	e8 a6 1c 00 00       	call   80102fb0 <log_write>
  brelse(bp);
8010130a:	89 1c 24             	mov    %ebx,(%esp)
8010130d:	e8 de ee ff ff       	call   801001f0 <brelse>
}
80101312:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101315:	89 f0                	mov    %esi,%eax
80101317:	5b                   	pop    %ebx
80101318:	5e                   	pop    %esi
80101319:	5f                   	pop    %edi
8010131a:	5d                   	pop    %ebp
8010131b:	c3                   	ret
8010131c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101320 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101320:	55                   	push   %ebp
80101321:	89 e5                	mov    %esp,%ebp
80101323:	57                   	push   %edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101324:	31 ff                	xor    %edi,%edi
{
80101326:	56                   	push   %esi
80101327:	89 c6                	mov    %eax,%esi
80101329:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010132a:	bb 94 f9 10 80       	mov    $0x8010f994,%ebx
{
8010132f:	83 ec 28             	sub    $0x28,%esp
80101332:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101335:	68 60 f9 10 80       	push   $0x8010f960
8010133a:	e8 e1 32 00 00       	call   80104620 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010133f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101342:	83 c4 10             	add    $0x10,%esp
80101345:	eb 1b                	jmp    80101362 <iget+0x42>
80101347:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101350:	39 33                	cmp    %esi,(%ebx)
80101352:	74 6c                	je     801013c0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101354:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010135a:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101360:	74 26                	je     80101388 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101362:	8b 43 08             	mov    0x8(%ebx),%eax
80101365:	85 c0                	test   %eax,%eax
80101367:	7f e7                	jg     80101350 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101369:	85 ff                	test   %edi,%edi
8010136b:	75 e7                	jne    80101354 <iget+0x34>
8010136d:	85 c0                	test   %eax,%eax
8010136f:	75 76                	jne    801013e7 <iget+0xc7>
80101371:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101373:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101379:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
8010137f:	75 e1                	jne    80101362 <iget+0x42>
80101381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101388:	85 ff                	test   %edi,%edi
8010138a:	74 79                	je     80101405 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010138c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010138f:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
80101391:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
80101394:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
8010139b:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
801013a2:	68 60 f9 10 80       	push   $0x8010f960
801013a7:	e8 14 32 00 00       	call   801045c0 <release>

  return ip;
801013ac:	83 c4 10             	add    $0x10,%esp
}
801013af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013b2:	89 f8                	mov    %edi,%eax
801013b4:	5b                   	pop    %ebx
801013b5:	5e                   	pop    %esi
801013b6:	5f                   	pop    %edi
801013b7:	5d                   	pop    %ebp
801013b8:	c3                   	ret
801013b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013c0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013c3:	75 8f                	jne    80101354 <iget+0x34>
      ip->ref++;
801013c5:	83 c0 01             	add    $0x1,%eax
      release(&icache.lock);
801013c8:	83 ec 0c             	sub    $0xc,%esp
      return ip;
801013cb:	89 df                	mov    %ebx,%edi
      ip->ref++;
801013cd:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801013d0:	68 60 f9 10 80       	push   $0x8010f960
801013d5:	e8 e6 31 00 00       	call   801045c0 <release>
      return ip;
801013da:	83 c4 10             	add    $0x10,%esp
}
801013dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e0:	89 f8                	mov    %edi,%eax
801013e2:	5b                   	pop    %ebx
801013e3:	5e                   	pop    %esi
801013e4:	5f                   	pop    %edi
801013e5:	5d                   	pop    %ebp
801013e6:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013e7:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013ed:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
801013f3:	74 10                	je     80101405 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f5:	8b 43 08             	mov    0x8(%ebx),%eax
801013f8:	85 c0                	test   %eax,%eax
801013fa:	0f 8f 50 ff ff ff    	jg     80101350 <iget+0x30>
80101400:	e9 68 ff ff ff       	jmp    8010136d <iget+0x4d>
    panic("iget: no inodes");
80101405:	83 ec 0c             	sub    $0xc,%esp
80101408:	68 d5 72 10 80       	push   $0x801072d5
8010140d:	e8 6e ef ff ff       	call   80100380 <panic>
80101412:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101420 <bfree>:
{
80101420:	55                   	push   %ebp
80101421:	89 c1                	mov    %eax,%ecx
  bp = bread(dev, BBLOCK(b, sb));
80101423:	89 d0                	mov    %edx,%eax
80101425:	c1 e8 0c             	shr    $0xc,%eax
{
80101428:	89 e5                	mov    %esp,%ebp
8010142a:	56                   	push   %esi
8010142b:	53                   	push   %ebx
  bp = bread(dev, BBLOCK(b, sb));
8010142c:	03 05 cc 15 11 80    	add    0x801115cc,%eax
{
80101432:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101434:	83 ec 08             	sub    $0x8,%esp
80101437:	50                   	push   %eax
80101438:	51                   	push   %ecx
80101439:	e8 92 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010143e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101440:	c1 fb 03             	sar    $0x3,%ebx
80101443:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101446:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101448:	83 e1 07             	and    $0x7,%ecx
8010144b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101450:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101456:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101458:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010145d:	85 c1                	test   %eax,%ecx
8010145f:	74 23                	je     80101484 <bfree+0x64>
  bp->data[bi/8] &= ~m;
80101461:	f7 d0                	not    %eax
  log_write(bp);
80101463:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101466:	21 c8                	and    %ecx,%eax
80101468:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010146c:	56                   	push   %esi
8010146d:	e8 3e 1b 00 00       	call   80102fb0 <log_write>
  brelse(bp);
80101472:	89 34 24             	mov    %esi,(%esp)
80101475:	e8 76 ed ff ff       	call   801001f0 <brelse>
}
8010147a:	83 c4 10             	add    $0x10,%esp
8010147d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101480:	5b                   	pop    %ebx
80101481:	5e                   	pop    %esi
80101482:	5d                   	pop    %ebp
80101483:	c3                   	ret
    panic("freeing free block");
80101484:	83 ec 0c             	sub    $0xc,%esp
80101487:	68 e5 72 10 80       	push   $0x801072e5
8010148c:	e8 ef ee ff ff       	call   80100380 <panic>
80101491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101498:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010149f:	90                   	nop

801014a0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801014a0:	55                   	push   %ebp
801014a1:	89 e5                	mov    %esp,%ebp
801014a3:	57                   	push   %edi
801014a4:	56                   	push   %esi
801014a5:	89 c6                	mov    %eax,%esi
801014a7:	53                   	push   %ebx
801014a8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801014ab:	83 fa 0b             	cmp    $0xb,%edx
801014ae:	0f 86 8c 00 00 00    	jbe    80101540 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801014b4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801014b7:	83 fb 7f             	cmp    $0x7f,%ebx
801014ba:	0f 87 a2 00 00 00    	ja     80101562 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801014c0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801014c6:	85 c0                	test   %eax,%eax
801014c8:	74 5e                	je     80101528 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801014ca:	83 ec 08             	sub    $0x8,%esp
801014cd:	50                   	push   %eax
801014ce:	ff 36                	push   (%esi)
801014d0:	e8 fb eb ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801014d5:	83 c4 10             	add    $0x10,%esp
801014d8:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
801014dc:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
801014de:	8b 3b                	mov    (%ebx),%edi
801014e0:	85 ff                	test   %edi,%edi
801014e2:	74 1c                	je     80101500 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801014e4:	83 ec 0c             	sub    $0xc,%esp
801014e7:	52                   	push   %edx
801014e8:	e8 03 ed ff ff       	call   801001f0 <brelse>
801014ed:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014f3:	89 f8                	mov    %edi,%eax
801014f5:	5b                   	pop    %ebx
801014f6:	5e                   	pop    %esi
801014f7:	5f                   	pop    %edi
801014f8:	5d                   	pop    %ebp
801014f9:	c3                   	ret
801014fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101500:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101503:	8b 06                	mov    (%esi),%eax
80101505:	e8 06 fd ff ff       	call   80101210 <balloc>
      log_write(bp);
8010150a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010150d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101510:	89 03                	mov    %eax,(%ebx)
80101512:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101514:	52                   	push   %edx
80101515:	e8 96 1a 00 00       	call   80102fb0 <log_write>
8010151a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010151d:	83 c4 10             	add    $0x10,%esp
80101520:	eb c2                	jmp    801014e4 <bmap+0x44>
80101522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101528:	8b 06                	mov    (%esi),%eax
8010152a:	e8 e1 fc ff ff       	call   80101210 <balloc>
8010152f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101535:	eb 93                	jmp    801014ca <bmap+0x2a>
80101537:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010153e:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
80101540:	8d 5a 14             	lea    0x14(%edx),%ebx
80101543:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101547:	85 ff                	test   %edi,%edi
80101549:	75 a5                	jne    801014f0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010154b:	8b 00                	mov    (%eax),%eax
8010154d:	e8 be fc ff ff       	call   80101210 <balloc>
80101552:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101556:	89 c7                	mov    %eax,%edi
}
80101558:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010155b:	5b                   	pop    %ebx
8010155c:	89 f8                	mov    %edi,%eax
8010155e:	5e                   	pop    %esi
8010155f:	5f                   	pop    %edi
80101560:	5d                   	pop    %ebp
80101561:	c3                   	ret
  panic("bmap: out of range");
80101562:	83 ec 0c             	sub    $0xc,%esp
80101565:	68 f8 72 10 80       	push   $0x801072f8
8010156a:	e8 11 ee ff ff       	call   80100380 <panic>
8010156f:	90                   	nop

80101570 <readsb>:
{
80101570:	55                   	push   %ebp
80101571:	89 e5                	mov    %esp,%ebp
80101573:	56                   	push   %esi
80101574:	53                   	push   %ebx
80101575:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101578:	83 ec 08             	sub    $0x8,%esp
8010157b:	6a 01                	push   $0x1
8010157d:	ff 75 08             	push   0x8(%ebp)
80101580:	e8 4b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101585:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101588:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010158a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010158d:	6a 1c                	push   $0x1c
8010158f:	50                   	push   %eax
80101590:	56                   	push   %esi
80101591:	e8 fa 31 00 00       	call   80104790 <memmove>
  brelse(bp);
80101596:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101599:	83 c4 10             	add    $0x10,%esp
}
8010159c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010159f:	5b                   	pop    %ebx
801015a0:	5e                   	pop    %esi
801015a1:	5d                   	pop    %ebp
  brelse(bp);
801015a2:	e9 49 ec ff ff       	jmp    801001f0 <brelse>
801015a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015ae:	66 90                	xchg   %ax,%ax

801015b0 <iinit>:
{
801015b0:	55                   	push   %ebp
801015b1:	89 e5                	mov    %esp,%ebp
801015b3:	53                   	push   %ebx
801015b4:	bb a0 f9 10 80       	mov    $0x8010f9a0,%ebx
801015b9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801015bc:	68 0b 73 10 80       	push   $0x8010730b
801015c1:	68 60 f9 10 80       	push   $0x8010f960
801015c6:	e8 75 2e 00 00       	call   80104440 <initlock>
  for(i = 0; i < NINODE; i++) {
801015cb:	83 c4 10             	add    $0x10,%esp
801015ce:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801015d0:	83 ec 08             	sub    $0x8,%esp
801015d3:	68 12 73 10 80       	push   $0x80107312
801015d8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
801015d9:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801015df:	e8 2c 2d 00 00       	call   80104310 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015e4:	83 c4 10             	add    $0x10,%esp
801015e7:	81 fb c0 15 11 80    	cmp    $0x801115c0,%ebx
801015ed:	75 e1                	jne    801015d0 <iinit+0x20>
  bp = bread(dev, 1);
801015ef:	83 ec 08             	sub    $0x8,%esp
801015f2:	6a 01                	push   $0x1
801015f4:	ff 75 08             	push   0x8(%ebp)
801015f7:	e8 d4 ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015fc:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015ff:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101601:	8d 40 5c             	lea    0x5c(%eax),%eax
80101604:	6a 1c                	push   $0x1c
80101606:	50                   	push   %eax
80101607:	68 b4 15 11 80       	push   $0x801115b4
8010160c:	e8 7f 31 00 00       	call   80104790 <memmove>
  brelse(bp);
80101611:	89 1c 24             	mov    %ebx,(%esp)
80101614:	e8 d7 eb ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101619:	ff 35 cc 15 11 80    	push   0x801115cc
8010161f:	ff 35 c8 15 11 80    	push   0x801115c8
80101625:	ff 35 c4 15 11 80    	push   0x801115c4
8010162b:	ff 35 c0 15 11 80    	push   0x801115c0
80101631:	ff 35 bc 15 11 80    	push   0x801115bc
80101637:	ff 35 b8 15 11 80    	push   0x801115b8
8010163d:	ff 35 b4 15 11 80    	push   0x801115b4
80101643:	68 78 73 10 80       	push   $0x80107378
80101648:	e8 63 f0 ff ff       	call   801006b0 <cprintf>
}
8010164d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101650:	83 c4 30             	add    $0x30,%esp
80101653:	c9                   	leave
80101654:	c3                   	ret
80101655:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010165c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101660 <ialloc>:
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	57                   	push   %edi
80101664:	56                   	push   %esi
80101665:	53                   	push   %ebx
80101666:	83 ec 1c             	sub    $0x1c,%esp
80101669:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010166c:	83 3d bc 15 11 80 01 	cmpl   $0x1,0x801115bc
{
80101673:	8b 75 08             	mov    0x8(%ebp),%esi
80101676:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101679:	0f 86 91 00 00 00    	jbe    80101710 <ialloc+0xb0>
8010167f:	bf 01 00 00 00       	mov    $0x1,%edi
80101684:	eb 21                	jmp    801016a7 <ialloc+0x47>
80101686:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010168d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101690:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101693:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101696:	53                   	push   %ebx
80101697:	e8 54 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010169c:	83 c4 10             	add    $0x10,%esp
8010169f:	3b 3d bc 15 11 80    	cmp    0x801115bc,%edi
801016a5:	73 69                	jae    80101710 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801016a7:	89 f8                	mov    %edi,%eax
801016a9:	83 ec 08             	sub    $0x8,%esp
801016ac:	c1 e8 03             	shr    $0x3,%eax
801016af:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801016b5:	50                   	push   %eax
801016b6:	56                   	push   %esi
801016b7:	e8 14 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
801016bc:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
801016bf:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
801016c1:	89 f8                	mov    %edi,%eax
801016c3:	83 e0 07             	and    $0x7,%eax
801016c6:	c1 e0 06             	shl    $0x6,%eax
801016c9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801016cd:	66 83 39 00          	cmpw   $0x0,(%ecx)
801016d1:	75 bd                	jne    80101690 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801016d3:	83 ec 04             	sub    $0x4,%esp
801016d6:	6a 40                	push   $0x40
801016d8:	6a 00                	push   $0x0
801016da:	51                   	push   %ecx
801016db:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016de:	e8 1d 30 00 00       	call   80104700 <memset>
      dip->type = type;
801016e3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016e7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016ea:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016ed:	89 1c 24             	mov    %ebx,(%esp)
801016f0:	e8 bb 18 00 00       	call   80102fb0 <log_write>
      brelse(bp);
801016f5:	89 1c 24             	mov    %ebx,(%esp)
801016f8:	e8 f3 ea ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016fd:	83 c4 10             	add    $0x10,%esp
}
80101700:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101703:	89 fa                	mov    %edi,%edx
}
80101705:	5b                   	pop    %ebx
      return iget(dev, inum);
80101706:	89 f0                	mov    %esi,%eax
}
80101708:	5e                   	pop    %esi
80101709:	5f                   	pop    %edi
8010170a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010170b:	e9 10 fc ff ff       	jmp    80101320 <iget>
  panic("ialloc: no inodes");
80101710:	83 ec 0c             	sub    $0xc,%esp
80101713:	68 18 73 10 80       	push   $0x80107318
80101718:	e8 63 ec ff ff       	call   80100380 <panic>
8010171d:	8d 76 00             	lea    0x0(%esi),%esi

80101720 <iupdate>:
{
80101720:	55                   	push   %ebp
80101721:	89 e5                	mov    %esp,%ebp
80101723:	56                   	push   %esi
80101724:	53                   	push   %ebx
80101725:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101728:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010172b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010172e:	83 ec 08             	sub    $0x8,%esp
80101731:	c1 e8 03             	shr    $0x3,%eax
80101734:	03 05 c8 15 11 80    	add    0x801115c8,%eax
8010173a:	50                   	push   %eax
8010173b:	ff 73 a4             	push   -0x5c(%ebx)
8010173e:	e8 8d e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101743:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101747:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010174a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010174c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010174f:	83 e0 07             	and    $0x7,%eax
80101752:	c1 e0 06             	shl    $0x6,%eax
80101755:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101759:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010175c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101760:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101763:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101767:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010176b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010176f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101773:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101777:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010177a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010177d:	6a 34                	push   $0x34
8010177f:	53                   	push   %ebx
80101780:	50                   	push   %eax
80101781:	e8 0a 30 00 00       	call   80104790 <memmove>
  log_write(bp);
80101786:	89 34 24             	mov    %esi,(%esp)
80101789:	e8 22 18 00 00       	call   80102fb0 <log_write>
  brelse(bp);
8010178e:	89 75 08             	mov    %esi,0x8(%ebp)
80101791:	83 c4 10             	add    $0x10,%esp
}
80101794:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101797:	5b                   	pop    %ebx
80101798:	5e                   	pop    %esi
80101799:	5d                   	pop    %ebp
  brelse(bp);
8010179a:	e9 51 ea ff ff       	jmp    801001f0 <brelse>
8010179f:	90                   	nop

801017a0 <idup>:
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	53                   	push   %ebx
801017a4:	83 ec 10             	sub    $0x10,%esp
801017a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801017aa:	68 60 f9 10 80       	push   $0x8010f960
801017af:	e8 6c 2e 00 00       	call   80104620 <acquire>
  ip->ref++;
801017b4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017b8:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
801017bf:	e8 fc 2d 00 00       	call   801045c0 <release>
}
801017c4:	89 d8                	mov    %ebx,%eax
801017c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017c9:	c9                   	leave
801017ca:	c3                   	ret
801017cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801017cf:	90                   	nop

801017d0 <ilock>:
{
801017d0:	55                   	push   %ebp
801017d1:	89 e5                	mov    %esp,%ebp
801017d3:	56                   	push   %esi
801017d4:	53                   	push   %ebx
801017d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801017d8:	85 db                	test   %ebx,%ebx
801017da:	0f 84 b7 00 00 00    	je     80101897 <ilock+0xc7>
801017e0:	8b 53 08             	mov    0x8(%ebx),%edx
801017e3:	85 d2                	test   %edx,%edx
801017e5:	0f 8e ac 00 00 00    	jle    80101897 <ilock+0xc7>
  acquiresleep(&ip->lock);
801017eb:	83 ec 0c             	sub    $0xc,%esp
801017ee:	8d 43 0c             	lea    0xc(%ebx),%eax
801017f1:	50                   	push   %eax
801017f2:	e8 59 2b 00 00       	call   80104350 <acquiresleep>
  if(ip->valid == 0){
801017f7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017fa:	83 c4 10             	add    $0x10,%esp
801017fd:	85 c0                	test   %eax,%eax
801017ff:	74 0f                	je     80101810 <ilock+0x40>
}
80101801:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101804:	5b                   	pop    %ebx
80101805:	5e                   	pop    %esi
80101806:	5d                   	pop    %ebp
80101807:	c3                   	ret
80101808:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010180f:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101810:	8b 43 04             	mov    0x4(%ebx),%eax
80101813:	83 ec 08             	sub    $0x8,%esp
80101816:	c1 e8 03             	shr    $0x3,%eax
80101819:	03 05 c8 15 11 80    	add    0x801115c8,%eax
8010181f:	50                   	push   %eax
80101820:	ff 33                	push   (%ebx)
80101822:	e8 a9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101827:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010182a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010182c:	8b 43 04             	mov    0x4(%ebx),%eax
8010182f:	83 e0 07             	and    $0x7,%eax
80101832:	c1 e0 06             	shl    $0x6,%eax
80101835:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101839:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010183c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010183f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101843:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101847:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010184b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010184f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101853:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101857:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010185b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010185e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101861:	6a 34                	push   $0x34
80101863:	50                   	push   %eax
80101864:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101867:	50                   	push   %eax
80101868:	e8 23 2f 00 00       	call   80104790 <memmove>
    brelse(bp);
8010186d:	89 34 24             	mov    %esi,(%esp)
80101870:	e8 7b e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101875:	83 c4 10             	add    $0x10,%esp
80101878:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010187d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101884:	0f 85 77 ff ff ff    	jne    80101801 <ilock+0x31>
      panic("ilock: no type");
8010188a:	83 ec 0c             	sub    $0xc,%esp
8010188d:	68 30 73 10 80       	push   $0x80107330
80101892:	e8 e9 ea ff ff       	call   80100380 <panic>
    panic("ilock");
80101897:	83 ec 0c             	sub    $0xc,%esp
8010189a:	68 2a 73 10 80       	push   $0x8010732a
8010189f:	e8 dc ea ff ff       	call   80100380 <panic>
801018a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018af:	90                   	nop

801018b0 <iunlock>:
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	56                   	push   %esi
801018b4:	53                   	push   %ebx
801018b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801018b8:	85 db                	test   %ebx,%ebx
801018ba:	74 28                	je     801018e4 <iunlock+0x34>
801018bc:	83 ec 0c             	sub    $0xc,%esp
801018bf:	8d 73 0c             	lea    0xc(%ebx),%esi
801018c2:	56                   	push   %esi
801018c3:	e8 28 2b 00 00       	call   801043f0 <holdingsleep>
801018c8:	83 c4 10             	add    $0x10,%esp
801018cb:	85 c0                	test   %eax,%eax
801018cd:	74 15                	je     801018e4 <iunlock+0x34>
801018cf:	8b 43 08             	mov    0x8(%ebx),%eax
801018d2:	85 c0                	test   %eax,%eax
801018d4:	7e 0e                	jle    801018e4 <iunlock+0x34>
  releasesleep(&ip->lock);
801018d6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801018d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018dc:	5b                   	pop    %ebx
801018dd:	5e                   	pop    %esi
801018de:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801018df:	e9 cc 2a 00 00       	jmp    801043b0 <releasesleep>
    panic("iunlock");
801018e4:	83 ec 0c             	sub    $0xc,%esp
801018e7:	68 3f 73 10 80       	push   $0x8010733f
801018ec:	e8 8f ea ff ff       	call   80100380 <panic>
801018f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018ff:	90                   	nop

80101900 <iput>:
{
80101900:	55                   	push   %ebp
80101901:	89 e5                	mov    %esp,%ebp
80101903:	57                   	push   %edi
80101904:	56                   	push   %esi
80101905:	53                   	push   %ebx
80101906:	83 ec 28             	sub    $0x28,%esp
80101909:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010190c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010190f:	57                   	push   %edi
80101910:	e8 3b 2a 00 00       	call   80104350 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101915:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101918:	83 c4 10             	add    $0x10,%esp
8010191b:	85 d2                	test   %edx,%edx
8010191d:	74 07                	je     80101926 <iput+0x26>
8010191f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101924:	74 32                	je     80101958 <iput+0x58>
  releasesleep(&ip->lock);
80101926:	83 ec 0c             	sub    $0xc,%esp
80101929:	57                   	push   %edi
8010192a:	e8 81 2a 00 00       	call   801043b0 <releasesleep>
  acquire(&icache.lock);
8010192f:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101936:	e8 e5 2c 00 00       	call   80104620 <acquire>
  ip->ref--;
8010193b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010193f:	83 c4 10             	add    $0x10,%esp
80101942:	c7 45 08 60 f9 10 80 	movl   $0x8010f960,0x8(%ebp)
}
80101949:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010194c:	5b                   	pop    %ebx
8010194d:	5e                   	pop    %esi
8010194e:	5f                   	pop    %edi
8010194f:	5d                   	pop    %ebp
  release(&icache.lock);
80101950:	e9 6b 2c 00 00       	jmp    801045c0 <release>
80101955:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101958:	83 ec 0c             	sub    $0xc,%esp
8010195b:	68 60 f9 10 80       	push   $0x8010f960
80101960:	e8 bb 2c 00 00       	call   80104620 <acquire>
    int r = ip->ref;
80101965:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101968:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010196f:	e8 4c 2c 00 00       	call   801045c0 <release>
    if(r == 1){
80101974:	83 c4 10             	add    $0x10,%esp
80101977:	83 fe 01             	cmp    $0x1,%esi
8010197a:	75 aa                	jne    80101926 <iput+0x26>
8010197c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101982:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101985:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101988:	89 df                	mov    %ebx,%edi
8010198a:	89 cb                	mov    %ecx,%ebx
8010198c:	eb 09                	jmp    80101997 <iput+0x97>
8010198e:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101990:	83 c6 04             	add    $0x4,%esi
80101993:	39 de                	cmp    %ebx,%esi
80101995:	74 19                	je     801019b0 <iput+0xb0>
    if(ip->addrs[i]){
80101997:	8b 16                	mov    (%esi),%edx
80101999:	85 d2                	test   %edx,%edx
8010199b:	74 f3                	je     80101990 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010199d:	8b 07                	mov    (%edi),%eax
8010199f:	e8 7c fa ff ff       	call   80101420 <bfree>
      ip->addrs[i] = 0;
801019a4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801019aa:	eb e4                	jmp    80101990 <iput+0x90>
801019ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801019b0:	89 fb                	mov    %edi,%ebx
801019b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019b5:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801019bb:	85 c0                	test   %eax,%eax
801019bd:	75 2d                	jne    801019ec <iput+0xec>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801019bf:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801019c2:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801019c9:	53                   	push   %ebx
801019ca:	e8 51 fd ff ff       	call   80101720 <iupdate>
      ip->type = 0;
801019cf:	31 c0                	xor    %eax,%eax
801019d1:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801019d5:	89 1c 24             	mov    %ebx,(%esp)
801019d8:	e8 43 fd ff ff       	call   80101720 <iupdate>
      ip->valid = 0;
801019dd:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801019e4:	83 c4 10             	add    $0x10,%esp
801019e7:	e9 3a ff ff ff       	jmp    80101926 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801019ec:	83 ec 08             	sub    $0x8,%esp
801019ef:	50                   	push   %eax
801019f0:	ff 33                	push   (%ebx)
801019f2:	e8 d9 e6 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
801019f7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801019fa:	83 c4 10             	add    $0x10,%esp
801019fd:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101a03:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101a06:	8d 70 5c             	lea    0x5c(%eax),%esi
80101a09:	89 cf                	mov    %ecx,%edi
80101a0b:	eb 0a                	jmp    80101a17 <iput+0x117>
80101a0d:	8d 76 00             	lea    0x0(%esi),%esi
80101a10:	83 c6 04             	add    $0x4,%esi
80101a13:	39 fe                	cmp    %edi,%esi
80101a15:	74 0f                	je     80101a26 <iput+0x126>
      if(a[j])
80101a17:	8b 16                	mov    (%esi),%edx
80101a19:	85 d2                	test   %edx,%edx
80101a1b:	74 f3                	je     80101a10 <iput+0x110>
        bfree(ip->dev, a[j]);
80101a1d:	8b 03                	mov    (%ebx),%eax
80101a1f:	e8 fc f9 ff ff       	call   80101420 <bfree>
80101a24:	eb ea                	jmp    80101a10 <iput+0x110>
    brelse(bp);
80101a26:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101a29:	83 ec 0c             	sub    $0xc,%esp
80101a2c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a2f:	50                   	push   %eax
80101a30:	e8 bb e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a35:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a3b:	8b 03                	mov    (%ebx),%eax
80101a3d:	e8 de f9 ff ff       	call   80101420 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a42:	83 c4 10             	add    $0x10,%esp
80101a45:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a4c:	00 00 00 
80101a4f:	e9 6b ff ff ff       	jmp    801019bf <iput+0xbf>
80101a54:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a5f:	90                   	nop

80101a60 <iunlockput>:
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	56                   	push   %esi
80101a64:	53                   	push   %ebx
80101a65:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a68:	85 db                	test   %ebx,%ebx
80101a6a:	74 34                	je     80101aa0 <iunlockput+0x40>
80101a6c:	83 ec 0c             	sub    $0xc,%esp
80101a6f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a72:	56                   	push   %esi
80101a73:	e8 78 29 00 00       	call   801043f0 <holdingsleep>
80101a78:	83 c4 10             	add    $0x10,%esp
80101a7b:	85 c0                	test   %eax,%eax
80101a7d:	74 21                	je     80101aa0 <iunlockput+0x40>
80101a7f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a82:	85 c0                	test   %eax,%eax
80101a84:	7e 1a                	jle    80101aa0 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a86:	83 ec 0c             	sub    $0xc,%esp
80101a89:	56                   	push   %esi
80101a8a:	e8 21 29 00 00       	call   801043b0 <releasesleep>
  iput(ip);
80101a8f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a92:	83 c4 10             	add    $0x10,%esp
}
80101a95:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a98:	5b                   	pop    %ebx
80101a99:	5e                   	pop    %esi
80101a9a:	5d                   	pop    %ebp
  iput(ip);
80101a9b:	e9 60 fe ff ff       	jmp    80101900 <iput>
    panic("iunlock");
80101aa0:	83 ec 0c             	sub    $0xc,%esp
80101aa3:	68 3f 73 10 80       	push   $0x8010733f
80101aa8:	e8 d3 e8 ff ff       	call   80100380 <panic>
80101aad:	8d 76 00             	lea    0x0(%esi),%esi

80101ab0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101ab0:	55                   	push   %ebp
80101ab1:	89 e5                	mov    %esp,%ebp
80101ab3:	8b 55 08             	mov    0x8(%ebp),%edx
80101ab6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101ab9:	8b 0a                	mov    (%edx),%ecx
80101abb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101abe:	8b 4a 04             	mov    0x4(%edx),%ecx
80101ac1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101ac4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101ac8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101acb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101acf:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101ad3:	8b 52 58             	mov    0x58(%edx),%edx
80101ad6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101ad9:	5d                   	pop    %ebp
80101ada:	c3                   	ret
80101adb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101adf:	90                   	nop

80101ae0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ae0:	55                   	push   %ebp
80101ae1:	89 e5                	mov    %esp,%ebp
80101ae3:	57                   	push   %edi
80101ae4:	56                   	push   %esi
80101ae5:	53                   	push   %ebx
80101ae6:	83 ec 1c             	sub    $0x1c,%esp
80101ae9:	8b 75 08             	mov    0x8(%ebp),%esi
80101aec:	8b 45 0c             	mov    0xc(%ebp),%eax
80101aef:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101af2:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
{
80101af7:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101afa:	89 75 d8             	mov    %esi,-0x28(%ebp)
80101afd:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
80101b00:	0f 84 aa 00 00 00    	je     80101bb0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101b06:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101b09:	8b 56 58             	mov    0x58(%esi),%edx
80101b0c:	39 fa                	cmp    %edi,%edx
80101b0e:	0f 82 bd 00 00 00    	jb     80101bd1 <readi+0xf1>
80101b14:	89 f9                	mov    %edi,%ecx
80101b16:	31 db                	xor    %ebx,%ebx
80101b18:	01 c1                	add    %eax,%ecx
80101b1a:	0f 92 c3             	setb   %bl
80101b1d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101b20:	0f 82 ab 00 00 00    	jb     80101bd1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101b26:	89 d3                	mov    %edx,%ebx
80101b28:	29 fb                	sub    %edi,%ebx
80101b2a:	39 ca                	cmp    %ecx,%edx
80101b2c:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b2f:	85 c0                	test   %eax,%eax
80101b31:	74 73                	je     80101ba6 <readi+0xc6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101b33:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101b36:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b40:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b43:	89 fa                	mov    %edi,%edx
80101b45:	c1 ea 09             	shr    $0x9,%edx
80101b48:	89 d8                	mov    %ebx,%eax
80101b4a:	e8 51 f9 ff ff       	call   801014a0 <bmap>
80101b4f:	83 ec 08             	sub    $0x8,%esp
80101b52:	50                   	push   %eax
80101b53:	ff 33                	push   (%ebx)
80101b55:	e8 76 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b5a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b5d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b62:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b64:	89 f8                	mov    %edi,%eax
80101b66:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b6b:	29 f3                	sub    %esi,%ebx
80101b6d:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b6f:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b73:	39 d9                	cmp    %ebx,%ecx
80101b75:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b78:	83 c4 0c             	add    $0xc,%esp
80101b7b:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b7c:	01 de                	add    %ebx,%esi
80101b7e:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101b80:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101b83:	50                   	push   %eax
80101b84:	ff 75 e0             	push   -0x20(%ebp)
80101b87:	e8 04 2c 00 00       	call   80104790 <memmove>
    brelse(bp);
80101b8c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b8f:	89 14 24             	mov    %edx,(%esp)
80101b92:	e8 59 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b97:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b9a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b9d:	83 c4 10             	add    $0x10,%esp
80101ba0:	39 de                	cmp    %ebx,%esi
80101ba2:	72 9c                	jb     80101b40 <readi+0x60>
80101ba4:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80101ba6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ba9:	5b                   	pop    %ebx
80101baa:	5e                   	pop    %esi
80101bab:	5f                   	pop    %edi
80101bac:	5d                   	pop    %ebp
80101bad:	c3                   	ret
80101bae:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101bb0:	0f bf 56 52          	movswl 0x52(%esi),%edx
80101bb4:	66 83 fa 09          	cmp    $0x9,%dx
80101bb8:	77 17                	ja     80101bd1 <readi+0xf1>
80101bba:	8b 14 d5 00 f9 10 80 	mov    -0x7fef0700(,%edx,8),%edx
80101bc1:	85 d2                	test   %edx,%edx
80101bc3:	74 0c                	je     80101bd1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101bc5:	89 45 10             	mov    %eax,0x10(%ebp)
}
80101bc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bcb:	5b                   	pop    %ebx
80101bcc:	5e                   	pop    %esi
80101bcd:	5f                   	pop    %edi
80101bce:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101bcf:	ff e2                	jmp    *%edx
      return -1;
80101bd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101bd6:	eb ce                	jmp    80101ba6 <readi+0xc6>
80101bd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bdf:	90                   	nop

80101be0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101be0:	55                   	push   %ebp
80101be1:	89 e5                	mov    %esp,%ebp
80101be3:	57                   	push   %edi
80101be4:	56                   	push   %esi
80101be5:	53                   	push   %ebx
80101be6:	83 ec 1c             	sub    $0x1c,%esp
80101be9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bec:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101bef:	8b 75 14             	mov    0x14(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bf2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bf7:	89 7d dc             	mov    %edi,-0x24(%ebp)
80101bfa:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101bfd:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
80101c00:	0f 84 ca 00 00 00    	je     80101cd0 <writei+0xf0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101c06:	39 78 58             	cmp    %edi,0x58(%eax)
80101c09:	0f 82 fa 00 00 00    	jb     80101d09 <writei+0x129>
80101c0f:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101c12:	31 c9                	xor    %ecx,%ecx
80101c14:	89 f2                	mov    %esi,%edx
80101c16:	01 fa                	add    %edi,%edx
80101c18:	0f 92 c1             	setb   %cl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101c1b:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
80101c21:	0f 87 e2 00 00 00    	ja     80101d09 <writei+0x129>
80101c27:	85 c9                	test   %ecx,%ecx
80101c29:	0f 85 da 00 00 00    	jne    80101d09 <writei+0x129>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c2f:	85 f6                	test   %esi,%esi
80101c31:	0f 84 86 00 00 00    	je     80101cbd <writei+0xdd>
80101c37:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101c3e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c48:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101c4b:	89 fa                	mov    %edi,%edx
80101c4d:	c1 ea 09             	shr    $0x9,%edx
80101c50:	89 f0                	mov    %esi,%eax
80101c52:	e8 49 f8 ff ff       	call   801014a0 <bmap>
80101c57:	83 ec 08             	sub    $0x8,%esp
80101c5a:	50                   	push   %eax
80101c5b:	ff 36                	push   (%esi)
80101c5d:	e8 6e e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c62:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101c65:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c68:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c6d:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c6f:	89 f8                	mov    %edi,%eax
80101c71:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c76:	29 d3                	sub    %edx,%ebx
80101c78:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c7a:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c7e:	39 d9                	cmp    %ebx,%ecx
80101c80:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c83:	83 c4 0c             	add    $0xc,%esp
80101c86:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c87:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80101c89:	ff 75 dc             	push   -0x24(%ebp)
80101c8c:	50                   	push   %eax
80101c8d:	e8 fe 2a 00 00       	call   80104790 <memmove>
    log_write(bp);
80101c92:	89 34 24             	mov    %esi,(%esp)
80101c95:	e8 16 13 00 00       	call   80102fb0 <log_write>
    brelse(bp);
80101c9a:	89 34 24             	mov    %esi,(%esp)
80101c9d:	e8 4e e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ca2:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101ca5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101ca8:	83 c4 10             	add    $0x10,%esp
80101cab:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101cae:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101cb1:	39 d8                	cmp    %ebx,%eax
80101cb3:	72 93                	jb     80101c48 <writei+0x68>
  }

  if(n > 0 && off > ip->size){
80101cb5:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101cb8:	39 78 58             	cmp    %edi,0x58(%eax)
80101cbb:	72 3b                	jb     80101cf8 <writei+0x118>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101cbd:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101cc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cc3:	5b                   	pop    %ebx
80101cc4:	5e                   	pop    %esi
80101cc5:	5f                   	pop    %edi
80101cc6:	5d                   	pop    %ebp
80101cc7:	c3                   	ret
80101cc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ccf:	90                   	nop
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101cd0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101cd4:	66 83 f8 09          	cmp    $0x9,%ax
80101cd8:	77 2f                	ja     80101d09 <writei+0x129>
80101cda:	8b 04 c5 04 f9 10 80 	mov    -0x7fef06fc(,%eax,8),%eax
80101ce1:	85 c0                	test   %eax,%eax
80101ce3:	74 24                	je     80101d09 <writei+0x129>
    return devsw[ip->major].write(ip, src, n);
80101ce5:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101ce8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ceb:	5b                   	pop    %ebx
80101cec:	5e                   	pop    %esi
80101ced:	5f                   	pop    %edi
80101cee:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101cef:	ff e0                	jmp    *%eax
80101cf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80101cf8:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101cfb:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
80101cfe:	50                   	push   %eax
80101cff:	e8 1c fa ff ff       	call   80101720 <iupdate>
80101d04:	83 c4 10             	add    $0x10,%esp
80101d07:	eb b4                	jmp    80101cbd <writei+0xdd>
      return -1;
80101d09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d0e:	eb b0                	jmp    80101cc0 <writei+0xe0>

80101d10 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101d10:	55                   	push   %ebp
80101d11:	89 e5                	mov    %esp,%ebp
80101d13:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101d16:	6a 0e                	push   $0xe
80101d18:	ff 75 0c             	push   0xc(%ebp)
80101d1b:	ff 75 08             	push   0x8(%ebp)
80101d1e:	e8 dd 2a 00 00       	call   80104800 <strncmp>
}
80101d23:	c9                   	leave
80101d24:	c3                   	ret
80101d25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101d30 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101d30:	55                   	push   %ebp
80101d31:	89 e5                	mov    %esp,%ebp
80101d33:	57                   	push   %edi
80101d34:	56                   	push   %esi
80101d35:	53                   	push   %ebx
80101d36:	83 ec 1c             	sub    $0x1c,%esp
80101d39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101d3c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d41:	0f 85 85 00 00 00    	jne    80101dcc <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d47:	8b 53 58             	mov    0x58(%ebx),%edx
80101d4a:	31 ff                	xor    %edi,%edi
80101d4c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d4f:	85 d2                	test   %edx,%edx
80101d51:	74 3e                	je     80101d91 <dirlookup+0x61>
80101d53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d57:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d58:	6a 10                	push   $0x10
80101d5a:	57                   	push   %edi
80101d5b:	56                   	push   %esi
80101d5c:	53                   	push   %ebx
80101d5d:	e8 7e fd ff ff       	call   80101ae0 <readi>
80101d62:	83 c4 10             	add    $0x10,%esp
80101d65:	83 f8 10             	cmp    $0x10,%eax
80101d68:	75 55                	jne    80101dbf <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d6a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d6f:	74 18                	je     80101d89 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d71:	83 ec 04             	sub    $0x4,%esp
80101d74:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d77:	6a 0e                	push   $0xe
80101d79:	50                   	push   %eax
80101d7a:	ff 75 0c             	push   0xc(%ebp)
80101d7d:	e8 7e 2a 00 00       	call   80104800 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d82:	83 c4 10             	add    $0x10,%esp
80101d85:	85 c0                	test   %eax,%eax
80101d87:	74 17                	je     80101da0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d89:	83 c7 10             	add    $0x10,%edi
80101d8c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d8f:	72 c7                	jb     80101d58 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d91:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d94:	31 c0                	xor    %eax,%eax
}
80101d96:	5b                   	pop    %ebx
80101d97:	5e                   	pop    %esi
80101d98:	5f                   	pop    %edi
80101d99:	5d                   	pop    %ebp
80101d9a:	c3                   	ret
80101d9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d9f:	90                   	nop
      if(poff)
80101da0:	8b 45 10             	mov    0x10(%ebp),%eax
80101da3:	85 c0                	test   %eax,%eax
80101da5:	74 05                	je     80101dac <dirlookup+0x7c>
        *poff = off;
80101da7:	8b 45 10             	mov    0x10(%ebp),%eax
80101daa:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101dac:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101db0:	8b 03                	mov    (%ebx),%eax
80101db2:	e8 69 f5 ff ff       	call   80101320 <iget>
}
80101db7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dba:	5b                   	pop    %ebx
80101dbb:	5e                   	pop    %esi
80101dbc:	5f                   	pop    %edi
80101dbd:	5d                   	pop    %ebp
80101dbe:	c3                   	ret
      panic("dirlookup read");
80101dbf:	83 ec 0c             	sub    $0xc,%esp
80101dc2:	68 59 73 10 80       	push   $0x80107359
80101dc7:	e8 b4 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101dcc:	83 ec 0c             	sub    $0xc,%esp
80101dcf:	68 47 73 10 80       	push   $0x80107347
80101dd4:	e8 a7 e5 ff ff       	call   80100380 <panic>
80101dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101de0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101de0:	55                   	push   %ebp
80101de1:	89 e5                	mov    %esp,%ebp
80101de3:	57                   	push   %edi
80101de4:	56                   	push   %esi
80101de5:	53                   	push   %ebx
80101de6:	89 c3                	mov    %eax,%ebx
80101de8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101deb:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101dee:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101df1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101df4:	0f 84 64 01 00 00    	je     80101f5e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101dfa:	e8 f1 1b 00 00       	call   801039f0 <myproc>
  acquire(&icache.lock);
80101dff:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101e02:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101e05:	68 60 f9 10 80       	push   $0x8010f960
80101e0a:	e8 11 28 00 00       	call   80104620 <acquire>
  ip->ref++;
80101e0f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101e13:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101e1a:	e8 a1 27 00 00       	call   801045c0 <release>
80101e1f:	83 c4 10             	add    $0x10,%esp
80101e22:	eb 07                	jmp    80101e2b <namex+0x4b>
80101e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e28:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e2b:	0f b6 03             	movzbl (%ebx),%eax
80101e2e:	3c 2f                	cmp    $0x2f,%al
80101e30:	74 f6                	je     80101e28 <namex+0x48>
  if(*path == 0)
80101e32:	84 c0                	test   %al,%al
80101e34:	0f 84 06 01 00 00    	je     80101f40 <namex+0x160>
  while(*path != '/' && *path != 0)
80101e3a:	0f b6 03             	movzbl (%ebx),%eax
80101e3d:	84 c0                	test   %al,%al
80101e3f:	0f 84 10 01 00 00    	je     80101f55 <namex+0x175>
80101e45:	89 df                	mov    %ebx,%edi
80101e47:	3c 2f                	cmp    $0x2f,%al
80101e49:	0f 84 06 01 00 00    	je     80101f55 <namex+0x175>
80101e4f:	90                   	nop
80101e50:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e54:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e57:	3c 2f                	cmp    $0x2f,%al
80101e59:	74 04                	je     80101e5f <namex+0x7f>
80101e5b:	84 c0                	test   %al,%al
80101e5d:	75 f1                	jne    80101e50 <namex+0x70>
  len = path - s;
80101e5f:	89 f8                	mov    %edi,%eax
80101e61:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e63:	83 f8 0d             	cmp    $0xd,%eax
80101e66:	0f 8e ac 00 00 00    	jle    80101f18 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e6c:	83 ec 04             	sub    $0x4,%esp
80101e6f:	6a 0e                	push   $0xe
80101e71:	53                   	push   %ebx
    path++;
80101e72:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e74:	ff 75 e4             	push   -0x1c(%ebp)
80101e77:	e8 14 29 00 00       	call   80104790 <memmove>
80101e7c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e7f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e82:	75 0c                	jne    80101e90 <namex+0xb0>
80101e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e88:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e8b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e8e:	74 f8                	je     80101e88 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e90:	83 ec 0c             	sub    $0xc,%esp
80101e93:	56                   	push   %esi
80101e94:	e8 37 f9 ff ff       	call   801017d0 <ilock>
    if(ip->type != T_DIR){
80101e99:	83 c4 10             	add    $0x10,%esp
80101e9c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101ea1:	0f 85 cd 00 00 00    	jne    80101f74 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101ea7:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101eaa:	85 c0                	test   %eax,%eax
80101eac:	74 09                	je     80101eb7 <namex+0xd7>
80101eae:	80 3b 00             	cmpb   $0x0,(%ebx)
80101eb1:	0f 84 34 01 00 00    	je     80101feb <namex+0x20b>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101eb7:	83 ec 04             	sub    $0x4,%esp
80101eba:	6a 00                	push   $0x0
80101ebc:	ff 75 e4             	push   -0x1c(%ebp)
80101ebf:	56                   	push   %esi
80101ec0:	e8 6b fe ff ff       	call   80101d30 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ec5:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101ec8:	83 c4 10             	add    $0x10,%esp
80101ecb:	89 c7                	mov    %eax,%edi
80101ecd:	85 c0                	test   %eax,%eax
80101ecf:	0f 84 e1 00 00 00    	je     80101fb6 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ed5:	83 ec 0c             	sub    $0xc,%esp
80101ed8:	52                   	push   %edx
80101ed9:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101edc:	e8 0f 25 00 00       	call   801043f0 <holdingsleep>
80101ee1:	83 c4 10             	add    $0x10,%esp
80101ee4:	85 c0                	test   %eax,%eax
80101ee6:	0f 84 3f 01 00 00    	je     8010202b <namex+0x24b>
80101eec:	8b 56 08             	mov    0x8(%esi),%edx
80101eef:	85 d2                	test   %edx,%edx
80101ef1:	0f 8e 34 01 00 00    	jle    8010202b <namex+0x24b>
  releasesleep(&ip->lock);
80101ef7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101efa:	83 ec 0c             	sub    $0xc,%esp
80101efd:	52                   	push   %edx
80101efe:	e8 ad 24 00 00       	call   801043b0 <releasesleep>
  iput(ip);
80101f03:	89 34 24             	mov    %esi,(%esp)
80101f06:	89 fe                	mov    %edi,%esi
80101f08:	e8 f3 f9 ff ff       	call   80101900 <iput>
80101f0d:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101f10:	e9 16 ff ff ff       	jmp    80101e2b <namex+0x4b>
80101f15:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101f18:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101f1b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101f1e:	83 ec 04             	sub    $0x4,%esp
80101f21:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101f24:	50                   	push   %eax
80101f25:	53                   	push   %ebx
    name[len] = 0;
80101f26:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101f28:	ff 75 e4             	push   -0x1c(%ebp)
80101f2b:	e8 60 28 00 00       	call   80104790 <memmove>
    name[len] = 0;
80101f30:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101f33:	83 c4 10             	add    $0x10,%esp
80101f36:	c6 02 00             	movb   $0x0,(%edx)
80101f39:	e9 41 ff ff ff       	jmp    80101e7f <namex+0x9f>
80101f3e:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101f40:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f43:	85 c0                	test   %eax,%eax
80101f45:	0f 85 d0 00 00 00    	jne    8010201b <namex+0x23b>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f4e:	89 f0                	mov    %esi,%eax
80101f50:	5b                   	pop    %ebx
80101f51:	5e                   	pop    %esi
80101f52:	5f                   	pop    %edi
80101f53:	5d                   	pop    %ebp
80101f54:	c3                   	ret
  while(*path != '/' && *path != 0)
80101f55:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f58:	89 df                	mov    %ebx,%edi
80101f5a:	31 c0                	xor    %eax,%eax
80101f5c:	eb c0                	jmp    80101f1e <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f5e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f63:	b8 01 00 00 00       	mov    $0x1,%eax
80101f68:	e8 b3 f3 ff ff       	call   80101320 <iget>
80101f6d:	89 c6                	mov    %eax,%esi
80101f6f:	e9 b7 fe ff ff       	jmp    80101e2b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f74:	83 ec 0c             	sub    $0xc,%esp
80101f77:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f7a:	53                   	push   %ebx
80101f7b:	e8 70 24 00 00       	call   801043f0 <holdingsleep>
80101f80:	83 c4 10             	add    $0x10,%esp
80101f83:	85 c0                	test   %eax,%eax
80101f85:	0f 84 a0 00 00 00    	je     8010202b <namex+0x24b>
80101f8b:	8b 46 08             	mov    0x8(%esi),%eax
80101f8e:	85 c0                	test   %eax,%eax
80101f90:	0f 8e 95 00 00 00    	jle    8010202b <namex+0x24b>
  releasesleep(&ip->lock);
80101f96:	83 ec 0c             	sub    $0xc,%esp
80101f99:	53                   	push   %ebx
80101f9a:	e8 11 24 00 00       	call   801043b0 <releasesleep>
  iput(ip);
80101f9f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101fa2:	31 f6                	xor    %esi,%esi
  iput(ip);
80101fa4:	e8 57 f9 ff ff       	call   80101900 <iput>
      return 0;
80101fa9:	83 c4 10             	add    $0x10,%esp
}
80101fac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101faf:	89 f0                	mov    %esi,%eax
80101fb1:	5b                   	pop    %ebx
80101fb2:	5e                   	pop    %esi
80101fb3:	5f                   	pop    %edi
80101fb4:	5d                   	pop    %ebp
80101fb5:	c3                   	ret
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101fb6:	83 ec 0c             	sub    $0xc,%esp
80101fb9:	52                   	push   %edx
80101fba:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101fbd:	e8 2e 24 00 00       	call   801043f0 <holdingsleep>
80101fc2:	83 c4 10             	add    $0x10,%esp
80101fc5:	85 c0                	test   %eax,%eax
80101fc7:	74 62                	je     8010202b <namex+0x24b>
80101fc9:	8b 4e 08             	mov    0x8(%esi),%ecx
80101fcc:	85 c9                	test   %ecx,%ecx
80101fce:	7e 5b                	jle    8010202b <namex+0x24b>
  releasesleep(&ip->lock);
80101fd0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101fd3:	83 ec 0c             	sub    $0xc,%esp
80101fd6:	52                   	push   %edx
80101fd7:	e8 d4 23 00 00       	call   801043b0 <releasesleep>
  iput(ip);
80101fdc:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101fdf:	31 f6                	xor    %esi,%esi
  iput(ip);
80101fe1:	e8 1a f9 ff ff       	call   80101900 <iput>
      return 0;
80101fe6:	83 c4 10             	add    $0x10,%esp
80101fe9:	eb c1                	jmp    80101fac <namex+0x1cc>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101feb:	83 ec 0c             	sub    $0xc,%esp
80101fee:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101ff1:	53                   	push   %ebx
80101ff2:	e8 f9 23 00 00       	call   801043f0 <holdingsleep>
80101ff7:	83 c4 10             	add    $0x10,%esp
80101ffa:	85 c0                	test   %eax,%eax
80101ffc:	74 2d                	je     8010202b <namex+0x24b>
80101ffe:	8b 7e 08             	mov    0x8(%esi),%edi
80102001:	85 ff                	test   %edi,%edi
80102003:	7e 26                	jle    8010202b <namex+0x24b>
  releasesleep(&ip->lock);
80102005:	83 ec 0c             	sub    $0xc,%esp
80102008:	53                   	push   %ebx
80102009:	e8 a2 23 00 00       	call   801043b0 <releasesleep>
}
8010200e:	83 c4 10             	add    $0x10,%esp
}
80102011:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102014:	89 f0                	mov    %esi,%eax
80102016:	5b                   	pop    %ebx
80102017:	5e                   	pop    %esi
80102018:	5f                   	pop    %edi
80102019:	5d                   	pop    %ebp
8010201a:	c3                   	ret
    iput(ip);
8010201b:	83 ec 0c             	sub    $0xc,%esp
8010201e:	56                   	push   %esi
      return 0;
8010201f:	31 f6                	xor    %esi,%esi
    iput(ip);
80102021:	e8 da f8 ff ff       	call   80101900 <iput>
    return 0;
80102026:	83 c4 10             	add    $0x10,%esp
80102029:	eb 81                	jmp    80101fac <namex+0x1cc>
    panic("iunlock");
8010202b:	83 ec 0c             	sub    $0xc,%esp
8010202e:	68 3f 73 10 80       	push   $0x8010733f
80102033:	e8 48 e3 ff ff       	call   80100380 <panic>
80102038:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010203f:	90                   	nop

80102040 <dirlink>:
{
80102040:	55                   	push   %ebp
80102041:	89 e5                	mov    %esp,%ebp
80102043:	57                   	push   %edi
80102044:	56                   	push   %esi
80102045:	53                   	push   %ebx
80102046:	83 ec 20             	sub    $0x20,%esp
80102049:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010204c:	6a 00                	push   $0x0
8010204e:	ff 75 0c             	push   0xc(%ebp)
80102051:	53                   	push   %ebx
80102052:	e8 d9 fc ff ff       	call   80101d30 <dirlookup>
80102057:	83 c4 10             	add    $0x10,%esp
8010205a:	85 c0                	test   %eax,%eax
8010205c:	75 67                	jne    801020c5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010205e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102061:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102064:	85 ff                	test   %edi,%edi
80102066:	74 29                	je     80102091 <dirlink+0x51>
80102068:	31 ff                	xor    %edi,%edi
8010206a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010206d:	eb 09                	jmp    80102078 <dirlink+0x38>
8010206f:	90                   	nop
80102070:	83 c7 10             	add    $0x10,%edi
80102073:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102076:	73 19                	jae    80102091 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102078:	6a 10                	push   $0x10
8010207a:	57                   	push   %edi
8010207b:	56                   	push   %esi
8010207c:	53                   	push   %ebx
8010207d:	e8 5e fa ff ff       	call   80101ae0 <readi>
80102082:	83 c4 10             	add    $0x10,%esp
80102085:	83 f8 10             	cmp    $0x10,%eax
80102088:	75 4e                	jne    801020d8 <dirlink+0x98>
    if(de.inum == 0)
8010208a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010208f:	75 df                	jne    80102070 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102091:	83 ec 04             	sub    $0x4,%esp
80102094:	8d 45 da             	lea    -0x26(%ebp),%eax
80102097:	6a 0e                	push   $0xe
80102099:	ff 75 0c             	push   0xc(%ebp)
8010209c:	50                   	push   %eax
8010209d:	e8 ae 27 00 00       	call   80104850 <strncpy>
  de.inum = inum;
801020a2:	8b 45 10             	mov    0x10(%ebp),%eax
801020a5:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020a9:	6a 10                	push   $0x10
801020ab:	57                   	push   %edi
801020ac:	56                   	push   %esi
801020ad:	53                   	push   %ebx
801020ae:	e8 2d fb ff ff       	call   80101be0 <writei>
801020b3:	83 c4 20             	add    $0x20,%esp
801020b6:	83 f8 10             	cmp    $0x10,%eax
801020b9:	75 2a                	jne    801020e5 <dirlink+0xa5>
  return 0;
801020bb:	31 c0                	xor    %eax,%eax
}
801020bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020c0:	5b                   	pop    %ebx
801020c1:	5e                   	pop    %esi
801020c2:	5f                   	pop    %edi
801020c3:	5d                   	pop    %ebp
801020c4:	c3                   	ret
    iput(ip);
801020c5:	83 ec 0c             	sub    $0xc,%esp
801020c8:	50                   	push   %eax
801020c9:	e8 32 f8 ff ff       	call   80101900 <iput>
    return -1;
801020ce:	83 c4 10             	add    $0x10,%esp
801020d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020d6:	eb e5                	jmp    801020bd <dirlink+0x7d>
      panic("dirlink read");
801020d8:	83 ec 0c             	sub    $0xc,%esp
801020db:	68 68 73 10 80       	push   $0x80107368
801020e0:	e8 9b e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
801020e5:	83 ec 0c             	sub    $0xc,%esp
801020e8:	68 42 79 10 80       	push   $0x80107942
801020ed:	e8 8e e2 ff ff       	call   80100380 <panic>
801020f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102100 <namei>:

struct inode*
namei(char *path)
{
80102100:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102101:	31 d2                	xor    %edx,%edx
{
80102103:	89 e5                	mov    %esp,%ebp
80102105:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102108:	8b 45 08             	mov    0x8(%ebp),%eax
8010210b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010210e:	e8 cd fc ff ff       	call   80101de0 <namex>
}
80102113:	c9                   	leave
80102114:	c3                   	ret
80102115:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010211c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102120 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102120:	55                   	push   %ebp
  return namex(path, 1, name);
80102121:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102126:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102128:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010212b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010212e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010212f:	e9 ac fc ff ff       	jmp    80101de0 <namex>
80102134:	66 90                	xchg   %ax,%ax
80102136:	66 90                	xchg   %ax,%ax
80102138:	66 90                	xchg   %ax,%ax
8010213a:	66 90                	xchg   %ax,%ax
8010213c:	66 90                	xchg   %ax,%ax
8010213e:	66 90                	xchg   %ax,%ax

80102140 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102140:	55                   	push   %ebp
80102141:	89 e5                	mov    %esp,%ebp
80102143:	57                   	push   %edi
80102144:	56                   	push   %esi
80102145:	53                   	push   %ebx
80102146:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102149:	85 c0                	test   %eax,%eax
8010214b:	0f 84 b4 00 00 00    	je     80102205 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102151:	8b 70 08             	mov    0x8(%eax),%esi
80102154:	89 c3                	mov    %eax,%ebx
80102156:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010215c:	0f 87 96 00 00 00    	ja     801021f8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102162:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102167:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010216e:	66 90                	xchg   %ax,%ax
80102170:	89 ca                	mov    %ecx,%edx
80102172:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102173:	83 e0 c0             	and    $0xffffffc0,%eax
80102176:	3c 40                	cmp    $0x40,%al
80102178:	75 f6                	jne    80102170 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010217a:	31 ff                	xor    %edi,%edi
8010217c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102181:	89 f8                	mov    %edi,%eax
80102183:	ee                   	out    %al,(%dx)
80102184:	b8 01 00 00 00       	mov    $0x1,%eax
80102189:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010218e:	ee                   	out    %al,(%dx)
8010218f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102194:	89 f0                	mov    %esi,%eax
80102196:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102197:	89 f0                	mov    %esi,%eax
80102199:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010219e:	c1 f8 08             	sar    $0x8,%eax
801021a1:	ee                   	out    %al,(%dx)
801021a2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801021a7:	89 f8                	mov    %edi,%eax
801021a9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801021aa:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801021ae:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021b3:	c1 e0 04             	shl    $0x4,%eax
801021b6:	83 e0 10             	and    $0x10,%eax
801021b9:	83 c8 e0             	or     $0xffffffe0,%eax
801021bc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801021bd:	f6 03 04             	testb  $0x4,(%ebx)
801021c0:	75 16                	jne    801021d8 <idestart+0x98>
801021c2:	b8 20 00 00 00       	mov    $0x20,%eax
801021c7:	89 ca                	mov    %ecx,%edx
801021c9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801021ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021cd:	5b                   	pop    %ebx
801021ce:	5e                   	pop    %esi
801021cf:	5f                   	pop    %edi
801021d0:	5d                   	pop    %ebp
801021d1:	c3                   	ret
801021d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801021d8:	b8 30 00 00 00       	mov    $0x30,%eax
801021dd:	89 ca                	mov    %ecx,%edx
801021df:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801021e0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801021e5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801021e8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021ed:	fc                   	cld
801021ee:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801021f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021f3:	5b                   	pop    %ebx
801021f4:	5e                   	pop    %esi
801021f5:	5f                   	pop    %edi
801021f6:	5d                   	pop    %ebp
801021f7:	c3                   	ret
    panic("incorrect blockno");
801021f8:	83 ec 0c             	sub    $0xc,%esp
801021fb:	68 d4 73 10 80       	push   $0x801073d4
80102200:	e8 7b e1 ff ff       	call   80100380 <panic>
    panic("idestart");
80102205:	83 ec 0c             	sub    $0xc,%esp
80102208:	68 cb 73 10 80       	push   $0x801073cb
8010220d:	e8 6e e1 ff ff       	call   80100380 <panic>
80102212:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102220 <ideinit>:
{
80102220:	55                   	push   %ebp
80102221:	89 e5                	mov    %esp,%ebp
80102223:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102226:	68 e6 73 10 80       	push   $0x801073e6
8010222b:	68 00 16 11 80       	push   $0x80111600
80102230:	e8 0b 22 00 00       	call   80104440 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102235:	58                   	pop    %eax
80102236:	a1 84 17 11 80       	mov    0x80111784,%eax
8010223b:	5a                   	pop    %edx
8010223c:	83 e8 01             	sub    $0x1,%eax
8010223f:	50                   	push   %eax
80102240:	6a 0e                	push   $0xe
80102242:	e8 99 02 00 00       	call   801024e0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102247:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010224a:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
8010224f:	90                   	nop
80102250:	89 ca                	mov    %ecx,%edx
80102252:	ec                   	in     (%dx),%al
80102253:	83 e0 c0             	and    $0xffffffc0,%eax
80102256:	3c 40                	cmp    $0x40,%al
80102258:	75 f6                	jne    80102250 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010225a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010225f:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102264:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102265:	89 ca                	mov    %ecx,%edx
80102267:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102268:	84 c0                	test   %al,%al
8010226a:	75 1e                	jne    8010228a <ideinit+0x6a>
8010226c:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
80102271:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102276:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227d:	8d 76 00             	lea    0x0(%esi),%esi
  for(i=0; i<1000; i++){
80102280:	83 e9 01             	sub    $0x1,%ecx
80102283:	74 0f                	je     80102294 <ideinit+0x74>
80102285:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102286:	84 c0                	test   %al,%al
80102288:	74 f6                	je     80102280 <ideinit+0x60>
      havedisk1 = 1;
8010228a:	c7 05 e0 15 11 80 01 	movl   $0x1,0x801115e0
80102291:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102294:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102299:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010229e:	ee                   	out    %al,(%dx)
}
8010229f:	c9                   	leave
801022a0:	c3                   	ret
801022a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022af:	90                   	nop

801022b0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801022b0:	55                   	push   %ebp
801022b1:	89 e5                	mov    %esp,%ebp
801022b3:	57                   	push   %edi
801022b4:	56                   	push   %esi
801022b5:	53                   	push   %ebx
801022b6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801022b9:	68 00 16 11 80       	push   $0x80111600
801022be:	e8 5d 23 00 00       	call   80104620 <acquire>

  if((b = idequeue) == 0){
801022c3:	8b 1d e4 15 11 80    	mov    0x801115e4,%ebx
801022c9:	83 c4 10             	add    $0x10,%esp
801022cc:	85 db                	test   %ebx,%ebx
801022ce:	74 63                	je     80102333 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801022d0:	8b 43 58             	mov    0x58(%ebx),%eax
801022d3:	a3 e4 15 11 80       	mov    %eax,0x801115e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801022d8:	8b 33                	mov    (%ebx),%esi
801022da:	f7 c6 04 00 00 00    	test   $0x4,%esi
801022e0:	75 2f                	jne    80102311 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022e2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022ee:	66 90                	xchg   %ax,%ax
801022f0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022f1:	89 c1                	mov    %eax,%ecx
801022f3:	83 e1 c0             	and    $0xffffffc0,%ecx
801022f6:	80 f9 40             	cmp    $0x40,%cl
801022f9:	75 f5                	jne    801022f0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801022fb:	a8 21                	test   $0x21,%al
801022fd:	75 12                	jne    80102311 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801022ff:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102302:	b9 80 00 00 00       	mov    $0x80,%ecx
80102307:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010230c:	fc                   	cld
8010230d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010230f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102311:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102314:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102317:	83 ce 02             	or     $0x2,%esi
8010231a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010231c:	53                   	push   %ebx
8010231d:	e8 4e 1e 00 00       	call   80104170 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102322:	a1 e4 15 11 80       	mov    0x801115e4,%eax
80102327:	83 c4 10             	add    $0x10,%esp
8010232a:	85 c0                	test   %eax,%eax
8010232c:	74 05                	je     80102333 <ideintr+0x83>
    idestart(idequeue);
8010232e:	e8 0d fe ff ff       	call   80102140 <idestart>
    release(&idelock);
80102333:	83 ec 0c             	sub    $0xc,%esp
80102336:	68 00 16 11 80       	push   $0x80111600
8010233b:	e8 80 22 00 00       	call   801045c0 <release>

  release(&idelock);
}
80102340:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102343:	5b                   	pop    %ebx
80102344:	5e                   	pop    %esi
80102345:	5f                   	pop    %edi
80102346:	5d                   	pop    %ebp
80102347:	c3                   	ret
80102348:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010234f:	90                   	nop

80102350 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102350:	55                   	push   %ebp
80102351:	89 e5                	mov    %esp,%ebp
80102353:	53                   	push   %ebx
80102354:	83 ec 10             	sub    $0x10,%esp
80102357:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010235a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010235d:	50                   	push   %eax
8010235e:	e8 8d 20 00 00       	call   801043f0 <holdingsleep>
80102363:	83 c4 10             	add    $0x10,%esp
80102366:	85 c0                	test   %eax,%eax
80102368:	0f 84 c3 00 00 00    	je     80102431 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010236e:	8b 03                	mov    (%ebx),%eax
80102370:	83 e0 06             	and    $0x6,%eax
80102373:	83 f8 02             	cmp    $0x2,%eax
80102376:	0f 84 a8 00 00 00    	je     80102424 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010237c:	8b 53 04             	mov    0x4(%ebx),%edx
8010237f:	85 d2                	test   %edx,%edx
80102381:	74 0d                	je     80102390 <iderw+0x40>
80102383:	a1 e0 15 11 80       	mov    0x801115e0,%eax
80102388:	85 c0                	test   %eax,%eax
8010238a:	0f 84 87 00 00 00    	je     80102417 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102390:	83 ec 0c             	sub    $0xc,%esp
80102393:	68 00 16 11 80       	push   $0x80111600
80102398:	e8 83 22 00 00       	call   80104620 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010239d:	a1 e4 15 11 80       	mov    0x801115e4,%eax
  b->qnext = 0;
801023a2:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023a9:	83 c4 10             	add    $0x10,%esp
801023ac:	85 c0                	test   %eax,%eax
801023ae:	74 60                	je     80102410 <iderw+0xc0>
801023b0:	89 c2                	mov    %eax,%edx
801023b2:	8b 40 58             	mov    0x58(%eax),%eax
801023b5:	85 c0                	test   %eax,%eax
801023b7:	75 f7                	jne    801023b0 <iderw+0x60>
801023b9:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801023bc:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801023be:	39 1d e4 15 11 80    	cmp    %ebx,0x801115e4
801023c4:	74 3a                	je     80102400 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023c6:	8b 03                	mov    (%ebx),%eax
801023c8:	83 e0 06             	and    $0x6,%eax
801023cb:	83 f8 02             	cmp    $0x2,%eax
801023ce:	74 1b                	je     801023eb <iderw+0x9b>
    sleep(b, &idelock);
801023d0:	83 ec 08             	sub    $0x8,%esp
801023d3:	68 00 16 11 80       	push   $0x80111600
801023d8:	53                   	push   %ebx
801023d9:	e8 d2 1c 00 00       	call   801040b0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023de:	8b 03                	mov    (%ebx),%eax
801023e0:	83 c4 10             	add    $0x10,%esp
801023e3:	83 e0 06             	and    $0x6,%eax
801023e6:	83 f8 02             	cmp    $0x2,%eax
801023e9:	75 e5                	jne    801023d0 <iderw+0x80>
  }


  release(&idelock);
801023eb:	c7 45 08 00 16 11 80 	movl   $0x80111600,0x8(%ebp)
}
801023f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023f5:	c9                   	leave
  release(&idelock);
801023f6:	e9 c5 21 00 00       	jmp    801045c0 <release>
801023fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023ff:	90                   	nop
    idestart(b);
80102400:	89 d8                	mov    %ebx,%eax
80102402:	e8 39 fd ff ff       	call   80102140 <idestart>
80102407:	eb bd                	jmp    801023c6 <iderw+0x76>
80102409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102410:	ba e4 15 11 80       	mov    $0x801115e4,%edx
80102415:	eb a5                	jmp    801023bc <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102417:	83 ec 0c             	sub    $0xc,%esp
8010241a:	68 15 74 10 80       	push   $0x80107415
8010241f:	e8 5c df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
80102424:	83 ec 0c             	sub    $0xc,%esp
80102427:	68 00 74 10 80       	push   $0x80107400
8010242c:	e8 4f df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
80102431:	83 ec 0c             	sub    $0xc,%esp
80102434:	68 ea 73 10 80       	push   $0x801073ea
80102439:	e8 42 df ff ff       	call   80100380 <panic>
8010243e:	66 90                	xchg   %ax,%ax

80102440 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102440:	55                   	push   %ebp
80102441:	89 e5                	mov    %esp,%ebp
80102443:	56                   	push   %esi
80102444:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102445:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
8010244c:	00 c0 fe 
  ioapic->reg = reg;
8010244f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102456:	00 00 00 
  return ioapic->data;
80102459:	8b 15 34 16 11 80    	mov    0x80111634,%edx
8010245f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102462:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102468:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010246e:	0f b6 15 80 17 11 80 	movzbl 0x80111780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102475:	c1 ee 10             	shr    $0x10,%esi
80102478:	89 f0                	mov    %esi,%eax
8010247a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010247d:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102480:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102483:	39 c2                	cmp    %eax,%edx
80102485:	74 16                	je     8010249d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102487:	83 ec 0c             	sub    $0xc,%esp
8010248a:	68 34 74 10 80       	push   $0x80107434
8010248f:	e8 1c e2 ff ff       	call   801006b0 <cprintf>
  ioapic->reg = reg;
80102494:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
8010249a:	83 c4 10             	add    $0x10,%esp
{
8010249d:	ba 10 00 00 00       	mov    $0x10,%edx
801024a2:	31 c0                	xor    %eax,%eax
801024a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
801024a8:	89 13                	mov    %edx,(%ebx)
801024aa:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
801024ad:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801024b3:	83 c0 01             	add    $0x1,%eax
801024b6:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
801024bc:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
801024bf:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
801024c2:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
801024c5:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
801024c7:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
801024cd:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
801024d4:	39 c6                	cmp    %eax,%esi
801024d6:	7d d0                	jge    801024a8 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801024d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024db:	5b                   	pop    %ebx
801024dc:	5e                   	pop    %esi
801024dd:	5d                   	pop    %ebp
801024de:	c3                   	ret
801024df:	90                   	nop

801024e0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801024e0:	55                   	push   %ebp
  ioapic->reg = reg;
801024e1:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
{
801024e7:	89 e5                	mov    %esp,%ebp
801024e9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801024ec:	8d 50 20             	lea    0x20(%eax),%edx
801024ef:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801024f3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024f5:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024fb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801024fe:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102501:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102504:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102506:	a1 34 16 11 80       	mov    0x80111634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010250b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010250e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102511:	5d                   	pop    %ebp
80102512:	c3                   	ret
80102513:	66 90                	xchg   %ax,%ax
80102515:	66 90                	xchg   %ax,%ax
80102517:	66 90                	xchg   %ax,%ax
80102519:	66 90                	xchg   %ax,%ax
8010251b:	66 90                	xchg   %ax,%ax
8010251d:	66 90                	xchg   %ax,%ax
8010251f:	90                   	nop

80102520 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102520:	55                   	push   %ebp
80102521:	89 e5                	mov    %esp,%ebp
80102523:	53                   	push   %ebx
80102524:	83 ec 04             	sub    $0x4,%esp
80102527:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010252a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102530:	75 76                	jne    801025a8 <kfree+0x88>
80102532:	81 fb d0 54 11 80    	cmp    $0x801154d0,%ebx
80102538:	72 6e                	jb     801025a8 <kfree+0x88>
8010253a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102540:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102545:	77 61                	ja     801025a8 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102547:	83 ec 04             	sub    $0x4,%esp
8010254a:	68 00 10 00 00       	push   $0x1000
8010254f:	6a 01                	push   $0x1
80102551:	53                   	push   %ebx
80102552:	e8 a9 21 00 00       	call   80104700 <memset>

  if(kmem.use_lock)
80102557:	8b 15 74 16 11 80    	mov    0x80111674,%edx
8010255d:	83 c4 10             	add    $0x10,%esp
80102560:	85 d2                	test   %edx,%edx
80102562:	75 1c                	jne    80102580 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102564:	a1 78 16 11 80       	mov    0x80111678,%eax
80102569:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010256b:	a1 74 16 11 80       	mov    0x80111674,%eax
  kmem.freelist = r;
80102570:	89 1d 78 16 11 80    	mov    %ebx,0x80111678
  if(kmem.use_lock)
80102576:	85 c0                	test   %eax,%eax
80102578:	75 1e                	jne    80102598 <kfree+0x78>
    release(&kmem.lock);
}
8010257a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010257d:	c9                   	leave
8010257e:	c3                   	ret
8010257f:	90                   	nop
    acquire(&kmem.lock);
80102580:	83 ec 0c             	sub    $0xc,%esp
80102583:	68 40 16 11 80       	push   $0x80111640
80102588:	e8 93 20 00 00       	call   80104620 <acquire>
8010258d:	83 c4 10             	add    $0x10,%esp
80102590:	eb d2                	jmp    80102564 <kfree+0x44>
80102592:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102598:	c7 45 08 40 16 11 80 	movl   $0x80111640,0x8(%ebp)
}
8010259f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025a2:	c9                   	leave
    release(&kmem.lock);
801025a3:	e9 18 20 00 00       	jmp    801045c0 <release>
    panic("kfree");
801025a8:	83 ec 0c             	sub    $0xc,%esp
801025ab:	68 66 74 10 80       	push   $0x80107466
801025b0:	e8 cb dd ff ff       	call   80100380 <panic>
801025b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801025c0 <freerange>:
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	56                   	push   %esi
801025c4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025c5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801025cb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025dd:	39 de                	cmp    %ebx,%esi
801025df:	72 23                	jb     80102604 <freerange+0x44>
801025e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025e8:	83 ec 0c             	sub    $0xc,%esp
801025eb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025f7:	50                   	push   %eax
801025f8:	e8 23 ff ff ff       	call   80102520 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025fd:	83 c4 10             	add    $0x10,%esp
80102600:	39 de                	cmp    %ebx,%esi
80102602:	73 e4                	jae    801025e8 <freerange+0x28>
}
80102604:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102607:	5b                   	pop    %ebx
80102608:	5e                   	pop    %esi
80102609:	5d                   	pop    %ebp
8010260a:	c3                   	ret
8010260b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010260f:	90                   	nop

80102610 <kinit2>:
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	56                   	push   %esi
80102614:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102615:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102618:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010261b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102621:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102627:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010262d:	39 de                	cmp    %ebx,%esi
8010262f:	72 23                	jb     80102654 <kinit2+0x44>
80102631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102638:	83 ec 0c             	sub    $0xc,%esp
8010263b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102641:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102647:	50                   	push   %eax
80102648:	e8 d3 fe ff ff       	call   80102520 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010264d:	83 c4 10             	add    $0x10,%esp
80102650:	39 de                	cmp    %ebx,%esi
80102652:	73 e4                	jae    80102638 <kinit2+0x28>
  kmem.use_lock = 1;
80102654:	c7 05 74 16 11 80 01 	movl   $0x1,0x80111674
8010265b:	00 00 00 
}
8010265e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102661:	5b                   	pop    %ebx
80102662:	5e                   	pop    %esi
80102663:	5d                   	pop    %ebp
80102664:	c3                   	ret
80102665:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010266c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102670 <kinit1>:
{
80102670:	55                   	push   %ebp
80102671:	89 e5                	mov    %esp,%ebp
80102673:	56                   	push   %esi
80102674:	53                   	push   %ebx
80102675:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102678:	83 ec 08             	sub    $0x8,%esp
8010267b:	68 6c 74 10 80       	push   $0x8010746c
80102680:	68 40 16 11 80       	push   $0x80111640
80102685:	e8 b6 1d 00 00       	call   80104440 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010268a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010268d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102690:	c7 05 74 16 11 80 00 	movl   $0x0,0x80111674
80102697:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010269a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026a0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026a6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026ac:	39 de                	cmp    %ebx,%esi
801026ae:	72 1c                	jb     801026cc <kinit1+0x5c>
    kfree(p);
801026b0:	83 ec 0c             	sub    $0xc,%esp
801026b3:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026b9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026bf:	50                   	push   %eax
801026c0:	e8 5b fe ff ff       	call   80102520 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026c5:	83 c4 10             	add    $0x10,%esp
801026c8:	39 de                	cmp    %ebx,%esi
801026ca:	73 e4                	jae    801026b0 <kinit1+0x40>
}
801026cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026cf:	5b                   	pop    %ebx
801026d0:	5e                   	pop    %esi
801026d1:	5d                   	pop    %ebp
801026d2:	c3                   	ret
801026d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801026e0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801026e0:	55                   	push   %ebp
801026e1:	89 e5                	mov    %esp,%ebp
801026e3:	53                   	push   %ebx
801026e4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
801026e7:	a1 74 16 11 80       	mov    0x80111674,%eax
801026ec:	85 c0                	test   %eax,%eax
801026ee:	75 20                	jne    80102710 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
801026f0:	8b 1d 78 16 11 80    	mov    0x80111678,%ebx
  if(r)
801026f6:	85 db                	test   %ebx,%ebx
801026f8:	74 07                	je     80102701 <kalloc+0x21>
    kmem.freelist = r->next;
801026fa:	8b 03                	mov    (%ebx),%eax
801026fc:	a3 78 16 11 80       	mov    %eax,0x80111678
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102701:	89 d8                	mov    %ebx,%eax
80102703:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102706:	c9                   	leave
80102707:	c3                   	ret
80102708:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010270f:	90                   	nop
    acquire(&kmem.lock);
80102710:	83 ec 0c             	sub    $0xc,%esp
80102713:	68 40 16 11 80       	push   $0x80111640
80102718:	e8 03 1f 00 00       	call   80104620 <acquire>
  r = kmem.freelist;
8010271d:	8b 1d 78 16 11 80    	mov    0x80111678,%ebx
  if(kmem.use_lock)
80102723:	a1 74 16 11 80       	mov    0x80111674,%eax
  if(r)
80102728:	83 c4 10             	add    $0x10,%esp
8010272b:	85 db                	test   %ebx,%ebx
8010272d:	74 08                	je     80102737 <kalloc+0x57>
    kmem.freelist = r->next;
8010272f:	8b 13                	mov    (%ebx),%edx
80102731:	89 15 78 16 11 80    	mov    %edx,0x80111678
  if(kmem.use_lock)
80102737:	85 c0                	test   %eax,%eax
80102739:	74 c6                	je     80102701 <kalloc+0x21>
    release(&kmem.lock);
8010273b:	83 ec 0c             	sub    $0xc,%esp
8010273e:	68 40 16 11 80       	push   $0x80111640
80102743:	e8 78 1e 00 00       	call   801045c0 <release>
}
80102748:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
8010274a:	83 c4 10             	add    $0x10,%esp
}
8010274d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102750:	c9                   	leave
80102751:	c3                   	ret
80102752:	66 90                	xchg   %ax,%ax
80102754:	66 90                	xchg   %ax,%ax
80102756:	66 90                	xchg   %ax,%ax
80102758:	66 90                	xchg   %ax,%ax
8010275a:	66 90                	xchg   %ax,%ax
8010275c:	66 90                	xchg   %ax,%ax
8010275e:	66 90                	xchg   %ax,%ax

80102760 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102760:	ba 64 00 00 00       	mov    $0x64,%edx
80102765:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102766:	a8 01                	test   $0x1,%al
80102768:	0f 84 c2 00 00 00    	je     80102830 <kbdgetc+0xd0>
{
8010276e:	55                   	push   %ebp
8010276f:	ba 60 00 00 00       	mov    $0x60,%edx
80102774:	89 e5                	mov    %esp,%ebp
80102776:	53                   	push   %ebx
80102777:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102778:	8b 1d 7c 16 11 80    	mov    0x8011167c,%ebx
  data = inb(KBDATAP);
8010277e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102781:	3c e0                	cmp    $0xe0,%al
80102783:	74 5b                	je     801027e0 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102785:	89 da                	mov    %ebx,%edx
80102787:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010278a:	84 c0                	test   %al,%al
8010278c:	78 6a                	js     801027f8 <kbdgetc+0x98>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010278e:	85 d2                	test   %edx,%edx
80102790:	74 09                	je     8010279b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102792:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102795:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102798:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010279b:	0f b6 91 a0 75 10 80 	movzbl -0x7fef8a60(%ecx),%edx
  shift ^= togglecode[data];
801027a2:	0f b6 81 a0 74 10 80 	movzbl -0x7fef8b60(%ecx),%eax
  shift |= shiftcode[data];
801027a9:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
801027ab:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801027ad:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
801027af:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  c = charcode[shift & (CTL | SHIFT)][data];
801027b5:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801027b8:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801027bb:	8b 04 85 80 74 10 80 	mov    -0x7fef8b80(,%eax,4),%eax
801027c2:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801027c6:	74 0b                	je     801027d3 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
801027c8:	8d 50 9f             	lea    -0x61(%eax),%edx
801027cb:	83 fa 19             	cmp    $0x19,%edx
801027ce:	77 48                	ja     80102818 <kbdgetc+0xb8>
      c += 'A' - 'a';
801027d0:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801027d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027d6:	c9                   	leave
801027d7:	c3                   	ret
801027d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027df:	90                   	nop
    shift |= E0ESC;
801027e0:	89 d8                	mov    %ebx,%eax
801027e2:	83 c8 40             	or     $0x40,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801027e5:	a3 7c 16 11 80       	mov    %eax,0x8011167c
    return 0;
801027ea:	31 c0                	xor    %eax,%eax
}
801027ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027ef:	c9                   	leave
801027f0:	c3                   	ret
801027f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    data = (shift & E0ESC ? data : data & 0x7F);
801027f8:	83 e0 7f             	and    $0x7f,%eax
801027fb:	85 d2                	test   %edx,%edx
801027fd:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102800:	0f b6 81 a0 75 10 80 	movzbl -0x7fef8a60(%ecx),%eax
80102807:	83 c8 40             	or     $0x40,%eax
8010280a:	0f b6 c0             	movzbl %al,%eax
8010280d:	f7 d0                	not    %eax
8010280f:	21 d8                	and    %ebx,%eax
    return 0;
80102811:	eb d2                	jmp    801027e5 <kbdgetc+0x85>
80102813:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102817:	90                   	nop
    else if('A' <= c && c <= 'Z')
80102818:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010281b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010281e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102821:	c9                   	leave
      c += 'a' - 'A';
80102822:	83 f9 1a             	cmp    $0x1a,%ecx
80102825:	0f 42 c2             	cmovb  %edx,%eax
}
80102828:	c3                   	ret
80102829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102830:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102835:	c3                   	ret
80102836:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010283d:	8d 76 00             	lea    0x0(%esi),%esi

80102840 <kbdintr>:

void
kbdintr(void)
{
80102840:	55                   	push   %ebp
80102841:	89 e5                	mov    %esp,%ebp
80102843:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102846:	68 60 27 10 80       	push   $0x80102760
8010284b:	e8 70 e0 ff ff       	call   801008c0 <consoleintr>
}
80102850:	83 c4 10             	add    $0x10,%esp
80102853:	c9                   	leave
80102854:	c3                   	ret
80102855:	66 90                	xchg   %ax,%ax
80102857:	66 90                	xchg   %ax,%ax
80102859:	66 90                	xchg   %ax,%ax
8010285b:	66 90                	xchg   %ax,%ax
8010285d:	66 90                	xchg   %ax,%ax
8010285f:	90                   	nop

80102860 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102860:	a1 80 16 11 80       	mov    0x80111680,%eax
80102865:	85 c0                	test   %eax,%eax
80102867:	0f 84 cb 00 00 00    	je     80102938 <lapicinit+0xd8>
  lapic[index] = value;
8010286d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102874:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102877:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010287a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102881:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102884:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102887:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010288e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102891:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102894:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010289b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010289e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028a1:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801028a8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028ab:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ae:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801028b5:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028b8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801028bb:	8b 50 30             	mov    0x30(%eax),%edx
801028be:	c1 ea 10             	shr    $0x10,%edx
801028c1:	81 e2 fc 00 00 00    	and    $0xfc,%edx
801028c7:	75 77                	jne    80102940 <lapicinit+0xe0>
  lapic[index] = value;
801028c9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801028d0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028d3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028d6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028dd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028e0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028e3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028ea:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028ed:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028f0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028f7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028fa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028fd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102904:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102907:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010290a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102911:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102914:	8b 50 20             	mov    0x20(%eax),%edx
80102917:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010291e:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102920:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102926:	80 e6 10             	and    $0x10,%dh
80102929:	75 f5                	jne    80102920 <lapicinit+0xc0>
  lapic[index] = value;
8010292b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102932:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102935:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102938:	c3                   	ret
80102939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102940:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102947:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010294a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010294d:	e9 77 ff ff ff       	jmp    801028c9 <lapicinit+0x69>
80102952:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102960 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102960:	a1 80 16 11 80       	mov    0x80111680,%eax
80102965:	85 c0                	test   %eax,%eax
80102967:	74 07                	je     80102970 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102969:	8b 40 20             	mov    0x20(%eax),%eax
8010296c:	c1 e8 18             	shr    $0x18,%eax
8010296f:	c3                   	ret
    return 0;
80102970:	31 c0                	xor    %eax,%eax
}
80102972:	c3                   	ret
80102973:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010297a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102980 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102980:	a1 80 16 11 80       	mov    0x80111680,%eax
80102985:	85 c0                	test   %eax,%eax
80102987:	74 0d                	je     80102996 <lapiceoi+0x16>
  lapic[index] = value;
80102989:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102990:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102993:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102996:	c3                   	ret
80102997:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010299e:	66 90                	xchg   %ax,%ax

801029a0 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
801029a0:	c3                   	ret
801029a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029af:	90                   	nop

801029b0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801029b0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029b1:	b8 0f 00 00 00       	mov    $0xf,%eax
801029b6:	ba 70 00 00 00       	mov    $0x70,%edx
801029bb:	89 e5                	mov    %esp,%ebp
801029bd:	53                   	push   %ebx
801029be:	8b 5d 08             	mov    0x8(%ebp),%ebx
801029c1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801029c4:	ee                   	out    %al,(%dx)
801029c5:	b8 0a 00 00 00       	mov    $0xa,%eax
801029ca:	ba 71 00 00 00       	mov    $0x71,%edx
801029cf:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801029d0:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
801029d2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801029d5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801029db:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801029dd:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
801029e0:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
801029e2:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
801029e5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801029e8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801029ee:	a1 80 16 11 80       	mov    0x80111680,%eax
801029f3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029f9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029fc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102a03:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a06:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a09:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102a10:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a13:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a16:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a1c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a1f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a25:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a28:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a2e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a31:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a37:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102a3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a3d:	c9                   	leave
80102a3e:	c3                   	ret
80102a3f:	90                   	nop

80102a40 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102a40:	55                   	push   %ebp
80102a41:	b8 0b 00 00 00       	mov    $0xb,%eax
80102a46:	ba 70 00 00 00       	mov    $0x70,%edx
80102a4b:	89 e5                	mov    %esp,%ebp
80102a4d:	57                   	push   %edi
80102a4e:	56                   	push   %esi
80102a4f:	53                   	push   %ebx
80102a50:	83 ec 4c             	sub    $0x4c,%esp
80102a53:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a54:	ba 71 00 00 00       	mov    $0x71,%edx
80102a59:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102a5a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a5d:	bf 70 00 00 00       	mov    $0x70,%edi
80102a62:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a65:	8d 76 00             	lea    0x0(%esi),%esi
80102a68:	31 c0                	xor    %eax,%eax
80102a6a:	89 fa                	mov    %edi,%edx
80102a6c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a6d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a72:	89 ca                	mov    %ecx,%edx
80102a74:	ec                   	in     (%dx),%al
80102a75:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a78:	89 fa                	mov    %edi,%edx
80102a7a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a7f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a80:	89 ca                	mov    %ecx,%edx
80102a82:	ec                   	in     (%dx),%al
80102a83:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a86:	89 fa                	mov    %edi,%edx
80102a88:	b8 04 00 00 00       	mov    $0x4,%eax
80102a8d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8e:	89 ca                	mov    %ecx,%edx
80102a90:	ec                   	in     (%dx),%al
80102a91:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a94:	89 fa                	mov    %edi,%edx
80102a96:	b8 07 00 00 00       	mov    $0x7,%eax
80102a9b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9c:	89 ca                	mov    %ecx,%edx
80102a9e:	ec                   	in     (%dx),%al
80102a9f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa2:	89 fa                	mov    %edi,%edx
80102aa4:	b8 08 00 00 00       	mov    $0x8,%eax
80102aa9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aaa:	89 ca                	mov    %ecx,%edx
80102aac:	ec                   	in     (%dx),%al
80102aad:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aaf:	89 fa                	mov    %edi,%edx
80102ab1:	b8 09 00 00 00       	mov    $0x9,%eax
80102ab6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ab7:	89 ca                	mov    %ecx,%edx
80102ab9:	ec                   	in     (%dx),%al
80102aba:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102abd:	89 fa                	mov    %edi,%edx
80102abf:	b8 0a 00 00 00       	mov    $0xa,%eax
80102ac4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ac5:	89 ca                	mov    %ecx,%edx
80102ac7:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102ac8:	84 c0                	test   %al,%al
80102aca:	78 9c                	js     80102a68 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102acc:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102ad0:	89 f2                	mov    %esi,%edx
80102ad2:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80102ad5:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad8:	89 fa                	mov    %edi,%edx
80102ada:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102add:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102ae1:	89 75 c8             	mov    %esi,-0x38(%ebp)
80102ae4:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102ae7:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102aeb:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102aee:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102af2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102af5:	31 c0                	xor    %eax,%eax
80102af7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102af8:	89 ca                	mov    %ecx,%edx
80102afa:	ec                   	in     (%dx),%al
80102afb:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102afe:	89 fa                	mov    %edi,%edx
80102b00:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102b03:	b8 02 00 00 00       	mov    $0x2,%eax
80102b08:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b09:	89 ca                	mov    %ecx,%edx
80102b0b:	ec                   	in     (%dx),%al
80102b0c:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b0f:	89 fa                	mov    %edi,%edx
80102b11:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102b14:	b8 04 00 00 00       	mov    $0x4,%eax
80102b19:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b1a:	89 ca                	mov    %ecx,%edx
80102b1c:	ec                   	in     (%dx),%al
80102b1d:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b20:	89 fa                	mov    %edi,%edx
80102b22:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102b25:	b8 07 00 00 00       	mov    $0x7,%eax
80102b2a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b2b:	89 ca                	mov    %ecx,%edx
80102b2d:	ec                   	in     (%dx),%al
80102b2e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b31:	89 fa                	mov    %edi,%edx
80102b33:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102b36:	b8 08 00 00 00       	mov    $0x8,%eax
80102b3b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b3c:	89 ca                	mov    %ecx,%edx
80102b3e:	ec                   	in     (%dx),%al
80102b3f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b42:	89 fa                	mov    %edi,%edx
80102b44:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102b47:	b8 09 00 00 00       	mov    $0x9,%eax
80102b4c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b4d:	89 ca                	mov    %ecx,%edx
80102b4f:	ec                   	in     (%dx),%al
80102b50:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b53:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102b56:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b59:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102b5c:	6a 18                	push   $0x18
80102b5e:	50                   	push   %eax
80102b5f:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b62:	50                   	push   %eax
80102b63:	e8 d8 1b 00 00       	call   80104740 <memcmp>
80102b68:	83 c4 10             	add    $0x10,%esp
80102b6b:	85 c0                	test   %eax,%eax
80102b6d:	0f 85 f5 fe ff ff    	jne    80102a68 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b73:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
80102b77:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b7a:	89 f0                	mov    %esi,%eax
80102b7c:	84 c0                	test   %al,%al
80102b7e:	75 78                	jne    80102bf8 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b80:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b83:	89 c2                	mov    %eax,%edx
80102b85:	83 e0 0f             	and    $0xf,%eax
80102b88:	c1 ea 04             	shr    $0x4,%edx
80102b8b:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b8e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b91:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b94:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b97:	89 c2                	mov    %eax,%edx
80102b99:	83 e0 0f             	and    $0xf,%eax
80102b9c:	c1 ea 04             	shr    $0x4,%edx
80102b9f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ba2:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ba5:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102ba8:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102bab:	89 c2                	mov    %eax,%edx
80102bad:	83 e0 0f             	and    $0xf,%eax
80102bb0:	c1 ea 04             	shr    $0x4,%edx
80102bb3:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bb6:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bb9:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102bbc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bbf:	89 c2                	mov    %eax,%edx
80102bc1:	83 e0 0f             	and    $0xf,%eax
80102bc4:	c1 ea 04             	shr    $0x4,%edx
80102bc7:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bca:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bcd:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102bd0:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bd3:	89 c2                	mov    %eax,%edx
80102bd5:	83 e0 0f             	and    $0xf,%eax
80102bd8:	c1 ea 04             	shr    $0x4,%edx
80102bdb:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bde:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102be1:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102be4:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102be7:	89 c2                	mov    %eax,%edx
80102be9:	83 e0 0f             	and    $0xf,%eax
80102bec:	c1 ea 04             	shr    $0x4,%edx
80102bef:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bf2:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bf5:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102bf8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102bfb:	89 03                	mov    %eax,(%ebx)
80102bfd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c00:	89 43 04             	mov    %eax,0x4(%ebx)
80102c03:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c06:	89 43 08             	mov    %eax,0x8(%ebx)
80102c09:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c0c:	89 43 0c             	mov    %eax,0xc(%ebx)
80102c0f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c12:	89 43 10             	mov    %eax,0x10(%ebx)
80102c15:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c18:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
80102c1b:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102c22:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c25:	5b                   	pop    %ebx
80102c26:	5e                   	pop    %esi
80102c27:	5f                   	pop    %edi
80102c28:	5d                   	pop    %ebp
80102c29:	c3                   	ret
80102c2a:	66 90                	xchg   %ax,%ax
80102c2c:	66 90                	xchg   %ax,%ax
80102c2e:	66 90                	xchg   %ax,%ax

80102c30 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c30:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102c36:	85 c9                	test   %ecx,%ecx
80102c38:	0f 8e 8a 00 00 00    	jle    80102cc8 <install_trans+0x98>
{
80102c3e:	55                   	push   %ebp
80102c3f:	89 e5                	mov    %esp,%ebp
80102c41:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102c42:	31 ff                	xor    %edi,%edi
{
80102c44:	56                   	push   %esi
80102c45:	53                   	push   %ebx
80102c46:	83 ec 0c             	sub    $0xc,%esp
80102c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102c50:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102c55:	83 ec 08             	sub    $0x8,%esp
80102c58:	01 f8                	add    %edi,%eax
80102c5a:	83 c0 01             	add    $0x1,%eax
80102c5d:	50                   	push   %eax
80102c5e:	ff 35 e4 16 11 80    	push   0x801116e4
80102c64:	e8 67 d4 ff ff       	call   801000d0 <bread>
80102c69:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c6b:	58                   	pop    %eax
80102c6c:	5a                   	pop    %edx
80102c6d:	ff 34 bd ec 16 11 80 	push   -0x7feee914(,%edi,4)
80102c74:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c7a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c7d:	e8 4e d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c82:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c85:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c87:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c8a:	68 00 02 00 00       	push   $0x200
80102c8f:	50                   	push   %eax
80102c90:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c93:	50                   	push   %eax
80102c94:	e8 f7 1a 00 00       	call   80104790 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c99:	89 1c 24             	mov    %ebx,(%esp)
80102c9c:	e8 0f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102ca1:	89 34 24             	mov    %esi,(%esp)
80102ca4:	e8 47 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102ca9:	89 1c 24             	mov    %ebx,(%esp)
80102cac:	e8 3f d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102cb1:	83 c4 10             	add    $0x10,%esp
80102cb4:	39 3d e8 16 11 80    	cmp    %edi,0x801116e8
80102cba:	7f 94                	jg     80102c50 <install_trans+0x20>
  }
}
80102cbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102cbf:	5b                   	pop    %ebx
80102cc0:	5e                   	pop    %esi
80102cc1:	5f                   	pop    %edi
80102cc2:	5d                   	pop    %ebp
80102cc3:	c3                   	ret
80102cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cc8:	c3                   	ret
80102cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102cd0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102cd0:	55                   	push   %ebp
80102cd1:	89 e5                	mov    %esp,%ebp
80102cd3:	53                   	push   %ebx
80102cd4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102cd7:	ff 35 d4 16 11 80    	push   0x801116d4
80102cdd:	ff 35 e4 16 11 80    	push   0x801116e4
80102ce3:	e8 e8 d3 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102ce8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ceb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102ced:	a1 e8 16 11 80       	mov    0x801116e8,%eax
80102cf2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102cf5:	85 c0                	test   %eax,%eax
80102cf7:	7e 19                	jle    80102d12 <write_head+0x42>
80102cf9:	31 d2                	xor    %edx,%edx
80102cfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cff:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102d00:	8b 0c 95 ec 16 11 80 	mov    -0x7feee914(,%edx,4),%ecx
80102d07:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d0b:	83 c2 01             	add    $0x1,%edx
80102d0e:	39 d0                	cmp    %edx,%eax
80102d10:	75 ee                	jne    80102d00 <write_head+0x30>
  }
  bwrite(buf);
80102d12:	83 ec 0c             	sub    $0xc,%esp
80102d15:	53                   	push   %ebx
80102d16:	e8 95 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102d1b:	89 1c 24             	mov    %ebx,(%esp)
80102d1e:	e8 cd d4 ff ff       	call   801001f0 <brelse>
}
80102d23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d26:	83 c4 10             	add    $0x10,%esp
80102d29:	c9                   	leave
80102d2a:	c3                   	ret
80102d2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d2f:	90                   	nop

80102d30 <initlog>:
{
80102d30:	55                   	push   %ebp
80102d31:	89 e5                	mov    %esp,%ebp
80102d33:	53                   	push   %ebx
80102d34:	83 ec 2c             	sub    $0x2c,%esp
80102d37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102d3a:	68 a0 76 10 80       	push   $0x801076a0
80102d3f:	68 a0 16 11 80       	push   $0x801116a0
80102d44:	e8 f7 16 00 00       	call   80104440 <initlock>
  readsb(dev, &sb);
80102d49:	58                   	pop    %eax
80102d4a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102d4d:	5a                   	pop    %edx
80102d4e:	50                   	push   %eax
80102d4f:	53                   	push   %ebx
80102d50:	e8 1b e8 ff ff       	call   80101570 <readsb>
  log.size = sb.nlog;
80102d55:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.dev = dev;
80102d5b:	89 1d e4 16 11 80    	mov    %ebx,0x801116e4
  log.start = sb.logstart;
80102d61:	a3 d4 16 11 80       	mov    %eax,0x801116d4
  log.size = sb.nlog;
80102d66:	89 15 d8 16 11 80    	mov    %edx,0x801116d8
  struct buf *buf = bread(log.dev, log.start);
80102d6c:	59                   	pop    %ecx
80102d6d:	5a                   	pop    %edx
80102d6e:	50                   	push   %eax
80102d6f:	53                   	push   %ebx
80102d70:	e8 5b d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d75:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d78:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d7b:	89 1d e8 16 11 80    	mov    %ebx,0x801116e8
  for (i = 0; i < log.lh.n; i++) {
80102d81:	85 db                	test   %ebx,%ebx
80102d83:	7e 1d                	jle    80102da2 <initlog+0x72>
80102d85:	31 d2                	xor    %edx,%edx
80102d87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d8e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102d90:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d94:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d9b:	83 c2 01             	add    $0x1,%edx
80102d9e:	39 d3                	cmp    %edx,%ebx
80102da0:	75 ee                	jne    80102d90 <initlog+0x60>
  brelse(buf);
80102da2:	83 ec 0c             	sub    $0xc,%esp
80102da5:	50                   	push   %eax
80102da6:	e8 45 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102dab:	e8 80 fe ff ff       	call   80102c30 <install_trans>
  log.lh.n = 0;
80102db0:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102db7:	00 00 00 
  write_head(); // clear the log
80102dba:	e8 11 ff ff ff       	call   80102cd0 <write_head>
}
80102dbf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dc2:	83 c4 10             	add    $0x10,%esp
80102dc5:	c9                   	leave
80102dc6:	c3                   	ret
80102dc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dce:	66 90                	xchg   %ax,%ax

80102dd0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102dd0:	55                   	push   %ebp
80102dd1:	89 e5                	mov    %esp,%ebp
80102dd3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102dd6:	68 a0 16 11 80       	push   $0x801116a0
80102ddb:	e8 40 18 00 00       	call   80104620 <acquire>
80102de0:	83 c4 10             	add    $0x10,%esp
80102de3:	eb 18                	jmp    80102dfd <begin_op+0x2d>
80102de5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102de8:	83 ec 08             	sub    $0x8,%esp
80102deb:	68 a0 16 11 80       	push   $0x801116a0
80102df0:	68 a0 16 11 80       	push   $0x801116a0
80102df5:	e8 b6 12 00 00       	call   801040b0 <sleep>
80102dfa:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102dfd:	a1 e0 16 11 80       	mov    0x801116e0,%eax
80102e02:	85 c0                	test   %eax,%eax
80102e04:	75 e2                	jne    80102de8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102e06:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102e0b:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102e11:	83 c0 01             	add    $0x1,%eax
80102e14:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102e17:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102e1a:	83 fa 1e             	cmp    $0x1e,%edx
80102e1d:	7f c9                	jg     80102de8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102e1f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102e22:	a3 dc 16 11 80       	mov    %eax,0x801116dc
      release(&log.lock);
80102e27:	68 a0 16 11 80       	push   $0x801116a0
80102e2c:	e8 8f 17 00 00       	call   801045c0 <release>
      break;
    }
  }
}
80102e31:	83 c4 10             	add    $0x10,%esp
80102e34:	c9                   	leave
80102e35:	c3                   	ret
80102e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e3d:	8d 76 00             	lea    0x0(%esi),%esi

80102e40 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	57                   	push   %edi
80102e44:	56                   	push   %esi
80102e45:	53                   	push   %ebx
80102e46:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102e49:	68 a0 16 11 80       	push   $0x801116a0
80102e4e:	e8 cd 17 00 00       	call   80104620 <acquire>
  log.outstanding -= 1;
80102e53:	a1 dc 16 11 80       	mov    0x801116dc,%eax
  if(log.committing)
80102e58:	8b 35 e0 16 11 80    	mov    0x801116e0,%esi
80102e5e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e61:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102e64:	89 1d dc 16 11 80    	mov    %ebx,0x801116dc
  if(log.committing)
80102e6a:	85 f6                	test   %esi,%esi
80102e6c:	0f 85 22 01 00 00    	jne    80102f94 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e72:	85 db                	test   %ebx,%ebx
80102e74:	0f 85 f6 00 00 00    	jne    80102f70 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e7a:	c7 05 e0 16 11 80 01 	movl   $0x1,0x801116e0
80102e81:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e84:	83 ec 0c             	sub    $0xc,%esp
80102e87:	68 a0 16 11 80       	push   $0x801116a0
80102e8c:	e8 2f 17 00 00       	call   801045c0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e91:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102e97:	83 c4 10             	add    $0x10,%esp
80102e9a:	85 c9                	test   %ecx,%ecx
80102e9c:	7f 42                	jg     80102ee0 <end_op+0xa0>
    acquire(&log.lock);
80102e9e:	83 ec 0c             	sub    $0xc,%esp
80102ea1:	68 a0 16 11 80       	push   $0x801116a0
80102ea6:	e8 75 17 00 00       	call   80104620 <acquire>
    log.committing = 0;
80102eab:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
80102eb2:	00 00 00 
    wakeup(&log);
80102eb5:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102ebc:	e8 af 12 00 00       	call   80104170 <wakeup>
    release(&log.lock);
80102ec1:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102ec8:	e8 f3 16 00 00       	call   801045c0 <release>
80102ecd:	83 c4 10             	add    $0x10,%esp
}
80102ed0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ed3:	5b                   	pop    %ebx
80102ed4:	5e                   	pop    %esi
80102ed5:	5f                   	pop    %edi
80102ed6:	5d                   	pop    %ebp
80102ed7:	c3                   	ret
80102ed8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102edf:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102ee0:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102ee5:	83 ec 08             	sub    $0x8,%esp
80102ee8:	01 d8                	add    %ebx,%eax
80102eea:	83 c0 01             	add    $0x1,%eax
80102eed:	50                   	push   %eax
80102eee:	ff 35 e4 16 11 80    	push   0x801116e4
80102ef4:	e8 d7 d1 ff ff       	call   801000d0 <bread>
80102ef9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102efb:	58                   	pop    %eax
80102efc:	5a                   	pop    %edx
80102efd:	ff 34 9d ec 16 11 80 	push   -0x7feee914(,%ebx,4)
80102f04:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102f0a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f0d:	e8 be d1 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102f12:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f15:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102f17:	8d 40 5c             	lea    0x5c(%eax),%eax
80102f1a:	68 00 02 00 00       	push   $0x200
80102f1f:	50                   	push   %eax
80102f20:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f23:	50                   	push   %eax
80102f24:	e8 67 18 00 00       	call   80104790 <memmove>
    bwrite(to);  // write the log
80102f29:	89 34 24             	mov    %esi,(%esp)
80102f2c:	e8 7f d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102f31:	89 3c 24             	mov    %edi,(%esp)
80102f34:	e8 b7 d2 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102f39:	89 34 24             	mov    %esi,(%esp)
80102f3c:	e8 af d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f41:	83 c4 10             	add    $0x10,%esp
80102f44:	3b 1d e8 16 11 80    	cmp    0x801116e8,%ebx
80102f4a:	7c 94                	jl     80102ee0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102f4c:	e8 7f fd ff ff       	call   80102cd0 <write_head>
    install_trans(); // Now install writes to home locations
80102f51:	e8 da fc ff ff       	call   80102c30 <install_trans>
    log.lh.n = 0;
80102f56:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102f5d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f60:	e8 6b fd ff ff       	call   80102cd0 <write_head>
80102f65:	e9 34 ff ff ff       	jmp    80102e9e <end_op+0x5e>
80102f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f70:	83 ec 0c             	sub    $0xc,%esp
80102f73:	68 a0 16 11 80       	push   $0x801116a0
80102f78:	e8 f3 11 00 00       	call   80104170 <wakeup>
  release(&log.lock);
80102f7d:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102f84:	e8 37 16 00 00       	call   801045c0 <release>
80102f89:	83 c4 10             	add    $0x10,%esp
}
80102f8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f8f:	5b                   	pop    %ebx
80102f90:	5e                   	pop    %esi
80102f91:	5f                   	pop    %edi
80102f92:	5d                   	pop    %ebp
80102f93:	c3                   	ret
    panic("log.committing");
80102f94:	83 ec 0c             	sub    $0xc,%esp
80102f97:	68 a4 76 10 80       	push   $0x801076a4
80102f9c:	e8 df d3 ff ff       	call   80100380 <panic>
80102fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fa8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102faf:	90                   	nop

80102fb0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102fb0:	55                   	push   %ebp
80102fb1:	89 e5                	mov    %esp,%ebp
80102fb3:	53                   	push   %ebx
80102fb4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102fb7:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
{
80102fbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102fc0:	83 fa 1d             	cmp    $0x1d,%edx
80102fc3:	7f 7d                	jg     80103042 <log_write+0x92>
80102fc5:	a1 d8 16 11 80       	mov    0x801116d8,%eax
80102fca:	83 e8 01             	sub    $0x1,%eax
80102fcd:	39 c2                	cmp    %eax,%edx
80102fcf:	7d 71                	jge    80103042 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102fd1:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102fd6:	85 c0                	test   %eax,%eax
80102fd8:	7e 75                	jle    8010304f <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102fda:	83 ec 0c             	sub    $0xc,%esp
80102fdd:	68 a0 16 11 80       	push   $0x801116a0
80102fe2:	e8 39 16 00 00       	call   80104620 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fe7:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102fea:	83 c4 10             	add    $0x10,%esp
80102fed:	31 c0                	xor    %eax,%eax
80102fef:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102ff5:	85 d2                	test   %edx,%edx
80102ff7:	7f 0e                	jg     80103007 <log_write+0x57>
80102ff9:	eb 15                	jmp    80103010 <log_write+0x60>
80102ffb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fff:	90                   	nop
80103000:	83 c0 01             	add    $0x1,%eax
80103003:	39 c2                	cmp    %eax,%edx
80103005:	74 29                	je     80103030 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103007:	39 0c 85 ec 16 11 80 	cmp    %ecx,-0x7feee914(,%eax,4)
8010300e:	75 f0                	jne    80103000 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103010:	89 0c 85 ec 16 11 80 	mov    %ecx,-0x7feee914(,%eax,4)
  if (i == log.lh.n)
80103017:	39 c2                	cmp    %eax,%edx
80103019:	74 1c                	je     80103037 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
8010301b:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010301e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80103021:	c7 45 08 a0 16 11 80 	movl   $0x801116a0,0x8(%ebp)
}
80103028:	c9                   	leave
  release(&log.lock);
80103029:	e9 92 15 00 00       	jmp    801045c0 <release>
8010302e:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
80103030:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
    log.lh.n++;
80103037:	83 c2 01             	add    $0x1,%edx
8010303a:	89 15 e8 16 11 80    	mov    %edx,0x801116e8
80103040:	eb d9                	jmp    8010301b <log_write+0x6b>
    panic("too big a transaction");
80103042:	83 ec 0c             	sub    $0xc,%esp
80103045:	68 b3 76 10 80       	push   $0x801076b3
8010304a:	e8 31 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010304f:	83 ec 0c             	sub    $0xc,%esp
80103052:	68 c9 76 10 80       	push   $0x801076c9
80103057:	e8 24 d3 ff ff       	call   80100380 <panic>
8010305c:	66 90                	xchg   %ax,%ax
8010305e:	66 90                	xchg   %ax,%ax

80103060 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103060:	55                   	push   %ebp
80103061:	89 e5                	mov    %esp,%ebp
80103063:	53                   	push   %ebx
80103064:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103067:	e8 64 09 00 00       	call   801039d0 <cpuid>
8010306c:	89 c3                	mov    %eax,%ebx
8010306e:	e8 5d 09 00 00       	call   801039d0 <cpuid>
80103073:	83 ec 04             	sub    $0x4,%esp
80103076:	53                   	push   %ebx
80103077:	50                   	push   %eax
80103078:	68 e4 76 10 80       	push   $0x801076e4
8010307d:	e8 2e d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103082:	e8 d9 28 00 00       	call   80105960 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103087:	e8 e4 08 00 00       	call   80103970 <mycpu>
8010308c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010308e:	b8 01 00 00 00       	mov    $0x1,%eax
80103093:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010309a:	e8 01 0c 00 00       	call   80103ca0 <scheduler>
8010309f:	90                   	nop

801030a0 <mpenter>:
{
801030a0:	55                   	push   %ebp
801030a1:	89 e5                	mov    %esp,%ebp
801030a3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801030a6:	e8 c5 39 00 00       	call   80106a70 <switchkvm>
  seginit();
801030ab:	e8 30 39 00 00       	call   801069e0 <seginit>
  lapicinit();
801030b0:	e8 ab f7 ff ff       	call   80102860 <lapicinit>
  mpmain();
801030b5:	e8 a6 ff ff ff       	call   80103060 <mpmain>
801030ba:	66 90                	xchg   %ax,%ax
801030bc:	66 90                	xchg   %ax,%ax
801030be:	66 90                	xchg   %ax,%ax

801030c0 <main>:
{
801030c0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801030c4:	83 e4 f0             	and    $0xfffffff0,%esp
801030c7:	ff 71 fc             	push   -0x4(%ecx)
801030ca:	55                   	push   %ebp
801030cb:	89 e5                	mov    %esp,%ebp
801030cd:	53                   	push   %ebx
801030ce:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801030cf:	83 ec 08             	sub    $0x8,%esp
801030d2:	68 00 00 40 80       	push   $0x80400000
801030d7:	68 d0 54 11 80       	push   $0x801154d0
801030dc:	e8 8f f5 ff ff       	call   80102670 <kinit1>
  kvmalloc();      // kernel page table
801030e1:	e8 4a 3e 00 00       	call   80106f30 <kvmalloc>
  mpinit();        // detect other processors
801030e6:	e8 85 01 00 00       	call   80103270 <mpinit>
  lapicinit();     // interrupt controller
801030eb:	e8 70 f7 ff ff       	call   80102860 <lapicinit>
  seginit();       // segment descriptors
801030f0:	e8 eb 38 00 00       	call   801069e0 <seginit>
  picinit();       // disable pic
801030f5:	e8 86 03 00 00       	call   80103480 <picinit>
  ioapicinit();    // another interrupt controller
801030fa:	e8 41 f3 ff ff       	call   80102440 <ioapicinit>
  consoleinit();   // console hardware
801030ff:	e8 8c d9 ff ff       	call   80100a90 <consoleinit>
  uartinit();      // serial port
80103104:	e8 47 2b 00 00       	call   80105c50 <uartinit>
  pinit();         // process table
80103109:	e8 42 08 00 00       	call   80103950 <pinit>
  tvinit();        // trap vectors
8010310e:	e8 cd 27 00 00       	call   801058e0 <tvinit>
  binit();         // buffer cache
80103113:	e8 28 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103118:	e8 43 dd ff ff       	call   80100e60 <fileinit>
  ideinit();       // disk 
8010311d:	e8 fe f0 ff ff       	call   80102220 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103122:	83 c4 0c             	add    $0xc,%esp
80103125:	68 8a 00 00 00       	push   $0x8a
8010312a:	68 8c a4 10 80       	push   $0x8010a48c
8010312f:	68 00 70 00 80       	push   $0x80007000
80103134:	e8 57 16 00 00       	call   80104790 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103139:	83 c4 10             	add    $0x10,%esp
8010313c:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
80103143:	00 00 00 
80103146:	05 a0 17 11 80       	add    $0x801117a0,%eax
8010314b:	3d a0 17 11 80       	cmp    $0x801117a0,%eax
80103150:	76 7e                	jbe    801031d0 <main+0x110>
80103152:	bb a0 17 11 80       	mov    $0x801117a0,%ebx
80103157:	eb 20                	jmp    80103179 <main+0xb9>
80103159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103160:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
80103167:	00 00 00 
8010316a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103170:	05 a0 17 11 80       	add    $0x801117a0,%eax
80103175:	39 c3                	cmp    %eax,%ebx
80103177:	73 57                	jae    801031d0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103179:	e8 f2 07 00 00       	call   80103970 <mycpu>
8010317e:	39 c3                	cmp    %eax,%ebx
80103180:	74 de                	je     80103160 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103182:	e8 59 f5 ff ff       	call   801026e0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103187:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010318a:	c7 05 f8 6f 00 80 a0 	movl   $0x801030a0,0x80006ff8
80103191:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103194:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010319b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010319e:	05 00 10 00 00       	add    $0x1000,%eax
801031a3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801031a8:	0f b6 03             	movzbl (%ebx),%eax
801031ab:	68 00 70 00 00       	push   $0x7000
801031b0:	50                   	push   %eax
801031b1:	e8 fa f7 ff ff       	call   801029b0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801031b6:	83 c4 10             	add    $0x10,%esp
801031b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031c0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801031c6:	85 c0                	test   %eax,%eax
801031c8:	74 f6                	je     801031c0 <main+0x100>
801031ca:	eb 94                	jmp    80103160 <main+0xa0>
801031cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801031d0:	83 ec 08             	sub    $0x8,%esp
801031d3:	68 00 00 00 8e       	push   $0x8e000000
801031d8:	68 00 00 40 80       	push   $0x80400000
801031dd:	e8 2e f4 ff ff       	call   80102610 <kinit2>
  userinit();      // first user process
801031e2:	e8 39 08 00 00       	call   80103a20 <userinit>
  mpmain();        // finish this processor's setup
801031e7:	e8 74 fe ff ff       	call   80103060 <mpmain>
801031ec:	66 90                	xchg   %ax,%ax
801031ee:	66 90                	xchg   %ax,%ax

801031f0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031f0:	55                   	push   %ebp
801031f1:	89 e5                	mov    %esp,%ebp
801031f3:	57                   	push   %edi
801031f4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801031f5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801031fb:	53                   	push   %ebx
  e = addr+len;
801031fc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801031ff:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103202:	39 de                	cmp    %ebx,%esi
80103204:	72 10                	jb     80103216 <mpsearch1+0x26>
80103206:	eb 50                	jmp    80103258 <mpsearch1+0x68>
80103208:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010320f:	90                   	nop
80103210:	89 fe                	mov    %edi,%esi
80103212:	39 df                	cmp    %ebx,%edi
80103214:	73 42                	jae    80103258 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103216:	83 ec 04             	sub    $0x4,%esp
80103219:	8d 7e 10             	lea    0x10(%esi),%edi
8010321c:	6a 04                	push   $0x4
8010321e:	68 f8 76 10 80       	push   $0x801076f8
80103223:	56                   	push   %esi
80103224:	e8 17 15 00 00       	call   80104740 <memcmp>
80103229:	83 c4 10             	add    $0x10,%esp
8010322c:	85 c0                	test   %eax,%eax
8010322e:	75 e0                	jne    80103210 <mpsearch1+0x20>
80103230:	89 f2                	mov    %esi,%edx
80103232:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103238:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010323b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010323e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103240:	39 fa                	cmp    %edi,%edx
80103242:	75 f4                	jne    80103238 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103244:	84 c0                	test   %al,%al
80103246:	75 c8                	jne    80103210 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103248:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010324b:	89 f0                	mov    %esi,%eax
8010324d:	5b                   	pop    %ebx
8010324e:	5e                   	pop    %esi
8010324f:	5f                   	pop    %edi
80103250:	5d                   	pop    %ebp
80103251:	c3                   	ret
80103252:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103258:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010325b:	31 f6                	xor    %esi,%esi
}
8010325d:	5b                   	pop    %ebx
8010325e:	89 f0                	mov    %esi,%eax
80103260:	5e                   	pop    %esi
80103261:	5f                   	pop    %edi
80103262:	5d                   	pop    %ebp
80103263:	c3                   	ret
80103264:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010326b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010326f:	90                   	nop

80103270 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103270:	55                   	push   %ebp
80103271:	89 e5                	mov    %esp,%ebp
80103273:	57                   	push   %edi
80103274:	56                   	push   %esi
80103275:	53                   	push   %ebx
80103276:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103279:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103280:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103287:	c1 e0 08             	shl    $0x8,%eax
8010328a:	09 d0                	or     %edx,%eax
8010328c:	c1 e0 04             	shl    $0x4,%eax
8010328f:	75 1b                	jne    801032ac <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103291:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103298:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010329f:	c1 e0 08             	shl    $0x8,%eax
801032a2:	09 d0                	or     %edx,%eax
801032a4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801032a7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801032ac:	ba 00 04 00 00       	mov    $0x400,%edx
801032b1:	e8 3a ff ff ff       	call   801031f0 <mpsearch1>
801032b6:	89 c3                	mov    %eax,%ebx
801032b8:	85 c0                	test   %eax,%eax
801032ba:	0f 84 50 01 00 00    	je     80103410 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032c0:	8b 73 04             	mov    0x4(%ebx),%esi
801032c3:	85 f6                	test   %esi,%esi
801032c5:	0f 84 35 01 00 00    	je     80103400 <mpinit+0x190>
  if(memcmp(conf, "PCMP", 4) != 0)
801032cb:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032ce:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801032d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801032d7:	6a 04                	push   $0x4
801032d9:	68 fd 76 10 80       	push   $0x801076fd
801032de:	50                   	push   %eax
801032df:	e8 5c 14 00 00       	call   80104740 <memcmp>
801032e4:	83 c4 10             	add    $0x10,%esp
801032e7:	85 c0                	test   %eax,%eax
801032e9:	0f 85 11 01 00 00    	jne    80103400 <mpinit+0x190>
  if(conf->version != 1 && conf->version != 4)
801032ef:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801032f6:	3c 01                	cmp    $0x1,%al
801032f8:	74 08                	je     80103302 <mpinit+0x92>
801032fa:	3c 04                	cmp    $0x4,%al
801032fc:	0f 85 fe 00 00 00    	jne    80103400 <mpinit+0x190>
  if(sum((uchar*)conf, conf->length) != 0)
80103302:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103309:	66 85 d2             	test   %dx,%dx
8010330c:	74 22                	je     80103330 <mpinit+0xc0>
8010330e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103311:	89 f0                	mov    %esi,%eax
  sum = 0;
80103313:	31 d2                	xor    %edx,%edx
80103315:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103318:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010331f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103322:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103324:	39 c7                	cmp    %eax,%edi
80103326:	75 f0                	jne    80103318 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103328:	84 d2                	test   %dl,%dl
8010332a:	0f 85 d0 00 00 00    	jne    80103400 <mpinit+0x190>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103330:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103336:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103339:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  lapic = (uint*)conf->lapicaddr;
8010333c:	a3 80 16 11 80       	mov    %eax,0x80111680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103341:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103348:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
8010334e:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103353:	01 d7                	add    %edx,%edi
80103355:	89 fa                	mov    %edi,%edx
80103357:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010335e:	66 90                	xchg   %ax,%ax
80103360:	39 d0                	cmp    %edx,%eax
80103362:	73 15                	jae    80103379 <mpinit+0x109>
    switch(*p){
80103364:	0f b6 08             	movzbl (%eax),%ecx
80103367:	80 f9 02             	cmp    $0x2,%cl
8010336a:	74 54                	je     801033c0 <mpinit+0x150>
8010336c:	77 42                	ja     801033b0 <mpinit+0x140>
8010336e:	84 c9                	test   %cl,%cl
80103370:	74 5e                	je     801033d0 <mpinit+0x160>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103372:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103375:	39 d0                	cmp    %edx,%eax
80103377:	72 eb                	jb     80103364 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103379:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010337c:	85 f6                	test   %esi,%esi
8010337e:	0f 84 e1 00 00 00    	je     80103465 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103384:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103388:	74 15                	je     8010339f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010338a:	b8 70 00 00 00       	mov    $0x70,%eax
8010338f:	ba 22 00 00 00       	mov    $0x22,%edx
80103394:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103395:	ba 23 00 00 00       	mov    $0x23,%edx
8010339a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010339b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010339e:	ee                   	out    %al,(%dx)
  }
}
8010339f:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033a2:	5b                   	pop    %ebx
801033a3:	5e                   	pop    %esi
801033a4:	5f                   	pop    %edi
801033a5:	5d                   	pop    %ebp
801033a6:	c3                   	ret
801033a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033ae:	66 90                	xchg   %ax,%ax
    switch(*p){
801033b0:	83 e9 03             	sub    $0x3,%ecx
801033b3:	80 f9 01             	cmp    $0x1,%cl
801033b6:	76 ba                	jbe    80103372 <mpinit+0x102>
801033b8:	31 f6                	xor    %esi,%esi
801033ba:	eb a4                	jmp    80103360 <mpinit+0xf0>
801033bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801033c0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801033c4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801033c7:	88 0d 80 17 11 80    	mov    %cl,0x80111780
      continue;
801033cd:	eb 91                	jmp    80103360 <mpinit+0xf0>
801033cf:	90                   	nop
      if(ncpu < NCPU) {
801033d0:	8b 0d 84 17 11 80    	mov    0x80111784,%ecx
801033d6:	83 f9 07             	cmp    $0x7,%ecx
801033d9:	7f 19                	jg     801033f4 <mpinit+0x184>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033db:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
801033e1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801033e5:	83 c1 01             	add    $0x1,%ecx
801033e8:	89 0d 84 17 11 80    	mov    %ecx,0x80111784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033ee:	88 9f a0 17 11 80    	mov    %bl,-0x7feee860(%edi)
      p += sizeof(struct mpproc);
801033f4:	83 c0 14             	add    $0x14,%eax
      continue;
801033f7:	e9 64 ff ff ff       	jmp    80103360 <mpinit+0xf0>
801033fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103400:	83 ec 0c             	sub    $0xc,%esp
80103403:	68 02 77 10 80       	push   $0x80107702
80103408:	e8 73 cf ff ff       	call   80100380 <panic>
8010340d:	8d 76 00             	lea    0x0(%esi),%esi
{
80103410:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80103415:	eb 13                	jmp    8010342a <mpinit+0x1ba>
80103417:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010341e:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
80103420:	89 f3                	mov    %esi,%ebx
80103422:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103428:	74 d6                	je     80103400 <mpinit+0x190>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010342a:	83 ec 04             	sub    $0x4,%esp
8010342d:	8d 73 10             	lea    0x10(%ebx),%esi
80103430:	6a 04                	push   $0x4
80103432:	68 f8 76 10 80       	push   $0x801076f8
80103437:	53                   	push   %ebx
80103438:	e8 03 13 00 00       	call   80104740 <memcmp>
8010343d:	83 c4 10             	add    $0x10,%esp
80103440:	85 c0                	test   %eax,%eax
80103442:	75 dc                	jne    80103420 <mpinit+0x1b0>
80103444:	89 da                	mov    %ebx,%edx
80103446:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010344d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103450:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103453:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103456:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103458:	39 f2                	cmp    %esi,%edx
8010345a:	75 f4                	jne    80103450 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010345c:	84 c0                	test   %al,%al
8010345e:	75 c0                	jne    80103420 <mpinit+0x1b0>
80103460:	e9 5b fe ff ff       	jmp    801032c0 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103465:	83 ec 0c             	sub    $0xc,%esp
80103468:	68 1c 77 10 80       	push   $0x8010771c
8010346d:	e8 0e cf ff ff       	call   80100380 <panic>
80103472:	66 90                	xchg   %ax,%ax
80103474:	66 90                	xchg   %ax,%ax
80103476:	66 90                	xchg   %ax,%ax
80103478:	66 90                	xchg   %ax,%ax
8010347a:	66 90                	xchg   %ax,%ax
8010347c:	66 90                	xchg   %ax,%ax
8010347e:	66 90                	xchg   %ax,%ax

80103480 <picinit>:
80103480:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103485:	ba 21 00 00 00       	mov    $0x21,%edx
8010348a:	ee                   	out    %al,(%dx)
8010348b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103490:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103491:	c3                   	ret
80103492:	66 90                	xchg   %ax,%ax
80103494:	66 90                	xchg   %ax,%ax
80103496:	66 90                	xchg   %ax,%ax
80103498:	66 90                	xchg   %ax,%ax
8010349a:	66 90                	xchg   %ax,%ax
8010349c:	66 90                	xchg   %ax,%ax
8010349e:	66 90                	xchg   %ax,%ax

801034a0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801034a0:	55                   	push   %ebp
801034a1:	89 e5                	mov    %esp,%ebp
801034a3:	57                   	push   %edi
801034a4:	56                   	push   %esi
801034a5:	53                   	push   %ebx
801034a6:	83 ec 0c             	sub    $0xc,%esp
801034a9:	8b 75 08             	mov    0x8(%ebp),%esi
801034ac:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801034af:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
801034b5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801034bb:	e8 c0 d9 ff ff       	call   80100e80 <filealloc>
801034c0:	89 06                	mov    %eax,(%esi)
801034c2:	85 c0                	test   %eax,%eax
801034c4:	0f 84 a5 00 00 00    	je     8010356f <pipealloc+0xcf>
801034ca:	e8 b1 d9 ff ff       	call   80100e80 <filealloc>
801034cf:	89 07                	mov    %eax,(%edi)
801034d1:	85 c0                	test   %eax,%eax
801034d3:	0f 84 84 00 00 00    	je     8010355d <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801034d9:	e8 02 f2 ff ff       	call   801026e0 <kalloc>
801034de:	89 c3                	mov    %eax,%ebx
801034e0:	85 c0                	test   %eax,%eax
801034e2:	0f 84 a0 00 00 00    	je     80103588 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
801034e8:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801034ef:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801034f2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801034f5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801034fc:	00 00 00 
  p->nwrite = 0;
801034ff:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103506:	00 00 00 
  p->nread = 0;
80103509:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103510:	00 00 00 
  initlock(&p->lock, "pipe");
80103513:	68 3b 77 10 80       	push   $0x8010773b
80103518:	50                   	push   %eax
80103519:	e8 22 0f 00 00       	call   80104440 <initlock>
  (*f0)->type = FD_PIPE;
8010351e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103520:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103523:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103529:	8b 06                	mov    (%esi),%eax
8010352b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010352f:	8b 06                	mov    (%esi),%eax
80103531:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103535:	8b 06                	mov    (%esi),%eax
80103537:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010353a:	8b 07                	mov    (%edi),%eax
8010353c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103542:	8b 07                	mov    (%edi),%eax
80103544:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103548:	8b 07                	mov    (%edi),%eax
8010354a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010354e:	8b 07                	mov    (%edi),%eax
80103550:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
80103553:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103555:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103558:	5b                   	pop    %ebx
80103559:	5e                   	pop    %esi
8010355a:	5f                   	pop    %edi
8010355b:	5d                   	pop    %ebp
8010355c:	c3                   	ret
  if(*f0)
8010355d:	8b 06                	mov    (%esi),%eax
8010355f:	85 c0                	test   %eax,%eax
80103561:	74 1e                	je     80103581 <pipealloc+0xe1>
    fileclose(*f0);
80103563:	83 ec 0c             	sub    $0xc,%esp
80103566:	50                   	push   %eax
80103567:	e8 d4 d9 ff ff       	call   80100f40 <fileclose>
8010356c:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010356f:	8b 07                	mov    (%edi),%eax
80103571:	85 c0                	test   %eax,%eax
80103573:	74 0c                	je     80103581 <pipealloc+0xe1>
    fileclose(*f1);
80103575:	83 ec 0c             	sub    $0xc,%esp
80103578:	50                   	push   %eax
80103579:	e8 c2 d9 ff ff       	call   80100f40 <fileclose>
8010357e:	83 c4 10             	add    $0x10,%esp
  return -1;
80103581:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103586:	eb cd                	jmp    80103555 <pipealloc+0xb5>
  if(*f0)
80103588:	8b 06                	mov    (%esi),%eax
8010358a:	85 c0                	test   %eax,%eax
8010358c:	75 d5                	jne    80103563 <pipealloc+0xc3>
8010358e:	eb df                	jmp    8010356f <pipealloc+0xcf>

80103590 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103590:	55                   	push   %ebp
80103591:	89 e5                	mov    %esp,%ebp
80103593:	56                   	push   %esi
80103594:	53                   	push   %ebx
80103595:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103598:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010359b:	83 ec 0c             	sub    $0xc,%esp
8010359e:	53                   	push   %ebx
8010359f:	e8 7c 10 00 00       	call   80104620 <acquire>
  if(writable){
801035a4:	83 c4 10             	add    $0x10,%esp
801035a7:	85 f6                	test   %esi,%esi
801035a9:	74 65                	je     80103610 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
801035ab:	83 ec 0c             	sub    $0xc,%esp
801035ae:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801035b4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801035bb:	00 00 00 
    wakeup(&p->nread);
801035be:	50                   	push   %eax
801035bf:	e8 ac 0b 00 00       	call   80104170 <wakeup>
801035c4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801035c7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801035cd:	85 d2                	test   %edx,%edx
801035cf:	75 0a                	jne    801035db <pipeclose+0x4b>
801035d1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801035d7:	85 c0                	test   %eax,%eax
801035d9:	74 15                	je     801035f0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801035db:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801035de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035e1:	5b                   	pop    %ebx
801035e2:	5e                   	pop    %esi
801035e3:	5d                   	pop    %ebp
    release(&p->lock);
801035e4:	e9 d7 0f 00 00       	jmp    801045c0 <release>
801035e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801035f0:	83 ec 0c             	sub    $0xc,%esp
801035f3:	53                   	push   %ebx
801035f4:	e8 c7 0f 00 00       	call   801045c0 <release>
    kfree((char*)p);
801035f9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801035fc:	83 c4 10             	add    $0x10,%esp
}
801035ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103602:	5b                   	pop    %ebx
80103603:	5e                   	pop    %esi
80103604:	5d                   	pop    %ebp
    kfree((char*)p);
80103605:	e9 16 ef ff ff       	jmp    80102520 <kfree>
8010360a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103610:	83 ec 0c             	sub    $0xc,%esp
80103613:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103619:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103620:	00 00 00 
    wakeup(&p->nwrite);
80103623:	50                   	push   %eax
80103624:	e8 47 0b 00 00       	call   80104170 <wakeup>
80103629:	83 c4 10             	add    $0x10,%esp
8010362c:	eb 99                	jmp    801035c7 <pipeclose+0x37>
8010362e:	66 90                	xchg   %ax,%ax

80103630 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103630:	55                   	push   %ebp
80103631:	89 e5                	mov    %esp,%ebp
80103633:	57                   	push   %edi
80103634:	56                   	push   %esi
80103635:	53                   	push   %ebx
80103636:	83 ec 28             	sub    $0x28,%esp
80103639:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010363c:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
8010363f:	53                   	push   %ebx
80103640:	e8 db 0f 00 00       	call   80104620 <acquire>
  for(i = 0; i < n; i++){
80103645:	83 c4 10             	add    $0x10,%esp
80103648:	85 ff                	test   %edi,%edi
8010364a:	0f 8e ce 00 00 00    	jle    8010371e <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103650:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103656:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103659:	89 7d 10             	mov    %edi,0x10(%ebp)
8010365c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010365f:	8d 34 39             	lea    (%ecx,%edi,1),%esi
80103662:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103665:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010366b:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103671:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103677:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
8010367d:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
80103680:	0f 85 b6 00 00 00    	jne    8010373c <pipewrite+0x10c>
80103686:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103689:	eb 3b                	jmp    801036c6 <pipewrite+0x96>
8010368b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010368f:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
80103690:	e8 5b 03 00 00       	call   801039f0 <myproc>
80103695:	8b 48 24             	mov    0x24(%eax),%ecx
80103698:	85 c9                	test   %ecx,%ecx
8010369a:	75 34                	jne    801036d0 <pipewrite+0xa0>
      wakeup(&p->nread);
8010369c:	83 ec 0c             	sub    $0xc,%esp
8010369f:	56                   	push   %esi
801036a0:	e8 cb 0a 00 00       	call   80104170 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801036a5:	58                   	pop    %eax
801036a6:	5a                   	pop    %edx
801036a7:	53                   	push   %ebx
801036a8:	57                   	push   %edi
801036a9:	e8 02 0a 00 00       	call   801040b0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036ae:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801036b4:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801036ba:	83 c4 10             	add    $0x10,%esp
801036bd:	05 00 02 00 00       	add    $0x200,%eax
801036c2:	39 c2                	cmp    %eax,%edx
801036c4:	75 2a                	jne    801036f0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801036c6:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801036cc:	85 c0                	test   %eax,%eax
801036ce:	75 c0                	jne    80103690 <pipewrite+0x60>
        release(&p->lock);
801036d0:	83 ec 0c             	sub    $0xc,%esp
801036d3:	53                   	push   %ebx
801036d4:	e8 e7 0e 00 00       	call   801045c0 <release>
        return -1;
801036d9:	83 c4 10             	add    $0x10,%esp
801036dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801036e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036e4:	5b                   	pop    %ebx
801036e5:	5e                   	pop    %esi
801036e6:	5f                   	pop    %edi
801036e7:	5d                   	pop    %ebp
801036e8:	c3                   	ret
801036e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036f0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036f3:	8d 42 01             	lea    0x1(%edx),%eax
801036f6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
801036fc:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036ff:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103705:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103708:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
8010370c:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103710:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103713:	39 c1                	cmp    %eax,%ecx
80103715:	0f 85 50 ff ff ff    	jne    8010366b <pipewrite+0x3b>
8010371b:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010371e:	83 ec 0c             	sub    $0xc,%esp
80103721:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103727:	50                   	push   %eax
80103728:	e8 43 0a 00 00       	call   80104170 <wakeup>
  release(&p->lock);
8010372d:	89 1c 24             	mov    %ebx,(%esp)
80103730:	e8 8b 0e 00 00       	call   801045c0 <release>
  return n;
80103735:	83 c4 10             	add    $0x10,%esp
80103738:	89 f8                	mov    %edi,%eax
8010373a:	eb a5                	jmp    801036e1 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010373c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010373f:	eb b2                	jmp    801036f3 <pipewrite+0xc3>
80103741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103748:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010374f:	90                   	nop

80103750 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103750:	55                   	push   %ebp
80103751:	89 e5                	mov    %esp,%ebp
80103753:	57                   	push   %edi
80103754:	56                   	push   %esi
80103755:	53                   	push   %ebx
80103756:	83 ec 18             	sub    $0x18,%esp
80103759:	8b 75 08             	mov    0x8(%ebp),%esi
8010375c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010375f:	56                   	push   %esi
80103760:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103766:	e8 b5 0e 00 00       	call   80104620 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010376b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103771:	83 c4 10             	add    $0x10,%esp
80103774:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010377a:	74 2f                	je     801037ab <piperead+0x5b>
8010377c:	eb 37                	jmp    801037b5 <piperead+0x65>
8010377e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103780:	e8 6b 02 00 00       	call   801039f0 <myproc>
80103785:	8b 48 24             	mov    0x24(%eax),%ecx
80103788:	85 c9                	test   %ecx,%ecx
8010378a:	0f 85 80 00 00 00    	jne    80103810 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103790:	83 ec 08             	sub    $0x8,%esp
80103793:	56                   	push   %esi
80103794:	53                   	push   %ebx
80103795:	e8 16 09 00 00       	call   801040b0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010379a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
801037a0:	83 c4 10             	add    $0x10,%esp
801037a3:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
801037a9:	75 0a                	jne    801037b5 <piperead+0x65>
801037ab:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
801037b1:	85 c0                	test   %eax,%eax
801037b3:	75 cb                	jne    80103780 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037b5:	8b 55 10             	mov    0x10(%ebp),%edx
801037b8:	31 db                	xor    %ebx,%ebx
801037ba:	85 d2                	test   %edx,%edx
801037bc:	7f 20                	jg     801037de <piperead+0x8e>
801037be:	eb 2c                	jmp    801037ec <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801037c0:	8d 48 01             	lea    0x1(%eax),%ecx
801037c3:	25 ff 01 00 00       	and    $0x1ff,%eax
801037c8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801037ce:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801037d3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037d6:	83 c3 01             	add    $0x1,%ebx
801037d9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801037dc:	74 0e                	je     801037ec <piperead+0x9c>
    if(p->nread == p->nwrite)
801037de:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801037e4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801037ea:	75 d4                	jne    801037c0 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801037ec:	83 ec 0c             	sub    $0xc,%esp
801037ef:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801037f5:	50                   	push   %eax
801037f6:	e8 75 09 00 00       	call   80104170 <wakeup>
  release(&p->lock);
801037fb:	89 34 24             	mov    %esi,(%esp)
801037fe:	e8 bd 0d 00 00       	call   801045c0 <release>
  return i;
80103803:	83 c4 10             	add    $0x10,%esp
}
80103806:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103809:	89 d8                	mov    %ebx,%eax
8010380b:	5b                   	pop    %ebx
8010380c:	5e                   	pop    %esi
8010380d:	5f                   	pop    %edi
8010380e:	5d                   	pop    %ebp
8010380f:	c3                   	ret
      release(&p->lock);
80103810:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103813:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103818:	56                   	push   %esi
80103819:	e8 a2 0d 00 00       	call   801045c0 <release>
      return -1;
8010381e:	83 c4 10             	add    $0x10,%esp
}
80103821:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103824:	89 d8                	mov    %ebx,%eax
80103826:	5b                   	pop    %ebx
80103827:	5e                   	pop    %esi
80103828:	5f                   	pop    %edi
80103829:	5d                   	pop    %ebp
8010382a:	c3                   	ret
8010382b:	66 90                	xchg   %ax,%ax
8010382d:	66 90                	xchg   %ax,%ax
8010382f:	90                   	nop

80103830 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103830:	55                   	push   %ebp
80103831:	89 e5                	mov    %esp,%ebp
80103833:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103834:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
{
80103839:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010383c:	68 20 1d 11 80       	push   $0x80111d20
80103841:	e8 da 0d 00 00       	call   80104620 <acquire>
80103846:	83 c4 10             	add    $0x10,%esp
80103849:	eb 10                	jmp    8010385b <allocproc+0x2b>
8010384b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010384f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103850:	83 c3 7c             	add    $0x7c,%ebx
80103853:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
80103859:	74 75                	je     801038d0 <allocproc+0xa0>
    if(p->state == UNUSED)
8010385b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010385e:	85 c0                	test   %eax,%eax
80103860:	75 ee                	jne    80103850 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103862:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103867:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010386a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103871:	8d 50 01             	lea    0x1(%eax),%edx
80103874:	89 43 10             	mov    %eax,0x10(%ebx)
80103877:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
8010387d:	68 20 1d 11 80       	push   $0x80111d20
80103882:	e8 39 0d 00 00       	call   801045c0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103887:	e8 54 ee ff ff       	call   801026e0 <kalloc>
8010388c:	83 c4 10             	add    $0x10,%esp
8010388f:	89 43 08             	mov    %eax,0x8(%ebx)
80103892:	85 c0                	test   %eax,%eax
80103894:	74 53                	je     801038e9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103896:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010389c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010389f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801038a4:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801038a7:	c7 40 14 d2 58 10 80 	movl   $0x801058d2,0x14(%eax)
  p->context = (struct context*)sp;
801038ae:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801038b1:	6a 14                	push   $0x14
801038b3:	6a 00                	push   $0x0
801038b5:	50                   	push   %eax
801038b6:	e8 45 0e 00 00       	call   80104700 <memset>
  p->context->eip = (uint)forkret;
801038bb:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801038be:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801038c1:	c7 40 10 00 39 10 80 	movl   $0x80103900,0x10(%eax)
}
801038c8:	89 d8                	mov    %ebx,%eax
801038ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038cd:	c9                   	leave
801038ce:	c3                   	ret
801038cf:	90                   	nop
  release(&ptable.lock);
801038d0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801038d3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801038d5:	68 20 1d 11 80       	push   $0x80111d20
801038da:	e8 e1 0c 00 00       	call   801045c0 <release>
  return 0;
801038df:	83 c4 10             	add    $0x10,%esp
}
801038e2:	89 d8                	mov    %ebx,%eax
801038e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038e7:	c9                   	leave
801038e8:	c3                   	ret
    p->state = UNUSED;
801038e9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  return 0;
801038f0:	31 db                	xor    %ebx,%ebx
801038f2:	eb ee                	jmp    801038e2 <allocproc+0xb2>
801038f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038ff:	90                   	nop

80103900 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103906:	68 20 1d 11 80       	push   $0x80111d20
8010390b:	e8 b0 0c 00 00       	call   801045c0 <release>

  if (first) {
80103910:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103915:	83 c4 10             	add    $0x10,%esp
80103918:	85 c0                	test   %eax,%eax
8010391a:	75 04                	jne    80103920 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010391c:	c9                   	leave
8010391d:	c3                   	ret
8010391e:	66 90                	xchg   %ax,%ax
    first = 0;
80103920:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103927:	00 00 00 
    iinit(ROOTDEV);
8010392a:	83 ec 0c             	sub    $0xc,%esp
8010392d:	6a 01                	push   $0x1
8010392f:	e8 7c dc ff ff       	call   801015b0 <iinit>
    initlog(ROOTDEV);
80103934:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010393b:	e8 f0 f3 ff ff       	call   80102d30 <initlog>
}
80103940:	83 c4 10             	add    $0x10,%esp
80103943:	c9                   	leave
80103944:	c3                   	ret
80103945:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010394c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103950 <pinit>:
{
80103950:	55                   	push   %ebp
80103951:	89 e5                	mov    %esp,%ebp
80103953:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103956:	68 40 77 10 80       	push   $0x80107740
8010395b:	68 20 1d 11 80       	push   $0x80111d20
80103960:	e8 db 0a 00 00       	call   80104440 <initlock>
}
80103965:	83 c4 10             	add    $0x10,%esp
80103968:	c9                   	leave
80103969:	c3                   	ret
8010396a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103970 <mycpu>:
{
80103970:	55                   	push   %ebp
80103971:	89 e5                	mov    %esp,%ebp
80103973:	56                   	push   %esi
80103974:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103975:	9c                   	pushf
80103976:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103977:	f6 c4 02             	test   $0x2,%ah
8010397a:	75 46                	jne    801039c2 <mycpu+0x52>
  apicid = lapicid();
8010397c:	e8 df ef ff ff       	call   80102960 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103981:	8b 35 84 17 11 80    	mov    0x80111784,%esi
80103987:	85 f6                	test   %esi,%esi
80103989:	7e 2a                	jle    801039b5 <mycpu+0x45>
8010398b:	31 d2                	xor    %edx,%edx
8010398d:	eb 08                	jmp    80103997 <mycpu+0x27>
8010398f:	90                   	nop
80103990:	83 c2 01             	add    $0x1,%edx
80103993:	39 f2                	cmp    %esi,%edx
80103995:	74 1e                	je     801039b5 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103997:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010399d:	0f b6 99 a0 17 11 80 	movzbl -0x7feee860(%ecx),%ebx
801039a4:	39 c3                	cmp    %eax,%ebx
801039a6:	75 e8                	jne    80103990 <mycpu+0x20>
}
801039a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
801039ab:	8d 81 a0 17 11 80    	lea    -0x7feee860(%ecx),%eax
}
801039b1:	5b                   	pop    %ebx
801039b2:	5e                   	pop    %esi
801039b3:	5d                   	pop    %ebp
801039b4:	c3                   	ret
  panic("unknown apicid\n");
801039b5:	83 ec 0c             	sub    $0xc,%esp
801039b8:	68 47 77 10 80       	push   $0x80107747
801039bd:	e8 be c9 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
801039c2:	83 ec 0c             	sub    $0xc,%esp
801039c5:	68 24 78 10 80       	push   $0x80107824
801039ca:	e8 b1 c9 ff ff       	call   80100380 <panic>
801039cf:	90                   	nop

801039d0 <cpuid>:
cpuid() {
801039d0:	55                   	push   %ebp
801039d1:	89 e5                	mov    %esp,%ebp
801039d3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801039d6:	e8 95 ff ff ff       	call   80103970 <mycpu>
}
801039db:	c9                   	leave
  return mycpu()-cpus;
801039dc:	2d a0 17 11 80       	sub    $0x801117a0,%eax
801039e1:	c1 f8 04             	sar    $0x4,%eax
801039e4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801039ea:	c3                   	ret
801039eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039ef:	90                   	nop

801039f0 <myproc>:
myproc(void) {
801039f0:	55                   	push   %ebp
801039f1:	89 e5                	mov    %esp,%ebp
801039f3:	53                   	push   %ebx
801039f4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801039f7:	e8 d4 0a 00 00       	call   801044d0 <pushcli>
  c = mycpu();
801039fc:	e8 6f ff ff ff       	call   80103970 <mycpu>
  p = c->proc;
80103a01:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a07:	e8 14 0b 00 00       	call   80104520 <popcli>
}
80103a0c:	89 d8                	mov    %ebx,%eax
80103a0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a11:	c9                   	leave
80103a12:	c3                   	ret
80103a13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a20 <userinit>:
{
80103a20:	55                   	push   %ebp
80103a21:	89 e5                	mov    %esp,%ebp
80103a23:	53                   	push   %ebx
80103a24:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103a27:	e8 04 fe ff ff       	call   80103830 <allocproc>
80103a2c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103a2e:	a3 54 3c 11 80       	mov    %eax,0x80113c54
  if((p->pgdir = setupkvm()) == 0)
80103a33:	e8 78 34 00 00       	call   80106eb0 <setupkvm>
80103a38:	89 43 04             	mov    %eax,0x4(%ebx)
80103a3b:	85 c0                	test   %eax,%eax
80103a3d:	0f 84 bd 00 00 00    	je     80103b00 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a43:	83 ec 04             	sub    $0x4,%esp
80103a46:	68 2c 00 00 00       	push   $0x2c
80103a4b:	68 60 a4 10 80       	push   $0x8010a460
80103a50:	50                   	push   %eax
80103a51:	e8 3a 31 00 00       	call   80106b90 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a56:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a59:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a5f:	6a 4c                	push   $0x4c
80103a61:	6a 00                	push   $0x0
80103a63:	ff 73 18             	push   0x18(%ebx)
80103a66:	e8 95 0c 00 00       	call   80104700 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a6b:	8b 43 18             	mov    0x18(%ebx),%eax
80103a6e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a73:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a76:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a7b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a7f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a82:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a86:	8b 43 18             	mov    0x18(%ebx),%eax
80103a89:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a8d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a91:	8b 43 18             	mov    0x18(%ebx),%eax
80103a94:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a98:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a9c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a9f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103aa6:	8b 43 18             	mov    0x18(%ebx),%eax
80103aa9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103ab0:	8b 43 18             	mov    0x18(%ebx),%eax
80103ab3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103aba:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103abd:	6a 10                	push   $0x10
80103abf:	68 70 77 10 80       	push   $0x80107770
80103ac4:	50                   	push   %eax
80103ac5:	e8 e6 0d 00 00       	call   801048b0 <safestrcpy>
  p->cwd = namei("/");
80103aca:	c7 04 24 79 77 10 80 	movl   $0x80107779,(%esp)
80103ad1:	e8 2a e6 ff ff       	call   80102100 <namei>
80103ad6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103ad9:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103ae0:	e8 3b 0b 00 00       	call   80104620 <acquire>
  p->state = RUNNABLE;
80103ae5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103aec:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103af3:	e8 c8 0a 00 00       	call   801045c0 <release>
}
80103af8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103afb:	83 c4 10             	add    $0x10,%esp
80103afe:	c9                   	leave
80103aff:	c3                   	ret
    panic("userinit: out of memory?");
80103b00:	83 ec 0c             	sub    $0xc,%esp
80103b03:	68 57 77 10 80       	push   $0x80107757
80103b08:	e8 73 c8 ff ff       	call   80100380 <panic>
80103b0d:	8d 76 00             	lea    0x0(%esi),%esi

80103b10 <growproc>:
{
80103b10:	55                   	push   %ebp
80103b11:	89 e5                	mov    %esp,%ebp
80103b13:	56                   	push   %esi
80103b14:	53                   	push   %ebx
80103b15:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103b18:	e8 b3 09 00 00       	call   801044d0 <pushcli>
  c = mycpu();
80103b1d:	e8 4e fe ff ff       	call   80103970 <mycpu>
  p = c->proc;
80103b22:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b28:	e8 f3 09 00 00       	call   80104520 <popcli>
  sz = curproc->sz;
80103b2d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103b2f:	85 f6                	test   %esi,%esi
80103b31:	7f 1d                	jg     80103b50 <growproc+0x40>
  } else if(n < 0){
80103b33:	75 3b                	jne    80103b70 <growproc+0x60>
  switchuvm(curproc);
80103b35:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103b38:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103b3a:	53                   	push   %ebx
80103b3b:	e8 40 2f 00 00       	call   80106a80 <switchuvm>
  return 0;
80103b40:	83 c4 10             	add    $0x10,%esp
80103b43:	31 c0                	xor    %eax,%eax
}
80103b45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b48:	5b                   	pop    %ebx
80103b49:	5e                   	pop    %esi
80103b4a:	5d                   	pop    %ebp
80103b4b:	c3                   	ret
80103b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b50:	83 ec 04             	sub    $0x4,%esp
80103b53:	01 c6                	add    %eax,%esi
80103b55:	56                   	push   %esi
80103b56:	50                   	push   %eax
80103b57:	ff 73 04             	push   0x4(%ebx)
80103b5a:	e8 81 31 00 00       	call   80106ce0 <allocuvm>
80103b5f:	83 c4 10             	add    $0x10,%esp
80103b62:	85 c0                	test   %eax,%eax
80103b64:	75 cf                	jne    80103b35 <growproc+0x25>
      return -1;
80103b66:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b6b:	eb d8                	jmp    80103b45 <growproc+0x35>
80103b6d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b70:	83 ec 04             	sub    $0x4,%esp
80103b73:	01 c6                	add    %eax,%esi
80103b75:	56                   	push   %esi
80103b76:	50                   	push   %eax
80103b77:	ff 73 04             	push   0x4(%ebx)
80103b7a:	e8 81 32 00 00       	call   80106e00 <deallocuvm>
80103b7f:	83 c4 10             	add    $0x10,%esp
80103b82:	85 c0                	test   %eax,%eax
80103b84:	75 af                	jne    80103b35 <growproc+0x25>
80103b86:	eb de                	jmp    80103b66 <growproc+0x56>
80103b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b8f:	90                   	nop

80103b90 <fork>:
{
80103b90:	55                   	push   %ebp
80103b91:	89 e5                	mov    %esp,%ebp
80103b93:	57                   	push   %edi
80103b94:	56                   	push   %esi
80103b95:	53                   	push   %ebx
80103b96:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b99:	e8 32 09 00 00       	call   801044d0 <pushcli>
  c = mycpu();
80103b9e:	e8 cd fd ff ff       	call   80103970 <mycpu>
  p = c->proc;
80103ba3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ba9:	e8 72 09 00 00       	call   80104520 <popcli>
  if((np = allocproc()) == 0){
80103bae:	e8 7d fc ff ff       	call   80103830 <allocproc>
80103bb3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103bb6:	85 c0                	test   %eax,%eax
80103bb8:	0f 84 d6 00 00 00    	je     80103c94 <fork+0x104>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103bbe:	83 ec 08             	sub    $0x8,%esp
80103bc1:	ff 33                	push   (%ebx)
80103bc3:	89 c7                	mov    %eax,%edi
80103bc5:	ff 73 04             	push   0x4(%ebx)
80103bc8:	e8 d3 33 00 00       	call   80106fa0 <copyuvm>
80103bcd:	83 c4 10             	add    $0x10,%esp
80103bd0:	89 47 04             	mov    %eax,0x4(%edi)
80103bd3:	85 c0                	test   %eax,%eax
80103bd5:	0f 84 9a 00 00 00    	je     80103c75 <fork+0xe5>
  np->sz = curproc->sz;
80103bdb:	8b 03                	mov    (%ebx),%eax
80103bdd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103be0:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103be2:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103be5:	89 c8                	mov    %ecx,%eax
80103be7:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103bea:	b9 13 00 00 00       	mov    $0x13,%ecx
80103bef:	8b 73 18             	mov    0x18(%ebx),%esi
80103bf2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103bf4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103bf6:	8b 40 18             	mov    0x18(%eax),%eax
80103bf9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103c00:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103c04:	85 c0                	test   %eax,%eax
80103c06:	74 13                	je     80103c1b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103c08:	83 ec 0c             	sub    $0xc,%esp
80103c0b:	50                   	push   %eax
80103c0c:	e8 df d2 ff ff       	call   80100ef0 <filedup>
80103c11:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103c14:	83 c4 10             	add    $0x10,%esp
80103c17:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103c1b:	83 c6 01             	add    $0x1,%esi
80103c1e:	83 fe 10             	cmp    $0x10,%esi
80103c21:	75 dd                	jne    80103c00 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103c23:	83 ec 0c             	sub    $0xc,%esp
80103c26:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c29:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103c2c:	e8 6f db ff ff       	call   801017a0 <idup>
80103c31:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c34:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103c37:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c3a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103c3d:	6a 10                	push   $0x10
80103c3f:	53                   	push   %ebx
80103c40:	50                   	push   %eax
80103c41:	e8 6a 0c 00 00       	call   801048b0 <safestrcpy>
  pid = np->pid;
80103c46:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103c49:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103c50:	e8 cb 09 00 00       	call   80104620 <acquire>
  np->state = RUNNABLE;
80103c55:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103c5c:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103c63:	e8 58 09 00 00       	call   801045c0 <release>
  return pid;
80103c68:	83 c4 10             	add    $0x10,%esp
}
80103c6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c6e:	89 d8                	mov    %ebx,%eax
80103c70:	5b                   	pop    %ebx
80103c71:	5e                   	pop    %esi
80103c72:	5f                   	pop    %edi
80103c73:	5d                   	pop    %ebp
80103c74:	c3                   	ret
    kfree(np->kstack);
80103c75:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c78:	83 ec 0c             	sub    $0xc,%esp
80103c7b:	ff 73 08             	push   0x8(%ebx)
80103c7e:	e8 9d e8 ff ff       	call   80102520 <kfree>
    np->kstack = 0;
80103c83:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103c8a:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103c8d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c94:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c99:	eb d0                	jmp    80103c6b <fork+0xdb>
80103c9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c9f:	90                   	nop

80103ca0 <scheduler>:
{
80103ca0:	55                   	push   %ebp
80103ca1:	89 e5                	mov    %esp,%ebp
80103ca3:	57                   	push   %edi
80103ca4:	56                   	push   %esi
80103ca5:	53                   	push   %ebx
80103ca6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103ca9:	e8 c2 fc ff ff       	call   80103970 <mycpu>
  c->proc = 0;
80103cae:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103cb5:	00 00 00 
  struct cpu *c = mycpu();
80103cb8:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103cba:	8d 78 04             	lea    0x4(%eax),%edi
80103cbd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103cc0:	fb                   	sti
    acquire(&ptable.lock);
80103cc1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cc4:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
    acquire(&ptable.lock);
80103cc9:	68 20 1d 11 80       	push   $0x80111d20
80103cce:	e8 4d 09 00 00       	call   80104620 <acquire>
80103cd3:	83 c4 10             	add    $0x10,%esp
80103cd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cdd:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103ce0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103ce4:	75 33                	jne    80103d19 <scheduler+0x79>
      switchuvm(p);
80103ce6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103ce9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103cef:	53                   	push   %ebx
80103cf0:	e8 8b 2d 00 00       	call   80106a80 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103cf5:	58                   	pop    %eax
80103cf6:	5a                   	pop    %edx
80103cf7:	ff 73 1c             	push   0x1c(%ebx)
80103cfa:	57                   	push   %edi
      p->state = RUNNING;
80103cfb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103d02:	e8 04 0c 00 00       	call   8010490b <swtch>
      switchkvm();
80103d07:	e8 64 2d 00 00       	call   80106a70 <switchkvm>
      c->proc = 0;
80103d0c:	83 c4 10             	add    $0x10,%esp
80103d0f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103d16:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d19:	83 c3 7c             	add    $0x7c,%ebx
80103d1c:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
80103d22:	75 bc                	jne    80103ce0 <scheduler+0x40>
    release(&ptable.lock);
80103d24:	83 ec 0c             	sub    $0xc,%esp
80103d27:	68 20 1d 11 80       	push   $0x80111d20
80103d2c:	e8 8f 08 00 00       	call   801045c0 <release>
    sti();
80103d31:	83 c4 10             	add    $0x10,%esp
80103d34:	eb 8a                	jmp    80103cc0 <scheduler+0x20>
80103d36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d3d:	8d 76 00             	lea    0x0(%esi),%esi

80103d40 <sched>:
{
80103d40:	55                   	push   %ebp
80103d41:	89 e5                	mov    %esp,%ebp
80103d43:	56                   	push   %esi
80103d44:	53                   	push   %ebx
  pushcli();
80103d45:	e8 86 07 00 00       	call   801044d0 <pushcli>
  c = mycpu();
80103d4a:	e8 21 fc ff ff       	call   80103970 <mycpu>
  p = c->proc;
80103d4f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d55:	e8 c6 07 00 00       	call   80104520 <popcli>
  if(!holding(&ptable.lock))
80103d5a:	83 ec 0c             	sub    $0xc,%esp
80103d5d:	68 20 1d 11 80       	push   $0x80111d20
80103d62:	e8 19 08 00 00       	call   80104580 <holding>
80103d67:	83 c4 10             	add    $0x10,%esp
80103d6a:	85 c0                	test   %eax,%eax
80103d6c:	74 4f                	je     80103dbd <sched+0x7d>
  if(mycpu()->ncli != 1)
80103d6e:	e8 fd fb ff ff       	call   80103970 <mycpu>
80103d73:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103d7a:	75 68                	jne    80103de4 <sched+0xa4>
  if(p->state == RUNNING)
80103d7c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103d80:	74 55                	je     80103dd7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d82:	9c                   	pushf
80103d83:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d84:	f6 c4 02             	test   $0x2,%ah
80103d87:	75 41                	jne    80103dca <sched+0x8a>
  intena = mycpu()->intena;
80103d89:	e8 e2 fb ff ff       	call   80103970 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103d8e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103d91:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103d97:	e8 d4 fb ff ff       	call   80103970 <mycpu>
80103d9c:	83 ec 08             	sub    $0x8,%esp
80103d9f:	ff 70 04             	push   0x4(%eax)
80103da2:	53                   	push   %ebx
80103da3:	e8 63 0b 00 00       	call   8010490b <swtch>
  mycpu()->intena = intena;
80103da8:	e8 c3 fb ff ff       	call   80103970 <mycpu>
}
80103dad:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103db0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103db6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103db9:	5b                   	pop    %ebx
80103dba:	5e                   	pop    %esi
80103dbb:	5d                   	pop    %ebp
80103dbc:	c3                   	ret
    panic("sched ptable.lock");
80103dbd:	83 ec 0c             	sub    $0xc,%esp
80103dc0:	68 7b 77 10 80       	push   $0x8010777b
80103dc5:	e8 b6 c5 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103dca:	83 ec 0c             	sub    $0xc,%esp
80103dcd:	68 a7 77 10 80       	push   $0x801077a7
80103dd2:	e8 a9 c5 ff ff       	call   80100380 <panic>
    panic("sched running");
80103dd7:	83 ec 0c             	sub    $0xc,%esp
80103dda:	68 99 77 10 80       	push   $0x80107799
80103ddf:	e8 9c c5 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103de4:	83 ec 0c             	sub    $0xc,%esp
80103de7:	68 8d 77 10 80       	push   $0x8010778d
80103dec:	e8 8f c5 ff ff       	call   80100380 <panic>
80103df1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103df8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dff:	90                   	nop

80103e00 <exit>:
{
80103e00:	55                   	push   %ebp
80103e01:	89 e5                	mov    %esp,%ebp
80103e03:	57                   	push   %edi
80103e04:	56                   	push   %esi
80103e05:	53                   	push   %ebx
80103e06:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103e09:	e8 e2 fb ff ff       	call   801039f0 <myproc>
  if(curproc == initproc)
80103e0e:	39 05 54 3c 11 80    	cmp    %eax,0x80113c54
80103e14:	0f 84 fd 00 00 00    	je     80103f17 <exit+0x117>
80103e1a:	89 c3                	mov    %eax,%ebx
80103e1c:	8d 70 28             	lea    0x28(%eax),%esi
80103e1f:	8d 78 68             	lea    0x68(%eax),%edi
80103e22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103e28:	8b 06                	mov    (%esi),%eax
80103e2a:	85 c0                	test   %eax,%eax
80103e2c:	74 12                	je     80103e40 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103e2e:	83 ec 0c             	sub    $0xc,%esp
80103e31:	50                   	push   %eax
80103e32:	e8 09 d1 ff ff       	call   80100f40 <fileclose>
      curproc->ofile[fd] = 0;
80103e37:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103e3d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103e40:	83 c6 04             	add    $0x4,%esi
80103e43:	39 f7                	cmp    %esi,%edi
80103e45:	75 e1                	jne    80103e28 <exit+0x28>
  begin_op();
80103e47:	e8 84 ef ff ff       	call   80102dd0 <begin_op>
  iput(curproc->cwd);
80103e4c:	83 ec 0c             	sub    $0xc,%esp
80103e4f:	ff 73 68             	push   0x68(%ebx)
80103e52:	e8 a9 da ff ff       	call   80101900 <iput>
  end_op();
80103e57:	e8 e4 ef ff ff       	call   80102e40 <end_op>
  curproc->cwd = 0;
80103e5c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103e63:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103e6a:	e8 b1 07 00 00       	call   80104620 <acquire>
  wakeup1(curproc->parent);
80103e6f:	8b 53 14             	mov    0x14(%ebx),%edx
80103e72:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e75:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103e7a:	eb 0e                	jmp    80103e8a <exit+0x8a>
80103e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e80:	83 c0 7c             	add    $0x7c,%eax
80103e83:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80103e88:	74 1c                	je     80103ea6 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103e8a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e8e:	75 f0                	jne    80103e80 <exit+0x80>
80103e90:	3b 50 20             	cmp    0x20(%eax),%edx
80103e93:	75 eb                	jne    80103e80 <exit+0x80>
      p->state = RUNNABLE;
80103e95:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e9c:	83 c0 7c             	add    $0x7c,%eax
80103e9f:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80103ea4:	75 e4                	jne    80103e8a <exit+0x8a>
      p->parent = initproc;
80103ea6:	8b 0d 54 3c 11 80    	mov    0x80113c54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103eac:	ba 54 1d 11 80       	mov    $0x80111d54,%edx
80103eb1:	eb 10                	jmp    80103ec3 <exit+0xc3>
80103eb3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103eb7:	90                   	nop
80103eb8:	83 c2 7c             	add    $0x7c,%edx
80103ebb:	81 fa 54 3c 11 80    	cmp    $0x80113c54,%edx
80103ec1:	74 3b                	je     80103efe <exit+0xfe>
    if(p->parent == curproc){
80103ec3:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103ec6:	75 f0                	jne    80103eb8 <exit+0xb8>
      if(p->state == ZOMBIE)
80103ec8:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103ecc:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103ecf:	75 e7                	jne    80103eb8 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ed1:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103ed6:	eb 12                	jmp    80103eea <exit+0xea>
80103ed8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103edf:	90                   	nop
80103ee0:	83 c0 7c             	add    $0x7c,%eax
80103ee3:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80103ee8:	74 ce                	je     80103eb8 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80103eea:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103eee:	75 f0                	jne    80103ee0 <exit+0xe0>
80103ef0:	3b 48 20             	cmp    0x20(%eax),%ecx
80103ef3:	75 eb                	jne    80103ee0 <exit+0xe0>
      p->state = RUNNABLE;
80103ef5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103efc:	eb e2                	jmp    80103ee0 <exit+0xe0>
  curproc->state = ZOMBIE;
80103efe:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103f05:	e8 36 fe ff ff       	call   80103d40 <sched>
  panic("zombie exit");
80103f0a:	83 ec 0c             	sub    $0xc,%esp
80103f0d:	68 c8 77 10 80       	push   $0x801077c8
80103f12:	e8 69 c4 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103f17:	83 ec 0c             	sub    $0xc,%esp
80103f1a:	68 bb 77 10 80       	push   $0x801077bb
80103f1f:	e8 5c c4 ff ff       	call   80100380 <panic>
80103f24:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f2f:	90                   	nop

80103f30 <wait>:
{
80103f30:	55                   	push   %ebp
80103f31:	89 e5                	mov    %esp,%ebp
80103f33:	56                   	push   %esi
80103f34:	53                   	push   %ebx
  pushcli();
80103f35:	e8 96 05 00 00       	call   801044d0 <pushcli>
  c = mycpu();
80103f3a:	e8 31 fa ff ff       	call   80103970 <mycpu>
  p = c->proc;
80103f3f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f45:	e8 d6 05 00 00       	call   80104520 <popcli>
  acquire(&ptable.lock);
80103f4a:	83 ec 0c             	sub    $0xc,%esp
80103f4d:	68 20 1d 11 80       	push   $0x80111d20
80103f52:	e8 c9 06 00 00       	call   80104620 <acquire>
80103f57:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103f5a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f5c:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103f61:	eb 10                	jmp    80103f73 <wait+0x43>
80103f63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f67:	90                   	nop
80103f68:	83 c3 7c             	add    $0x7c,%ebx
80103f6b:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
80103f71:	74 1b                	je     80103f8e <wait+0x5e>
      if(p->parent != curproc)
80103f73:	39 73 14             	cmp    %esi,0x14(%ebx)
80103f76:	75 f0                	jne    80103f68 <wait+0x38>
      if(p->state == ZOMBIE){
80103f78:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103f7c:	74 62                	je     80103fe0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f7e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80103f81:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f86:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
80103f8c:	75 e5                	jne    80103f73 <wait+0x43>
    if(!havekids || curproc->killed){
80103f8e:	85 c0                	test   %eax,%eax
80103f90:	0f 84 a0 00 00 00    	je     80104036 <wait+0x106>
80103f96:	8b 46 24             	mov    0x24(%esi),%eax
80103f99:	85 c0                	test   %eax,%eax
80103f9b:	0f 85 95 00 00 00    	jne    80104036 <wait+0x106>
  pushcli();
80103fa1:	e8 2a 05 00 00       	call   801044d0 <pushcli>
  c = mycpu();
80103fa6:	e8 c5 f9 ff ff       	call   80103970 <mycpu>
  p = c->proc;
80103fab:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fb1:	e8 6a 05 00 00       	call   80104520 <popcli>
  if(p == 0)
80103fb6:	85 db                	test   %ebx,%ebx
80103fb8:	0f 84 8f 00 00 00    	je     8010404d <wait+0x11d>
  p->chan = chan;
80103fbe:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80103fc1:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103fc8:	e8 73 fd ff ff       	call   80103d40 <sched>
  p->chan = 0;
80103fcd:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103fd4:	eb 84                	jmp    80103f5a <wait+0x2a>
80103fd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fdd:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
80103fe0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80103fe3:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103fe6:	ff 73 08             	push   0x8(%ebx)
80103fe9:	e8 32 e5 ff ff       	call   80102520 <kfree>
        p->kstack = 0;
80103fee:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103ff5:	5a                   	pop    %edx
80103ff6:	ff 73 04             	push   0x4(%ebx)
80103ff9:	e8 32 2e 00 00       	call   80106e30 <freevm>
        p->pid = 0;
80103ffe:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104005:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010400c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104010:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104017:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010401e:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80104025:	e8 96 05 00 00       	call   801045c0 <release>
        return pid;
8010402a:	83 c4 10             	add    $0x10,%esp
}
8010402d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104030:	89 f0                	mov    %esi,%eax
80104032:	5b                   	pop    %ebx
80104033:	5e                   	pop    %esi
80104034:	5d                   	pop    %ebp
80104035:	c3                   	ret
      release(&ptable.lock);
80104036:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104039:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010403e:	68 20 1d 11 80       	push   $0x80111d20
80104043:	e8 78 05 00 00       	call   801045c0 <release>
      return -1;
80104048:	83 c4 10             	add    $0x10,%esp
8010404b:	eb e0                	jmp    8010402d <wait+0xfd>
    panic("sleep");
8010404d:	83 ec 0c             	sub    $0xc,%esp
80104050:	68 d4 77 10 80       	push   $0x801077d4
80104055:	e8 26 c3 ff ff       	call   80100380 <panic>
8010405a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104060 <yield>:
{
80104060:	55                   	push   %ebp
80104061:	89 e5                	mov    %esp,%ebp
80104063:	53                   	push   %ebx
80104064:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104067:	68 20 1d 11 80       	push   $0x80111d20
8010406c:	e8 af 05 00 00       	call   80104620 <acquire>
  pushcli();
80104071:	e8 5a 04 00 00       	call   801044d0 <pushcli>
  c = mycpu();
80104076:	e8 f5 f8 ff ff       	call   80103970 <mycpu>
  p = c->proc;
8010407b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104081:	e8 9a 04 00 00       	call   80104520 <popcli>
  myproc()->state = RUNNABLE;
80104086:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010408d:	e8 ae fc ff ff       	call   80103d40 <sched>
  release(&ptable.lock);
80104092:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80104099:	e8 22 05 00 00       	call   801045c0 <release>
}
8010409e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040a1:	83 c4 10             	add    $0x10,%esp
801040a4:	c9                   	leave
801040a5:	c3                   	ret
801040a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040ad:	8d 76 00             	lea    0x0(%esi),%esi

801040b0 <sleep>:
{
801040b0:	55                   	push   %ebp
801040b1:	89 e5                	mov    %esp,%ebp
801040b3:	57                   	push   %edi
801040b4:	56                   	push   %esi
801040b5:	53                   	push   %ebx
801040b6:	83 ec 0c             	sub    $0xc,%esp
801040b9:	8b 7d 08             	mov    0x8(%ebp),%edi
801040bc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801040bf:	e8 0c 04 00 00       	call   801044d0 <pushcli>
  c = mycpu();
801040c4:	e8 a7 f8 ff ff       	call   80103970 <mycpu>
  p = c->proc;
801040c9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040cf:	e8 4c 04 00 00       	call   80104520 <popcli>
  if(p == 0)
801040d4:	85 db                	test   %ebx,%ebx
801040d6:	0f 84 87 00 00 00    	je     80104163 <sleep+0xb3>
  if(lk == 0)
801040dc:	85 f6                	test   %esi,%esi
801040de:	74 76                	je     80104156 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801040e0:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
801040e6:	74 50                	je     80104138 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801040e8:	83 ec 0c             	sub    $0xc,%esp
801040eb:	68 20 1d 11 80       	push   $0x80111d20
801040f0:	e8 2b 05 00 00       	call   80104620 <acquire>
    release(lk);
801040f5:	89 34 24             	mov    %esi,(%esp)
801040f8:	e8 c3 04 00 00       	call   801045c0 <release>
  p->chan = chan;
801040fd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104100:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104107:	e8 34 fc ff ff       	call   80103d40 <sched>
  p->chan = 0;
8010410c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104113:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
8010411a:	e8 a1 04 00 00       	call   801045c0 <release>
    acquire(lk);
8010411f:	89 75 08             	mov    %esi,0x8(%ebp)
80104122:	83 c4 10             	add    $0x10,%esp
}
80104125:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104128:	5b                   	pop    %ebx
80104129:	5e                   	pop    %esi
8010412a:	5f                   	pop    %edi
8010412b:	5d                   	pop    %ebp
    acquire(lk);
8010412c:	e9 ef 04 00 00       	jmp    80104620 <acquire>
80104131:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104138:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010413b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104142:	e8 f9 fb ff ff       	call   80103d40 <sched>
  p->chan = 0;
80104147:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010414e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104151:	5b                   	pop    %ebx
80104152:	5e                   	pop    %esi
80104153:	5f                   	pop    %edi
80104154:	5d                   	pop    %ebp
80104155:	c3                   	ret
    panic("sleep without lk");
80104156:	83 ec 0c             	sub    $0xc,%esp
80104159:	68 da 77 10 80       	push   $0x801077da
8010415e:	e8 1d c2 ff ff       	call   80100380 <panic>
    panic("sleep");
80104163:	83 ec 0c             	sub    $0xc,%esp
80104166:	68 d4 77 10 80       	push   $0x801077d4
8010416b:	e8 10 c2 ff ff       	call   80100380 <panic>

80104170 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104170:	55                   	push   %ebp
80104171:	89 e5                	mov    %esp,%ebp
80104173:	53                   	push   %ebx
80104174:	83 ec 10             	sub    $0x10,%esp
80104177:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010417a:	68 20 1d 11 80       	push   $0x80111d20
8010417f:	e8 9c 04 00 00       	call   80104620 <acquire>
80104184:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104187:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
8010418c:	eb 0c                	jmp    8010419a <wakeup+0x2a>
8010418e:	66 90                	xchg   %ax,%ax
80104190:	83 c0 7c             	add    $0x7c,%eax
80104193:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80104198:	74 1c                	je     801041b6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010419a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010419e:	75 f0                	jne    80104190 <wakeup+0x20>
801041a0:	3b 58 20             	cmp    0x20(%eax),%ebx
801041a3:	75 eb                	jne    80104190 <wakeup+0x20>
      p->state = RUNNABLE;
801041a5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041ac:	83 c0 7c             	add    $0x7c,%eax
801041af:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
801041b4:	75 e4                	jne    8010419a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
801041b6:	c7 45 08 20 1d 11 80 	movl   $0x80111d20,0x8(%ebp)
}
801041bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041c0:	c9                   	leave
  release(&ptable.lock);
801041c1:	e9 fa 03 00 00       	jmp    801045c0 <release>
801041c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041cd:	8d 76 00             	lea    0x0(%esi),%esi

801041d0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801041d0:	55                   	push   %ebp
801041d1:	89 e5                	mov    %esp,%ebp
801041d3:	53                   	push   %ebx
801041d4:	83 ec 10             	sub    $0x10,%esp
801041d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801041da:	68 20 1d 11 80       	push   $0x80111d20
801041df:	e8 3c 04 00 00       	call   80104620 <acquire>
801041e4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041e7:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
801041ec:	eb 0c                	jmp    801041fa <kill+0x2a>
801041ee:	66 90                	xchg   %ax,%ax
801041f0:	83 c0 7c             	add    $0x7c,%eax
801041f3:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
801041f8:	74 36                	je     80104230 <kill+0x60>
    if(p->pid == pid){
801041fa:	39 58 10             	cmp    %ebx,0x10(%eax)
801041fd:	75 f1                	jne    801041f0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801041ff:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104203:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010420a:	75 07                	jne    80104213 <kill+0x43>
        p->state = RUNNABLE;
8010420c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104213:	83 ec 0c             	sub    $0xc,%esp
80104216:	68 20 1d 11 80       	push   $0x80111d20
8010421b:	e8 a0 03 00 00       	call   801045c0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104220:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104223:	83 c4 10             	add    $0x10,%esp
80104226:	31 c0                	xor    %eax,%eax
}
80104228:	c9                   	leave
80104229:	c3                   	ret
8010422a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104230:	83 ec 0c             	sub    $0xc,%esp
80104233:	68 20 1d 11 80       	push   $0x80111d20
80104238:	e8 83 03 00 00       	call   801045c0 <release>
}
8010423d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104240:	83 c4 10             	add    $0x10,%esp
80104243:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104248:	c9                   	leave
80104249:	c3                   	ret
8010424a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104250 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	57                   	push   %edi
80104254:	56                   	push   %esi
80104255:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104258:	53                   	push   %ebx
80104259:	bb c0 1d 11 80       	mov    $0x80111dc0,%ebx
8010425e:	83 ec 3c             	sub    $0x3c,%esp
80104261:	eb 24                	jmp    80104287 <procdump+0x37>
80104263:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104267:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104268:	83 ec 0c             	sub    $0xc,%esp
8010426b:	68 5b 7b 10 80       	push   $0x80107b5b
80104270:	e8 3b c4 ff ff       	call   801006b0 <cprintf>
80104275:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104278:	83 c3 7c             	add    $0x7c,%ebx
8010427b:	81 fb c0 3c 11 80    	cmp    $0x80113cc0,%ebx
80104281:	0f 84 81 00 00 00    	je     80104308 <procdump+0xb8>
    if(p->state == UNUSED)
80104287:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010428a:	85 c0                	test   %eax,%eax
8010428c:	74 ea                	je     80104278 <procdump+0x28>
      state = "???";
8010428e:	ba eb 77 10 80       	mov    $0x801077eb,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104293:	83 f8 05             	cmp    $0x5,%eax
80104296:	77 11                	ja     801042a9 <procdump+0x59>
80104298:	8b 14 85 4c 78 10 80 	mov    -0x7fef87b4(,%eax,4),%edx
      state = "???";
8010429f:	b8 eb 77 10 80       	mov    $0x801077eb,%eax
801042a4:	85 d2                	test   %edx,%edx
801042a6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801042a9:	53                   	push   %ebx
801042aa:	52                   	push   %edx
801042ab:	ff 73 a4             	push   -0x5c(%ebx)
801042ae:	68 ef 77 10 80       	push   $0x801077ef
801042b3:	e8 f8 c3 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
801042b8:	83 c4 10             	add    $0x10,%esp
801042bb:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801042bf:	75 a7                	jne    80104268 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801042c1:	83 ec 08             	sub    $0x8,%esp
801042c4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801042c7:	8d 7d c0             	lea    -0x40(%ebp),%edi
801042ca:	50                   	push   %eax
801042cb:	8b 43 b0             	mov    -0x50(%ebx),%eax
801042ce:	8b 40 0c             	mov    0xc(%eax),%eax
801042d1:	83 c0 08             	add    $0x8,%eax
801042d4:	50                   	push   %eax
801042d5:	e8 86 01 00 00       	call   80104460 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801042da:	83 c4 10             	add    $0x10,%esp
801042dd:	8d 76 00             	lea    0x0(%esi),%esi
801042e0:	8b 17                	mov    (%edi),%edx
801042e2:	85 d2                	test   %edx,%edx
801042e4:	74 82                	je     80104268 <procdump+0x18>
        cprintf(" %p", pc[i]);
801042e6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801042e9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801042ec:	52                   	push   %edx
801042ed:	68 41 72 10 80       	push   $0x80107241
801042f2:	e8 b9 c3 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801042f7:	83 c4 10             	add    $0x10,%esp
801042fa:	39 f7                	cmp    %esi,%edi
801042fc:	75 e2                	jne    801042e0 <procdump+0x90>
801042fe:	e9 65 ff ff ff       	jmp    80104268 <procdump+0x18>
80104303:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104307:	90                   	nop
  }
}
80104308:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010430b:	5b                   	pop    %ebx
8010430c:	5e                   	pop    %esi
8010430d:	5f                   	pop    %edi
8010430e:	5d                   	pop    %ebp
8010430f:	c3                   	ret

80104310 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	53                   	push   %ebx
80104314:	83 ec 0c             	sub    $0xc,%esp
80104317:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010431a:	68 64 78 10 80       	push   $0x80107864
8010431f:	8d 43 04             	lea    0x4(%ebx),%eax
80104322:	50                   	push   %eax
80104323:	e8 18 01 00 00       	call   80104440 <initlock>
  lk->name = name;
80104328:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010432b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104331:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104334:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010433b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010433e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104341:	c9                   	leave
80104342:	c3                   	ret
80104343:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010434a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104350 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	56                   	push   %esi
80104354:	53                   	push   %ebx
80104355:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104358:	8d 73 04             	lea    0x4(%ebx),%esi
8010435b:	83 ec 0c             	sub    $0xc,%esp
8010435e:	56                   	push   %esi
8010435f:	e8 bc 02 00 00       	call   80104620 <acquire>
  while (lk->locked) {
80104364:	8b 13                	mov    (%ebx),%edx
80104366:	83 c4 10             	add    $0x10,%esp
80104369:	85 d2                	test   %edx,%edx
8010436b:	74 16                	je     80104383 <acquiresleep+0x33>
8010436d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104370:	83 ec 08             	sub    $0x8,%esp
80104373:	56                   	push   %esi
80104374:	53                   	push   %ebx
80104375:	e8 36 fd ff ff       	call   801040b0 <sleep>
  while (lk->locked) {
8010437a:	8b 03                	mov    (%ebx),%eax
8010437c:	83 c4 10             	add    $0x10,%esp
8010437f:	85 c0                	test   %eax,%eax
80104381:	75 ed                	jne    80104370 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104383:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104389:	e8 62 f6 ff ff       	call   801039f0 <myproc>
8010438e:	8b 40 10             	mov    0x10(%eax),%eax
80104391:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104394:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104397:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010439a:	5b                   	pop    %ebx
8010439b:	5e                   	pop    %esi
8010439c:	5d                   	pop    %ebp
  release(&lk->lk);
8010439d:	e9 1e 02 00 00       	jmp    801045c0 <release>
801043a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801043b0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
801043b3:	56                   	push   %esi
801043b4:	53                   	push   %ebx
801043b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801043b8:	8d 73 04             	lea    0x4(%ebx),%esi
801043bb:	83 ec 0c             	sub    $0xc,%esp
801043be:	56                   	push   %esi
801043bf:	e8 5c 02 00 00       	call   80104620 <acquire>
  lk->locked = 0;
801043c4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801043ca:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801043d1:	89 1c 24             	mov    %ebx,(%esp)
801043d4:	e8 97 fd ff ff       	call   80104170 <wakeup>
  release(&lk->lk);
801043d9:	89 75 08             	mov    %esi,0x8(%ebp)
801043dc:	83 c4 10             	add    $0x10,%esp
}
801043df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043e2:	5b                   	pop    %ebx
801043e3:	5e                   	pop    %esi
801043e4:	5d                   	pop    %ebp
  release(&lk->lk);
801043e5:	e9 d6 01 00 00       	jmp    801045c0 <release>
801043ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043f0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	57                   	push   %edi
801043f4:	31 ff                	xor    %edi,%edi
801043f6:	56                   	push   %esi
801043f7:	53                   	push   %ebx
801043f8:	83 ec 18             	sub    $0x18,%esp
801043fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801043fe:	8d 73 04             	lea    0x4(%ebx),%esi
80104401:	56                   	push   %esi
80104402:	e8 19 02 00 00       	call   80104620 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104407:	8b 03                	mov    (%ebx),%eax
80104409:	83 c4 10             	add    $0x10,%esp
8010440c:	85 c0                	test   %eax,%eax
8010440e:	75 18                	jne    80104428 <holdingsleep+0x38>
  release(&lk->lk);
80104410:	83 ec 0c             	sub    $0xc,%esp
80104413:	56                   	push   %esi
80104414:	e8 a7 01 00 00       	call   801045c0 <release>
  return r;
}
80104419:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010441c:	89 f8                	mov    %edi,%eax
8010441e:	5b                   	pop    %ebx
8010441f:	5e                   	pop    %esi
80104420:	5f                   	pop    %edi
80104421:	5d                   	pop    %ebp
80104422:	c3                   	ret
80104423:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104427:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104428:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010442b:	e8 c0 f5 ff ff       	call   801039f0 <myproc>
80104430:	39 58 10             	cmp    %ebx,0x10(%eax)
80104433:	0f 94 c0             	sete   %al
80104436:	0f b6 c0             	movzbl %al,%eax
80104439:	89 c7                	mov    %eax,%edi
8010443b:	eb d3                	jmp    80104410 <holdingsleep+0x20>
8010443d:	66 90                	xchg   %ax,%ax
8010443f:	90                   	nop

80104440 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104446:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104449:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010444f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104452:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104459:	5d                   	pop    %ebp
8010445a:	c3                   	ret
8010445b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010445f:	90                   	nop

80104460 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	53                   	push   %ebx
80104464:	8b 45 08             	mov    0x8(%ebp),%eax
80104467:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010446a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010446d:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
80104472:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
80104477:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010447c:	76 10                	jbe    8010448e <getcallerpcs+0x2e>
8010447e:	eb 28                	jmp    801044a8 <getcallerpcs+0x48>
80104480:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104486:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010448c:	77 1a                	ja     801044a8 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010448e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104491:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104494:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104497:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104499:	83 f8 0a             	cmp    $0xa,%eax
8010449c:	75 e2                	jne    80104480 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010449e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044a1:	c9                   	leave
801044a2:	c3                   	ret
801044a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044a7:	90                   	nop
801044a8:	8d 04 81             	lea    (%ecx,%eax,4),%eax
801044ab:	8d 51 28             	lea    0x28(%ecx),%edx
801044ae:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801044b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801044b6:	83 c0 04             	add    $0x4,%eax
801044b9:	39 d0                	cmp    %edx,%eax
801044bb:	75 f3                	jne    801044b0 <getcallerpcs+0x50>
}
801044bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044c0:	c9                   	leave
801044c1:	c3                   	ret
801044c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801044d0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801044d0:	55                   	push   %ebp
801044d1:	89 e5                	mov    %esp,%ebp
801044d3:	53                   	push   %ebx
801044d4:	83 ec 04             	sub    $0x4,%esp
801044d7:	9c                   	pushf
801044d8:	5b                   	pop    %ebx
  asm volatile("cli");
801044d9:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801044da:	e8 91 f4 ff ff       	call   80103970 <mycpu>
801044df:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801044e5:	85 c0                	test   %eax,%eax
801044e7:	74 17                	je     80104500 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801044e9:	e8 82 f4 ff ff       	call   80103970 <mycpu>
801044ee:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801044f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044f8:	c9                   	leave
801044f9:	c3                   	ret
801044fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104500:	e8 6b f4 ff ff       	call   80103970 <mycpu>
80104505:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010450b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104511:	eb d6                	jmp    801044e9 <pushcli+0x19>
80104513:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010451a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104520 <popcli>:

void
popcli(void)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104526:	9c                   	pushf
80104527:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104528:	f6 c4 02             	test   $0x2,%ah
8010452b:	75 35                	jne    80104562 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010452d:	e8 3e f4 ff ff       	call   80103970 <mycpu>
80104532:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104539:	78 34                	js     8010456f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010453b:	e8 30 f4 ff ff       	call   80103970 <mycpu>
80104540:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104546:	85 d2                	test   %edx,%edx
80104548:	74 06                	je     80104550 <popcli+0x30>
    sti();
}
8010454a:	c9                   	leave
8010454b:	c3                   	ret
8010454c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104550:	e8 1b f4 ff ff       	call   80103970 <mycpu>
80104555:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010455b:	85 c0                	test   %eax,%eax
8010455d:	74 eb                	je     8010454a <popcli+0x2a>
  asm volatile("sti");
8010455f:	fb                   	sti
}
80104560:	c9                   	leave
80104561:	c3                   	ret
    panic("popcli - interruptible");
80104562:	83 ec 0c             	sub    $0xc,%esp
80104565:	68 6f 78 10 80       	push   $0x8010786f
8010456a:	e8 11 be ff ff       	call   80100380 <panic>
    panic("popcli");
8010456f:	83 ec 0c             	sub    $0xc,%esp
80104572:	68 86 78 10 80       	push   $0x80107886
80104577:	e8 04 be ff ff       	call   80100380 <panic>
8010457c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104580 <holding>:
{
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	56                   	push   %esi
80104584:	53                   	push   %ebx
80104585:	8b 75 08             	mov    0x8(%ebp),%esi
80104588:	31 db                	xor    %ebx,%ebx
  pushcli();
8010458a:	e8 41 ff ff ff       	call   801044d0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010458f:	8b 06                	mov    (%esi),%eax
80104591:	85 c0                	test   %eax,%eax
80104593:	75 0b                	jne    801045a0 <holding+0x20>
  popcli();
80104595:	e8 86 ff ff ff       	call   80104520 <popcli>
}
8010459a:	89 d8                	mov    %ebx,%eax
8010459c:	5b                   	pop    %ebx
8010459d:	5e                   	pop    %esi
8010459e:	5d                   	pop    %ebp
8010459f:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
801045a0:	8b 5e 08             	mov    0x8(%esi),%ebx
801045a3:	e8 c8 f3 ff ff       	call   80103970 <mycpu>
801045a8:	39 c3                	cmp    %eax,%ebx
801045aa:	0f 94 c3             	sete   %bl
  popcli();
801045ad:	e8 6e ff ff ff       	call   80104520 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801045b2:	0f b6 db             	movzbl %bl,%ebx
}
801045b5:	89 d8                	mov    %ebx,%eax
801045b7:	5b                   	pop    %ebx
801045b8:	5e                   	pop    %esi
801045b9:	5d                   	pop    %ebp
801045ba:	c3                   	ret
801045bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045bf:	90                   	nop

801045c0 <release>:
{
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
801045c3:	56                   	push   %esi
801045c4:	53                   	push   %ebx
801045c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801045c8:	e8 03 ff ff ff       	call   801044d0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801045cd:	8b 03                	mov    (%ebx),%eax
801045cf:	85 c0                	test   %eax,%eax
801045d1:	75 15                	jne    801045e8 <release+0x28>
  popcli();
801045d3:	e8 48 ff ff ff       	call   80104520 <popcli>
    panic("release");
801045d8:	83 ec 0c             	sub    $0xc,%esp
801045db:	68 8d 78 10 80       	push   $0x8010788d
801045e0:	e8 9b bd ff ff       	call   80100380 <panic>
801045e5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801045e8:	8b 73 08             	mov    0x8(%ebx),%esi
801045eb:	e8 80 f3 ff ff       	call   80103970 <mycpu>
801045f0:	39 c6                	cmp    %eax,%esi
801045f2:	75 df                	jne    801045d3 <release+0x13>
  popcli();
801045f4:	e8 27 ff ff ff       	call   80104520 <popcli>
  lk->pcs[0] = 0;
801045f9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104600:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104607:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010460c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104612:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104615:	5b                   	pop    %ebx
80104616:	5e                   	pop    %esi
80104617:	5d                   	pop    %ebp
  popcli();
80104618:	e9 03 ff ff ff       	jmp    80104520 <popcli>
8010461d:	8d 76 00             	lea    0x0(%esi),%esi

80104620 <acquire>:
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	53                   	push   %ebx
80104624:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104627:	e8 a4 fe ff ff       	call   801044d0 <pushcli>
  if(holding(lk))
8010462c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010462f:	e8 9c fe ff ff       	call   801044d0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104634:	8b 03                	mov    (%ebx),%eax
80104636:	85 c0                	test   %eax,%eax
80104638:	0f 85 9a 00 00 00    	jne    801046d8 <acquire+0xb8>
  popcli();
8010463e:	e8 dd fe ff ff       	call   80104520 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104643:	b9 01 00 00 00       	mov    $0x1,%ecx
80104648:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010464f:	90                   	nop
  while(xchg(&lk->locked, 1) != 0)
80104650:	8b 55 08             	mov    0x8(%ebp),%edx
80104653:	89 c8                	mov    %ecx,%eax
80104655:	f0 87 02             	lock xchg %eax,(%edx)
80104658:	85 c0                	test   %eax,%eax
8010465a:	75 f4                	jne    80104650 <acquire+0x30>
  __sync_synchronize();
8010465c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104661:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104664:	e8 07 f3 ff ff       	call   80103970 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104669:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
8010466c:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
8010466e:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104671:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
80104677:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
8010467c:	77 32                	ja     801046b0 <acquire+0x90>
  ebp = (uint*)v - 2;
8010467e:	89 e8                	mov    %ebp,%eax
80104680:	eb 14                	jmp    80104696 <acquire+0x76>
80104682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104688:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010468e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104694:	77 1a                	ja     801046b0 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
80104696:	8b 58 04             	mov    0x4(%eax),%ebx
80104699:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010469d:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801046a0:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801046a2:	83 fa 0a             	cmp    $0xa,%edx
801046a5:	75 e1                	jne    80104688 <acquire+0x68>
}
801046a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046aa:	c9                   	leave
801046ab:	c3                   	ret
801046ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046b0:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
801046b4:	8d 51 34             	lea    0x34(%ecx),%edx
801046b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046be:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801046c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801046c6:	83 c0 04             	add    $0x4,%eax
801046c9:	39 c2                	cmp    %eax,%edx
801046cb:	75 f3                	jne    801046c0 <acquire+0xa0>
}
801046cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046d0:	c9                   	leave
801046d1:	c3                   	ret
801046d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801046d8:	8b 5b 08             	mov    0x8(%ebx),%ebx
801046db:	e8 90 f2 ff ff       	call   80103970 <mycpu>
801046e0:	39 c3                	cmp    %eax,%ebx
801046e2:	0f 85 56 ff ff ff    	jne    8010463e <acquire+0x1e>
  popcli();
801046e8:	e8 33 fe ff ff       	call   80104520 <popcli>
    panic("acquire");
801046ed:	83 ec 0c             	sub    $0xc,%esp
801046f0:	68 95 78 10 80       	push   $0x80107895
801046f5:	e8 86 bc ff ff       	call   80100380 <panic>
801046fa:	66 90                	xchg   %ax,%ax
801046fc:	66 90                	xchg   %ax,%ax
801046fe:	66 90                	xchg   %ax,%ax

80104700 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	57                   	push   %edi
80104704:	8b 55 08             	mov    0x8(%ebp),%edx
80104707:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010470a:	89 d0                	mov    %edx,%eax
8010470c:	09 c8                	or     %ecx,%eax
8010470e:	a8 03                	test   $0x3,%al
80104710:	75 1e                	jne    80104730 <memset+0x30>
    c &= 0xFF;
80104712:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104716:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
80104719:	89 d7                	mov    %edx,%edi
8010471b:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
80104721:	fc                   	cld
80104722:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104724:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104727:	89 d0                	mov    %edx,%eax
80104729:	c9                   	leave
8010472a:	c3                   	ret
8010472b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010472f:	90                   	nop
  asm volatile("cld; rep stosb" :
80104730:	8b 45 0c             	mov    0xc(%ebp),%eax
80104733:	89 d7                	mov    %edx,%edi
80104735:	fc                   	cld
80104736:	f3 aa                	rep stos %al,%es:(%edi)
80104738:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010473b:	89 d0                	mov    %edx,%eax
8010473d:	c9                   	leave
8010473e:	c3                   	ret
8010473f:	90                   	nop

80104740 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104740:	55                   	push   %ebp
80104741:	89 e5                	mov    %esp,%ebp
80104743:	56                   	push   %esi
80104744:	53                   	push   %ebx
80104745:	8b 75 10             	mov    0x10(%ebp),%esi
80104748:	8b 55 08             	mov    0x8(%ebp),%edx
8010474b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010474e:	85 f6                	test   %esi,%esi
80104750:	74 2e                	je     80104780 <memcmp+0x40>
80104752:	01 c6                	add    %eax,%esi
80104754:	eb 14                	jmp    8010476a <memcmp+0x2a>
80104756:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010475d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104760:	83 c0 01             	add    $0x1,%eax
80104763:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104766:	39 f0                	cmp    %esi,%eax
80104768:	74 16                	je     80104780 <memcmp+0x40>
    if(*s1 != *s2)
8010476a:	0f b6 0a             	movzbl (%edx),%ecx
8010476d:	0f b6 18             	movzbl (%eax),%ebx
80104770:	38 d9                	cmp    %bl,%cl
80104772:	74 ec                	je     80104760 <memcmp+0x20>
      return *s1 - *s2;
80104774:	0f b6 c1             	movzbl %cl,%eax
80104777:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104779:	5b                   	pop    %ebx
8010477a:	5e                   	pop    %esi
8010477b:	5d                   	pop    %ebp
8010477c:	c3                   	ret
8010477d:	8d 76 00             	lea    0x0(%esi),%esi
80104780:	5b                   	pop    %ebx
  return 0;
80104781:	31 c0                	xor    %eax,%eax
}
80104783:	5e                   	pop    %esi
80104784:	5d                   	pop    %ebp
80104785:	c3                   	ret
80104786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010478d:	8d 76 00             	lea    0x0(%esi),%esi

80104790 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	57                   	push   %edi
80104794:	56                   	push   %esi
80104795:	8b 55 08             	mov    0x8(%ebp),%edx
80104798:	8b 75 0c             	mov    0xc(%ebp),%esi
8010479b:	8b 45 10             	mov    0x10(%ebp),%eax
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010479e:	39 d6                	cmp    %edx,%esi
801047a0:	73 26                	jae    801047c8 <memmove+0x38>
801047a2:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
801047a5:	39 ca                	cmp    %ecx,%edx
801047a7:	73 1f                	jae    801047c8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
801047a9:	85 c0                	test   %eax,%eax
801047ab:	74 0f                	je     801047bc <memmove+0x2c>
801047ad:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
801047b0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801047b4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801047b7:	83 e8 01             	sub    $0x1,%eax
801047ba:	73 f4                	jae    801047b0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801047bc:	5e                   	pop    %esi
801047bd:	89 d0                	mov    %edx,%eax
801047bf:	5f                   	pop    %edi
801047c0:	5d                   	pop    %ebp
801047c1:	c3                   	ret
801047c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
801047c8:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
801047cb:	89 d7                	mov    %edx,%edi
801047cd:	85 c0                	test   %eax,%eax
801047cf:	74 eb                	je     801047bc <memmove+0x2c>
801047d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801047d8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801047d9:	39 ce                	cmp    %ecx,%esi
801047db:	75 fb                	jne    801047d8 <memmove+0x48>
}
801047dd:	5e                   	pop    %esi
801047de:	89 d0                	mov    %edx,%eax
801047e0:	5f                   	pop    %edi
801047e1:	5d                   	pop    %ebp
801047e2:	c3                   	ret
801047e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047f0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801047f0:	eb 9e                	jmp    80104790 <memmove>
801047f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104800 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	53                   	push   %ebx
80104804:	8b 55 10             	mov    0x10(%ebp),%edx
80104807:	8b 45 08             	mov    0x8(%ebp),%eax
8010480a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
8010480d:	85 d2                	test   %edx,%edx
8010480f:	75 16                	jne    80104827 <strncmp+0x27>
80104811:	eb 2d                	jmp    80104840 <strncmp+0x40>
80104813:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104817:	90                   	nop
80104818:	3a 19                	cmp    (%ecx),%bl
8010481a:	75 12                	jne    8010482e <strncmp+0x2e>
    n--, p++, q++;
8010481c:	83 c0 01             	add    $0x1,%eax
8010481f:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104822:	83 ea 01             	sub    $0x1,%edx
80104825:	74 19                	je     80104840 <strncmp+0x40>
80104827:	0f b6 18             	movzbl (%eax),%ebx
8010482a:	84 db                	test   %bl,%bl
8010482c:	75 ea                	jne    80104818 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
8010482e:	0f b6 00             	movzbl (%eax),%eax
80104831:	0f b6 11             	movzbl (%ecx),%edx
}
80104834:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104837:	c9                   	leave
  return (uchar)*p - (uchar)*q;
80104838:	29 d0                	sub    %edx,%eax
}
8010483a:	c3                   	ret
8010483b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010483f:	90                   	nop
80104840:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80104843:	31 c0                	xor    %eax,%eax
}
80104845:	c9                   	leave
80104846:	c3                   	ret
80104847:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010484e:	66 90                	xchg   %ax,%ax

80104850 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	57                   	push   %edi
80104854:	56                   	push   %esi
80104855:	53                   	push   %ebx
80104856:	8b 75 08             	mov    0x8(%ebp),%esi
80104859:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010485c:	89 f0                	mov    %esi,%eax
8010485e:	eb 15                	jmp    80104875 <strncpy+0x25>
80104860:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104864:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104867:	83 c0 01             	add    $0x1,%eax
8010486a:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
8010486e:	88 48 ff             	mov    %cl,-0x1(%eax)
80104871:	84 c9                	test   %cl,%cl
80104873:	74 13                	je     80104888 <strncpy+0x38>
80104875:	89 d3                	mov    %edx,%ebx
80104877:	83 ea 01             	sub    $0x1,%edx
8010487a:	85 db                	test   %ebx,%ebx
8010487c:	7f e2                	jg     80104860 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
8010487e:	5b                   	pop    %ebx
8010487f:	89 f0                	mov    %esi,%eax
80104881:	5e                   	pop    %esi
80104882:	5f                   	pop    %edi
80104883:	5d                   	pop    %ebp
80104884:	c3                   	ret
80104885:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
80104888:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
8010488b:	83 e9 01             	sub    $0x1,%ecx
8010488e:	85 d2                	test   %edx,%edx
80104890:	74 ec                	je     8010487e <strncpy+0x2e>
80104892:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
80104898:	83 c0 01             	add    $0x1,%eax
8010489b:	89 ca                	mov    %ecx,%edx
8010489d:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
801048a1:	29 c2                	sub    %eax,%edx
801048a3:	85 d2                	test   %edx,%edx
801048a5:	7f f1                	jg     80104898 <strncpy+0x48>
}
801048a7:	5b                   	pop    %ebx
801048a8:	89 f0                	mov    %esi,%eax
801048aa:	5e                   	pop    %esi
801048ab:	5f                   	pop    %edi
801048ac:	5d                   	pop    %ebp
801048ad:	c3                   	ret
801048ae:	66 90                	xchg   %ax,%ax

801048b0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	56                   	push   %esi
801048b4:	53                   	push   %ebx
801048b5:	8b 55 10             	mov    0x10(%ebp),%edx
801048b8:	8b 75 08             	mov    0x8(%ebp),%esi
801048bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801048be:	85 d2                	test   %edx,%edx
801048c0:	7e 25                	jle    801048e7 <safestrcpy+0x37>
801048c2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
801048c6:	89 f2                	mov    %esi,%edx
801048c8:	eb 16                	jmp    801048e0 <safestrcpy+0x30>
801048ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801048d0:	0f b6 08             	movzbl (%eax),%ecx
801048d3:	83 c0 01             	add    $0x1,%eax
801048d6:	83 c2 01             	add    $0x1,%edx
801048d9:	88 4a ff             	mov    %cl,-0x1(%edx)
801048dc:	84 c9                	test   %cl,%cl
801048de:	74 04                	je     801048e4 <safestrcpy+0x34>
801048e0:	39 d8                	cmp    %ebx,%eax
801048e2:	75 ec                	jne    801048d0 <safestrcpy+0x20>
    ;
  *s = 0;
801048e4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801048e7:	89 f0                	mov    %esi,%eax
801048e9:	5b                   	pop    %ebx
801048ea:	5e                   	pop    %esi
801048eb:	5d                   	pop    %ebp
801048ec:	c3                   	ret
801048ed:	8d 76 00             	lea    0x0(%esi),%esi

801048f0 <strlen>:

int
strlen(const char *s)
{
801048f0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801048f1:	31 c0                	xor    %eax,%eax
{
801048f3:	89 e5                	mov    %esp,%ebp
801048f5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801048f8:	80 3a 00             	cmpb   $0x0,(%edx)
801048fb:	74 0c                	je     80104909 <strlen+0x19>
801048fd:	8d 76 00             	lea    0x0(%esi),%esi
80104900:	83 c0 01             	add    $0x1,%eax
80104903:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104907:	75 f7                	jne    80104900 <strlen+0x10>
    ;
  return n;
}
80104909:	5d                   	pop    %ebp
8010490a:	c3                   	ret

8010490b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010490b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010490f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104913:	55                   	push   %ebp
  pushl %ebx
80104914:	53                   	push   %ebx
  pushl %esi
80104915:	56                   	push   %esi
  pushl %edi
80104916:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104917:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104919:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010491b:	5f                   	pop    %edi
  popl %esi
8010491c:	5e                   	pop    %esi
  popl %ebx
8010491d:	5b                   	pop    %ebx
  popl %ebp
8010491e:	5d                   	pop    %ebp
  ret
8010491f:	c3                   	ret

80104920 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
80104923:	53                   	push   %ebx
80104924:	83 ec 04             	sub    $0x4,%esp
80104927:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010492a:	e8 c1 f0 ff ff       	call   801039f0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010492f:	8b 00                	mov    (%eax),%eax
80104931:	39 c3                	cmp    %eax,%ebx
80104933:	73 1b                	jae    80104950 <fetchint+0x30>
80104935:	8d 53 04             	lea    0x4(%ebx),%edx
80104938:	39 d0                	cmp    %edx,%eax
8010493a:	72 14                	jb     80104950 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010493c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010493f:	8b 13                	mov    (%ebx),%edx
80104941:	89 10                	mov    %edx,(%eax)
  return 0;
80104943:	31 c0                	xor    %eax,%eax
}
80104945:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104948:	c9                   	leave
80104949:	c3                   	ret
8010494a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104950:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104955:	eb ee                	jmp    80104945 <fetchint+0x25>
80104957:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010495e:	66 90                	xchg   %ax,%ax

80104960 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	53                   	push   %ebx
80104964:	83 ec 04             	sub    $0x4,%esp
80104967:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010496a:	e8 81 f0 ff ff       	call   801039f0 <myproc>

  if(addr >= curproc->sz)
8010496f:	3b 18                	cmp    (%eax),%ebx
80104971:	73 2d                	jae    801049a0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104973:	8b 55 0c             	mov    0xc(%ebp),%edx
80104976:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104978:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010497a:	39 d3                	cmp    %edx,%ebx
8010497c:	73 22                	jae    801049a0 <fetchstr+0x40>
8010497e:	89 d8                	mov    %ebx,%eax
80104980:	eb 0d                	jmp    8010498f <fetchstr+0x2f>
80104982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104988:	83 c0 01             	add    $0x1,%eax
8010498b:	39 d0                	cmp    %edx,%eax
8010498d:	73 11                	jae    801049a0 <fetchstr+0x40>
    if(*s == 0)
8010498f:	80 38 00             	cmpb   $0x0,(%eax)
80104992:	75 f4                	jne    80104988 <fetchstr+0x28>
      return s - *pp;
80104994:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104996:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104999:	c9                   	leave
8010499a:	c3                   	ret
8010499b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010499f:	90                   	nop
801049a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
801049a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049a8:	c9                   	leave
801049a9:	c3                   	ret
801049aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049b0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	56                   	push   %esi
801049b4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049b5:	e8 36 f0 ff ff       	call   801039f0 <myproc>
801049ba:	8b 55 08             	mov    0x8(%ebp),%edx
801049bd:	8b 40 18             	mov    0x18(%eax),%eax
801049c0:	8b 40 44             	mov    0x44(%eax),%eax
801049c3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801049c6:	e8 25 f0 ff ff       	call   801039f0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049cb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801049ce:	8b 00                	mov    (%eax),%eax
801049d0:	39 c6                	cmp    %eax,%esi
801049d2:	73 1c                	jae    801049f0 <argint+0x40>
801049d4:	8d 53 08             	lea    0x8(%ebx),%edx
801049d7:	39 d0                	cmp    %edx,%eax
801049d9:	72 15                	jb     801049f0 <argint+0x40>
  *ip = *(int*)(addr);
801049db:	8b 45 0c             	mov    0xc(%ebp),%eax
801049de:	8b 53 04             	mov    0x4(%ebx),%edx
801049e1:	89 10                	mov    %edx,(%eax)
  return 0;
801049e3:	31 c0                	xor    %eax,%eax
}
801049e5:	5b                   	pop    %ebx
801049e6:	5e                   	pop    %esi
801049e7:	5d                   	pop    %ebp
801049e8:	c3                   	ret
801049e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801049f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049f5:	eb ee                	jmp    801049e5 <argint+0x35>
801049f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049fe:	66 90                	xchg   %ax,%ax

80104a00 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104a00:	55                   	push   %ebp
80104a01:	89 e5                	mov    %esp,%ebp
80104a03:	57                   	push   %edi
80104a04:	56                   	push   %esi
80104a05:	53                   	push   %ebx
80104a06:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104a09:	e8 e2 ef ff ff       	call   801039f0 <myproc>
80104a0e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a10:	e8 db ef ff ff       	call   801039f0 <myproc>
80104a15:	8b 55 08             	mov    0x8(%ebp),%edx
80104a18:	8b 40 18             	mov    0x18(%eax),%eax
80104a1b:	8b 40 44             	mov    0x44(%eax),%eax
80104a1e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a21:	e8 ca ef ff ff       	call   801039f0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a26:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a29:	8b 00                	mov    (%eax),%eax
80104a2b:	39 c7                	cmp    %eax,%edi
80104a2d:	73 31                	jae    80104a60 <argptr+0x60>
80104a2f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104a32:	39 c8                	cmp    %ecx,%eax
80104a34:	72 2a                	jb     80104a60 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104a36:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104a39:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104a3c:	85 d2                	test   %edx,%edx
80104a3e:	78 20                	js     80104a60 <argptr+0x60>
80104a40:	8b 16                	mov    (%esi),%edx
80104a42:	39 d0                	cmp    %edx,%eax
80104a44:	73 1a                	jae    80104a60 <argptr+0x60>
80104a46:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104a49:	01 c3                	add    %eax,%ebx
80104a4b:	39 da                	cmp    %ebx,%edx
80104a4d:	72 11                	jb     80104a60 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104a4f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a52:	89 02                	mov    %eax,(%edx)
  return 0;
80104a54:	31 c0                	xor    %eax,%eax
}
80104a56:	83 c4 0c             	add    $0xc,%esp
80104a59:	5b                   	pop    %ebx
80104a5a:	5e                   	pop    %esi
80104a5b:	5f                   	pop    %edi
80104a5c:	5d                   	pop    %ebp
80104a5d:	c3                   	ret
80104a5e:	66 90                	xchg   %ax,%ax
    return -1;
80104a60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a65:	eb ef                	jmp    80104a56 <argptr+0x56>
80104a67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a6e:	66 90                	xchg   %ax,%ax

80104a70 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	56                   	push   %esi
80104a74:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a75:	e8 76 ef ff ff       	call   801039f0 <myproc>
80104a7a:	8b 55 08             	mov    0x8(%ebp),%edx
80104a7d:	8b 40 18             	mov    0x18(%eax),%eax
80104a80:	8b 40 44             	mov    0x44(%eax),%eax
80104a83:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a86:	e8 65 ef ff ff       	call   801039f0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a8b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a8e:	8b 00                	mov    (%eax),%eax
80104a90:	39 c6                	cmp    %eax,%esi
80104a92:	73 44                	jae    80104ad8 <argstr+0x68>
80104a94:	8d 53 08             	lea    0x8(%ebx),%edx
80104a97:	39 d0                	cmp    %edx,%eax
80104a99:	72 3d                	jb     80104ad8 <argstr+0x68>
  *ip = *(int*)(addr);
80104a9b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104a9e:	e8 4d ef ff ff       	call   801039f0 <myproc>
  if(addr >= curproc->sz)
80104aa3:	3b 18                	cmp    (%eax),%ebx
80104aa5:	73 31                	jae    80104ad8 <argstr+0x68>
  *pp = (char*)addr;
80104aa7:	8b 55 0c             	mov    0xc(%ebp),%edx
80104aaa:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104aac:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104aae:	39 d3                	cmp    %edx,%ebx
80104ab0:	73 26                	jae    80104ad8 <argstr+0x68>
80104ab2:	89 d8                	mov    %ebx,%eax
80104ab4:	eb 11                	jmp    80104ac7 <argstr+0x57>
80104ab6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104abd:	8d 76 00             	lea    0x0(%esi),%esi
80104ac0:	83 c0 01             	add    $0x1,%eax
80104ac3:	39 d0                	cmp    %edx,%eax
80104ac5:	73 11                	jae    80104ad8 <argstr+0x68>
    if(*s == 0)
80104ac7:	80 38 00             	cmpb   $0x0,(%eax)
80104aca:	75 f4                	jne    80104ac0 <argstr+0x50>
      return s - *pp;
80104acc:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104ace:	5b                   	pop    %ebx
80104acf:	5e                   	pop    %esi
80104ad0:	5d                   	pop    %ebp
80104ad1:	c3                   	ret
80104ad2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ad8:	5b                   	pop    %ebx
    return -1;
80104ad9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ade:	5e                   	pop    %esi
80104adf:	5d                   	pop    %ebp
80104ae0:	c3                   	ret
80104ae1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ae8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aef:	90                   	nop

80104af0 <syscall>:
[SYS_getreadcount] sys_getreadcount,
};

void
syscall(void)
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	53                   	push   %ebx
80104af4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104af7:	e8 f4 ee ff ff       	call   801039f0 <myproc>
80104afc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104afe:	8b 40 18             	mov    0x18(%eax),%eax
80104b01:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104b04:	8d 50 ff             	lea    -0x1(%eax),%edx
80104b07:	83 fa 15             	cmp    $0x15,%edx
80104b0a:	77 24                	ja     80104b30 <syscall+0x40>
80104b0c:	8b 14 85 c0 78 10 80 	mov    -0x7fef8740(,%eax,4),%edx
80104b13:	85 d2                	test   %edx,%edx
80104b15:	74 19                	je     80104b30 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104b17:	ff d2                	call   *%edx
80104b19:	89 c2                	mov    %eax,%edx
80104b1b:	8b 43 18             	mov    0x18(%ebx),%eax
80104b1e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104b21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b24:	c9                   	leave
80104b25:	c3                   	ret
80104b26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b2d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104b30:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104b31:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104b34:	50                   	push   %eax
80104b35:	ff 73 10             	push   0x10(%ebx)
80104b38:	68 9d 78 10 80       	push   $0x8010789d
80104b3d:	e8 6e bb ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104b42:	8b 43 18             	mov    0x18(%ebx),%eax
80104b45:	83 c4 10             	add    $0x10,%esp
80104b48:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104b4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b52:	c9                   	leave
80104b53:	c3                   	ret
80104b54:	66 90                	xchg   %ax,%ax
80104b56:	66 90                	xchg   %ax,%ax
80104b58:	66 90                	xchg   %ax,%ax
80104b5a:	66 90                	xchg   %ax,%ax
80104b5c:	66 90                	xchg   %ax,%ax
80104b5e:	66 90                	xchg   %ax,%ax

80104b60 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	57                   	push   %edi
80104b64:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104b65:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104b68:	53                   	push   %ebx
80104b69:	83 ec 34             	sub    $0x34,%esp
80104b6c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104b6f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104b72:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104b75:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104b78:	57                   	push   %edi
80104b79:	50                   	push   %eax
80104b7a:	e8 a1 d5 ff ff       	call   80102120 <nameiparent>
80104b7f:	83 c4 10             	add    $0x10,%esp
80104b82:	85 c0                	test   %eax,%eax
80104b84:	74 5e                	je     80104be4 <create+0x84>
    return 0;
  ilock(dp);
80104b86:	83 ec 0c             	sub    $0xc,%esp
80104b89:	89 c3                	mov    %eax,%ebx
80104b8b:	50                   	push   %eax
80104b8c:	e8 3f cc ff ff       	call   801017d0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104b91:	83 c4 0c             	add    $0xc,%esp
80104b94:	6a 00                	push   $0x0
80104b96:	57                   	push   %edi
80104b97:	53                   	push   %ebx
80104b98:	e8 93 d1 ff ff       	call   80101d30 <dirlookup>
80104b9d:	83 c4 10             	add    $0x10,%esp
80104ba0:	89 c6                	mov    %eax,%esi
80104ba2:	85 c0                	test   %eax,%eax
80104ba4:	74 4a                	je     80104bf0 <create+0x90>
    iunlockput(dp);
80104ba6:	83 ec 0c             	sub    $0xc,%esp
80104ba9:	53                   	push   %ebx
80104baa:	e8 b1 ce ff ff       	call   80101a60 <iunlockput>
    ilock(ip);
80104baf:	89 34 24             	mov    %esi,(%esp)
80104bb2:	e8 19 cc ff ff       	call   801017d0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104bb7:	83 c4 10             	add    $0x10,%esp
80104bba:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104bbf:	75 17                	jne    80104bd8 <create+0x78>
80104bc1:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104bc6:	75 10                	jne    80104bd8 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104bc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bcb:	89 f0                	mov    %esi,%eax
80104bcd:	5b                   	pop    %ebx
80104bce:	5e                   	pop    %esi
80104bcf:	5f                   	pop    %edi
80104bd0:	5d                   	pop    %ebp
80104bd1:	c3                   	ret
80104bd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80104bd8:	83 ec 0c             	sub    $0xc,%esp
80104bdb:	56                   	push   %esi
80104bdc:	e8 7f ce ff ff       	call   80101a60 <iunlockput>
    return 0;
80104be1:	83 c4 10             	add    $0x10,%esp
}
80104be4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104be7:	31 f6                	xor    %esi,%esi
}
80104be9:	5b                   	pop    %ebx
80104bea:	89 f0                	mov    %esi,%eax
80104bec:	5e                   	pop    %esi
80104bed:	5f                   	pop    %edi
80104bee:	5d                   	pop    %ebp
80104bef:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80104bf0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104bf4:	83 ec 08             	sub    $0x8,%esp
80104bf7:	50                   	push   %eax
80104bf8:	ff 33                	push   (%ebx)
80104bfa:	e8 61 ca ff ff       	call   80101660 <ialloc>
80104bff:	83 c4 10             	add    $0x10,%esp
80104c02:	89 c6                	mov    %eax,%esi
80104c04:	85 c0                	test   %eax,%eax
80104c06:	0f 84 bc 00 00 00    	je     80104cc8 <create+0x168>
  ilock(ip);
80104c0c:	83 ec 0c             	sub    $0xc,%esp
80104c0f:	50                   	push   %eax
80104c10:	e8 bb cb ff ff       	call   801017d0 <ilock>
  ip->major = major;
80104c15:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104c19:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104c1d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104c21:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104c25:	b8 01 00 00 00       	mov    $0x1,%eax
80104c2a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104c2e:	89 34 24             	mov    %esi,(%esp)
80104c31:	e8 ea ca ff ff       	call   80101720 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104c36:	83 c4 10             	add    $0x10,%esp
80104c39:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104c3e:	74 30                	je     80104c70 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
80104c40:	83 ec 04             	sub    $0x4,%esp
80104c43:	ff 76 04             	push   0x4(%esi)
80104c46:	57                   	push   %edi
80104c47:	53                   	push   %ebx
80104c48:	e8 f3 d3 ff ff       	call   80102040 <dirlink>
80104c4d:	83 c4 10             	add    $0x10,%esp
80104c50:	85 c0                	test   %eax,%eax
80104c52:	78 67                	js     80104cbb <create+0x15b>
  iunlockput(dp);
80104c54:	83 ec 0c             	sub    $0xc,%esp
80104c57:	53                   	push   %ebx
80104c58:	e8 03 ce ff ff       	call   80101a60 <iunlockput>
  return ip;
80104c5d:	83 c4 10             	add    $0x10,%esp
}
80104c60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c63:	89 f0                	mov    %esi,%eax
80104c65:	5b                   	pop    %ebx
80104c66:	5e                   	pop    %esi
80104c67:	5f                   	pop    %edi
80104c68:	5d                   	pop    %ebp
80104c69:	c3                   	ret
80104c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104c70:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104c73:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104c78:	53                   	push   %ebx
80104c79:	e8 a2 ca ff ff       	call   80101720 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104c7e:	83 c4 0c             	add    $0xc,%esp
80104c81:	ff 76 04             	push   0x4(%esi)
80104c84:	68 38 79 10 80       	push   $0x80107938
80104c89:	56                   	push   %esi
80104c8a:	e8 b1 d3 ff ff       	call   80102040 <dirlink>
80104c8f:	83 c4 10             	add    $0x10,%esp
80104c92:	85 c0                	test   %eax,%eax
80104c94:	78 18                	js     80104cae <create+0x14e>
80104c96:	83 ec 04             	sub    $0x4,%esp
80104c99:	ff 73 04             	push   0x4(%ebx)
80104c9c:	68 37 79 10 80       	push   $0x80107937
80104ca1:	56                   	push   %esi
80104ca2:	e8 99 d3 ff ff       	call   80102040 <dirlink>
80104ca7:	83 c4 10             	add    $0x10,%esp
80104caa:	85 c0                	test   %eax,%eax
80104cac:	79 92                	jns    80104c40 <create+0xe0>
      panic("create dots");
80104cae:	83 ec 0c             	sub    $0xc,%esp
80104cb1:	68 2b 79 10 80       	push   $0x8010792b
80104cb6:	e8 c5 b6 ff ff       	call   80100380 <panic>
    panic("create: dirlink");
80104cbb:	83 ec 0c             	sub    $0xc,%esp
80104cbe:	68 3a 79 10 80       	push   $0x8010793a
80104cc3:	e8 b8 b6 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104cc8:	83 ec 0c             	sub    $0xc,%esp
80104ccb:	68 1c 79 10 80       	push   $0x8010791c
80104cd0:	e8 ab b6 ff ff       	call   80100380 <panic>
80104cd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ce0 <sys_dup>:
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	56                   	push   %esi
80104ce4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ce5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104ce8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104ceb:	50                   	push   %eax
80104cec:	6a 00                	push   $0x0
80104cee:	e8 bd fc ff ff       	call   801049b0 <argint>
80104cf3:	83 c4 10             	add    $0x10,%esp
80104cf6:	85 c0                	test   %eax,%eax
80104cf8:	78 36                	js     80104d30 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104cfa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104cfe:	77 30                	ja     80104d30 <sys_dup+0x50>
80104d00:	e8 eb ec ff ff       	call   801039f0 <myproc>
80104d05:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d08:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104d0c:	85 f6                	test   %esi,%esi
80104d0e:	74 20                	je     80104d30 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104d10:	e8 db ec ff ff       	call   801039f0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104d15:	31 db                	xor    %ebx,%ebx
80104d17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d1e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104d20:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104d24:	85 d2                	test   %edx,%edx
80104d26:	74 18                	je     80104d40 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104d28:	83 c3 01             	add    $0x1,%ebx
80104d2b:	83 fb 10             	cmp    $0x10,%ebx
80104d2e:	75 f0                	jne    80104d20 <sys_dup+0x40>
}
80104d30:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104d33:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104d38:	89 d8                	mov    %ebx,%eax
80104d3a:	5b                   	pop    %ebx
80104d3b:	5e                   	pop    %esi
80104d3c:	5d                   	pop    %ebp
80104d3d:	c3                   	ret
80104d3e:	66 90                	xchg   %ax,%ax
  filedup(f);
80104d40:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104d43:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104d47:	56                   	push   %esi
80104d48:	e8 a3 c1 ff ff       	call   80100ef0 <filedup>
  return fd;
80104d4d:	83 c4 10             	add    $0x10,%esp
}
80104d50:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d53:	89 d8                	mov    %ebx,%eax
80104d55:	5b                   	pop    %ebx
80104d56:	5e                   	pop    %esi
80104d57:	5d                   	pop    %ebp
80104d58:	c3                   	ret
80104d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104d60 <sys_read>:
{
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	56                   	push   %esi
80104d64:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104d65:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104d68:	83 ec 18             	sub    $0x18,%esp
  readcount++;
80104d6b:	83 05 58 3c 11 80 01 	addl   $0x1,0x80113c58
  if(argint(n, &fd) < 0)
80104d72:	53                   	push   %ebx
80104d73:	6a 00                	push   $0x0
80104d75:	e8 36 fc ff ff       	call   801049b0 <argint>
80104d7a:	83 c4 10             	add    $0x10,%esp
80104d7d:	85 c0                	test   %eax,%eax
80104d7f:	78 5f                	js     80104de0 <sys_read+0x80>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104d81:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104d85:	77 59                	ja     80104de0 <sys_read+0x80>
80104d87:	e8 64 ec ff ff       	call   801039f0 <myproc>
80104d8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d8f:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104d93:	85 f6                	test   %esi,%esi
80104d95:	74 49                	je     80104de0 <sys_read+0x80>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d97:	83 ec 08             	sub    $0x8,%esp
80104d9a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d9d:	50                   	push   %eax
80104d9e:	6a 02                	push   $0x2
80104da0:	e8 0b fc ff ff       	call   801049b0 <argint>
80104da5:	83 c4 10             	add    $0x10,%esp
80104da8:	85 c0                	test   %eax,%eax
80104daa:	78 34                	js     80104de0 <sys_read+0x80>
80104dac:	83 ec 04             	sub    $0x4,%esp
80104daf:	ff 75 f0             	push   -0x10(%ebp)
80104db2:	53                   	push   %ebx
80104db3:	6a 01                	push   $0x1
80104db5:	e8 46 fc ff ff       	call   80104a00 <argptr>
80104dba:	83 c4 10             	add    $0x10,%esp
80104dbd:	85 c0                	test   %eax,%eax
80104dbf:	78 1f                	js     80104de0 <sys_read+0x80>
  return fileread(f, p, n);
80104dc1:	83 ec 04             	sub    $0x4,%esp
80104dc4:	ff 75 f0             	push   -0x10(%ebp)
80104dc7:	ff 75 f4             	push   -0xc(%ebp)
80104dca:	56                   	push   %esi
80104dcb:	e8 a0 c2 ff ff       	call   80101070 <fileread>
80104dd0:	83 c4 10             	add    $0x10,%esp
}
80104dd3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104dd6:	5b                   	pop    %ebx
80104dd7:	5e                   	pop    %esi
80104dd8:	5d                   	pop    %ebp
80104dd9:	c3                   	ret
80104dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104de0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104de5:	eb ec                	jmp    80104dd3 <sys_read+0x73>
80104de7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dee:	66 90                	xchg   %ax,%ax

80104df0 <sys_write>:
{
80104df0:	55                   	push   %ebp
80104df1:	89 e5                	mov    %esp,%ebp
80104df3:	56                   	push   %esi
80104df4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104df5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104df8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104dfb:	53                   	push   %ebx
80104dfc:	6a 00                	push   $0x0
80104dfe:	e8 ad fb ff ff       	call   801049b0 <argint>
80104e03:	83 c4 10             	add    $0x10,%esp
80104e06:	85 c0                	test   %eax,%eax
80104e08:	78 5e                	js     80104e68 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e0a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e0e:	77 58                	ja     80104e68 <sys_write+0x78>
80104e10:	e8 db eb ff ff       	call   801039f0 <myproc>
80104e15:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e18:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104e1c:	85 f6                	test   %esi,%esi
80104e1e:	74 48                	je     80104e68 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e20:	83 ec 08             	sub    $0x8,%esp
80104e23:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e26:	50                   	push   %eax
80104e27:	6a 02                	push   $0x2
80104e29:	e8 82 fb ff ff       	call   801049b0 <argint>
80104e2e:	83 c4 10             	add    $0x10,%esp
80104e31:	85 c0                	test   %eax,%eax
80104e33:	78 33                	js     80104e68 <sys_write+0x78>
80104e35:	83 ec 04             	sub    $0x4,%esp
80104e38:	ff 75 f0             	push   -0x10(%ebp)
80104e3b:	53                   	push   %ebx
80104e3c:	6a 01                	push   $0x1
80104e3e:	e8 bd fb ff ff       	call   80104a00 <argptr>
80104e43:	83 c4 10             	add    $0x10,%esp
80104e46:	85 c0                	test   %eax,%eax
80104e48:	78 1e                	js     80104e68 <sys_write+0x78>
  return filewrite(f, p, n);
80104e4a:	83 ec 04             	sub    $0x4,%esp
80104e4d:	ff 75 f0             	push   -0x10(%ebp)
80104e50:	ff 75 f4             	push   -0xc(%ebp)
80104e53:	56                   	push   %esi
80104e54:	e8 a7 c2 ff ff       	call   80101100 <filewrite>
80104e59:	83 c4 10             	add    $0x10,%esp
}
80104e5c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e5f:	5b                   	pop    %ebx
80104e60:	5e                   	pop    %esi
80104e61:	5d                   	pop    %ebp
80104e62:	c3                   	ret
80104e63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e67:	90                   	nop
    return -1;
80104e68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e6d:	eb ed                	jmp    80104e5c <sys_write+0x6c>
80104e6f:	90                   	nop

80104e70 <sys_close>:
{
80104e70:	55                   	push   %ebp
80104e71:	89 e5                	mov    %esp,%ebp
80104e73:	56                   	push   %esi
80104e74:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e75:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104e78:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e7b:	50                   	push   %eax
80104e7c:	6a 00                	push   $0x0
80104e7e:	e8 2d fb ff ff       	call   801049b0 <argint>
80104e83:	83 c4 10             	add    $0x10,%esp
80104e86:	85 c0                	test   %eax,%eax
80104e88:	78 3e                	js     80104ec8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e8a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e8e:	77 38                	ja     80104ec8 <sys_close+0x58>
80104e90:	e8 5b eb ff ff       	call   801039f0 <myproc>
80104e95:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e98:	8d 5a 08             	lea    0x8(%edx),%ebx
80104e9b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80104e9f:	85 f6                	test   %esi,%esi
80104ea1:	74 25                	je     80104ec8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80104ea3:	e8 48 eb ff ff       	call   801039f0 <myproc>
  fileclose(f);
80104ea8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104eab:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80104eb2:	00 
  fileclose(f);
80104eb3:	56                   	push   %esi
80104eb4:	e8 87 c0 ff ff       	call   80100f40 <fileclose>
  return 0;
80104eb9:	83 c4 10             	add    $0x10,%esp
80104ebc:	31 c0                	xor    %eax,%eax
}
80104ebe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ec1:	5b                   	pop    %ebx
80104ec2:	5e                   	pop    %esi
80104ec3:	5d                   	pop    %ebp
80104ec4:	c3                   	ret
80104ec5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104ec8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ecd:	eb ef                	jmp    80104ebe <sys_close+0x4e>
80104ecf:	90                   	nop

80104ed0 <sys_fstat>:
{
80104ed0:	55                   	push   %ebp
80104ed1:	89 e5                	mov    %esp,%ebp
80104ed3:	56                   	push   %esi
80104ed4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ed5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104ed8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104edb:	53                   	push   %ebx
80104edc:	6a 00                	push   $0x0
80104ede:	e8 cd fa ff ff       	call   801049b0 <argint>
80104ee3:	83 c4 10             	add    $0x10,%esp
80104ee6:	85 c0                	test   %eax,%eax
80104ee8:	78 46                	js     80104f30 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104eea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104eee:	77 40                	ja     80104f30 <sys_fstat+0x60>
80104ef0:	e8 fb ea ff ff       	call   801039f0 <myproc>
80104ef5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ef8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104efc:	85 f6                	test   %esi,%esi
80104efe:	74 30                	je     80104f30 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f00:	83 ec 04             	sub    $0x4,%esp
80104f03:	6a 14                	push   $0x14
80104f05:	53                   	push   %ebx
80104f06:	6a 01                	push   $0x1
80104f08:	e8 f3 fa ff ff       	call   80104a00 <argptr>
80104f0d:	83 c4 10             	add    $0x10,%esp
80104f10:	85 c0                	test   %eax,%eax
80104f12:	78 1c                	js     80104f30 <sys_fstat+0x60>
  return filestat(f, st);
80104f14:	83 ec 08             	sub    $0x8,%esp
80104f17:	ff 75 f4             	push   -0xc(%ebp)
80104f1a:	56                   	push   %esi
80104f1b:	e8 00 c1 ff ff       	call   80101020 <filestat>
80104f20:	83 c4 10             	add    $0x10,%esp
}
80104f23:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f26:	5b                   	pop    %ebx
80104f27:	5e                   	pop    %esi
80104f28:	5d                   	pop    %ebp
80104f29:	c3                   	ret
80104f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104f30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f35:	eb ec                	jmp    80104f23 <sys_fstat+0x53>
80104f37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f3e:	66 90                	xchg   %ax,%ax

80104f40 <sys_link>:
{
80104f40:	55                   	push   %ebp
80104f41:	89 e5                	mov    %esp,%ebp
80104f43:	57                   	push   %edi
80104f44:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f45:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104f48:	53                   	push   %ebx
80104f49:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f4c:	50                   	push   %eax
80104f4d:	6a 00                	push   $0x0
80104f4f:	e8 1c fb ff ff       	call   80104a70 <argstr>
80104f54:	83 c4 10             	add    $0x10,%esp
80104f57:	85 c0                	test   %eax,%eax
80104f59:	0f 88 fb 00 00 00    	js     8010505a <sys_link+0x11a>
80104f5f:	83 ec 08             	sub    $0x8,%esp
80104f62:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104f65:	50                   	push   %eax
80104f66:	6a 01                	push   $0x1
80104f68:	e8 03 fb ff ff       	call   80104a70 <argstr>
80104f6d:	83 c4 10             	add    $0x10,%esp
80104f70:	85 c0                	test   %eax,%eax
80104f72:	0f 88 e2 00 00 00    	js     8010505a <sys_link+0x11a>
  begin_op();
80104f78:	e8 53 de ff ff       	call   80102dd0 <begin_op>
  if((ip = namei(old)) == 0){
80104f7d:	83 ec 0c             	sub    $0xc,%esp
80104f80:	ff 75 d4             	push   -0x2c(%ebp)
80104f83:	e8 78 d1 ff ff       	call   80102100 <namei>
80104f88:	83 c4 10             	add    $0x10,%esp
80104f8b:	89 c3                	mov    %eax,%ebx
80104f8d:	85 c0                	test   %eax,%eax
80104f8f:	0f 84 df 00 00 00    	je     80105074 <sys_link+0x134>
  ilock(ip);
80104f95:	83 ec 0c             	sub    $0xc,%esp
80104f98:	50                   	push   %eax
80104f99:	e8 32 c8 ff ff       	call   801017d0 <ilock>
  if(ip->type == T_DIR){
80104f9e:	83 c4 10             	add    $0x10,%esp
80104fa1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104fa6:	0f 84 b5 00 00 00    	je     80105061 <sys_link+0x121>
  iupdate(ip);
80104fac:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80104faf:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104fb4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104fb7:	53                   	push   %ebx
80104fb8:	e8 63 c7 ff ff       	call   80101720 <iupdate>
  iunlock(ip);
80104fbd:	89 1c 24             	mov    %ebx,(%esp)
80104fc0:	e8 eb c8 ff ff       	call   801018b0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104fc5:	58                   	pop    %eax
80104fc6:	5a                   	pop    %edx
80104fc7:	57                   	push   %edi
80104fc8:	ff 75 d0             	push   -0x30(%ebp)
80104fcb:	e8 50 d1 ff ff       	call   80102120 <nameiparent>
80104fd0:	83 c4 10             	add    $0x10,%esp
80104fd3:	89 c6                	mov    %eax,%esi
80104fd5:	85 c0                	test   %eax,%eax
80104fd7:	74 5b                	je     80105034 <sys_link+0xf4>
  ilock(dp);
80104fd9:	83 ec 0c             	sub    $0xc,%esp
80104fdc:	50                   	push   %eax
80104fdd:	e8 ee c7 ff ff       	call   801017d0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104fe2:	8b 03                	mov    (%ebx),%eax
80104fe4:	83 c4 10             	add    $0x10,%esp
80104fe7:	39 06                	cmp    %eax,(%esi)
80104fe9:	75 3d                	jne    80105028 <sys_link+0xe8>
80104feb:	83 ec 04             	sub    $0x4,%esp
80104fee:	ff 73 04             	push   0x4(%ebx)
80104ff1:	57                   	push   %edi
80104ff2:	56                   	push   %esi
80104ff3:	e8 48 d0 ff ff       	call   80102040 <dirlink>
80104ff8:	83 c4 10             	add    $0x10,%esp
80104ffb:	85 c0                	test   %eax,%eax
80104ffd:	78 29                	js     80105028 <sys_link+0xe8>
  iunlockput(dp);
80104fff:	83 ec 0c             	sub    $0xc,%esp
80105002:	56                   	push   %esi
80105003:	e8 58 ca ff ff       	call   80101a60 <iunlockput>
  iput(ip);
80105008:	89 1c 24             	mov    %ebx,(%esp)
8010500b:	e8 f0 c8 ff ff       	call   80101900 <iput>
  end_op();
80105010:	e8 2b de ff ff       	call   80102e40 <end_op>
  return 0;
80105015:	83 c4 10             	add    $0x10,%esp
80105018:	31 c0                	xor    %eax,%eax
}
8010501a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010501d:	5b                   	pop    %ebx
8010501e:	5e                   	pop    %esi
8010501f:	5f                   	pop    %edi
80105020:	5d                   	pop    %ebp
80105021:	c3                   	ret
80105022:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105028:	83 ec 0c             	sub    $0xc,%esp
8010502b:	56                   	push   %esi
8010502c:	e8 2f ca ff ff       	call   80101a60 <iunlockput>
    goto bad;
80105031:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105034:	83 ec 0c             	sub    $0xc,%esp
80105037:	53                   	push   %ebx
80105038:	e8 93 c7 ff ff       	call   801017d0 <ilock>
  ip->nlink--;
8010503d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105042:	89 1c 24             	mov    %ebx,(%esp)
80105045:	e8 d6 c6 ff ff       	call   80101720 <iupdate>
  iunlockput(ip);
8010504a:	89 1c 24             	mov    %ebx,(%esp)
8010504d:	e8 0e ca ff ff       	call   80101a60 <iunlockput>
  end_op();
80105052:	e8 e9 dd ff ff       	call   80102e40 <end_op>
  return -1;
80105057:	83 c4 10             	add    $0x10,%esp
    return -1;
8010505a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010505f:	eb b9                	jmp    8010501a <sys_link+0xda>
    iunlockput(ip);
80105061:	83 ec 0c             	sub    $0xc,%esp
80105064:	53                   	push   %ebx
80105065:	e8 f6 c9 ff ff       	call   80101a60 <iunlockput>
    end_op();
8010506a:	e8 d1 dd ff ff       	call   80102e40 <end_op>
    return -1;
8010506f:	83 c4 10             	add    $0x10,%esp
80105072:	eb e6                	jmp    8010505a <sys_link+0x11a>
    end_op();
80105074:	e8 c7 dd ff ff       	call   80102e40 <end_op>
    return -1;
80105079:	eb df                	jmp    8010505a <sys_link+0x11a>
8010507b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010507f:	90                   	nop

80105080 <sys_unlink>:
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	57                   	push   %edi
80105084:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105085:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105088:	53                   	push   %ebx
80105089:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010508c:	50                   	push   %eax
8010508d:	6a 00                	push   $0x0
8010508f:	e8 dc f9 ff ff       	call   80104a70 <argstr>
80105094:	83 c4 10             	add    $0x10,%esp
80105097:	85 c0                	test   %eax,%eax
80105099:	0f 88 54 01 00 00    	js     801051f3 <sys_unlink+0x173>
  begin_op();
8010509f:	e8 2c dd ff ff       	call   80102dd0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801050a4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801050a7:	83 ec 08             	sub    $0x8,%esp
801050aa:	53                   	push   %ebx
801050ab:	ff 75 c0             	push   -0x40(%ebp)
801050ae:	e8 6d d0 ff ff       	call   80102120 <nameiparent>
801050b3:	83 c4 10             	add    $0x10,%esp
801050b6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801050b9:	85 c0                	test   %eax,%eax
801050bb:	0f 84 58 01 00 00    	je     80105219 <sys_unlink+0x199>
  ilock(dp);
801050c1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801050c4:	83 ec 0c             	sub    $0xc,%esp
801050c7:	57                   	push   %edi
801050c8:	e8 03 c7 ff ff       	call   801017d0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801050cd:	58                   	pop    %eax
801050ce:	5a                   	pop    %edx
801050cf:	68 38 79 10 80       	push   $0x80107938
801050d4:	53                   	push   %ebx
801050d5:	e8 36 cc ff ff       	call   80101d10 <namecmp>
801050da:	83 c4 10             	add    $0x10,%esp
801050dd:	85 c0                	test   %eax,%eax
801050df:	0f 84 fb 00 00 00    	je     801051e0 <sys_unlink+0x160>
801050e5:	83 ec 08             	sub    $0x8,%esp
801050e8:	68 37 79 10 80       	push   $0x80107937
801050ed:	53                   	push   %ebx
801050ee:	e8 1d cc ff ff       	call   80101d10 <namecmp>
801050f3:	83 c4 10             	add    $0x10,%esp
801050f6:	85 c0                	test   %eax,%eax
801050f8:	0f 84 e2 00 00 00    	je     801051e0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801050fe:	83 ec 04             	sub    $0x4,%esp
80105101:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105104:	50                   	push   %eax
80105105:	53                   	push   %ebx
80105106:	57                   	push   %edi
80105107:	e8 24 cc ff ff       	call   80101d30 <dirlookup>
8010510c:	83 c4 10             	add    $0x10,%esp
8010510f:	89 c3                	mov    %eax,%ebx
80105111:	85 c0                	test   %eax,%eax
80105113:	0f 84 c7 00 00 00    	je     801051e0 <sys_unlink+0x160>
  ilock(ip);
80105119:	83 ec 0c             	sub    $0xc,%esp
8010511c:	50                   	push   %eax
8010511d:	e8 ae c6 ff ff       	call   801017d0 <ilock>
  if(ip->nlink < 1)
80105122:	83 c4 10             	add    $0x10,%esp
80105125:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010512a:	0f 8e 0a 01 00 00    	jle    8010523a <sys_unlink+0x1ba>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105130:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105135:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105138:	74 66                	je     801051a0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010513a:	83 ec 04             	sub    $0x4,%esp
8010513d:	6a 10                	push   $0x10
8010513f:	6a 00                	push   $0x0
80105141:	57                   	push   %edi
80105142:	e8 b9 f5 ff ff       	call   80104700 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105147:	6a 10                	push   $0x10
80105149:	ff 75 c4             	push   -0x3c(%ebp)
8010514c:	57                   	push   %edi
8010514d:	ff 75 b4             	push   -0x4c(%ebp)
80105150:	e8 8b ca ff ff       	call   80101be0 <writei>
80105155:	83 c4 20             	add    $0x20,%esp
80105158:	83 f8 10             	cmp    $0x10,%eax
8010515b:	0f 85 cc 00 00 00    	jne    8010522d <sys_unlink+0x1ad>
  if(ip->type == T_DIR){
80105161:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105166:	0f 84 94 00 00 00    	je     80105200 <sys_unlink+0x180>
  iunlockput(dp);
8010516c:	83 ec 0c             	sub    $0xc,%esp
8010516f:	ff 75 b4             	push   -0x4c(%ebp)
80105172:	e8 e9 c8 ff ff       	call   80101a60 <iunlockput>
  ip->nlink--;
80105177:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010517c:	89 1c 24             	mov    %ebx,(%esp)
8010517f:	e8 9c c5 ff ff       	call   80101720 <iupdate>
  iunlockput(ip);
80105184:	89 1c 24             	mov    %ebx,(%esp)
80105187:	e8 d4 c8 ff ff       	call   80101a60 <iunlockput>
  end_op();
8010518c:	e8 af dc ff ff       	call   80102e40 <end_op>
  return 0;
80105191:	83 c4 10             	add    $0x10,%esp
80105194:	31 c0                	xor    %eax,%eax
}
80105196:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105199:	5b                   	pop    %ebx
8010519a:	5e                   	pop    %esi
8010519b:	5f                   	pop    %edi
8010519c:	5d                   	pop    %ebp
8010519d:	c3                   	ret
8010519e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801051a0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801051a4:	76 94                	jbe    8010513a <sys_unlink+0xba>
801051a6:	be 20 00 00 00       	mov    $0x20,%esi
801051ab:	eb 0b                	jmp    801051b8 <sys_unlink+0x138>
801051ad:	8d 76 00             	lea    0x0(%esi),%esi
801051b0:	83 c6 10             	add    $0x10,%esi
801051b3:	3b 73 58             	cmp    0x58(%ebx),%esi
801051b6:	73 82                	jae    8010513a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801051b8:	6a 10                	push   $0x10
801051ba:	56                   	push   %esi
801051bb:	57                   	push   %edi
801051bc:	53                   	push   %ebx
801051bd:	e8 1e c9 ff ff       	call   80101ae0 <readi>
801051c2:	83 c4 10             	add    $0x10,%esp
801051c5:	83 f8 10             	cmp    $0x10,%eax
801051c8:	75 56                	jne    80105220 <sys_unlink+0x1a0>
    if(de.inum != 0)
801051ca:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801051cf:	74 df                	je     801051b0 <sys_unlink+0x130>
    iunlockput(ip);
801051d1:	83 ec 0c             	sub    $0xc,%esp
801051d4:	53                   	push   %ebx
801051d5:	e8 86 c8 ff ff       	call   80101a60 <iunlockput>
    goto bad;
801051da:	83 c4 10             	add    $0x10,%esp
801051dd:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801051e0:	83 ec 0c             	sub    $0xc,%esp
801051e3:	ff 75 b4             	push   -0x4c(%ebp)
801051e6:	e8 75 c8 ff ff       	call   80101a60 <iunlockput>
  end_op();
801051eb:	e8 50 dc ff ff       	call   80102e40 <end_op>
  return -1;
801051f0:	83 c4 10             	add    $0x10,%esp
    return -1;
801051f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051f8:	eb 9c                	jmp    80105196 <sys_unlink+0x116>
801051fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105200:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105203:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105206:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010520b:	50                   	push   %eax
8010520c:	e8 0f c5 ff ff       	call   80101720 <iupdate>
80105211:	83 c4 10             	add    $0x10,%esp
80105214:	e9 53 ff ff ff       	jmp    8010516c <sys_unlink+0xec>
    end_op();
80105219:	e8 22 dc ff ff       	call   80102e40 <end_op>
    return -1;
8010521e:	eb d3                	jmp    801051f3 <sys_unlink+0x173>
      panic("isdirempty: readi");
80105220:	83 ec 0c             	sub    $0xc,%esp
80105223:	68 5c 79 10 80       	push   $0x8010795c
80105228:	e8 53 b1 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010522d:	83 ec 0c             	sub    $0xc,%esp
80105230:	68 6e 79 10 80       	push   $0x8010796e
80105235:	e8 46 b1 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010523a:	83 ec 0c             	sub    $0xc,%esp
8010523d:	68 4a 79 10 80       	push   $0x8010794a
80105242:	e8 39 b1 ff ff       	call   80100380 <panic>
80105247:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010524e:	66 90                	xchg   %ax,%ax

80105250 <sys_open>:

int
sys_open(void)
{
80105250:	55                   	push   %ebp
80105251:	89 e5                	mov    %esp,%ebp
80105253:	57                   	push   %edi
80105254:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105255:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105258:	53                   	push   %ebx
80105259:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010525c:	50                   	push   %eax
8010525d:	6a 00                	push   $0x0
8010525f:	e8 0c f8 ff ff       	call   80104a70 <argstr>
80105264:	83 c4 10             	add    $0x10,%esp
80105267:	85 c0                	test   %eax,%eax
80105269:	0f 88 8e 00 00 00    	js     801052fd <sys_open+0xad>
8010526f:	83 ec 08             	sub    $0x8,%esp
80105272:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105275:	50                   	push   %eax
80105276:	6a 01                	push   $0x1
80105278:	e8 33 f7 ff ff       	call   801049b0 <argint>
8010527d:	83 c4 10             	add    $0x10,%esp
80105280:	85 c0                	test   %eax,%eax
80105282:	78 79                	js     801052fd <sys_open+0xad>
    return -1;

  begin_op();
80105284:	e8 47 db ff ff       	call   80102dd0 <begin_op>

  if(omode & O_CREATE){
80105289:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010528d:	75 79                	jne    80105308 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010528f:	83 ec 0c             	sub    $0xc,%esp
80105292:	ff 75 e0             	push   -0x20(%ebp)
80105295:	e8 66 ce ff ff       	call   80102100 <namei>
8010529a:	83 c4 10             	add    $0x10,%esp
8010529d:	89 c6                	mov    %eax,%esi
8010529f:	85 c0                	test   %eax,%eax
801052a1:	0f 84 7e 00 00 00    	je     80105325 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801052a7:	83 ec 0c             	sub    $0xc,%esp
801052aa:	50                   	push   %eax
801052ab:	e8 20 c5 ff ff       	call   801017d0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801052b0:	83 c4 10             	add    $0x10,%esp
801052b3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801052b8:	0f 84 ba 00 00 00    	je     80105378 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801052be:	e8 bd bb ff ff       	call   80100e80 <filealloc>
801052c3:	89 c7                	mov    %eax,%edi
801052c5:	85 c0                	test   %eax,%eax
801052c7:	74 23                	je     801052ec <sys_open+0x9c>
  struct proc *curproc = myproc();
801052c9:	e8 22 e7 ff ff       	call   801039f0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801052ce:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801052d0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801052d4:	85 d2                	test   %edx,%edx
801052d6:	74 58                	je     80105330 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
801052d8:	83 c3 01             	add    $0x1,%ebx
801052db:	83 fb 10             	cmp    $0x10,%ebx
801052de:	75 f0                	jne    801052d0 <sys_open+0x80>
    if(f)
      fileclose(f);
801052e0:	83 ec 0c             	sub    $0xc,%esp
801052e3:	57                   	push   %edi
801052e4:	e8 57 bc ff ff       	call   80100f40 <fileclose>
801052e9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801052ec:	83 ec 0c             	sub    $0xc,%esp
801052ef:	56                   	push   %esi
801052f0:	e8 6b c7 ff ff       	call   80101a60 <iunlockput>
    end_op();
801052f5:	e8 46 db ff ff       	call   80102e40 <end_op>
    return -1;
801052fa:	83 c4 10             	add    $0x10,%esp
    return -1;
801052fd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105302:	eb 65                	jmp    80105369 <sys_open+0x119>
80105304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105308:	83 ec 0c             	sub    $0xc,%esp
8010530b:	31 c9                	xor    %ecx,%ecx
8010530d:	ba 02 00 00 00       	mov    $0x2,%edx
80105312:	6a 00                	push   $0x0
80105314:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105317:	e8 44 f8 ff ff       	call   80104b60 <create>
    if(ip == 0){
8010531c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010531f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105321:	85 c0                	test   %eax,%eax
80105323:	75 99                	jne    801052be <sys_open+0x6e>
      end_op();
80105325:	e8 16 db ff ff       	call   80102e40 <end_op>
      return -1;
8010532a:	eb d1                	jmp    801052fd <sys_open+0xad>
8010532c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105330:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105333:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105337:	56                   	push   %esi
80105338:	e8 73 c5 ff ff       	call   801018b0 <iunlock>
  end_op();
8010533d:	e8 fe da ff ff       	call   80102e40 <end_op>

  f->type = FD_INODE;
80105342:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105348:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010534b:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
8010534e:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105351:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105353:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010535a:	f7 d0                	not    %eax
8010535c:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010535f:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105362:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105365:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105369:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010536c:	89 d8                	mov    %ebx,%eax
8010536e:	5b                   	pop    %ebx
8010536f:	5e                   	pop    %esi
80105370:	5f                   	pop    %edi
80105371:	5d                   	pop    %ebp
80105372:	c3                   	ret
80105373:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105377:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105378:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010537b:	85 c9                	test   %ecx,%ecx
8010537d:	0f 84 3b ff ff ff    	je     801052be <sys_open+0x6e>
80105383:	e9 64 ff ff ff       	jmp    801052ec <sys_open+0x9c>
80105388:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010538f:	90                   	nop

80105390 <sys_mkdir>:

int
sys_mkdir(void)
{
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105396:	e8 35 da ff ff       	call   80102dd0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010539b:	83 ec 08             	sub    $0x8,%esp
8010539e:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053a1:	50                   	push   %eax
801053a2:	6a 00                	push   $0x0
801053a4:	e8 c7 f6 ff ff       	call   80104a70 <argstr>
801053a9:	83 c4 10             	add    $0x10,%esp
801053ac:	85 c0                	test   %eax,%eax
801053ae:	78 30                	js     801053e0 <sys_mkdir+0x50>
801053b0:	83 ec 0c             	sub    $0xc,%esp
801053b3:	31 c9                	xor    %ecx,%ecx
801053b5:	ba 01 00 00 00       	mov    $0x1,%edx
801053ba:	6a 00                	push   $0x0
801053bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053bf:	e8 9c f7 ff ff       	call   80104b60 <create>
801053c4:	83 c4 10             	add    $0x10,%esp
801053c7:	85 c0                	test   %eax,%eax
801053c9:	74 15                	je     801053e0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801053cb:	83 ec 0c             	sub    $0xc,%esp
801053ce:	50                   	push   %eax
801053cf:	e8 8c c6 ff ff       	call   80101a60 <iunlockput>
  end_op();
801053d4:	e8 67 da ff ff       	call   80102e40 <end_op>
  return 0;
801053d9:	83 c4 10             	add    $0x10,%esp
801053dc:	31 c0                	xor    %eax,%eax
}
801053de:	c9                   	leave
801053df:	c3                   	ret
    end_op();
801053e0:	e8 5b da ff ff       	call   80102e40 <end_op>
    return -1;
801053e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053ea:	c9                   	leave
801053eb:	c3                   	ret
801053ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053f0 <sys_mknod>:

int
sys_mknod(void)
{
801053f0:	55                   	push   %ebp
801053f1:	89 e5                	mov    %esp,%ebp
801053f3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801053f6:	e8 d5 d9 ff ff       	call   80102dd0 <begin_op>
  if((argstr(0, &path)) < 0 ||
801053fb:	83 ec 08             	sub    $0x8,%esp
801053fe:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105401:	50                   	push   %eax
80105402:	6a 00                	push   $0x0
80105404:	e8 67 f6 ff ff       	call   80104a70 <argstr>
80105409:	83 c4 10             	add    $0x10,%esp
8010540c:	85 c0                	test   %eax,%eax
8010540e:	78 60                	js     80105470 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105410:	83 ec 08             	sub    $0x8,%esp
80105413:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105416:	50                   	push   %eax
80105417:	6a 01                	push   $0x1
80105419:	e8 92 f5 ff ff       	call   801049b0 <argint>
  if((argstr(0, &path)) < 0 ||
8010541e:	83 c4 10             	add    $0x10,%esp
80105421:	85 c0                	test   %eax,%eax
80105423:	78 4b                	js     80105470 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105425:	83 ec 08             	sub    $0x8,%esp
80105428:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010542b:	50                   	push   %eax
8010542c:	6a 02                	push   $0x2
8010542e:	e8 7d f5 ff ff       	call   801049b0 <argint>
     argint(1, &major) < 0 ||
80105433:	83 c4 10             	add    $0x10,%esp
80105436:	85 c0                	test   %eax,%eax
80105438:	78 36                	js     80105470 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010543a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010543e:	83 ec 0c             	sub    $0xc,%esp
80105441:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105445:	ba 03 00 00 00       	mov    $0x3,%edx
8010544a:	50                   	push   %eax
8010544b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010544e:	e8 0d f7 ff ff       	call   80104b60 <create>
     argint(2, &minor) < 0 ||
80105453:	83 c4 10             	add    $0x10,%esp
80105456:	85 c0                	test   %eax,%eax
80105458:	74 16                	je     80105470 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010545a:	83 ec 0c             	sub    $0xc,%esp
8010545d:	50                   	push   %eax
8010545e:	e8 fd c5 ff ff       	call   80101a60 <iunlockput>
  end_op();
80105463:	e8 d8 d9 ff ff       	call   80102e40 <end_op>
  return 0;
80105468:	83 c4 10             	add    $0x10,%esp
8010546b:	31 c0                	xor    %eax,%eax
}
8010546d:	c9                   	leave
8010546e:	c3                   	ret
8010546f:	90                   	nop
    end_op();
80105470:	e8 cb d9 ff ff       	call   80102e40 <end_op>
    return -1;
80105475:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010547a:	c9                   	leave
8010547b:	c3                   	ret
8010547c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105480 <sys_chdir>:

int
sys_chdir(void)
{
80105480:	55                   	push   %ebp
80105481:	89 e5                	mov    %esp,%ebp
80105483:	56                   	push   %esi
80105484:	53                   	push   %ebx
80105485:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105488:	e8 63 e5 ff ff       	call   801039f0 <myproc>
8010548d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010548f:	e8 3c d9 ff ff       	call   80102dd0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105494:	83 ec 08             	sub    $0x8,%esp
80105497:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010549a:	50                   	push   %eax
8010549b:	6a 00                	push   $0x0
8010549d:	e8 ce f5 ff ff       	call   80104a70 <argstr>
801054a2:	83 c4 10             	add    $0x10,%esp
801054a5:	85 c0                	test   %eax,%eax
801054a7:	78 77                	js     80105520 <sys_chdir+0xa0>
801054a9:	83 ec 0c             	sub    $0xc,%esp
801054ac:	ff 75 f4             	push   -0xc(%ebp)
801054af:	e8 4c cc ff ff       	call   80102100 <namei>
801054b4:	83 c4 10             	add    $0x10,%esp
801054b7:	89 c3                	mov    %eax,%ebx
801054b9:	85 c0                	test   %eax,%eax
801054bb:	74 63                	je     80105520 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801054bd:	83 ec 0c             	sub    $0xc,%esp
801054c0:	50                   	push   %eax
801054c1:	e8 0a c3 ff ff       	call   801017d0 <ilock>
  if(ip->type != T_DIR){
801054c6:	83 c4 10             	add    $0x10,%esp
801054c9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054ce:	75 30                	jne    80105500 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801054d0:	83 ec 0c             	sub    $0xc,%esp
801054d3:	53                   	push   %ebx
801054d4:	e8 d7 c3 ff ff       	call   801018b0 <iunlock>
  iput(curproc->cwd);
801054d9:	58                   	pop    %eax
801054da:	ff 76 68             	push   0x68(%esi)
801054dd:	e8 1e c4 ff ff       	call   80101900 <iput>
  end_op();
801054e2:	e8 59 d9 ff ff       	call   80102e40 <end_op>
  curproc->cwd = ip;
801054e7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801054ea:	83 c4 10             	add    $0x10,%esp
801054ed:	31 c0                	xor    %eax,%eax
}
801054ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054f2:	5b                   	pop    %ebx
801054f3:	5e                   	pop    %esi
801054f4:	5d                   	pop    %ebp
801054f5:	c3                   	ret
801054f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054fd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105500:	83 ec 0c             	sub    $0xc,%esp
80105503:	53                   	push   %ebx
80105504:	e8 57 c5 ff ff       	call   80101a60 <iunlockput>
    end_op();
80105509:	e8 32 d9 ff ff       	call   80102e40 <end_op>
    return -1;
8010550e:	83 c4 10             	add    $0x10,%esp
    return -1;
80105511:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105516:	eb d7                	jmp    801054ef <sys_chdir+0x6f>
80105518:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010551f:	90                   	nop
    end_op();
80105520:	e8 1b d9 ff ff       	call   80102e40 <end_op>
    return -1;
80105525:	eb ea                	jmp    80105511 <sys_chdir+0x91>
80105527:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010552e:	66 90                	xchg   %ax,%ax

80105530 <sys_exec>:

int
sys_exec(void)
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	57                   	push   %edi
80105534:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105535:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010553b:	53                   	push   %ebx
8010553c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105542:	50                   	push   %eax
80105543:	6a 00                	push   $0x0
80105545:	e8 26 f5 ff ff       	call   80104a70 <argstr>
8010554a:	83 c4 10             	add    $0x10,%esp
8010554d:	85 c0                	test   %eax,%eax
8010554f:	0f 88 87 00 00 00    	js     801055dc <sys_exec+0xac>
80105555:	83 ec 08             	sub    $0x8,%esp
80105558:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010555e:	50                   	push   %eax
8010555f:	6a 01                	push   $0x1
80105561:	e8 4a f4 ff ff       	call   801049b0 <argint>
80105566:	83 c4 10             	add    $0x10,%esp
80105569:	85 c0                	test   %eax,%eax
8010556b:	78 6f                	js     801055dc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010556d:	83 ec 04             	sub    $0x4,%esp
80105570:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105576:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105578:	68 80 00 00 00       	push   $0x80
8010557d:	6a 00                	push   $0x0
8010557f:	56                   	push   %esi
80105580:	e8 7b f1 ff ff       	call   80104700 <memset>
80105585:	83 c4 10             	add    $0x10,%esp
80105588:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010558f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105590:	83 ec 08             	sub    $0x8,%esp
80105593:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105599:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
801055a0:	50                   	push   %eax
801055a1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801055a7:	01 f8                	add    %edi,%eax
801055a9:	50                   	push   %eax
801055aa:	e8 71 f3 ff ff       	call   80104920 <fetchint>
801055af:	83 c4 10             	add    $0x10,%esp
801055b2:	85 c0                	test   %eax,%eax
801055b4:	78 26                	js     801055dc <sys_exec+0xac>
      return -1;
    if(uarg == 0){
801055b6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801055bc:	85 c0                	test   %eax,%eax
801055be:	74 30                	je     801055f0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801055c0:	83 ec 08             	sub    $0x8,%esp
801055c3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
801055c6:	52                   	push   %edx
801055c7:	50                   	push   %eax
801055c8:	e8 93 f3 ff ff       	call   80104960 <fetchstr>
801055cd:	83 c4 10             	add    $0x10,%esp
801055d0:	85 c0                	test   %eax,%eax
801055d2:	78 08                	js     801055dc <sys_exec+0xac>
  for(i=0;; i++){
801055d4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801055d7:	83 fb 20             	cmp    $0x20,%ebx
801055da:	75 b4                	jne    80105590 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801055dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801055df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055e4:	5b                   	pop    %ebx
801055e5:	5e                   	pop    %esi
801055e6:	5f                   	pop    %edi
801055e7:	5d                   	pop    %ebp
801055e8:	c3                   	ret
801055e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
801055f0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801055f7:	00 00 00 00 
  return exec(path, argv);
801055fb:	83 ec 08             	sub    $0x8,%esp
801055fe:	56                   	push   %esi
801055ff:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105605:	e8 d6 b4 ff ff       	call   80100ae0 <exec>
8010560a:	83 c4 10             	add    $0x10,%esp
}
8010560d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105610:	5b                   	pop    %ebx
80105611:	5e                   	pop    %esi
80105612:	5f                   	pop    %edi
80105613:	5d                   	pop    %ebp
80105614:	c3                   	ret
80105615:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010561c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105620 <sys_pipe>:

int
sys_pipe(void)
{
80105620:	55                   	push   %ebp
80105621:	89 e5                	mov    %esp,%ebp
80105623:	57                   	push   %edi
80105624:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105625:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105628:	53                   	push   %ebx
80105629:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010562c:	6a 08                	push   $0x8
8010562e:	50                   	push   %eax
8010562f:	6a 00                	push   $0x0
80105631:	e8 ca f3 ff ff       	call   80104a00 <argptr>
80105636:	83 c4 10             	add    $0x10,%esp
80105639:	85 c0                	test   %eax,%eax
8010563b:	0f 88 8b 00 00 00    	js     801056cc <sys_pipe+0xac>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105641:	83 ec 08             	sub    $0x8,%esp
80105644:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105647:	50                   	push   %eax
80105648:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010564b:	50                   	push   %eax
8010564c:	e8 4f de ff ff       	call   801034a0 <pipealloc>
80105651:	83 c4 10             	add    $0x10,%esp
80105654:	85 c0                	test   %eax,%eax
80105656:	78 74                	js     801056cc <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105658:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010565b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010565d:	e8 8e e3 ff ff       	call   801039f0 <myproc>
    if(curproc->ofile[fd] == 0){
80105662:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105666:	85 f6                	test   %esi,%esi
80105668:	74 16                	je     80105680 <sys_pipe+0x60>
8010566a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105670:	83 c3 01             	add    $0x1,%ebx
80105673:	83 fb 10             	cmp    $0x10,%ebx
80105676:	74 3d                	je     801056b5 <sys_pipe+0x95>
    if(curproc->ofile[fd] == 0){
80105678:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010567c:	85 f6                	test   %esi,%esi
8010567e:	75 f0                	jne    80105670 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105680:	8d 73 08             	lea    0x8(%ebx),%esi
80105683:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105687:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010568a:	e8 61 e3 ff ff       	call   801039f0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010568f:	31 d2                	xor    %edx,%edx
80105691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105698:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010569c:	85 c9                	test   %ecx,%ecx
8010569e:	74 38                	je     801056d8 <sys_pipe+0xb8>
  for(fd = 0; fd < NOFILE; fd++){
801056a0:	83 c2 01             	add    $0x1,%edx
801056a3:	83 fa 10             	cmp    $0x10,%edx
801056a6:	75 f0                	jne    80105698 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
801056a8:	e8 43 e3 ff ff       	call   801039f0 <myproc>
801056ad:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801056b4:	00 
    fileclose(rf);
801056b5:	83 ec 0c             	sub    $0xc,%esp
801056b8:	ff 75 e0             	push   -0x20(%ebp)
801056bb:	e8 80 b8 ff ff       	call   80100f40 <fileclose>
    fileclose(wf);
801056c0:	58                   	pop    %eax
801056c1:	ff 75 e4             	push   -0x1c(%ebp)
801056c4:	e8 77 b8 ff ff       	call   80100f40 <fileclose>
    return -1;
801056c9:	83 c4 10             	add    $0x10,%esp
    return -1;
801056cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056d1:	eb 16                	jmp    801056e9 <sys_pipe+0xc9>
801056d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056d7:	90                   	nop
      curproc->ofile[fd] = f;
801056d8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801056dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056df:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801056e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056e4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801056e7:	31 c0                	xor    %eax,%eax
}
801056e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056ec:	5b                   	pop    %ebx
801056ed:	5e                   	pop    %esi
801056ee:	5f                   	pop    %edi
801056ef:	5d                   	pop    %ebp
801056f0:	c3                   	ret
801056f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ff:	90                   	nop

80105700 <sys_getreadcount>:

int
sys_getreadcount(void)
{
  return readcount;
}
80105700:	a1 58 3c 11 80       	mov    0x80113c58,%eax
80105705:	c3                   	ret
80105706:	66 90                	xchg   %ax,%ax
80105708:	66 90                	xchg   %ax,%ax
8010570a:	66 90                	xchg   %ax,%ax
8010570c:	66 90                	xchg   %ax,%ax
8010570e:	66 90                	xchg   %ax,%ax

80105710 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105710:	e9 7b e4 ff ff       	jmp    80103b90 <fork>
80105715:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010571c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105720 <sys_exit>:
}

int
sys_exit(void)
{
80105720:	55                   	push   %ebp
80105721:	89 e5                	mov    %esp,%ebp
80105723:	83 ec 08             	sub    $0x8,%esp
  exit();
80105726:	e8 d5 e6 ff ff       	call   80103e00 <exit>
  return 0;  // not reached
}
8010572b:	31 c0                	xor    %eax,%eax
8010572d:	c9                   	leave
8010572e:	c3                   	ret
8010572f:	90                   	nop

80105730 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105730:	e9 fb e7 ff ff       	jmp    80103f30 <wait>
80105735:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010573c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105740 <sys_kill>:
}

int
sys_kill(void)
{
80105740:	55                   	push   %ebp
80105741:	89 e5                	mov    %esp,%ebp
80105743:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105746:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105749:	50                   	push   %eax
8010574a:	6a 00                	push   $0x0
8010574c:	e8 5f f2 ff ff       	call   801049b0 <argint>
80105751:	83 c4 10             	add    $0x10,%esp
80105754:	85 c0                	test   %eax,%eax
80105756:	78 18                	js     80105770 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105758:	83 ec 0c             	sub    $0xc,%esp
8010575b:	ff 75 f4             	push   -0xc(%ebp)
8010575e:	e8 6d ea ff ff       	call   801041d0 <kill>
80105763:	83 c4 10             	add    $0x10,%esp
}
80105766:	c9                   	leave
80105767:	c3                   	ret
80105768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010576f:	90                   	nop
80105770:	c9                   	leave
    return -1;
80105771:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105776:	c3                   	ret
80105777:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010577e:	66 90                	xchg   %ax,%ax

80105780 <sys_getpid>:

int
sys_getpid(void)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105786:	e8 65 e2 ff ff       	call   801039f0 <myproc>
8010578b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010578e:	c9                   	leave
8010578f:	c3                   	ret

80105790 <sys_sbrk>:

int
sys_sbrk(void)
{
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
80105793:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105794:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105797:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010579a:	50                   	push   %eax
8010579b:	6a 00                	push   $0x0
8010579d:	e8 0e f2 ff ff       	call   801049b0 <argint>
801057a2:	83 c4 10             	add    $0x10,%esp
801057a5:	85 c0                	test   %eax,%eax
801057a7:	78 27                	js     801057d0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801057a9:	e8 42 e2 ff ff       	call   801039f0 <myproc>
  if(growproc(n) < 0)
801057ae:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801057b1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801057b3:	ff 75 f4             	push   -0xc(%ebp)
801057b6:	e8 55 e3 ff ff       	call   80103b10 <growproc>
801057bb:	83 c4 10             	add    $0x10,%esp
801057be:	85 c0                	test   %eax,%eax
801057c0:	78 0e                	js     801057d0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801057c2:	89 d8                	mov    %ebx,%eax
801057c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057c7:	c9                   	leave
801057c8:	c3                   	ret
801057c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801057d0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801057d5:	eb eb                	jmp    801057c2 <sys_sbrk+0x32>
801057d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057de:	66 90                	xchg   %ax,%ax

801057e0 <sys_sleep>:

int
sys_sleep(void)
{
801057e0:	55                   	push   %ebp
801057e1:	89 e5                	mov    %esp,%ebp
801057e3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801057e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801057e7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801057ea:	50                   	push   %eax
801057eb:	6a 00                	push   $0x0
801057ed:	e8 be f1 ff ff       	call   801049b0 <argint>
801057f2:	83 c4 10             	add    $0x10,%esp
801057f5:	85 c0                	test   %eax,%eax
801057f7:	78 64                	js     8010585d <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
801057f9:	83 ec 0c             	sub    $0xc,%esp
801057fc:	68 80 3c 11 80       	push   $0x80113c80
80105801:	e8 1a ee ff ff       	call   80104620 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105806:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105809:	8b 1d 60 3c 11 80    	mov    0x80113c60,%ebx
  while(ticks - ticks0 < n){
8010580f:	83 c4 10             	add    $0x10,%esp
80105812:	85 d2                	test   %edx,%edx
80105814:	75 2b                	jne    80105841 <sys_sleep+0x61>
80105816:	eb 58                	jmp    80105870 <sys_sleep+0x90>
80105818:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010581f:	90                   	nop
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105820:	83 ec 08             	sub    $0x8,%esp
80105823:	68 80 3c 11 80       	push   $0x80113c80
80105828:	68 60 3c 11 80       	push   $0x80113c60
8010582d:	e8 7e e8 ff ff       	call   801040b0 <sleep>
  while(ticks - ticks0 < n){
80105832:	a1 60 3c 11 80       	mov    0x80113c60,%eax
80105837:	83 c4 10             	add    $0x10,%esp
8010583a:	29 d8                	sub    %ebx,%eax
8010583c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010583f:	73 2f                	jae    80105870 <sys_sleep+0x90>
    if(myproc()->killed){
80105841:	e8 aa e1 ff ff       	call   801039f0 <myproc>
80105846:	8b 40 24             	mov    0x24(%eax),%eax
80105849:	85 c0                	test   %eax,%eax
8010584b:	74 d3                	je     80105820 <sys_sleep+0x40>
      release(&tickslock);
8010584d:	83 ec 0c             	sub    $0xc,%esp
80105850:	68 80 3c 11 80       	push   $0x80113c80
80105855:	e8 66 ed ff ff       	call   801045c0 <release>
      return -1;
8010585a:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
8010585d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105860:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105865:	c9                   	leave
80105866:	c3                   	ret
80105867:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010586e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105870:	83 ec 0c             	sub    $0xc,%esp
80105873:	68 80 3c 11 80       	push   $0x80113c80
80105878:	e8 43 ed ff ff       	call   801045c0 <release>
}
8010587d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
80105880:	83 c4 10             	add    $0x10,%esp
80105883:	31 c0                	xor    %eax,%eax
}
80105885:	c9                   	leave
80105886:	c3                   	ret
80105887:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010588e:	66 90                	xchg   %ax,%ax

80105890 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105890:	55                   	push   %ebp
80105891:	89 e5                	mov    %esp,%ebp
80105893:	53                   	push   %ebx
80105894:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105897:	68 80 3c 11 80       	push   $0x80113c80
8010589c:	e8 7f ed ff ff       	call   80104620 <acquire>
  xticks = ticks;
801058a1:	8b 1d 60 3c 11 80    	mov    0x80113c60,%ebx
  release(&tickslock);
801058a7:	c7 04 24 80 3c 11 80 	movl   $0x80113c80,(%esp)
801058ae:	e8 0d ed ff ff       	call   801045c0 <release>
  return xticks;
}
801058b3:	89 d8                	mov    %ebx,%eax
801058b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058b8:	c9                   	leave
801058b9:	c3                   	ret

801058ba <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801058ba:	1e                   	push   %ds
  pushl %es
801058bb:	06                   	push   %es
  pushl %fs
801058bc:	0f a0                	push   %fs
  pushl %gs
801058be:	0f a8                	push   %gs
  pushal
801058c0:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801058c1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801058c5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801058c7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801058c9:	54                   	push   %esp
  call trap
801058ca:	e8 c1 00 00 00       	call   80105990 <trap>
  addl $4, %esp
801058cf:	83 c4 04             	add    $0x4,%esp

801058d2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801058d2:	61                   	popa
  popl %gs
801058d3:	0f a9                	pop    %gs
  popl %fs
801058d5:	0f a1                	pop    %fs
  popl %es
801058d7:	07                   	pop    %es
  popl %ds
801058d8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801058d9:	83 c4 08             	add    $0x8,%esp
  iret
801058dc:	cf                   	iret
801058dd:	66 90                	xchg   %ax,%ax
801058df:	90                   	nop

801058e0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801058e0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801058e1:	31 c0                	xor    %eax,%eax
{
801058e3:	89 e5                	mov    %esp,%ebp
801058e5:	83 ec 08             	sub    $0x8,%esp
801058e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ef:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801058f0:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
801058f7:	c7 04 c5 c2 3c 11 80 	movl   $0x8e000008,-0x7feec33e(,%eax,8)
801058fe:	08 00 00 8e 
80105902:	66 89 14 c5 c0 3c 11 	mov    %dx,-0x7feec340(,%eax,8)
80105909:	80 
8010590a:	c1 ea 10             	shr    $0x10,%edx
8010590d:	66 89 14 c5 c6 3c 11 	mov    %dx,-0x7feec33a(,%eax,8)
80105914:	80 
  for(i = 0; i < 256; i++)
80105915:	83 c0 01             	add    $0x1,%eax
80105918:	3d 00 01 00 00       	cmp    $0x100,%eax
8010591d:	75 d1                	jne    801058f0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010591f:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105924:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105927:	c7 05 c2 3e 11 80 08 	movl   $0xef000008,0x80113ec2
8010592e:	00 00 ef 
80105931:	66 a3 c0 3e 11 80    	mov    %ax,0x80113ec0
80105937:	c1 e8 10             	shr    $0x10,%eax
8010593a:	66 a3 c6 3e 11 80    	mov    %ax,0x80113ec6
  initlock(&tickslock, "time");
80105940:	68 7d 79 10 80       	push   $0x8010797d
80105945:	68 80 3c 11 80       	push   $0x80113c80
8010594a:	e8 f1 ea ff ff       	call   80104440 <initlock>
}
8010594f:	83 c4 10             	add    $0x10,%esp
80105952:	c9                   	leave
80105953:	c3                   	ret
80105954:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010595b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010595f:	90                   	nop

80105960 <idtinit>:

void
idtinit(void)
{
80105960:	55                   	push   %ebp
  pd[0] = size-1;
80105961:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105966:	89 e5                	mov    %esp,%ebp
80105968:	83 ec 10             	sub    $0x10,%esp
8010596b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010596f:	b8 c0 3c 11 80       	mov    $0x80113cc0,%eax
80105974:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105978:	c1 e8 10             	shr    $0x10,%eax
8010597b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010597f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105982:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105985:	c9                   	leave
80105986:	c3                   	ret
80105987:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010598e:	66 90                	xchg   %ax,%ax

80105990 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105990:	55                   	push   %ebp
80105991:	89 e5                	mov    %esp,%ebp
80105993:	57                   	push   %edi
80105994:	56                   	push   %esi
80105995:	53                   	push   %ebx
80105996:	83 ec 1c             	sub    $0x1c,%esp
80105999:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010599c:	8b 43 30             	mov    0x30(%ebx),%eax
8010599f:	83 f8 40             	cmp    $0x40,%eax
801059a2:	0f 84 68 01 00 00    	je     80105b10 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801059a8:	83 e8 20             	sub    $0x20,%eax
801059ab:	83 f8 1f             	cmp    $0x1f,%eax
801059ae:	0f 87 8c 00 00 00    	ja     80105a40 <trap+0xb0>
801059b4:	ff 24 85 24 7a 10 80 	jmp    *-0x7fef85dc(,%eax,4)
801059bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059bf:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801059c0:	e8 eb c8 ff ff       	call   801022b0 <ideintr>
    lapiceoi();
801059c5:	e8 b6 cf ff ff       	call   80102980 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801059ca:	e8 21 e0 ff ff       	call   801039f0 <myproc>
801059cf:	85 c0                	test   %eax,%eax
801059d1:	74 1d                	je     801059f0 <trap+0x60>
801059d3:	e8 18 e0 ff ff       	call   801039f0 <myproc>
801059d8:	8b 50 24             	mov    0x24(%eax),%edx
801059db:	85 d2                	test   %edx,%edx
801059dd:	74 11                	je     801059f0 <trap+0x60>
801059df:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801059e3:	83 e0 03             	and    $0x3,%eax
801059e6:	66 83 f8 03          	cmp    $0x3,%ax
801059ea:	0f 84 e8 01 00 00    	je     80105bd8 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801059f0:	e8 fb df ff ff       	call   801039f0 <myproc>
801059f5:	85 c0                	test   %eax,%eax
801059f7:	74 0f                	je     80105a08 <trap+0x78>
801059f9:	e8 f2 df ff ff       	call   801039f0 <myproc>
801059fe:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105a02:	0f 84 b8 00 00 00    	je     80105ac0 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a08:	e8 e3 df ff ff       	call   801039f0 <myproc>
80105a0d:	85 c0                	test   %eax,%eax
80105a0f:	74 1d                	je     80105a2e <trap+0x9e>
80105a11:	e8 da df ff ff       	call   801039f0 <myproc>
80105a16:	8b 40 24             	mov    0x24(%eax),%eax
80105a19:	85 c0                	test   %eax,%eax
80105a1b:	74 11                	je     80105a2e <trap+0x9e>
80105a1d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105a21:	83 e0 03             	and    $0x3,%eax
80105a24:	66 83 f8 03          	cmp    $0x3,%ax
80105a28:	0f 84 0f 01 00 00    	je     80105b3d <trap+0x1ad>
    exit();
}
80105a2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a31:	5b                   	pop    %ebx
80105a32:	5e                   	pop    %esi
80105a33:	5f                   	pop    %edi
80105a34:	5d                   	pop    %ebp
80105a35:	c3                   	ret
80105a36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80105a40:	e8 ab df ff ff       	call   801039f0 <myproc>
80105a45:	8b 7b 38             	mov    0x38(%ebx),%edi
80105a48:	85 c0                	test   %eax,%eax
80105a4a:	0f 84 a2 01 00 00    	je     80105bf2 <trap+0x262>
80105a50:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105a54:	0f 84 98 01 00 00    	je     80105bf2 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105a5a:	0f 20 d1             	mov    %cr2,%ecx
80105a5d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a60:	e8 6b df ff ff       	call   801039d0 <cpuid>
80105a65:	8b 73 30             	mov    0x30(%ebx),%esi
80105a68:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105a6b:	8b 43 34             	mov    0x34(%ebx),%eax
80105a6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105a71:	e8 7a df ff ff       	call   801039f0 <myproc>
80105a76:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105a79:	e8 72 df ff ff       	call   801039f0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a7e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105a81:	51                   	push   %ecx
80105a82:	57                   	push   %edi
80105a83:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105a86:	52                   	push   %edx
80105a87:	ff 75 e4             	push   -0x1c(%ebp)
80105a8a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105a8b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105a8e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a91:	56                   	push   %esi
80105a92:	ff 70 10             	push   0x10(%eax)
80105a95:	68 e0 79 10 80       	push   $0x801079e0
80105a9a:	e8 11 ac ff ff       	call   801006b0 <cprintf>
    myproc()->killed = 1;
80105a9f:	83 c4 20             	add    $0x20,%esp
80105aa2:	e8 49 df ff ff       	call   801039f0 <myproc>
80105aa7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105aae:	e8 3d df ff ff       	call   801039f0 <myproc>
80105ab3:	85 c0                	test   %eax,%eax
80105ab5:	0f 85 18 ff ff ff    	jne    801059d3 <trap+0x43>
80105abb:	e9 30 ff ff ff       	jmp    801059f0 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80105ac0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105ac4:	0f 85 3e ff ff ff    	jne    80105a08 <trap+0x78>
    yield();
80105aca:	e8 91 e5 ff ff       	call   80104060 <yield>
80105acf:	e9 34 ff ff ff       	jmp    80105a08 <trap+0x78>
80105ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105ad8:	8b 7b 38             	mov    0x38(%ebx),%edi
80105adb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105adf:	e8 ec de ff ff       	call   801039d0 <cpuid>
80105ae4:	57                   	push   %edi
80105ae5:	56                   	push   %esi
80105ae6:	50                   	push   %eax
80105ae7:	68 88 79 10 80       	push   $0x80107988
80105aec:	e8 bf ab ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80105af1:	e8 8a ce ff ff       	call   80102980 <lapiceoi>
    break;
80105af6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105af9:	e8 f2 de ff ff       	call   801039f0 <myproc>
80105afe:	85 c0                	test   %eax,%eax
80105b00:	0f 85 cd fe ff ff    	jne    801059d3 <trap+0x43>
80105b06:	e9 e5 fe ff ff       	jmp    801059f0 <trap+0x60>
80105b0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b0f:	90                   	nop
    if(myproc()->killed)
80105b10:	e8 db de ff ff       	call   801039f0 <myproc>
80105b15:	8b 70 24             	mov    0x24(%eax),%esi
80105b18:	85 f6                	test   %esi,%esi
80105b1a:	0f 85 c8 00 00 00    	jne    80105be8 <trap+0x258>
    myproc()->tf = tf;
80105b20:	e8 cb de ff ff       	call   801039f0 <myproc>
80105b25:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105b28:	e8 c3 ef ff ff       	call   80104af0 <syscall>
    if(myproc()->killed)
80105b2d:	e8 be de ff ff       	call   801039f0 <myproc>
80105b32:	8b 48 24             	mov    0x24(%eax),%ecx
80105b35:	85 c9                	test   %ecx,%ecx
80105b37:	0f 84 f1 fe ff ff    	je     80105a2e <trap+0x9e>
}
80105b3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b40:	5b                   	pop    %ebx
80105b41:	5e                   	pop    %esi
80105b42:	5f                   	pop    %edi
80105b43:	5d                   	pop    %ebp
      exit();
80105b44:	e9 b7 e2 ff ff       	jmp    80103e00 <exit>
80105b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105b50:	e8 4b 02 00 00       	call   80105da0 <uartintr>
    lapiceoi();
80105b55:	e8 26 ce ff ff       	call   80102980 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b5a:	e8 91 de ff ff       	call   801039f0 <myproc>
80105b5f:	85 c0                	test   %eax,%eax
80105b61:	0f 85 6c fe ff ff    	jne    801059d3 <trap+0x43>
80105b67:	e9 84 fe ff ff       	jmp    801059f0 <trap+0x60>
80105b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105b70:	e8 cb cc ff ff       	call   80102840 <kbdintr>
    lapiceoi();
80105b75:	e8 06 ce ff ff       	call   80102980 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b7a:	e8 71 de ff ff       	call   801039f0 <myproc>
80105b7f:	85 c0                	test   %eax,%eax
80105b81:	0f 85 4c fe ff ff    	jne    801059d3 <trap+0x43>
80105b87:	e9 64 fe ff ff       	jmp    801059f0 <trap+0x60>
80105b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105b90:	e8 3b de ff ff       	call   801039d0 <cpuid>
80105b95:	85 c0                	test   %eax,%eax
80105b97:	0f 85 28 fe ff ff    	jne    801059c5 <trap+0x35>
      acquire(&tickslock);
80105b9d:	83 ec 0c             	sub    $0xc,%esp
80105ba0:	68 80 3c 11 80       	push   $0x80113c80
80105ba5:	e8 76 ea ff ff       	call   80104620 <acquire>
      ticks++;
80105baa:	83 05 60 3c 11 80 01 	addl   $0x1,0x80113c60
      wakeup(&ticks);
80105bb1:	c7 04 24 60 3c 11 80 	movl   $0x80113c60,(%esp)
80105bb8:	e8 b3 e5 ff ff       	call   80104170 <wakeup>
      release(&tickslock);
80105bbd:	c7 04 24 80 3c 11 80 	movl   $0x80113c80,(%esp)
80105bc4:	e8 f7 e9 ff ff       	call   801045c0 <release>
80105bc9:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105bcc:	e9 f4 fd ff ff       	jmp    801059c5 <trap+0x35>
80105bd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105bd8:	e8 23 e2 ff ff       	call   80103e00 <exit>
80105bdd:	e9 0e fe ff ff       	jmp    801059f0 <trap+0x60>
80105be2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105be8:	e8 13 e2 ff ff       	call   80103e00 <exit>
80105bed:	e9 2e ff ff ff       	jmp    80105b20 <trap+0x190>
80105bf2:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105bf5:	e8 d6 dd ff ff       	call   801039d0 <cpuid>
80105bfa:	83 ec 0c             	sub    $0xc,%esp
80105bfd:	56                   	push   %esi
80105bfe:	57                   	push   %edi
80105bff:	50                   	push   %eax
80105c00:	ff 73 30             	push   0x30(%ebx)
80105c03:	68 ac 79 10 80       	push   $0x801079ac
80105c08:	e8 a3 aa ff ff       	call   801006b0 <cprintf>
      panic("trap");
80105c0d:	83 c4 14             	add    $0x14,%esp
80105c10:	68 82 79 10 80       	push   $0x80107982
80105c15:	e8 66 a7 ff ff       	call   80100380 <panic>
80105c1a:	66 90                	xchg   %ax,%ax
80105c1c:	66 90                	xchg   %ax,%ax
80105c1e:	66 90                	xchg   %ax,%ax

80105c20 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105c20:	a1 c0 44 11 80       	mov    0x801144c0,%eax
80105c25:	85 c0                	test   %eax,%eax
80105c27:	74 17                	je     80105c40 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105c29:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105c2e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105c2f:	a8 01                	test   $0x1,%al
80105c31:	74 0d                	je     80105c40 <uartgetc+0x20>
80105c33:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c38:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105c39:	0f b6 c0             	movzbl %al,%eax
80105c3c:	c3                   	ret
80105c3d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105c40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c45:	c3                   	ret
80105c46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c4d:	8d 76 00             	lea    0x0(%esi),%esi

80105c50 <uartinit>:
{
80105c50:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105c51:	31 c9                	xor    %ecx,%ecx
80105c53:	89 c8                	mov    %ecx,%eax
80105c55:	89 e5                	mov    %esp,%ebp
80105c57:	57                   	push   %edi
80105c58:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105c5d:	56                   	push   %esi
80105c5e:	89 fa                	mov    %edi,%edx
80105c60:	53                   	push   %ebx
80105c61:	83 ec 1c             	sub    $0x1c,%esp
80105c64:	ee                   	out    %al,(%dx)
80105c65:	be fb 03 00 00       	mov    $0x3fb,%esi
80105c6a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105c6f:	89 f2                	mov    %esi,%edx
80105c71:	ee                   	out    %al,(%dx)
80105c72:	b8 0c 00 00 00       	mov    $0xc,%eax
80105c77:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c7c:	ee                   	out    %al,(%dx)
80105c7d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105c82:	89 c8                	mov    %ecx,%eax
80105c84:	89 da                	mov    %ebx,%edx
80105c86:	ee                   	out    %al,(%dx)
80105c87:	b8 03 00 00 00       	mov    $0x3,%eax
80105c8c:	89 f2                	mov    %esi,%edx
80105c8e:	ee                   	out    %al,(%dx)
80105c8f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105c94:	89 c8                	mov    %ecx,%eax
80105c96:	ee                   	out    %al,(%dx)
80105c97:	b8 01 00 00 00       	mov    $0x1,%eax
80105c9c:	89 da                	mov    %ebx,%edx
80105c9e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105c9f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ca4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105ca5:	3c ff                	cmp    $0xff,%al
80105ca7:	0f 84 7c 00 00 00    	je     80105d29 <uartinit+0xd9>
  uart = 1;
80105cad:	c7 05 c0 44 11 80 01 	movl   $0x1,0x801144c0
80105cb4:	00 00 00 
80105cb7:	89 fa                	mov    %edi,%edx
80105cb9:	ec                   	in     (%dx),%al
80105cba:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105cbf:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105cc0:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105cc3:	bf a4 7a 10 80       	mov    $0x80107aa4,%edi
80105cc8:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105ccd:	6a 00                	push   $0x0
80105ccf:	6a 04                	push   $0x4
80105cd1:	e8 0a c8 ff ff       	call   801024e0 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105cd6:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80105cda:	83 c4 10             	add    $0x10,%esp
80105cdd:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80105ce0:	a1 c0 44 11 80       	mov    0x801144c0,%eax
80105ce5:	85 c0                	test   %eax,%eax
80105ce7:	74 32                	je     80105d1b <uartinit+0xcb>
80105ce9:	89 f2                	mov    %esi,%edx
80105ceb:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105cec:	a8 20                	test   $0x20,%al
80105cee:	75 21                	jne    80105d11 <uartinit+0xc1>
80105cf0:	bb 80 00 00 00       	mov    $0x80,%ebx
80105cf5:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80105cf8:	83 ec 0c             	sub    $0xc,%esp
80105cfb:	6a 0a                	push   $0xa
80105cfd:	e8 9e cc ff ff       	call   801029a0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105d02:	83 c4 10             	add    $0x10,%esp
80105d05:	83 eb 01             	sub    $0x1,%ebx
80105d08:	74 07                	je     80105d11 <uartinit+0xc1>
80105d0a:	89 f2                	mov    %esi,%edx
80105d0c:	ec                   	in     (%dx),%al
80105d0d:	a8 20                	test   $0x20,%al
80105d0f:	74 e7                	je     80105cf8 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105d11:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d16:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80105d1a:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105d1b:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80105d1f:	83 c7 01             	add    $0x1,%edi
80105d22:	88 45 e7             	mov    %al,-0x19(%ebp)
80105d25:	84 c0                	test   %al,%al
80105d27:	75 b7                	jne    80105ce0 <uartinit+0x90>
}
80105d29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d2c:	5b                   	pop    %ebx
80105d2d:	5e                   	pop    %esi
80105d2e:	5f                   	pop    %edi
80105d2f:	5d                   	pop    %ebp
80105d30:	c3                   	ret
80105d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d3f:	90                   	nop

80105d40 <uartputc>:
  if(!uart)
80105d40:	a1 c0 44 11 80       	mov    0x801144c0,%eax
80105d45:	85 c0                	test   %eax,%eax
80105d47:	74 4f                	je     80105d98 <uartputc+0x58>
{
80105d49:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105d4a:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105d4f:	89 e5                	mov    %esp,%ebp
80105d51:	56                   	push   %esi
80105d52:	53                   	push   %ebx
80105d53:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105d54:	a8 20                	test   $0x20,%al
80105d56:	75 29                	jne    80105d81 <uartputc+0x41>
80105d58:	bb 80 00 00 00       	mov    $0x80,%ebx
80105d5d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105d62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80105d68:	83 ec 0c             	sub    $0xc,%esp
80105d6b:	6a 0a                	push   $0xa
80105d6d:	e8 2e cc ff ff       	call   801029a0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105d72:	83 c4 10             	add    $0x10,%esp
80105d75:	83 eb 01             	sub    $0x1,%ebx
80105d78:	74 07                	je     80105d81 <uartputc+0x41>
80105d7a:	89 f2                	mov    %esi,%edx
80105d7c:	ec                   	in     (%dx),%al
80105d7d:	a8 20                	test   $0x20,%al
80105d7f:	74 e7                	je     80105d68 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105d81:	8b 45 08             	mov    0x8(%ebp),%eax
80105d84:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d89:	ee                   	out    %al,(%dx)
}
80105d8a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d8d:	5b                   	pop    %ebx
80105d8e:	5e                   	pop    %esi
80105d8f:	5d                   	pop    %ebp
80105d90:	c3                   	ret
80105d91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d98:	c3                   	ret
80105d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105da0 <uartintr>:

void
uartintr(void)
{
80105da0:	55                   	push   %ebp
80105da1:	89 e5                	mov    %esp,%ebp
80105da3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105da6:	68 20 5c 10 80       	push   $0x80105c20
80105dab:	e8 10 ab ff ff       	call   801008c0 <consoleintr>
}
80105db0:	83 c4 10             	add    $0x10,%esp
80105db3:	c9                   	leave
80105db4:	c3                   	ret

80105db5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105db5:	6a 00                	push   $0x0
  pushl $0
80105db7:	6a 00                	push   $0x0
  jmp alltraps
80105db9:	e9 fc fa ff ff       	jmp    801058ba <alltraps>

80105dbe <vector1>:
.globl vector1
vector1:
  pushl $0
80105dbe:	6a 00                	push   $0x0
  pushl $1
80105dc0:	6a 01                	push   $0x1
  jmp alltraps
80105dc2:	e9 f3 fa ff ff       	jmp    801058ba <alltraps>

80105dc7 <vector2>:
.globl vector2
vector2:
  pushl $0
80105dc7:	6a 00                	push   $0x0
  pushl $2
80105dc9:	6a 02                	push   $0x2
  jmp alltraps
80105dcb:	e9 ea fa ff ff       	jmp    801058ba <alltraps>

80105dd0 <vector3>:
.globl vector3
vector3:
  pushl $0
80105dd0:	6a 00                	push   $0x0
  pushl $3
80105dd2:	6a 03                	push   $0x3
  jmp alltraps
80105dd4:	e9 e1 fa ff ff       	jmp    801058ba <alltraps>

80105dd9 <vector4>:
.globl vector4
vector4:
  pushl $0
80105dd9:	6a 00                	push   $0x0
  pushl $4
80105ddb:	6a 04                	push   $0x4
  jmp alltraps
80105ddd:	e9 d8 fa ff ff       	jmp    801058ba <alltraps>

80105de2 <vector5>:
.globl vector5
vector5:
  pushl $0
80105de2:	6a 00                	push   $0x0
  pushl $5
80105de4:	6a 05                	push   $0x5
  jmp alltraps
80105de6:	e9 cf fa ff ff       	jmp    801058ba <alltraps>

80105deb <vector6>:
.globl vector6
vector6:
  pushl $0
80105deb:	6a 00                	push   $0x0
  pushl $6
80105ded:	6a 06                	push   $0x6
  jmp alltraps
80105def:	e9 c6 fa ff ff       	jmp    801058ba <alltraps>

80105df4 <vector7>:
.globl vector7
vector7:
  pushl $0
80105df4:	6a 00                	push   $0x0
  pushl $7
80105df6:	6a 07                	push   $0x7
  jmp alltraps
80105df8:	e9 bd fa ff ff       	jmp    801058ba <alltraps>

80105dfd <vector8>:
.globl vector8
vector8:
  pushl $8
80105dfd:	6a 08                	push   $0x8
  jmp alltraps
80105dff:	e9 b6 fa ff ff       	jmp    801058ba <alltraps>

80105e04 <vector9>:
.globl vector9
vector9:
  pushl $0
80105e04:	6a 00                	push   $0x0
  pushl $9
80105e06:	6a 09                	push   $0x9
  jmp alltraps
80105e08:	e9 ad fa ff ff       	jmp    801058ba <alltraps>

80105e0d <vector10>:
.globl vector10
vector10:
  pushl $10
80105e0d:	6a 0a                	push   $0xa
  jmp alltraps
80105e0f:	e9 a6 fa ff ff       	jmp    801058ba <alltraps>

80105e14 <vector11>:
.globl vector11
vector11:
  pushl $11
80105e14:	6a 0b                	push   $0xb
  jmp alltraps
80105e16:	e9 9f fa ff ff       	jmp    801058ba <alltraps>

80105e1b <vector12>:
.globl vector12
vector12:
  pushl $12
80105e1b:	6a 0c                	push   $0xc
  jmp alltraps
80105e1d:	e9 98 fa ff ff       	jmp    801058ba <alltraps>

80105e22 <vector13>:
.globl vector13
vector13:
  pushl $13
80105e22:	6a 0d                	push   $0xd
  jmp alltraps
80105e24:	e9 91 fa ff ff       	jmp    801058ba <alltraps>

80105e29 <vector14>:
.globl vector14
vector14:
  pushl $14
80105e29:	6a 0e                	push   $0xe
  jmp alltraps
80105e2b:	e9 8a fa ff ff       	jmp    801058ba <alltraps>

80105e30 <vector15>:
.globl vector15
vector15:
  pushl $0
80105e30:	6a 00                	push   $0x0
  pushl $15
80105e32:	6a 0f                	push   $0xf
  jmp alltraps
80105e34:	e9 81 fa ff ff       	jmp    801058ba <alltraps>

80105e39 <vector16>:
.globl vector16
vector16:
  pushl $0
80105e39:	6a 00                	push   $0x0
  pushl $16
80105e3b:	6a 10                	push   $0x10
  jmp alltraps
80105e3d:	e9 78 fa ff ff       	jmp    801058ba <alltraps>

80105e42 <vector17>:
.globl vector17
vector17:
  pushl $17
80105e42:	6a 11                	push   $0x11
  jmp alltraps
80105e44:	e9 71 fa ff ff       	jmp    801058ba <alltraps>

80105e49 <vector18>:
.globl vector18
vector18:
  pushl $0
80105e49:	6a 00                	push   $0x0
  pushl $18
80105e4b:	6a 12                	push   $0x12
  jmp alltraps
80105e4d:	e9 68 fa ff ff       	jmp    801058ba <alltraps>

80105e52 <vector19>:
.globl vector19
vector19:
  pushl $0
80105e52:	6a 00                	push   $0x0
  pushl $19
80105e54:	6a 13                	push   $0x13
  jmp alltraps
80105e56:	e9 5f fa ff ff       	jmp    801058ba <alltraps>

80105e5b <vector20>:
.globl vector20
vector20:
  pushl $0
80105e5b:	6a 00                	push   $0x0
  pushl $20
80105e5d:	6a 14                	push   $0x14
  jmp alltraps
80105e5f:	e9 56 fa ff ff       	jmp    801058ba <alltraps>

80105e64 <vector21>:
.globl vector21
vector21:
  pushl $0
80105e64:	6a 00                	push   $0x0
  pushl $21
80105e66:	6a 15                	push   $0x15
  jmp alltraps
80105e68:	e9 4d fa ff ff       	jmp    801058ba <alltraps>

80105e6d <vector22>:
.globl vector22
vector22:
  pushl $0
80105e6d:	6a 00                	push   $0x0
  pushl $22
80105e6f:	6a 16                	push   $0x16
  jmp alltraps
80105e71:	e9 44 fa ff ff       	jmp    801058ba <alltraps>

80105e76 <vector23>:
.globl vector23
vector23:
  pushl $0
80105e76:	6a 00                	push   $0x0
  pushl $23
80105e78:	6a 17                	push   $0x17
  jmp alltraps
80105e7a:	e9 3b fa ff ff       	jmp    801058ba <alltraps>

80105e7f <vector24>:
.globl vector24
vector24:
  pushl $0
80105e7f:	6a 00                	push   $0x0
  pushl $24
80105e81:	6a 18                	push   $0x18
  jmp alltraps
80105e83:	e9 32 fa ff ff       	jmp    801058ba <alltraps>

80105e88 <vector25>:
.globl vector25
vector25:
  pushl $0
80105e88:	6a 00                	push   $0x0
  pushl $25
80105e8a:	6a 19                	push   $0x19
  jmp alltraps
80105e8c:	e9 29 fa ff ff       	jmp    801058ba <alltraps>

80105e91 <vector26>:
.globl vector26
vector26:
  pushl $0
80105e91:	6a 00                	push   $0x0
  pushl $26
80105e93:	6a 1a                	push   $0x1a
  jmp alltraps
80105e95:	e9 20 fa ff ff       	jmp    801058ba <alltraps>

80105e9a <vector27>:
.globl vector27
vector27:
  pushl $0
80105e9a:	6a 00                	push   $0x0
  pushl $27
80105e9c:	6a 1b                	push   $0x1b
  jmp alltraps
80105e9e:	e9 17 fa ff ff       	jmp    801058ba <alltraps>

80105ea3 <vector28>:
.globl vector28
vector28:
  pushl $0
80105ea3:	6a 00                	push   $0x0
  pushl $28
80105ea5:	6a 1c                	push   $0x1c
  jmp alltraps
80105ea7:	e9 0e fa ff ff       	jmp    801058ba <alltraps>

80105eac <vector29>:
.globl vector29
vector29:
  pushl $0
80105eac:	6a 00                	push   $0x0
  pushl $29
80105eae:	6a 1d                	push   $0x1d
  jmp alltraps
80105eb0:	e9 05 fa ff ff       	jmp    801058ba <alltraps>

80105eb5 <vector30>:
.globl vector30
vector30:
  pushl $0
80105eb5:	6a 00                	push   $0x0
  pushl $30
80105eb7:	6a 1e                	push   $0x1e
  jmp alltraps
80105eb9:	e9 fc f9 ff ff       	jmp    801058ba <alltraps>

80105ebe <vector31>:
.globl vector31
vector31:
  pushl $0
80105ebe:	6a 00                	push   $0x0
  pushl $31
80105ec0:	6a 1f                	push   $0x1f
  jmp alltraps
80105ec2:	e9 f3 f9 ff ff       	jmp    801058ba <alltraps>

80105ec7 <vector32>:
.globl vector32
vector32:
  pushl $0
80105ec7:	6a 00                	push   $0x0
  pushl $32
80105ec9:	6a 20                	push   $0x20
  jmp alltraps
80105ecb:	e9 ea f9 ff ff       	jmp    801058ba <alltraps>

80105ed0 <vector33>:
.globl vector33
vector33:
  pushl $0
80105ed0:	6a 00                	push   $0x0
  pushl $33
80105ed2:	6a 21                	push   $0x21
  jmp alltraps
80105ed4:	e9 e1 f9 ff ff       	jmp    801058ba <alltraps>

80105ed9 <vector34>:
.globl vector34
vector34:
  pushl $0
80105ed9:	6a 00                	push   $0x0
  pushl $34
80105edb:	6a 22                	push   $0x22
  jmp alltraps
80105edd:	e9 d8 f9 ff ff       	jmp    801058ba <alltraps>

80105ee2 <vector35>:
.globl vector35
vector35:
  pushl $0
80105ee2:	6a 00                	push   $0x0
  pushl $35
80105ee4:	6a 23                	push   $0x23
  jmp alltraps
80105ee6:	e9 cf f9 ff ff       	jmp    801058ba <alltraps>

80105eeb <vector36>:
.globl vector36
vector36:
  pushl $0
80105eeb:	6a 00                	push   $0x0
  pushl $36
80105eed:	6a 24                	push   $0x24
  jmp alltraps
80105eef:	e9 c6 f9 ff ff       	jmp    801058ba <alltraps>

80105ef4 <vector37>:
.globl vector37
vector37:
  pushl $0
80105ef4:	6a 00                	push   $0x0
  pushl $37
80105ef6:	6a 25                	push   $0x25
  jmp alltraps
80105ef8:	e9 bd f9 ff ff       	jmp    801058ba <alltraps>

80105efd <vector38>:
.globl vector38
vector38:
  pushl $0
80105efd:	6a 00                	push   $0x0
  pushl $38
80105eff:	6a 26                	push   $0x26
  jmp alltraps
80105f01:	e9 b4 f9 ff ff       	jmp    801058ba <alltraps>

80105f06 <vector39>:
.globl vector39
vector39:
  pushl $0
80105f06:	6a 00                	push   $0x0
  pushl $39
80105f08:	6a 27                	push   $0x27
  jmp alltraps
80105f0a:	e9 ab f9 ff ff       	jmp    801058ba <alltraps>

80105f0f <vector40>:
.globl vector40
vector40:
  pushl $0
80105f0f:	6a 00                	push   $0x0
  pushl $40
80105f11:	6a 28                	push   $0x28
  jmp alltraps
80105f13:	e9 a2 f9 ff ff       	jmp    801058ba <alltraps>

80105f18 <vector41>:
.globl vector41
vector41:
  pushl $0
80105f18:	6a 00                	push   $0x0
  pushl $41
80105f1a:	6a 29                	push   $0x29
  jmp alltraps
80105f1c:	e9 99 f9 ff ff       	jmp    801058ba <alltraps>

80105f21 <vector42>:
.globl vector42
vector42:
  pushl $0
80105f21:	6a 00                	push   $0x0
  pushl $42
80105f23:	6a 2a                	push   $0x2a
  jmp alltraps
80105f25:	e9 90 f9 ff ff       	jmp    801058ba <alltraps>

80105f2a <vector43>:
.globl vector43
vector43:
  pushl $0
80105f2a:	6a 00                	push   $0x0
  pushl $43
80105f2c:	6a 2b                	push   $0x2b
  jmp alltraps
80105f2e:	e9 87 f9 ff ff       	jmp    801058ba <alltraps>

80105f33 <vector44>:
.globl vector44
vector44:
  pushl $0
80105f33:	6a 00                	push   $0x0
  pushl $44
80105f35:	6a 2c                	push   $0x2c
  jmp alltraps
80105f37:	e9 7e f9 ff ff       	jmp    801058ba <alltraps>

80105f3c <vector45>:
.globl vector45
vector45:
  pushl $0
80105f3c:	6a 00                	push   $0x0
  pushl $45
80105f3e:	6a 2d                	push   $0x2d
  jmp alltraps
80105f40:	e9 75 f9 ff ff       	jmp    801058ba <alltraps>

80105f45 <vector46>:
.globl vector46
vector46:
  pushl $0
80105f45:	6a 00                	push   $0x0
  pushl $46
80105f47:	6a 2e                	push   $0x2e
  jmp alltraps
80105f49:	e9 6c f9 ff ff       	jmp    801058ba <alltraps>

80105f4e <vector47>:
.globl vector47
vector47:
  pushl $0
80105f4e:	6a 00                	push   $0x0
  pushl $47
80105f50:	6a 2f                	push   $0x2f
  jmp alltraps
80105f52:	e9 63 f9 ff ff       	jmp    801058ba <alltraps>

80105f57 <vector48>:
.globl vector48
vector48:
  pushl $0
80105f57:	6a 00                	push   $0x0
  pushl $48
80105f59:	6a 30                	push   $0x30
  jmp alltraps
80105f5b:	e9 5a f9 ff ff       	jmp    801058ba <alltraps>

80105f60 <vector49>:
.globl vector49
vector49:
  pushl $0
80105f60:	6a 00                	push   $0x0
  pushl $49
80105f62:	6a 31                	push   $0x31
  jmp alltraps
80105f64:	e9 51 f9 ff ff       	jmp    801058ba <alltraps>

80105f69 <vector50>:
.globl vector50
vector50:
  pushl $0
80105f69:	6a 00                	push   $0x0
  pushl $50
80105f6b:	6a 32                	push   $0x32
  jmp alltraps
80105f6d:	e9 48 f9 ff ff       	jmp    801058ba <alltraps>

80105f72 <vector51>:
.globl vector51
vector51:
  pushl $0
80105f72:	6a 00                	push   $0x0
  pushl $51
80105f74:	6a 33                	push   $0x33
  jmp alltraps
80105f76:	e9 3f f9 ff ff       	jmp    801058ba <alltraps>

80105f7b <vector52>:
.globl vector52
vector52:
  pushl $0
80105f7b:	6a 00                	push   $0x0
  pushl $52
80105f7d:	6a 34                	push   $0x34
  jmp alltraps
80105f7f:	e9 36 f9 ff ff       	jmp    801058ba <alltraps>

80105f84 <vector53>:
.globl vector53
vector53:
  pushl $0
80105f84:	6a 00                	push   $0x0
  pushl $53
80105f86:	6a 35                	push   $0x35
  jmp alltraps
80105f88:	e9 2d f9 ff ff       	jmp    801058ba <alltraps>

80105f8d <vector54>:
.globl vector54
vector54:
  pushl $0
80105f8d:	6a 00                	push   $0x0
  pushl $54
80105f8f:	6a 36                	push   $0x36
  jmp alltraps
80105f91:	e9 24 f9 ff ff       	jmp    801058ba <alltraps>

80105f96 <vector55>:
.globl vector55
vector55:
  pushl $0
80105f96:	6a 00                	push   $0x0
  pushl $55
80105f98:	6a 37                	push   $0x37
  jmp alltraps
80105f9a:	e9 1b f9 ff ff       	jmp    801058ba <alltraps>

80105f9f <vector56>:
.globl vector56
vector56:
  pushl $0
80105f9f:	6a 00                	push   $0x0
  pushl $56
80105fa1:	6a 38                	push   $0x38
  jmp alltraps
80105fa3:	e9 12 f9 ff ff       	jmp    801058ba <alltraps>

80105fa8 <vector57>:
.globl vector57
vector57:
  pushl $0
80105fa8:	6a 00                	push   $0x0
  pushl $57
80105faa:	6a 39                	push   $0x39
  jmp alltraps
80105fac:	e9 09 f9 ff ff       	jmp    801058ba <alltraps>

80105fb1 <vector58>:
.globl vector58
vector58:
  pushl $0
80105fb1:	6a 00                	push   $0x0
  pushl $58
80105fb3:	6a 3a                	push   $0x3a
  jmp alltraps
80105fb5:	e9 00 f9 ff ff       	jmp    801058ba <alltraps>

80105fba <vector59>:
.globl vector59
vector59:
  pushl $0
80105fba:	6a 00                	push   $0x0
  pushl $59
80105fbc:	6a 3b                	push   $0x3b
  jmp alltraps
80105fbe:	e9 f7 f8 ff ff       	jmp    801058ba <alltraps>

80105fc3 <vector60>:
.globl vector60
vector60:
  pushl $0
80105fc3:	6a 00                	push   $0x0
  pushl $60
80105fc5:	6a 3c                	push   $0x3c
  jmp alltraps
80105fc7:	e9 ee f8 ff ff       	jmp    801058ba <alltraps>

80105fcc <vector61>:
.globl vector61
vector61:
  pushl $0
80105fcc:	6a 00                	push   $0x0
  pushl $61
80105fce:	6a 3d                	push   $0x3d
  jmp alltraps
80105fd0:	e9 e5 f8 ff ff       	jmp    801058ba <alltraps>

80105fd5 <vector62>:
.globl vector62
vector62:
  pushl $0
80105fd5:	6a 00                	push   $0x0
  pushl $62
80105fd7:	6a 3e                	push   $0x3e
  jmp alltraps
80105fd9:	e9 dc f8 ff ff       	jmp    801058ba <alltraps>

80105fde <vector63>:
.globl vector63
vector63:
  pushl $0
80105fde:	6a 00                	push   $0x0
  pushl $63
80105fe0:	6a 3f                	push   $0x3f
  jmp alltraps
80105fe2:	e9 d3 f8 ff ff       	jmp    801058ba <alltraps>

80105fe7 <vector64>:
.globl vector64
vector64:
  pushl $0
80105fe7:	6a 00                	push   $0x0
  pushl $64
80105fe9:	6a 40                	push   $0x40
  jmp alltraps
80105feb:	e9 ca f8 ff ff       	jmp    801058ba <alltraps>

80105ff0 <vector65>:
.globl vector65
vector65:
  pushl $0
80105ff0:	6a 00                	push   $0x0
  pushl $65
80105ff2:	6a 41                	push   $0x41
  jmp alltraps
80105ff4:	e9 c1 f8 ff ff       	jmp    801058ba <alltraps>

80105ff9 <vector66>:
.globl vector66
vector66:
  pushl $0
80105ff9:	6a 00                	push   $0x0
  pushl $66
80105ffb:	6a 42                	push   $0x42
  jmp alltraps
80105ffd:	e9 b8 f8 ff ff       	jmp    801058ba <alltraps>

80106002 <vector67>:
.globl vector67
vector67:
  pushl $0
80106002:	6a 00                	push   $0x0
  pushl $67
80106004:	6a 43                	push   $0x43
  jmp alltraps
80106006:	e9 af f8 ff ff       	jmp    801058ba <alltraps>

8010600b <vector68>:
.globl vector68
vector68:
  pushl $0
8010600b:	6a 00                	push   $0x0
  pushl $68
8010600d:	6a 44                	push   $0x44
  jmp alltraps
8010600f:	e9 a6 f8 ff ff       	jmp    801058ba <alltraps>

80106014 <vector69>:
.globl vector69
vector69:
  pushl $0
80106014:	6a 00                	push   $0x0
  pushl $69
80106016:	6a 45                	push   $0x45
  jmp alltraps
80106018:	e9 9d f8 ff ff       	jmp    801058ba <alltraps>

8010601d <vector70>:
.globl vector70
vector70:
  pushl $0
8010601d:	6a 00                	push   $0x0
  pushl $70
8010601f:	6a 46                	push   $0x46
  jmp alltraps
80106021:	e9 94 f8 ff ff       	jmp    801058ba <alltraps>

80106026 <vector71>:
.globl vector71
vector71:
  pushl $0
80106026:	6a 00                	push   $0x0
  pushl $71
80106028:	6a 47                	push   $0x47
  jmp alltraps
8010602a:	e9 8b f8 ff ff       	jmp    801058ba <alltraps>

8010602f <vector72>:
.globl vector72
vector72:
  pushl $0
8010602f:	6a 00                	push   $0x0
  pushl $72
80106031:	6a 48                	push   $0x48
  jmp alltraps
80106033:	e9 82 f8 ff ff       	jmp    801058ba <alltraps>

80106038 <vector73>:
.globl vector73
vector73:
  pushl $0
80106038:	6a 00                	push   $0x0
  pushl $73
8010603a:	6a 49                	push   $0x49
  jmp alltraps
8010603c:	e9 79 f8 ff ff       	jmp    801058ba <alltraps>

80106041 <vector74>:
.globl vector74
vector74:
  pushl $0
80106041:	6a 00                	push   $0x0
  pushl $74
80106043:	6a 4a                	push   $0x4a
  jmp alltraps
80106045:	e9 70 f8 ff ff       	jmp    801058ba <alltraps>

8010604a <vector75>:
.globl vector75
vector75:
  pushl $0
8010604a:	6a 00                	push   $0x0
  pushl $75
8010604c:	6a 4b                	push   $0x4b
  jmp alltraps
8010604e:	e9 67 f8 ff ff       	jmp    801058ba <alltraps>

80106053 <vector76>:
.globl vector76
vector76:
  pushl $0
80106053:	6a 00                	push   $0x0
  pushl $76
80106055:	6a 4c                	push   $0x4c
  jmp alltraps
80106057:	e9 5e f8 ff ff       	jmp    801058ba <alltraps>

8010605c <vector77>:
.globl vector77
vector77:
  pushl $0
8010605c:	6a 00                	push   $0x0
  pushl $77
8010605e:	6a 4d                	push   $0x4d
  jmp alltraps
80106060:	e9 55 f8 ff ff       	jmp    801058ba <alltraps>

80106065 <vector78>:
.globl vector78
vector78:
  pushl $0
80106065:	6a 00                	push   $0x0
  pushl $78
80106067:	6a 4e                	push   $0x4e
  jmp alltraps
80106069:	e9 4c f8 ff ff       	jmp    801058ba <alltraps>

8010606e <vector79>:
.globl vector79
vector79:
  pushl $0
8010606e:	6a 00                	push   $0x0
  pushl $79
80106070:	6a 4f                	push   $0x4f
  jmp alltraps
80106072:	e9 43 f8 ff ff       	jmp    801058ba <alltraps>

80106077 <vector80>:
.globl vector80
vector80:
  pushl $0
80106077:	6a 00                	push   $0x0
  pushl $80
80106079:	6a 50                	push   $0x50
  jmp alltraps
8010607b:	e9 3a f8 ff ff       	jmp    801058ba <alltraps>

80106080 <vector81>:
.globl vector81
vector81:
  pushl $0
80106080:	6a 00                	push   $0x0
  pushl $81
80106082:	6a 51                	push   $0x51
  jmp alltraps
80106084:	e9 31 f8 ff ff       	jmp    801058ba <alltraps>

80106089 <vector82>:
.globl vector82
vector82:
  pushl $0
80106089:	6a 00                	push   $0x0
  pushl $82
8010608b:	6a 52                	push   $0x52
  jmp alltraps
8010608d:	e9 28 f8 ff ff       	jmp    801058ba <alltraps>

80106092 <vector83>:
.globl vector83
vector83:
  pushl $0
80106092:	6a 00                	push   $0x0
  pushl $83
80106094:	6a 53                	push   $0x53
  jmp alltraps
80106096:	e9 1f f8 ff ff       	jmp    801058ba <alltraps>

8010609b <vector84>:
.globl vector84
vector84:
  pushl $0
8010609b:	6a 00                	push   $0x0
  pushl $84
8010609d:	6a 54                	push   $0x54
  jmp alltraps
8010609f:	e9 16 f8 ff ff       	jmp    801058ba <alltraps>

801060a4 <vector85>:
.globl vector85
vector85:
  pushl $0
801060a4:	6a 00                	push   $0x0
  pushl $85
801060a6:	6a 55                	push   $0x55
  jmp alltraps
801060a8:	e9 0d f8 ff ff       	jmp    801058ba <alltraps>

801060ad <vector86>:
.globl vector86
vector86:
  pushl $0
801060ad:	6a 00                	push   $0x0
  pushl $86
801060af:	6a 56                	push   $0x56
  jmp alltraps
801060b1:	e9 04 f8 ff ff       	jmp    801058ba <alltraps>

801060b6 <vector87>:
.globl vector87
vector87:
  pushl $0
801060b6:	6a 00                	push   $0x0
  pushl $87
801060b8:	6a 57                	push   $0x57
  jmp alltraps
801060ba:	e9 fb f7 ff ff       	jmp    801058ba <alltraps>

801060bf <vector88>:
.globl vector88
vector88:
  pushl $0
801060bf:	6a 00                	push   $0x0
  pushl $88
801060c1:	6a 58                	push   $0x58
  jmp alltraps
801060c3:	e9 f2 f7 ff ff       	jmp    801058ba <alltraps>

801060c8 <vector89>:
.globl vector89
vector89:
  pushl $0
801060c8:	6a 00                	push   $0x0
  pushl $89
801060ca:	6a 59                	push   $0x59
  jmp alltraps
801060cc:	e9 e9 f7 ff ff       	jmp    801058ba <alltraps>

801060d1 <vector90>:
.globl vector90
vector90:
  pushl $0
801060d1:	6a 00                	push   $0x0
  pushl $90
801060d3:	6a 5a                	push   $0x5a
  jmp alltraps
801060d5:	e9 e0 f7 ff ff       	jmp    801058ba <alltraps>

801060da <vector91>:
.globl vector91
vector91:
  pushl $0
801060da:	6a 00                	push   $0x0
  pushl $91
801060dc:	6a 5b                	push   $0x5b
  jmp alltraps
801060de:	e9 d7 f7 ff ff       	jmp    801058ba <alltraps>

801060e3 <vector92>:
.globl vector92
vector92:
  pushl $0
801060e3:	6a 00                	push   $0x0
  pushl $92
801060e5:	6a 5c                	push   $0x5c
  jmp alltraps
801060e7:	e9 ce f7 ff ff       	jmp    801058ba <alltraps>

801060ec <vector93>:
.globl vector93
vector93:
  pushl $0
801060ec:	6a 00                	push   $0x0
  pushl $93
801060ee:	6a 5d                	push   $0x5d
  jmp alltraps
801060f0:	e9 c5 f7 ff ff       	jmp    801058ba <alltraps>

801060f5 <vector94>:
.globl vector94
vector94:
  pushl $0
801060f5:	6a 00                	push   $0x0
  pushl $94
801060f7:	6a 5e                	push   $0x5e
  jmp alltraps
801060f9:	e9 bc f7 ff ff       	jmp    801058ba <alltraps>

801060fe <vector95>:
.globl vector95
vector95:
  pushl $0
801060fe:	6a 00                	push   $0x0
  pushl $95
80106100:	6a 5f                	push   $0x5f
  jmp alltraps
80106102:	e9 b3 f7 ff ff       	jmp    801058ba <alltraps>

80106107 <vector96>:
.globl vector96
vector96:
  pushl $0
80106107:	6a 00                	push   $0x0
  pushl $96
80106109:	6a 60                	push   $0x60
  jmp alltraps
8010610b:	e9 aa f7 ff ff       	jmp    801058ba <alltraps>

80106110 <vector97>:
.globl vector97
vector97:
  pushl $0
80106110:	6a 00                	push   $0x0
  pushl $97
80106112:	6a 61                	push   $0x61
  jmp alltraps
80106114:	e9 a1 f7 ff ff       	jmp    801058ba <alltraps>

80106119 <vector98>:
.globl vector98
vector98:
  pushl $0
80106119:	6a 00                	push   $0x0
  pushl $98
8010611b:	6a 62                	push   $0x62
  jmp alltraps
8010611d:	e9 98 f7 ff ff       	jmp    801058ba <alltraps>

80106122 <vector99>:
.globl vector99
vector99:
  pushl $0
80106122:	6a 00                	push   $0x0
  pushl $99
80106124:	6a 63                	push   $0x63
  jmp alltraps
80106126:	e9 8f f7 ff ff       	jmp    801058ba <alltraps>

8010612b <vector100>:
.globl vector100
vector100:
  pushl $0
8010612b:	6a 00                	push   $0x0
  pushl $100
8010612d:	6a 64                	push   $0x64
  jmp alltraps
8010612f:	e9 86 f7 ff ff       	jmp    801058ba <alltraps>

80106134 <vector101>:
.globl vector101
vector101:
  pushl $0
80106134:	6a 00                	push   $0x0
  pushl $101
80106136:	6a 65                	push   $0x65
  jmp alltraps
80106138:	e9 7d f7 ff ff       	jmp    801058ba <alltraps>

8010613d <vector102>:
.globl vector102
vector102:
  pushl $0
8010613d:	6a 00                	push   $0x0
  pushl $102
8010613f:	6a 66                	push   $0x66
  jmp alltraps
80106141:	e9 74 f7 ff ff       	jmp    801058ba <alltraps>

80106146 <vector103>:
.globl vector103
vector103:
  pushl $0
80106146:	6a 00                	push   $0x0
  pushl $103
80106148:	6a 67                	push   $0x67
  jmp alltraps
8010614a:	e9 6b f7 ff ff       	jmp    801058ba <alltraps>

8010614f <vector104>:
.globl vector104
vector104:
  pushl $0
8010614f:	6a 00                	push   $0x0
  pushl $104
80106151:	6a 68                	push   $0x68
  jmp alltraps
80106153:	e9 62 f7 ff ff       	jmp    801058ba <alltraps>

80106158 <vector105>:
.globl vector105
vector105:
  pushl $0
80106158:	6a 00                	push   $0x0
  pushl $105
8010615a:	6a 69                	push   $0x69
  jmp alltraps
8010615c:	e9 59 f7 ff ff       	jmp    801058ba <alltraps>

80106161 <vector106>:
.globl vector106
vector106:
  pushl $0
80106161:	6a 00                	push   $0x0
  pushl $106
80106163:	6a 6a                	push   $0x6a
  jmp alltraps
80106165:	e9 50 f7 ff ff       	jmp    801058ba <alltraps>

8010616a <vector107>:
.globl vector107
vector107:
  pushl $0
8010616a:	6a 00                	push   $0x0
  pushl $107
8010616c:	6a 6b                	push   $0x6b
  jmp alltraps
8010616e:	e9 47 f7 ff ff       	jmp    801058ba <alltraps>

80106173 <vector108>:
.globl vector108
vector108:
  pushl $0
80106173:	6a 00                	push   $0x0
  pushl $108
80106175:	6a 6c                	push   $0x6c
  jmp alltraps
80106177:	e9 3e f7 ff ff       	jmp    801058ba <alltraps>

8010617c <vector109>:
.globl vector109
vector109:
  pushl $0
8010617c:	6a 00                	push   $0x0
  pushl $109
8010617e:	6a 6d                	push   $0x6d
  jmp alltraps
80106180:	e9 35 f7 ff ff       	jmp    801058ba <alltraps>

80106185 <vector110>:
.globl vector110
vector110:
  pushl $0
80106185:	6a 00                	push   $0x0
  pushl $110
80106187:	6a 6e                	push   $0x6e
  jmp alltraps
80106189:	e9 2c f7 ff ff       	jmp    801058ba <alltraps>

8010618e <vector111>:
.globl vector111
vector111:
  pushl $0
8010618e:	6a 00                	push   $0x0
  pushl $111
80106190:	6a 6f                	push   $0x6f
  jmp alltraps
80106192:	e9 23 f7 ff ff       	jmp    801058ba <alltraps>

80106197 <vector112>:
.globl vector112
vector112:
  pushl $0
80106197:	6a 00                	push   $0x0
  pushl $112
80106199:	6a 70                	push   $0x70
  jmp alltraps
8010619b:	e9 1a f7 ff ff       	jmp    801058ba <alltraps>

801061a0 <vector113>:
.globl vector113
vector113:
  pushl $0
801061a0:	6a 00                	push   $0x0
  pushl $113
801061a2:	6a 71                	push   $0x71
  jmp alltraps
801061a4:	e9 11 f7 ff ff       	jmp    801058ba <alltraps>

801061a9 <vector114>:
.globl vector114
vector114:
  pushl $0
801061a9:	6a 00                	push   $0x0
  pushl $114
801061ab:	6a 72                	push   $0x72
  jmp alltraps
801061ad:	e9 08 f7 ff ff       	jmp    801058ba <alltraps>

801061b2 <vector115>:
.globl vector115
vector115:
  pushl $0
801061b2:	6a 00                	push   $0x0
  pushl $115
801061b4:	6a 73                	push   $0x73
  jmp alltraps
801061b6:	e9 ff f6 ff ff       	jmp    801058ba <alltraps>

801061bb <vector116>:
.globl vector116
vector116:
  pushl $0
801061bb:	6a 00                	push   $0x0
  pushl $116
801061bd:	6a 74                	push   $0x74
  jmp alltraps
801061bf:	e9 f6 f6 ff ff       	jmp    801058ba <alltraps>

801061c4 <vector117>:
.globl vector117
vector117:
  pushl $0
801061c4:	6a 00                	push   $0x0
  pushl $117
801061c6:	6a 75                	push   $0x75
  jmp alltraps
801061c8:	e9 ed f6 ff ff       	jmp    801058ba <alltraps>

801061cd <vector118>:
.globl vector118
vector118:
  pushl $0
801061cd:	6a 00                	push   $0x0
  pushl $118
801061cf:	6a 76                	push   $0x76
  jmp alltraps
801061d1:	e9 e4 f6 ff ff       	jmp    801058ba <alltraps>

801061d6 <vector119>:
.globl vector119
vector119:
  pushl $0
801061d6:	6a 00                	push   $0x0
  pushl $119
801061d8:	6a 77                	push   $0x77
  jmp alltraps
801061da:	e9 db f6 ff ff       	jmp    801058ba <alltraps>

801061df <vector120>:
.globl vector120
vector120:
  pushl $0
801061df:	6a 00                	push   $0x0
  pushl $120
801061e1:	6a 78                	push   $0x78
  jmp alltraps
801061e3:	e9 d2 f6 ff ff       	jmp    801058ba <alltraps>

801061e8 <vector121>:
.globl vector121
vector121:
  pushl $0
801061e8:	6a 00                	push   $0x0
  pushl $121
801061ea:	6a 79                	push   $0x79
  jmp alltraps
801061ec:	e9 c9 f6 ff ff       	jmp    801058ba <alltraps>

801061f1 <vector122>:
.globl vector122
vector122:
  pushl $0
801061f1:	6a 00                	push   $0x0
  pushl $122
801061f3:	6a 7a                	push   $0x7a
  jmp alltraps
801061f5:	e9 c0 f6 ff ff       	jmp    801058ba <alltraps>

801061fa <vector123>:
.globl vector123
vector123:
  pushl $0
801061fa:	6a 00                	push   $0x0
  pushl $123
801061fc:	6a 7b                	push   $0x7b
  jmp alltraps
801061fe:	e9 b7 f6 ff ff       	jmp    801058ba <alltraps>

80106203 <vector124>:
.globl vector124
vector124:
  pushl $0
80106203:	6a 00                	push   $0x0
  pushl $124
80106205:	6a 7c                	push   $0x7c
  jmp alltraps
80106207:	e9 ae f6 ff ff       	jmp    801058ba <alltraps>

8010620c <vector125>:
.globl vector125
vector125:
  pushl $0
8010620c:	6a 00                	push   $0x0
  pushl $125
8010620e:	6a 7d                	push   $0x7d
  jmp alltraps
80106210:	e9 a5 f6 ff ff       	jmp    801058ba <alltraps>

80106215 <vector126>:
.globl vector126
vector126:
  pushl $0
80106215:	6a 00                	push   $0x0
  pushl $126
80106217:	6a 7e                	push   $0x7e
  jmp alltraps
80106219:	e9 9c f6 ff ff       	jmp    801058ba <alltraps>

8010621e <vector127>:
.globl vector127
vector127:
  pushl $0
8010621e:	6a 00                	push   $0x0
  pushl $127
80106220:	6a 7f                	push   $0x7f
  jmp alltraps
80106222:	e9 93 f6 ff ff       	jmp    801058ba <alltraps>

80106227 <vector128>:
.globl vector128
vector128:
  pushl $0
80106227:	6a 00                	push   $0x0
  pushl $128
80106229:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010622e:	e9 87 f6 ff ff       	jmp    801058ba <alltraps>

80106233 <vector129>:
.globl vector129
vector129:
  pushl $0
80106233:	6a 00                	push   $0x0
  pushl $129
80106235:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010623a:	e9 7b f6 ff ff       	jmp    801058ba <alltraps>

8010623f <vector130>:
.globl vector130
vector130:
  pushl $0
8010623f:	6a 00                	push   $0x0
  pushl $130
80106241:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106246:	e9 6f f6 ff ff       	jmp    801058ba <alltraps>

8010624b <vector131>:
.globl vector131
vector131:
  pushl $0
8010624b:	6a 00                	push   $0x0
  pushl $131
8010624d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106252:	e9 63 f6 ff ff       	jmp    801058ba <alltraps>

80106257 <vector132>:
.globl vector132
vector132:
  pushl $0
80106257:	6a 00                	push   $0x0
  pushl $132
80106259:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010625e:	e9 57 f6 ff ff       	jmp    801058ba <alltraps>

80106263 <vector133>:
.globl vector133
vector133:
  pushl $0
80106263:	6a 00                	push   $0x0
  pushl $133
80106265:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010626a:	e9 4b f6 ff ff       	jmp    801058ba <alltraps>

8010626f <vector134>:
.globl vector134
vector134:
  pushl $0
8010626f:	6a 00                	push   $0x0
  pushl $134
80106271:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106276:	e9 3f f6 ff ff       	jmp    801058ba <alltraps>

8010627b <vector135>:
.globl vector135
vector135:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $135
8010627d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106282:	e9 33 f6 ff ff       	jmp    801058ba <alltraps>

80106287 <vector136>:
.globl vector136
vector136:
  pushl $0
80106287:	6a 00                	push   $0x0
  pushl $136
80106289:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010628e:	e9 27 f6 ff ff       	jmp    801058ba <alltraps>

80106293 <vector137>:
.globl vector137
vector137:
  pushl $0
80106293:	6a 00                	push   $0x0
  pushl $137
80106295:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010629a:	e9 1b f6 ff ff       	jmp    801058ba <alltraps>

8010629f <vector138>:
.globl vector138
vector138:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $138
801062a1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801062a6:	e9 0f f6 ff ff       	jmp    801058ba <alltraps>

801062ab <vector139>:
.globl vector139
vector139:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $139
801062ad:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801062b2:	e9 03 f6 ff ff       	jmp    801058ba <alltraps>

801062b7 <vector140>:
.globl vector140
vector140:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $140
801062b9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801062be:	e9 f7 f5 ff ff       	jmp    801058ba <alltraps>

801062c3 <vector141>:
.globl vector141
vector141:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $141
801062c5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801062ca:	e9 eb f5 ff ff       	jmp    801058ba <alltraps>

801062cf <vector142>:
.globl vector142
vector142:
  pushl $0
801062cf:	6a 00                	push   $0x0
  pushl $142
801062d1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801062d6:	e9 df f5 ff ff       	jmp    801058ba <alltraps>

801062db <vector143>:
.globl vector143
vector143:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $143
801062dd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801062e2:	e9 d3 f5 ff ff       	jmp    801058ba <alltraps>

801062e7 <vector144>:
.globl vector144
vector144:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $144
801062e9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801062ee:	e9 c7 f5 ff ff       	jmp    801058ba <alltraps>

801062f3 <vector145>:
.globl vector145
vector145:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $145
801062f5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801062fa:	e9 bb f5 ff ff       	jmp    801058ba <alltraps>

801062ff <vector146>:
.globl vector146
vector146:
  pushl $0
801062ff:	6a 00                	push   $0x0
  pushl $146
80106301:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106306:	e9 af f5 ff ff       	jmp    801058ba <alltraps>

8010630b <vector147>:
.globl vector147
vector147:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $147
8010630d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106312:	e9 a3 f5 ff ff       	jmp    801058ba <alltraps>

80106317 <vector148>:
.globl vector148
vector148:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $148
80106319:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010631e:	e9 97 f5 ff ff       	jmp    801058ba <alltraps>

80106323 <vector149>:
.globl vector149
vector149:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $149
80106325:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010632a:	e9 8b f5 ff ff       	jmp    801058ba <alltraps>

8010632f <vector150>:
.globl vector150
vector150:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $150
80106331:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106336:	e9 7f f5 ff ff       	jmp    801058ba <alltraps>

8010633b <vector151>:
.globl vector151
vector151:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $151
8010633d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106342:	e9 73 f5 ff ff       	jmp    801058ba <alltraps>

80106347 <vector152>:
.globl vector152
vector152:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $152
80106349:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010634e:	e9 67 f5 ff ff       	jmp    801058ba <alltraps>

80106353 <vector153>:
.globl vector153
vector153:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $153
80106355:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010635a:	e9 5b f5 ff ff       	jmp    801058ba <alltraps>

8010635f <vector154>:
.globl vector154
vector154:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $154
80106361:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106366:	e9 4f f5 ff ff       	jmp    801058ba <alltraps>

8010636b <vector155>:
.globl vector155
vector155:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $155
8010636d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106372:	e9 43 f5 ff ff       	jmp    801058ba <alltraps>

80106377 <vector156>:
.globl vector156
vector156:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $156
80106379:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010637e:	e9 37 f5 ff ff       	jmp    801058ba <alltraps>

80106383 <vector157>:
.globl vector157
vector157:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $157
80106385:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010638a:	e9 2b f5 ff ff       	jmp    801058ba <alltraps>

8010638f <vector158>:
.globl vector158
vector158:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $158
80106391:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106396:	e9 1f f5 ff ff       	jmp    801058ba <alltraps>

8010639b <vector159>:
.globl vector159
vector159:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $159
8010639d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801063a2:	e9 13 f5 ff ff       	jmp    801058ba <alltraps>

801063a7 <vector160>:
.globl vector160
vector160:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $160
801063a9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801063ae:	e9 07 f5 ff ff       	jmp    801058ba <alltraps>

801063b3 <vector161>:
.globl vector161
vector161:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $161
801063b5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801063ba:	e9 fb f4 ff ff       	jmp    801058ba <alltraps>

801063bf <vector162>:
.globl vector162
vector162:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $162
801063c1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801063c6:	e9 ef f4 ff ff       	jmp    801058ba <alltraps>

801063cb <vector163>:
.globl vector163
vector163:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $163
801063cd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801063d2:	e9 e3 f4 ff ff       	jmp    801058ba <alltraps>

801063d7 <vector164>:
.globl vector164
vector164:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $164
801063d9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801063de:	e9 d7 f4 ff ff       	jmp    801058ba <alltraps>

801063e3 <vector165>:
.globl vector165
vector165:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $165
801063e5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801063ea:	e9 cb f4 ff ff       	jmp    801058ba <alltraps>

801063ef <vector166>:
.globl vector166
vector166:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $166
801063f1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801063f6:	e9 bf f4 ff ff       	jmp    801058ba <alltraps>

801063fb <vector167>:
.globl vector167
vector167:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $167
801063fd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106402:	e9 b3 f4 ff ff       	jmp    801058ba <alltraps>

80106407 <vector168>:
.globl vector168
vector168:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $168
80106409:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010640e:	e9 a7 f4 ff ff       	jmp    801058ba <alltraps>

80106413 <vector169>:
.globl vector169
vector169:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $169
80106415:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010641a:	e9 9b f4 ff ff       	jmp    801058ba <alltraps>

8010641f <vector170>:
.globl vector170
vector170:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $170
80106421:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106426:	e9 8f f4 ff ff       	jmp    801058ba <alltraps>

8010642b <vector171>:
.globl vector171
vector171:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $171
8010642d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106432:	e9 83 f4 ff ff       	jmp    801058ba <alltraps>

80106437 <vector172>:
.globl vector172
vector172:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $172
80106439:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010643e:	e9 77 f4 ff ff       	jmp    801058ba <alltraps>

80106443 <vector173>:
.globl vector173
vector173:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $173
80106445:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010644a:	e9 6b f4 ff ff       	jmp    801058ba <alltraps>

8010644f <vector174>:
.globl vector174
vector174:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $174
80106451:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106456:	e9 5f f4 ff ff       	jmp    801058ba <alltraps>

8010645b <vector175>:
.globl vector175
vector175:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $175
8010645d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106462:	e9 53 f4 ff ff       	jmp    801058ba <alltraps>

80106467 <vector176>:
.globl vector176
vector176:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $176
80106469:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010646e:	e9 47 f4 ff ff       	jmp    801058ba <alltraps>

80106473 <vector177>:
.globl vector177
vector177:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $177
80106475:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010647a:	e9 3b f4 ff ff       	jmp    801058ba <alltraps>

8010647f <vector178>:
.globl vector178
vector178:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $178
80106481:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106486:	e9 2f f4 ff ff       	jmp    801058ba <alltraps>

8010648b <vector179>:
.globl vector179
vector179:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $179
8010648d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106492:	e9 23 f4 ff ff       	jmp    801058ba <alltraps>

80106497 <vector180>:
.globl vector180
vector180:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $180
80106499:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010649e:	e9 17 f4 ff ff       	jmp    801058ba <alltraps>

801064a3 <vector181>:
.globl vector181
vector181:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $181
801064a5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801064aa:	e9 0b f4 ff ff       	jmp    801058ba <alltraps>

801064af <vector182>:
.globl vector182
vector182:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $182
801064b1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801064b6:	e9 ff f3 ff ff       	jmp    801058ba <alltraps>

801064bb <vector183>:
.globl vector183
vector183:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $183
801064bd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801064c2:	e9 f3 f3 ff ff       	jmp    801058ba <alltraps>

801064c7 <vector184>:
.globl vector184
vector184:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $184
801064c9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801064ce:	e9 e7 f3 ff ff       	jmp    801058ba <alltraps>

801064d3 <vector185>:
.globl vector185
vector185:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $185
801064d5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801064da:	e9 db f3 ff ff       	jmp    801058ba <alltraps>

801064df <vector186>:
.globl vector186
vector186:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $186
801064e1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801064e6:	e9 cf f3 ff ff       	jmp    801058ba <alltraps>

801064eb <vector187>:
.globl vector187
vector187:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $187
801064ed:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801064f2:	e9 c3 f3 ff ff       	jmp    801058ba <alltraps>

801064f7 <vector188>:
.globl vector188
vector188:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $188
801064f9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801064fe:	e9 b7 f3 ff ff       	jmp    801058ba <alltraps>

80106503 <vector189>:
.globl vector189
vector189:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $189
80106505:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010650a:	e9 ab f3 ff ff       	jmp    801058ba <alltraps>

8010650f <vector190>:
.globl vector190
vector190:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $190
80106511:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106516:	e9 9f f3 ff ff       	jmp    801058ba <alltraps>

8010651b <vector191>:
.globl vector191
vector191:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $191
8010651d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106522:	e9 93 f3 ff ff       	jmp    801058ba <alltraps>

80106527 <vector192>:
.globl vector192
vector192:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $192
80106529:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010652e:	e9 87 f3 ff ff       	jmp    801058ba <alltraps>

80106533 <vector193>:
.globl vector193
vector193:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $193
80106535:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010653a:	e9 7b f3 ff ff       	jmp    801058ba <alltraps>

8010653f <vector194>:
.globl vector194
vector194:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $194
80106541:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106546:	e9 6f f3 ff ff       	jmp    801058ba <alltraps>

8010654b <vector195>:
.globl vector195
vector195:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $195
8010654d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106552:	e9 63 f3 ff ff       	jmp    801058ba <alltraps>

80106557 <vector196>:
.globl vector196
vector196:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $196
80106559:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010655e:	e9 57 f3 ff ff       	jmp    801058ba <alltraps>

80106563 <vector197>:
.globl vector197
vector197:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $197
80106565:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010656a:	e9 4b f3 ff ff       	jmp    801058ba <alltraps>

8010656f <vector198>:
.globl vector198
vector198:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $198
80106571:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106576:	e9 3f f3 ff ff       	jmp    801058ba <alltraps>

8010657b <vector199>:
.globl vector199
vector199:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $199
8010657d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106582:	e9 33 f3 ff ff       	jmp    801058ba <alltraps>

80106587 <vector200>:
.globl vector200
vector200:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $200
80106589:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010658e:	e9 27 f3 ff ff       	jmp    801058ba <alltraps>

80106593 <vector201>:
.globl vector201
vector201:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $201
80106595:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010659a:	e9 1b f3 ff ff       	jmp    801058ba <alltraps>

8010659f <vector202>:
.globl vector202
vector202:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $202
801065a1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801065a6:	e9 0f f3 ff ff       	jmp    801058ba <alltraps>

801065ab <vector203>:
.globl vector203
vector203:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $203
801065ad:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801065b2:	e9 03 f3 ff ff       	jmp    801058ba <alltraps>

801065b7 <vector204>:
.globl vector204
vector204:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $204
801065b9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801065be:	e9 f7 f2 ff ff       	jmp    801058ba <alltraps>

801065c3 <vector205>:
.globl vector205
vector205:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $205
801065c5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801065ca:	e9 eb f2 ff ff       	jmp    801058ba <alltraps>

801065cf <vector206>:
.globl vector206
vector206:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $206
801065d1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801065d6:	e9 df f2 ff ff       	jmp    801058ba <alltraps>

801065db <vector207>:
.globl vector207
vector207:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $207
801065dd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801065e2:	e9 d3 f2 ff ff       	jmp    801058ba <alltraps>

801065e7 <vector208>:
.globl vector208
vector208:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $208
801065e9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801065ee:	e9 c7 f2 ff ff       	jmp    801058ba <alltraps>

801065f3 <vector209>:
.globl vector209
vector209:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $209
801065f5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801065fa:	e9 bb f2 ff ff       	jmp    801058ba <alltraps>

801065ff <vector210>:
.globl vector210
vector210:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $210
80106601:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106606:	e9 af f2 ff ff       	jmp    801058ba <alltraps>

8010660b <vector211>:
.globl vector211
vector211:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $211
8010660d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106612:	e9 a3 f2 ff ff       	jmp    801058ba <alltraps>

80106617 <vector212>:
.globl vector212
vector212:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $212
80106619:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010661e:	e9 97 f2 ff ff       	jmp    801058ba <alltraps>

80106623 <vector213>:
.globl vector213
vector213:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $213
80106625:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010662a:	e9 8b f2 ff ff       	jmp    801058ba <alltraps>

8010662f <vector214>:
.globl vector214
vector214:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $214
80106631:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106636:	e9 7f f2 ff ff       	jmp    801058ba <alltraps>

8010663b <vector215>:
.globl vector215
vector215:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $215
8010663d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106642:	e9 73 f2 ff ff       	jmp    801058ba <alltraps>

80106647 <vector216>:
.globl vector216
vector216:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $216
80106649:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010664e:	e9 67 f2 ff ff       	jmp    801058ba <alltraps>

80106653 <vector217>:
.globl vector217
vector217:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $217
80106655:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010665a:	e9 5b f2 ff ff       	jmp    801058ba <alltraps>

8010665f <vector218>:
.globl vector218
vector218:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $218
80106661:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106666:	e9 4f f2 ff ff       	jmp    801058ba <alltraps>

8010666b <vector219>:
.globl vector219
vector219:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $219
8010666d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106672:	e9 43 f2 ff ff       	jmp    801058ba <alltraps>

80106677 <vector220>:
.globl vector220
vector220:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $220
80106679:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010667e:	e9 37 f2 ff ff       	jmp    801058ba <alltraps>

80106683 <vector221>:
.globl vector221
vector221:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $221
80106685:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010668a:	e9 2b f2 ff ff       	jmp    801058ba <alltraps>

8010668f <vector222>:
.globl vector222
vector222:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $222
80106691:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106696:	e9 1f f2 ff ff       	jmp    801058ba <alltraps>

8010669b <vector223>:
.globl vector223
vector223:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $223
8010669d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801066a2:	e9 13 f2 ff ff       	jmp    801058ba <alltraps>

801066a7 <vector224>:
.globl vector224
vector224:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $224
801066a9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801066ae:	e9 07 f2 ff ff       	jmp    801058ba <alltraps>

801066b3 <vector225>:
.globl vector225
vector225:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $225
801066b5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801066ba:	e9 fb f1 ff ff       	jmp    801058ba <alltraps>

801066bf <vector226>:
.globl vector226
vector226:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $226
801066c1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801066c6:	e9 ef f1 ff ff       	jmp    801058ba <alltraps>

801066cb <vector227>:
.globl vector227
vector227:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $227
801066cd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801066d2:	e9 e3 f1 ff ff       	jmp    801058ba <alltraps>

801066d7 <vector228>:
.globl vector228
vector228:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $228
801066d9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801066de:	e9 d7 f1 ff ff       	jmp    801058ba <alltraps>

801066e3 <vector229>:
.globl vector229
vector229:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $229
801066e5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801066ea:	e9 cb f1 ff ff       	jmp    801058ba <alltraps>

801066ef <vector230>:
.globl vector230
vector230:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $230
801066f1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801066f6:	e9 bf f1 ff ff       	jmp    801058ba <alltraps>

801066fb <vector231>:
.globl vector231
vector231:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $231
801066fd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106702:	e9 b3 f1 ff ff       	jmp    801058ba <alltraps>

80106707 <vector232>:
.globl vector232
vector232:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $232
80106709:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010670e:	e9 a7 f1 ff ff       	jmp    801058ba <alltraps>

80106713 <vector233>:
.globl vector233
vector233:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $233
80106715:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010671a:	e9 9b f1 ff ff       	jmp    801058ba <alltraps>

8010671f <vector234>:
.globl vector234
vector234:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $234
80106721:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106726:	e9 8f f1 ff ff       	jmp    801058ba <alltraps>

8010672b <vector235>:
.globl vector235
vector235:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $235
8010672d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106732:	e9 83 f1 ff ff       	jmp    801058ba <alltraps>

80106737 <vector236>:
.globl vector236
vector236:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $236
80106739:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010673e:	e9 77 f1 ff ff       	jmp    801058ba <alltraps>

80106743 <vector237>:
.globl vector237
vector237:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $237
80106745:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010674a:	e9 6b f1 ff ff       	jmp    801058ba <alltraps>

8010674f <vector238>:
.globl vector238
vector238:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $238
80106751:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106756:	e9 5f f1 ff ff       	jmp    801058ba <alltraps>

8010675b <vector239>:
.globl vector239
vector239:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $239
8010675d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106762:	e9 53 f1 ff ff       	jmp    801058ba <alltraps>

80106767 <vector240>:
.globl vector240
vector240:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $240
80106769:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010676e:	e9 47 f1 ff ff       	jmp    801058ba <alltraps>

80106773 <vector241>:
.globl vector241
vector241:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $241
80106775:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010677a:	e9 3b f1 ff ff       	jmp    801058ba <alltraps>

8010677f <vector242>:
.globl vector242
vector242:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $242
80106781:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106786:	e9 2f f1 ff ff       	jmp    801058ba <alltraps>

8010678b <vector243>:
.globl vector243
vector243:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $243
8010678d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106792:	e9 23 f1 ff ff       	jmp    801058ba <alltraps>

80106797 <vector244>:
.globl vector244
vector244:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $244
80106799:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010679e:	e9 17 f1 ff ff       	jmp    801058ba <alltraps>

801067a3 <vector245>:
.globl vector245
vector245:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $245
801067a5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801067aa:	e9 0b f1 ff ff       	jmp    801058ba <alltraps>

801067af <vector246>:
.globl vector246
vector246:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $246
801067b1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801067b6:	e9 ff f0 ff ff       	jmp    801058ba <alltraps>

801067bb <vector247>:
.globl vector247
vector247:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $247
801067bd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801067c2:	e9 f3 f0 ff ff       	jmp    801058ba <alltraps>

801067c7 <vector248>:
.globl vector248
vector248:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $248
801067c9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801067ce:	e9 e7 f0 ff ff       	jmp    801058ba <alltraps>

801067d3 <vector249>:
.globl vector249
vector249:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $249
801067d5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801067da:	e9 db f0 ff ff       	jmp    801058ba <alltraps>

801067df <vector250>:
.globl vector250
vector250:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $250
801067e1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801067e6:	e9 cf f0 ff ff       	jmp    801058ba <alltraps>

801067eb <vector251>:
.globl vector251
vector251:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $251
801067ed:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801067f2:	e9 c3 f0 ff ff       	jmp    801058ba <alltraps>

801067f7 <vector252>:
.globl vector252
vector252:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $252
801067f9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801067fe:	e9 b7 f0 ff ff       	jmp    801058ba <alltraps>

80106803 <vector253>:
.globl vector253
vector253:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $253
80106805:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010680a:	e9 ab f0 ff ff       	jmp    801058ba <alltraps>

8010680f <vector254>:
.globl vector254
vector254:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $254
80106811:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106816:	e9 9f f0 ff ff       	jmp    801058ba <alltraps>

8010681b <vector255>:
.globl vector255
vector255:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $255
8010681d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106822:	e9 93 f0 ff ff       	jmp    801058ba <alltraps>
80106827:	66 90                	xchg   %ax,%ax
80106829:	66 90                	xchg   %ax,%ax
8010682b:	66 90                	xchg   %ax,%ax
8010682d:	66 90                	xchg   %ax,%ax
8010682f:	90                   	nop

80106830 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106830:	55                   	push   %ebp
80106831:	89 e5                	mov    %esp,%ebp
80106833:	57                   	push   %edi
80106834:	56                   	push   %esi
80106835:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106836:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
8010683c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106842:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
80106845:	39 d3                	cmp    %edx,%ebx
80106847:	73 56                	jae    8010689f <deallocuvm.part.0+0x6f>
80106849:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010684c:	89 c6                	mov    %eax,%esi
8010684e:	89 d7                	mov    %edx,%edi
80106850:	eb 12                	jmp    80106864 <deallocuvm.part.0+0x34>
80106852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106858:	83 c2 01             	add    $0x1,%edx
8010685b:	89 d3                	mov    %edx,%ebx
8010685d:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106860:	39 fb                	cmp    %edi,%ebx
80106862:	73 38                	jae    8010689c <deallocuvm.part.0+0x6c>
  pde = &pgdir[PDX(va)];
80106864:	89 da                	mov    %ebx,%edx
80106866:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106869:	8b 04 96             	mov    (%esi,%edx,4),%eax
8010686c:	a8 01                	test   $0x1,%al
8010686e:	74 e8                	je     80106858 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
80106870:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106872:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106877:	c1 e9 0a             	shr    $0xa,%ecx
8010687a:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106880:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
80106887:	85 c0                	test   %eax,%eax
80106889:	74 cd                	je     80106858 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
8010688b:	8b 10                	mov    (%eax),%edx
8010688d:	f6 c2 01             	test   $0x1,%dl
80106890:	75 1e                	jne    801068b0 <deallocuvm.part.0+0x80>
  for(; a  < oldsz; a += PGSIZE){
80106892:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106898:	39 fb                	cmp    %edi,%ebx
8010689a:	72 c8                	jb     80106864 <deallocuvm.part.0+0x34>
8010689c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
8010689f:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068a2:	89 c8                	mov    %ecx,%eax
801068a4:	5b                   	pop    %ebx
801068a5:	5e                   	pop    %esi
801068a6:	5f                   	pop    %edi
801068a7:	5d                   	pop    %ebp
801068a8:	c3                   	ret
801068a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
801068b0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801068b6:	74 26                	je     801068de <deallocuvm.part.0+0xae>
      kfree(v);
801068b8:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801068bb:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801068c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801068c4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
801068ca:	52                   	push   %edx
801068cb:	e8 50 bc ff ff       	call   80102520 <kfree>
      *pte = 0;
801068d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
801068d3:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
801068d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801068dc:	eb 82                	jmp    80106860 <deallocuvm.part.0+0x30>
        panic("kfree");
801068de:	83 ec 0c             	sub    $0xc,%esp
801068e1:	68 66 74 10 80       	push   $0x80107466
801068e6:	e8 95 9a ff ff       	call   80100380 <panic>
801068eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801068ef:	90                   	nop

801068f0 <mappages>:
{
801068f0:	55                   	push   %ebp
801068f1:	89 e5                	mov    %esp,%ebp
801068f3:	57                   	push   %edi
801068f4:	56                   	push   %esi
801068f5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
801068f6:	89 d3                	mov    %edx,%ebx
801068f8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801068fe:	83 ec 1c             	sub    $0x1c,%esp
80106901:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106904:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106908:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010690d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106910:	8b 45 08             	mov    0x8(%ebp),%eax
80106913:	29 d8                	sub    %ebx,%eax
80106915:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106918:	eb 3f                	jmp    80106959 <mappages+0x69>
8010691a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106920:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106922:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106927:	c1 ea 0a             	shr    $0xa,%edx
8010692a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106930:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106937:	85 c0                	test   %eax,%eax
80106939:	74 75                	je     801069b0 <mappages+0xc0>
    if(*pte & PTE_P)
8010693b:	f6 00 01             	testb  $0x1,(%eax)
8010693e:	0f 85 86 00 00 00    	jne    801069ca <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106944:	0b 75 0c             	or     0xc(%ebp),%esi
80106947:	83 ce 01             	or     $0x1,%esi
8010694a:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010694c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010694f:	39 c3                	cmp    %eax,%ebx
80106951:	74 6d                	je     801069c0 <mappages+0xd0>
    a += PGSIZE;
80106953:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106959:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
8010695c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010695f:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80106962:	89 d8                	mov    %ebx,%eax
80106964:	c1 e8 16             	shr    $0x16,%eax
80106967:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
8010696a:	8b 07                	mov    (%edi),%eax
8010696c:	a8 01                	test   $0x1,%al
8010696e:	75 b0                	jne    80106920 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106970:	e8 6b bd ff ff       	call   801026e0 <kalloc>
80106975:	85 c0                	test   %eax,%eax
80106977:	74 37                	je     801069b0 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106979:	83 ec 04             	sub    $0x4,%esp
8010697c:	68 00 10 00 00       	push   $0x1000
80106981:	6a 00                	push   $0x0
80106983:	50                   	push   %eax
80106984:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106987:	e8 74 dd ff ff       	call   80104700 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010698c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
8010698f:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106992:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106998:	83 c8 07             	or     $0x7,%eax
8010699b:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
8010699d:	89 d8                	mov    %ebx,%eax
8010699f:	c1 e8 0a             	shr    $0xa,%eax
801069a2:	25 fc 0f 00 00       	and    $0xffc,%eax
801069a7:	01 d0                	add    %edx,%eax
801069a9:	eb 90                	jmp    8010693b <mappages+0x4b>
801069ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801069af:	90                   	nop
}
801069b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801069b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801069b8:	5b                   	pop    %ebx
801069b9:	5e                   	pop    %esi
801069ba:	5f                   	pop    %edi
801069bb:	5d                   	pop    %ebp
801069bc:	c3                   	ret
801069bd:	8d 76 00             	lea    0x0(%esi),%esi
801069c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801069c3:	31 c0                	xor    %eax,%eax
}
801069c5:	5b                   	pop    %ebx
801069c6:	5e                   	pop    %esi
801069c7:	5f                   	pop    %edi
801069c8:	5d                   	pop    %ebp
801069c9:	c3                   	ret
      panic("remap");
801069ca:	83 ec 0c             	sub    $0xc,%esp
801069cd:	68 ac 7a 10 80       	push   $0x80107aac
801069d2:	e8 a9 99 ff ff       	call   80100380 <panic>
801069d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069de:	66 90                	xchg   %ax,%ax

801069e0 <seginit>:
{
801069e0:	55                   	push   %ebp
801069e1:	89 e5                	mov    %esp,%ebp
801069e3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801069e6:	e8 e5 cf ff ff       	call   801039d0 <cpuid>
  pd[0] = size-1;
801069eb:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801069f0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801069f6:	c7 80 18 18 11 80 ff 	movl   $0xffff,-0x7feee7e8(%eax)
801069fd:	ff 00 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106a00:	c7 80 20 18 11 80 ff 	movl   $0xffff,-0x7feee7e0(%eax)
80106a07:	ff 00 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106a0a:	c7 80 28 18 11 80 ff 	movl   $0xffff,-0x7feee7d8(%eax)
80106a11:	ff 00 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106a14:	c7 80 30 18 11 80 ff 	movl   $0xffff,-0x7feee7d0(%eax)
80106a1b:	ff 00 00 
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106a1e:	c7 80 1c 18 11 80 00 	movl   $0xcf9a00,-0x7feee7e4(%eax)
80106a25:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106a28:	c7 80 24 18 11 80 00 	movl   $0xcf9200,-0x7feee7dc(%eax)
80106a2f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106a32:	c7 80 2c 18 11 80 00 	movl   $0xcffa00,-0x7feee7d4(%eax)
80106a39:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106a3c:	c7 80 34 18 11 80 00 	movl   $0xcff200,-0x7feee7cc(%eax)
80106a43:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106a46:	05 10 18 11 80       	add    $0x80111810,%eax
80106a4b:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80106a4f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106a53:	c1 e8 10             	shr    $0x10,%eax
80106a56:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106a5a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106a5d:	0f 01 10             	lgdtl  (%eax)
}
80106a60:	c9                   	leave
80106a61:	c3                   	ret
80106a62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106a70 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106a70:	a1 c4 44 11 80       	mov    0x801144c4,%eax
80106a75:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106a7a:	0f 22 d8             	mov    %eax,%cr3
}
80106a7d:	c3                   	ret
80106a7e:	66 90                	xchg   %ax,%ax

80106a80 <switchuvm>:
{
80106a80:	55                   	push   %ebp
80106a81:	89 e5                	mov    %esp,%ebp
80106a83:	57                   	push   %edi
80106a84:	56                   	push   %esi
80106a85:	53                   	push   %ebx
80106a86:	83 ec 1c             	sub    $0x1c,%esp
80106a89:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106a8c:	85 f6                	test   %esi,%esi
80106a8e:	0f 84 cb 00 00 00    	je     80106b5f <switchuvm+0xdf>
  if(p->kstack == 0)
80106a94:	8b 46 08             	mov    0x8(%esi),%eax
80106a97:	85 c0                	test   %eax,%eax
80106a99:	0f 84 da 00 00 00    	je     80106b79 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106a9f:	8b 46 04             	mov    0x4(%esi),%eax
80106aa2:	85 c0                	test   %eax,%eax
80106aa4:	0f 84 c2 00 00 00    	je     80106b6c <switchuvm+0xec>
  pushcli();
80106aaa:	e8 21 da ff ff       	call   801044d0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106aaf:	e8 bc ce ff ff       	call   80103970 <mycpu>
80106ab4:	89 c3                	mov    %eax,%ebx
80106ab6:	e8 b5 ce ff ff       	call   80103970 <mycpu>
80106abb:	89 c7                	mov    %eax,%edi
80106abd:	e8 ae ce ff ff       	call   80103970 <mycpu>
80106ac2:	83 c7 08             	add    $0x8,%edi
80106ac5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106ac8:	e8 a3 ce ff ff       	call   80103970 <mycpu>
80106acd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106ad0:	ba 67 00 00 00       	mov    $0x67,%edx
80106ad5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106adc:	83 c0 08             	add    $0x8,%eax
80106adf:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106ae6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106aeb:	83 c1 08             	add    $0x8,%ecx
80106aee:	c1 e8 18             	shr    $0x18,%eax
80106af1:	c1 e9 10             	shr    $0x10,%ecx
80106af4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106afa:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106b00:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106b05:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106b0c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106b11:	e8 5a ce ff ff       	call   80103970 <mycpu>
80106b16:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106b1d:	e8 4e ce ff ff       	call   80103970 <mycpu>
80106b22:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106b26:	8b 5e 08             	mov    0x8(%esi),%ebx
80106b29:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b2f:	e8 3c ce ff ff       	call   80103970 <mycpu>
80106b34:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106b37:	e8 34 ce ff ff       	call   80103970 <mycpu>
80106b3c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106b40:	b8 28 00 00 00       	mov    $0x28,%eax
80106b45:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106b48:	8b 46 04             	mov    0x4(%esi),%eax
80106b4b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106b50:	0f 22 d8             	mov    %eax,%cr3
}
80106b53:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b56:	5b                   	pop    %ebx
80106b57:	5e                   	pop    %esi
80106b58:	5f                   	pop    %edi
80106b59:	5d                   	pop    %ebp
  popcli();
80106b5a:	e9 c1 d9 ff ff       	jmp    80104520 <popcli>
    panic("switchuvm: no process");
80106b5f:	83 ec 0c             	sub    $0xc,%esp
80106b62:	68 b2 7a 10 80       	push   $0x80107ab2
80106b67:	e8 14 98 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106b6c:	83 ec 0c             	sub    $0xc,%esp
80106b6f:	68 dd 7a 10 80       	push   $0x80107add
80106b74:	e8 07 98 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106b79:	83 ec 0c             	sub    $0xc,%esp
80106b7c:	68 c8 7a 10 80       	push   $0x80107ac8
80106b81:	e8 fa 97 ff ff       	call   80100380 <panic>
80106b86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b8d:	8d 76 00             	lea    0x0(%esi),%esi

80106b90 <inituvm>:
{
80106b90:	55                   	push   %ebp
80106b91:	89 e5                	mov    %esp,%ebp
80106b93:	57                   	push   %edi
80106b94:	56                   	push   %esi
80106b95:	53                   	push   %ebx
80106b96:	83 ec 1c             	sub    $0x1c,%esp
80106b99:	8b 45 08             	mov    0x8(%ebp),%eax
80106b9c:	8b 75 10             	mov    0x10(%ebp),%esi
80106b9f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106ba2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106ba5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106bab:	77 49                	ja     80106bf6 <inituvm+0x66>
  mem = kalloc();
80106bad:	e8 2e bb ff ff       	call   801026e0 <kalloc>
  memset(mem, 0, PGSIZE);
80106bb2:	83 ec 04             	sub    $0x4,%esp
80106bb5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106bba:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106bbc:	6a 00                	push   $0x0
80106bbe:	50                   	push   %eax
80106bbf:	e8 3c db ff ff       	call   80104700 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106bc4:	58                   	pop    %eax
80106bc5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106bcb:	5a                   	pop    %edx
80106bcc:	6a 06                	push   $0x6
80106bce:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106bd3:	31 d2                	xor    %edx,%edx
80106bd5:	50                   	push   %eax
80106bd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106bd9:	e8 12 fd ff ff       	call   801068f0 <mappages>
  memmove(mem, init, sz);
80106bde:	89 75 10             	mov    %esi,0x10(%ebp)
80106be1:	83 c4 10             	add    $0x10,%esp
80106be4:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106be7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106bea:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bed:	5b                   	pop    %ebx
80106bee:	5e                   	pop    %esi
80106bef:	5f                   	pop    %edi
80106bf0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106bf1:	e9 9a db ff ff       	jmp    80104790 <memmove>
    panic("inituvm: more than a page");
80106bf6:	83 ec 0c             	sub    $0xc,%esp
80106bf9:	68 f1 7a 10 80       	push   $0x80107af1
80106bfe:	e8 7d 97 ff ff       	call   80100380 <panic>
80106c03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c10 <loaduvm>:
{
80106c10:	55                   	push   %ebp
80106c11:	89 e5                	mov    %esp,%ebp
80106c13:	57                   	push   %edi
80106c14:	56                   	push   %esi
80106c15:	53                   	push   %ebx
80106c16:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106c19:	8b 75 0c             	mov    0xc(%ebp),%esi
{
80106c1c:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
80106c1f:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106c25:	0f 85 a2 00 00 00    	jne    80106ccd <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
80106c2b:	85 ff                	test   %edi,%edi
80106c2d:	74 7d                	je     80106cac <loaduvm+0x9c>
80106c2f:	90                   	nop
  pde = &pgdir[PDX(va)];
80106c30:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80106c33:	8b 55 08             	mov    0x8(%ebp),%edx
80106c36:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
80106c38:	89 c1                	mov    %eax,%ecx
80106c3a:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80106c3d:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
80106c40:	f6 c1 01             	test   $0x1,%cl
80106c43:	75 13                	jne    80106c58 <loaduvm+0x48>
      panic("loaduvm: address should exist");
80106c45:	83 ec 0c             	sub    $0xc,%esp
80106c48:	68 0b 7b 10 80       	push   $0x80107b0b
80106c4d:	e8 2e 97 ff ff       	call   80100380 <panic>
80106c52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106c58:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106c5b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106c61:	25 fc 0f 00 00       	and    $0xffc,%eax
80106c66:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106c6d:	85 c9                	test   %ecx,%ecx
80106c6f:	74 d4                	je     80106c45 <loaduvm+0x35>
    if(sz - i < PGSIZE)
80106c71:	89 fb                	mov    %edi,%ebx
80106c73:	b8 00 10 00 00       	mov    $0x1000,%eax
80106c78:	29 f3                	sub    %esi,%ebx
80106c7a:	39 c3                	cmp    %eax,%ebx
80106c7c:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106c7f:	53                   	push   %ebx
80106c80:	8b 45 14             	mov    0x14(%ebp),%eax
80106c83:	01 f0                	add    %esi,%eax
80106c85:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
80106c86:	8b 01                	mov    (%ecx),%eax
80106c88:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106c8d:	05 00 00 00 80       	add    $0x80000000,%eax
80106c92:	50                   	push   %eax
80106c93:	ff 75 10             	push   0x10(%ebp)
80106c96:	e8 45 ae ff ff       	call   80101ae0 <readi>
80106c9b:	83 c4 10             	add    $0x10,%esp
80106c9e:	39 d8                	cmp    %ebx,%eax
80106ca0:	75 1e                	jne    80106cc0 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
80106ca2:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106ca8:	39 fe                	cmp    %edi,%esi
80106caa:	72 84                	jb     80106c30 <loaduvm+0x20>
}
80106cac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106caf:	31 c0                	xor    %eax,%eax
}
80106cb1:	5b                   	pop    %ebx
80106cb2:	5e                   	pop    %esi
80106cb3:	5f                   	pop    %edi
80106cb4:	5d                   	pop    %ebp
80106cb5:	c3                   	ret
80106cb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cbd:	8d 76 00             	lea    0x0(%esi),%esi
80106cc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106cc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106cc8:	5b                   	pop    %ebx
80106cc9:	5e                   	pop    %esi
80106cca:	5f                   	pop    %edi
80106ccb:	5d                   	pop    %ebp
80106ccc:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
80106ccd:	83 ec 0c             	sub    $0xc,%esp
80106cd0:	68 ac 7b 10 80       	push   $0x80107bac
80106cd5:	e8 a6 96 ff ff       	call   80100380 <panic>
80106cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ce0 <allocuvm>:
{
80106ce0:	55                   	push   %ebp
80106ce1:	89 e5                	mov    %esp,%ebp
80106ce3:	57                   	push   %edi
80106ce4:	56                   	push   %esi
80106ce5:	53                   	push   %ebx
80106ce6:	83 ec 1c             	sub    $0x1c,%esp
80106ce9:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
80106cec:	85 f6                	test   %esi,%esi
80106cee:	0f 88 98 00 00 00    	js     80106d8c <allocuvm+0xac>
80106cf4:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
80106cf6:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106cf9:	0f 82 a1 00 00 00    	jb     80106da0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106cff:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d02:	05 ff 0f 00 00       	add    $0xfff,%eax
80106d07:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d0c:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
80106d0e:	39 f0                	cmp    %esi,%eax
80106d10:	0f 83 8d 00 00 00    	jae    80106da3 <allocuvm+0xc3>
80106d16:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80106d19:	eb 44                	jmp    80106d5f <allocuvm+0x7f>
80106d1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106d1f:	90                   	nop
    memset(mem, 0, PGSIZE);
80106d20:	83 ec 04             	sub    $0x4,%esp
80106d23:	68 00 10 00 00       	push   $0x1000
80106d28:	6a 00                	push   $0x0
80106d2a:	50                   	push   %eax
80106d2b:	e8 d0 d9 ff ff       	call   80104700 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106d30:	58                   	pop    %eax
80106d31:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106d37:	5a                   	pop    %edx
80106d38:	6a 06                	push   $0x6
80106d3a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106d3f:	89 fa                	mov    %edi,%edx
80106d41:	50                   	push   %eax
80106d42:	8b 45 08             	mov    0x8(%ebp),%eax
80106d45:	e8 a6 fb ff ff       	call   801068f0 <mappages>
80106d4a:	83 c4 10             	add    $0x10,%esp
80106d4d:	85 c0                	test   %eax,%eax
80106d4f:	78 5f                	js     80106db0 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
80106d51:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106d57:	39 f7                	cmp    %esi,%edi
80106d59:	0f 83 89 00 00 00    	jae    80106de8 <allocuvm+0x108>
    mem = kalloc();
80106d5f:	e8 7c b9 ff ff       	call   801026e0 <kalloc>
80106d64:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106d66:	85 c0                	test   %eax,%eax
80106d68:	75 b6                	jne    80106d20 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106d6a:	83 ec 0c             	sub    $0xc,%esp
80106d6d:	68 29 7b 10 80       	push   $0x80107b29
80106d72:	e8 39 99 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106d77:	83 c4 10             	add    $0x10,%esp
80106d7a:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106d7d:	74 0d                	je     80106d8c <allocuvm+0xac>
80106d7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106d82:	8b 45 08             	mov    0x8(%ebp),%eax
80106d85:	89 f2                	mov    %esi,%edx
80106d87:	e8 a4 fa ff ff       	call   80106830 <deallocuvm.part.0>
    return 0;
80106d8c:	31 d2                	xor    %edx,%edx
}
80106d8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d91:	89 d0                	mov    %edx,%eax
80106d93:	5b                   	pop    %ebx
80106d94:	5e                   	pop    %esi
80106d95:	5f                   	pop    %edi
80106d96:	5d                   	pop    %ebp
80106d97:	c3                   	ret
80106d98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d9f:	90                   	nop
    return oldsz;
80106da0:	8b 55 0c             	mov    0xc(%ebp),%edx
}
80106da3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106da6:	89 d0                	mov    %edx,%eax
80106da8:	5b                   	pop    %ebx
80106da9:	5e                   	pop    %esi
80106daa:	5f                   	pop    %edi
80106dab:	5d                   	pop    %ebp
80106dac:	c3                   	ret
80106dad:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106db0:	83 ec 0c             	sub    $0xc,%esp
80106db3:	68 41 7b 10 80       	push   $0x80107b41
80106db8:	e8 f3 98 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106dbd:	83 c4 10             	add    $0x10,%esp
80106dc0:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106dc3:	74 0d                	je     80106dd2 <allocuvm+0xf2>
80106dc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106dc8:	8b 45 08             	mov    0x8(%ebp),%eax
80106dcb:	89 f2                	mov    %esi,%edx
80106dcd:	e8 5e fa ff ff       	call   80106830 <deallocuvm.part.0>
      kfree(mem);
80106dd2:	83 ec 0c             	sub    $0xc,%esp
80106dd5:	53                   	push   %ebx
80106dd6:	e8 45 b7 ff ff       	call   80102520 <kfree>
      return 0;
80106ddb:	83 c4 10             	add    $0x10,%esp
    return 0;
80106dde:	31 d2                	xor    %edx,%edx
80106de0:	eb ac                	jmp    80106d8e <allocuvm+0xae>
80106de2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106de8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
80106deb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106dee:	5b                   	pop    %ebx
80106def:	5e                   	pop    %esi
80106df0:	89 d0                	mov    %edx,%eax
80106df2:	5f                   	pop    %edi
80106df3:	5d                   	pop    %ebp
80106df4:	c3                   	ret
80106df5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106e00 <deallocuvm>:
{
80106e00:	55                   	push   %ebp
80106e01:	89 e5                	mov    %esp,%ebp
80106e03:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e06:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106e09:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106e0c:	39 d1                	cmp    %edx,%ecx
80106e0e:	73 10                	jae    80106e20 <deallocuvm+0x20>
}
80106e10:	5d                   	pop    %ebp
80106e11:	e9 1a fa ff ff       	jmp    80106830 <deallocuvm.part.0>
80106e16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e1d:	8d 76 00             	lea    0x0(%esi),%esi
80106e20:	89 d0                	mov    %edx,%eax
80106e22:	5d                   	pop    %ebp
80106e23:	c3                   	ret
80106e24:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106e2f:	90                   	nop

80106e30 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106e30:	55                   	push   %ebp
80106e31:	89 e5                	mov    %esp,%ebp
80106e33:	57                   	push   %edi
80106e34:	56                   	push   %esi
80106e35:	53                   	push   %ebx
80106e36:	83 ec 0c             	sub    $0xc,%esp
80106e39:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106e3c:	85 f6                	test   %esi,%esi
80106e3e:	74 59                	je     80106e99 <freevm+0x69>
  if(newsz >= oldsz)
80106e40:	31 c9                	xor    %ecx,%ecx
80106e42:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106e47:	89 f0                	mov    %esi,%eax
80106e49:	89 f3                	mov    %esi,%ebx
80106e4b:	e8 e0 f9 ff ff       	call   80106830 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106e50:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106e56:	eb 0f                	jmp    80106e67 <freevm+0x37>
80106e58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e5f:	90                   	nop
80106e60:	83 c3 04             	add    $0x4,%ebx
80106e63:	39 fb                	cmp    %edi,%ebx
80106e65:	74 23                	je     80106e8a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106e67:	8b 03                	mov    (%ebx),%eax
80106e69:	a8 01                	test   $0x1,%al
80106e6b:	74 f3                	je     80106e60 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106e6d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106e72:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106e75:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106e78:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106e7d:	50                   	push   %eax
80106e7e:	e8 9d b6 ff ff       	call   80102520 <kfree>
80106e83:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106e86:	39 fb                	cmp    %edi,%ebx
80106e88:	75 dd                	jne    80106e67 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106e8a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106e8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e90:	5b                   	pop    %ebx
80106e91:	5e                   	pop    %esi
80106e92:	5f                   	pop    %edi
80106e93:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106e94:	e9 87 b6 ff ff       	jmp    80102520 <kfree>
    panic("freevm: no pgdir");
80106e99:	83 ec 0c             	sub    $0xc,%esp
80106e9c:	68 5d 7b 10 80       	push   $0x80107b5d
80106ea1:	e8 da 94 ff ff       	call   80100380 <panic>
80106ea6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ead:	8d 76 00             	lea    0x0(%esi),%esi

80106eb0 <setupkvm>:
{
80106eb0:	55                   	push   %ebp
80106eb1:	89 e5                	mov    %esp,%ebp
80106eb3:	56                   	push   %esi
80106eb4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106eb5:	e8 26 b8 ff ff       	call   801026e0 <kalloc>
80106eba:	85 c0                	test   %eax,%eax
80106ebc:	74 5e                	je     80106f1c <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
80106ebe:	83 ec 04             	sub    $0x4,%esp
80106ec1:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106ec3:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106ec8:	68 00 10 00 00       	push   $0x1000
80106ecd:	6a 00                	push   $0x0
80106ecf:	50                   	push   %eax
80106ed0:	e8 2b d8 ff ff       	call   80104700 <memset>
80106ed5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106ed8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106edb:	83 ec 08             	sub    $0x8,%esp
80106ede:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106ee1:	8b 13                	mov    (%ebx),%edx
80106ee3:	ff 73 0c             	push   0xc(%ebx)
80106ee6:	50                   	push   %eax
80106ee7:	29 c1                	sub    %eax,%ecx
80106ee9:	89 f0                	mov    %esi,%eax
80106eeb:	e8 00 fa ff ff       	call   801068f0 <mappages>
80106ef0:	83 c4 10             	add    $0x10,%esp
80106ef3:	85 c0                	test   %eax,%eax
80106ef5:	78 19                	js     80106f10 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106ef7:	83 c3 10             	add    $0x10,%ebx
80106efa:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106f00:	75 d6                	jne    80106ed8 <setupkvm+0x28>
}
80106f02:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106f05:	89 f0                	mov    %esi,%eax
80106f07:	5b                   	pop    %ebx
80106f08:	5e                   	pop    %esi
80106f09:	5d                   	pop    %ebp
80106f0a:	c3                   	ret
80106f0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f0f:	90                   	nop
      freevm(pgdir);
80106f10:	83 ec 0c             	sub    $0xc,%esp
80106f13:	56                   	push   %esi
80106f14:	e8 17 ff ff ff       	call   80106e30 <freevm>
      return 0;
80106f19:	83 c4 10             	add    $0x10,%esp
}
80106f1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
80106f1f:	31 f6                	xor    %esi,%esi
}
80106f21:	89 f0                	mov    %esi,%eax
80106f23:	5b                   	pop    %ebx
80106f24:	5e                   	pop    %esi
80106f25:	5d                   	pop    %ebp
80106f26:	c3                   	ret
80106f27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f2e:	66 90                	xchg   %ax,%ax

80106f30 <kvmalloc>:
{
80106f30:	55                   	push   %ebp
80106f31:	89 e5                	mov    %esp,%ebp
80106f33:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106f36:	e8 75 ff ff ff       	call   80106eb0 <setupkvm>
80106f3b:	a3 c4 44 11 80       	mov    %eax,0x801144c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f40:	05 00 00 00 80       	add    $0x80000000,%eax
80106f45:	0f 22 d8             	mov    %eax,%cr3
}
80106f48:	c9                   	leave
80106f49:	c3                   	ret
80106f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f50 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106f50:	55                   	push   %ebp
80106f51:	89 e5                	mov    %esp,%ebp
80106f53:	83 ec 08             	sub    $0x8,%esp
80106f56:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80106f59:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80106f5c:	89 c1                	mov    %eax,%ecx
80106f5e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80106f61:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80106f64:	f6 c2 01             	test   $0x1,%dl
80106f67:	75 17                	jne    80106f80 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106f69:	83 ec 0c             	sub    $0xc,%esp
80106f6c:	68 6e 7b 10 80       	push   $0x80107b6e
80106f71:	e8 0a 94 ff ff       	call   80100380 <panic>
80106f76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f7d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106f80:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106f83:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106f89:	25 fc 0f 00 00       	and    $0xffc,%eax
80106f8e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80106f95:	85 c0                	test   %eax,%eax
80106f97:	74 d0                	je     80106f69 <clearpteu+0x19>
  *pte &= ~PTE_U;
80106f99:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106f9c:	c9                   	leave
80106f9d:	c3                   	ret
80106f9e:	66 90                	xchg   %ax,%ax

80106fa0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106fa0:	55                   	push   %ebp
80106fa1:	89 e5                	mov    %esp,%ebp
80106fa3:	57                   	push   %edi
80106fa4:	56                   	push   %esi
80106fa5:	53                   	push   %ebx
80106fa6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106fa9:	e8 02 ff ff ff       	call   80106eb0 <setupkvm>
80106fae:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106fb1:	85 c0                	test   %eax,%eax
80106fb3:	0f 84 e9 00 00 00    	je     801070a2 <copyuvm+0x102>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106fb9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106fbc:	85 c9                	test   %ecx,%ecx
80106fbe:	0f 84 b2 00 00 00    	je     80107076 <copyuvm+0xd6>
80106fc4:	31 f6                	xor    %esi,%esi
80106fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fcd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80106fd0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80106fd3:	89 f0                	mov    %esi,%eax
80106fd5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106fd8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
80106fdb:	a8 01                	test   $0x1,%al
80106fdd:	75 11                	jne    80106ff0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80106fdf:	83 ec 0c             	sub    $0xc,%esp
80106fe2:	68 78 7b 10 80       	push   $0x80107b78
80106fe7:	e8 94 93 ff ff       	call   80100380 <panic>
80106fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80106ff0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106ff2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106ff7:	c1 ea 0a             	shr    $0xa,%edx
80106ffa:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107000:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107007:	85 c0                	test   %eax,%eax
80107009:	74 d4                	je     80106fdf <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010700b:	8b 00                	mov    (%eax),%eax
8010700d:	a8 01                	test   $0x1,%al
8010700f:	0f 84 9f 00 00 00    	je     801070b4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107015:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107017:	25 ff 0f 00 00       	and    $0xfff,%eax
8010701c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010701f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107025:	e8 b6 b6 ff ff       	call   801026e0 <kalloc>
8010702a:	89 c3                	mov    %eax,%ebx
8010702c:	85 c0                	test   %eax,%eax
8010702e:	74 64                	je     80107094 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107030:	83 ec 04             	sub    $0x4,%esp
80107033:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107039:	68 00 10 00 00       	push   $0x1000
8010703e:	57                   	push   %edi
8010703f:	50                   	push   %eax
80107040:	e8 4b d7 ff ff       	call   80104790 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107045:	58                   	pop    %eax
80107046:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010704c:	5a                   	pop    %edx
8010704d:	ff 75 e4             	push   -0x1c(%ebp)
80107050:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107055:	89 f2                	mov    %esi,%edx
80107057:	50                   	push   %eax
80107058:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010705b:	e8 90 f8 ff ff       	call   801068f0 <mappages>
80107060:	83 c4 10             	add    $0x10,%esp
80107063:	85 c0                	test   %eax,%eax
80107065:	78 21                	js     80107088 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107067:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010706d:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107070:	0f 82 5a ff ff ff    	jb     80106fd0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107076:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107079:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010707c:	5b                   	pop    %ebx
8010707d:	5e                   	pop    %esi
8010707e:	5f                   	pop    %edi
8010707f:	5d                   	pop    %ebp
80107080:	c3                   	ret
80107081:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107088:	83 ec 0c             	sub    $0xc,%esp
8010708b:	53                   	push   %ebx
8010708c:	e8 8f b4 ff ff       	call   80102520 <kfree>
      goto bad;
80107091:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107094:	83 ec 0c             	sub    $0xc,%esp
80107097:	ff 75 e0             	push   -0x20(%ebp)
8010709a:	e8 91 fd ff ff       	call   80106e30 <freevm>
  return 0;
8010709f:	83 c4 10             	add    $0x10,%esp
    return 0;
801070a2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801070a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801070ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070af:	5b                   	pop    %ebx
801070b0:	5e                   	pop    %esi
801070b1:	5f                   	pop    %edi
801070b2:	5d                   	pop    %ebp
801070b3:	c3                   	ret
      panic("copyuvm: page not present");
801070b4:	83 ec 0c             	sub    $0xc,%esp
801070b7:	68 92 7b 10 80       	push   $0x80107b92
801070bc:	e8 bf 92 ff ff       	call   80100380 <panic>
801070c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070cf:	90                   	nop

801070d0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801070d0:	55                   	push   %ebp
801070d1:	89 e5                	mov    %esp,%ebp
801070d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801070d6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801070d9:	89 c1                	mov    %eax,%ecx
801070db:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801070de:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801070e1:	f6 c2 01             	test   $0x1,%dl
801070e4:	0f 84 00 01 00 00    	je     801071ea <uva2ka.cold>
  return &pgtab[PTX(va)];
801070ea:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801070ed:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801070f3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801070f4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801070f9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107100:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107102:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107107:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010710a:	05 00 00 00 80       	add    $0x80000000,%eax
8010710f:	83 fa 05             	cmp    $0x5,%edx
80107112:	ba 00 00 00 00       	mov    $0x0,%edx
80107117:	0f 45 c2             	cmovne %edx,%eax
}
8010711a:	c3                   	ret
8010711b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010711f:	90                   	nop

80107120 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107120:	55                   	push   %ebp
80107121:	89 e5                	mov    %esp,%ebp
80107123:	57                   	push   %edi
80107124:	56                   	push   %esi
80107125:	53                   	push   %ebx
80107126:	83 ec 0c             	sub    $0xc,%esp
80107129:	8b 75 14             	mov    0x14(%ebp),%esi
8010712c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010712f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107132:	85 f6                	test   %esi,%esi
80107134:	75 51                	jne    80107187 <copyout+0x67>
80107136:	e9 a5 00 00 00       	jmp    801071e0 <copyout+0xc0>
8010713b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010713f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107140:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107146:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010714c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107152:	74 75                	je     801071c9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107154:	89 fb                	mov    %edi,%ebx
80107156:	29 c3                	sub    %eax,%ebx
80107158:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010715e:	39 f3                	cmp    %esi,%ebx
80107160:	0f 47 de             	cmova  %esi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107163:	29 f8                	sub    %edi,%eax
80107165:	83 ec 04             	sub    $0x4,%esp
80107168:	01 c1                	add    %eax,%ecx
8010716a:	53                   	push   %ebx
8010716b:	52                   	push   %edx
8010716c:	89 55 10             	mov    %edx,0x10(%ebp)
8010716f:	51                   	push   %ecx
80107170:	e8 1b d6 ff ff       	call   80104790 <memmove>
    len -= n;
    buf += n;
80107175:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107178:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010717e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107181:	01 da                	add    %ebx,%edx
  while(len > 0){
80107183:	29 de                	sub    %ebx,%esi
80107185:	74 59                	je     801071e0 <copyout+0xc0>
  if(*pde & PTE_P){
80107187:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010718a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010718c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010718e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107191:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107197:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010719a:	f6 c1 01             	test   $0x1,%cl
8010719d:	0f 84 4e 00 00 00    	je     801071f1 <copyout.cold>
  return &pgtab[PTX(va)];
801071a3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801071a5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801071ab:	c1 eb 0c             	shr    $0xc,%ebx
801071ae:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801071b4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801071bb:	89 d9                	mov    %ebx,%ecx
801071bd:	83 e1 05             	and    $0x5,%ecx
801071c0:	83 f9 05             	cmp    $0x5,%ecx
801071c3:	0f 84 77 ff ff ff    	je     80107140 <copyout+0x20>
  }
  return 0;
}
801071c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801071cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801071d1:	5b                   	pop    %ebx
801071d2:	5e                   	pop    %esi
801071d3:	5f                   	pop    %edi
801071d4:	5d                   	pop    %ebp
801071d5:	c3                   	ret
801071d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071dd:	8d 76 00             	lea    0x0(%esi),%esi
801071e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801071e3:	31 c0                	xor    %eax,%eax
}
801071e5:	5b                   	pop    %ebx
801071e6:	5e                   	pop    %esi
801071e7:	5f                   	pop    %edi
801071e8:	5d                   	pop    %ebp
801071e9:	c3                   	ret

801071ea <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801071ea:	a1 00 00 00 00       	mov    0x0,%eax
801071ef:	0f 0b                	ud2

801071f1 <copyout.cold>:
801071f1:	a1 00 00 00 00       	mov    0x0,%eax
801071f6:	0f 0b                	ud2
