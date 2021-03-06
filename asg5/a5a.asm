//Name: Ummey Zarin Tashnim
//ID: 30034931
//Professor: Leonard Manzara
//TA: Md. Reza Rabbani

//This progarm was translated from C to asembly
	
	define(false, 0)
	define(true, 1)
	define(tail_r, w9)
	define(head_r, w10)
	define(queue_r, w11)
	define(value_r, w19)
	define(i_r, w20)
	define(j_r, w21)
	define(count_r, w22)

	.text
	QUEUESIZE = 8
	MODMASK = 0x7

overflow:	.string "\nQueue overflow! Cannot enqueue into a full queue.\n"
underflow:	.string "\nQueue underflow! Cannot dequeue from an empty queue.\n"
emptyQueue:	.string "\nEmpty queue\n"
curr_queue:	.string "\nCurrent queue contents:\n"
queue_i:	.string "  %d"
point_head:	.string " <-- head of queue"
point_tail:	.string " <-- tail of queue"
end_line:	.string "\n"

//global variables		
	.data
	.global head
head:	.word -1
	.global tail
tail:	.word -1

//array
	.bss
	.global queue_s
queue_s:.skip QUEUESIZE * 4

	.text
	.global enqueue					//void enqueue(int value)
enqueue:
	stp	x29, x30, [sp, -16]!
	mov	x29, sp

	mov	value_r, w0				//keep w0 safe from being overwritten
	
	bl	queueFull				//call queueFull
	cmp	w0, true				//if (!queueFull())
	b.ne	nextIf					//go to nextIf

	adrp	x0, overflow				//else
	add	x0, x0, :lo12:overflow			//
	bl	printf					//print full queue overflow
	b	return					//
	
nextIf:	bl	queueEmpty				//call queueEmpty
	cmp	w0, true				//if (!queueEmpty())
	b.ne	else					//go to else

	adrp	x0, tail				//get the address of tail
	add	x0, x0, :lo12:tail			//

	adrp	x1, head				//get the address of head
	add	x1, x1, :lo12:head			//

	str	wzr, [x0]				//tail = 0
	str	wzr, [x1]				//head = tail = 0

	b	afterElse				//go to afterElse
	
else:	adrp	x0, tail				//get the address of tail
	add	x0, x0, :lo12:tail			//
	ldr	tail_r, [x0]				//

	add	tail_r, tail_r, 1			//tail = ++tail
	and	tail_r, tail_r, MODMASK			//tail = ++tail & MODMASK
	str	tail_r, [x0]				//store tail at it's address

afterElse:
	adrp	x0, tail				//get address of tail
	add	x0, x0, :lo12:tail			//
	ldr	tail_r, [x0]				//

	adrp	x0, queue_s				//get address of queue
	add	x0, x0, :lo12:queue_s			//
	str	value_r, [x0, tail_r, SXTW 2]		//queue[tail] = value

return:	ldp	x29, x30, [sp], 16			
	ret	


	


	.global queueFull				//int queueFull()
queueFull:
	stp	x29, x30, [sp, -16]! 
	mov	x29, sp

	adrp	x0, tail				//get the address of tail
	add	x0, x0, :lo12:tail			//
	ldr	tail_r, [x0]				//

	adrp	x0, head				//get the address of head
	add	x0, x0, :lo12:head			//
	ldr	head_r, [x0]				//

	add	tail_r, tail_r, 1			//tail = tail + 1
	and	tail_r, tail_r, MODMASK			//tail = tail & MODMASK

	cmp	tail_r, head_r				//if (((tail + 1) & MODMASK) != head)
	b.ne	retFalse				//go to retFalse
	mov	w0, true				//else return true
	b	return1					//go to return1
	
retFalse:
	mov	w0, false				//return false
	
return1:
	ldp	x29, x30, [sp], 16
	ret	



	

	.global queueEmpty				//int queueEmpty()	
queueEmpty:
	stp	x29, x30, [sp, -16]!
	mov	x29, sp

	adrp	x0, head				//get the address of head
	add	x0, x0, :lo12:head			//
	ldr	head_r, [x0]				//load head

	cmp	head_r, -1				//if (head != -1)
	b.ne	setFalse				//go to setFalse
	mov	x0, true 				//else return true
	b	return2					//go to return2

setFalse:
	mov	x0, false				//return false

return2:
	ldp	x29, x30, [sp], 16
	ret	




	.global dequeue					//int dequeue()
dequeue:
	stp	x29, x30, [sp, -16]!
	mov	x29, sp

	bl	queueEmpty				//call queueEmpty
	cmp	w0, true				//if (!queueEmpty())
	b.ne	doNext					//go to doNext
	adrp	x0, underflow				//else
	add	x0, x0, :lo12:underflow			//
	bl	printf					//print empty queue overflow
	mov	x0, -1					//return -1
	b	return3					//go to return3
	
doNext:	adrp	x1, head				//get the address of head
	add	x1, x1, :lo12:head			//
	ldr	head_r, [x1]				//load head

	adrp	x0, tail				//get the address of tail
	add	x0, x0, :lo12:tail			//
	ldr	tail_r, [x0]				//load tail
	
	adrp	x2, queue_s				//get the address of queue
	add	x2, x2, :lo12:queue_s			//
	ldr	value_r, [x2, head_r, SXTW 2]		//value = queue[head]
	
	cmp	head_r, tail_r				//if (head != tail)
	b.ne	else2					//go to else2

	mov	w11, -1					//w11 = -1
	str	w11, [x0]				//tail = -1
 	str	w11, [x1]				//head = tail = -1

	b	retValue				//go to retValue

else2:	add	head_r, head_r, 1
	and	head_r, head_r, MODMASK			//head = ++head & MODMASK
	str	head_r, [x1]				//store head

retValue:
	mov	w0, value_r				//return value
return3:
	ldp	x29, x30, [sp], 16
	ret	

	

		
	.global display					//void display()
display:
	stp	x29, x30, [sp, -16]!
	mov	x29, sp

	bl	queueEmpty				//call queueEmpty
	cmp	w0, true				//if (!queueEmpty())
	b.ne	go_next					//go to do_next

	adrp	x0, emptyQueue				//else
	add	x0, x0, :lo12:emptyQueue		//
	bl	printf					//print overflow_empty
	bl	return4
	
go_next:
	adrp	x0, tail				//get the address of tail
	add	x0, x0, :lo12:tail			//
	ldr	tail_r, [x0]				//load tail

	adrp	x1, head				//get the address of head
	add	x1, x1, :lo12:head			//
	ldr	head_r, [x1]				//load head	

	sub	count_r, tail_r, head_r			//count = tail - head
	add	count_r, count_r, 1			//count = tail - head + 1
	
	cmp	count_r, 0				//if (count > 0)
	b.gt	print_curr				//go to print_curr
	add	count_r, count_r, QUEUESIZE		//else count += QUEUESIZE
	
print_curr:
	adrp	x0, curr_queue				//
	add	x0, x0, :lo12:curr_queue		//
	bl	printf					//print curr_queue

	adrp	x0, head				//get the address of head
	add	x0, x0, :lo12:head			//
	ldr	head_r, [x0]				//load head

test1:	mov	i_r, head_r				//i = head
	mov	j_r, wzr				//j = 0	
	b	loop_test				//go to loop_test

loop:	adrp	x0, queue_i				//
	add	x0, x0, :lo12:queue_i			//
	adrp	x11, queue_s				//
	add	x11, x11, :lo12:queue_s			//
	ldr	w1, [x11, i_r, SXTW 2]			//load queue[i]
	bl	printf					//print queue[i]

test2:	adrp	x0, head				//get the address of head
	add	x0, x0, :lo12:head			//
	ldr	head_r, [x0]				//

test3:	cmp	i_r, head_r				//if (i != head)
	b.ne	is_tail					//go to is_tail

	adrp	x0, point_head				//else
	add	x0, x0, :lo12:point_head		//
	bl	printf					//print point_head

test4:	
is_tail:
	adrp	x0, tail				//get the address of tail
	add	x0, x0, :lo12:tail			//
	ldr	tail_r, [x0]				//

	cmp	i_r, w9					//if (i != tail)
	b.ne	not_tail				//go to not_tail

	adrp	x0, point_tail				//else
	add	x0, x0, :lo12:point_tail		//	
	bl	printf					//print point_tail
	
not_tail:	
	adrp	x0, end_line				//
	add	x0, x0, :lo12:end_line			//
	bl	printf					//print end_line

	add	i_r, i_r, 1				//i = ++i
	and	i_r, i_r, MODMASK			//i = ++i & MODMASK

	add	j_r, j_r, 1				//increment j

loop_test:
	cmp 	j_r, count_r				//while(j < count)
	b.lt	loop					//go to top
		
return4:
	ldp	x29, x30, [sp], 16			
	ret



