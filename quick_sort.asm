#quick_sort
.data
	array:.space 400
	stack:.space 400
	message_input_n:.asciiz "Please enter the length of the array\n"
	message_input_array:.asciiz "Please enter an integer with a new line\n"	
	message_output_array:.asciiz "The sorted array is:\n"
	space:.asciiz " "

.globl main
.text

input:
	la $a0,message_input_n
	li $v0,4
	syscall

	li $v0,5
	syscall
	move $t0,$v0

	li $t1,0
	for_input_begin:
		slt $t2,$t1,$t0
		beq $t2,$zero,for_input_end
		nop

		la $s0,array
		li $t2,4
		mult $t2,$t1
		mflo $t2

		la $a0,message_input_array
		li $v0,4
		syscall

		addu $s0,$s0,$t2
		li $v0,5
		syscall
		sw $v0,0($s0)

		addiu $t1,$t1,1
		j for_input_begin
		nop

	for_input_end:
	move $v0,$t0
	jr $ra
	nop

quick_sort:
	addiu $sp,$sp,-16
	move $s0,$a0 #low
	move $s1,$a1 #high

	while_begin:
		slt $t0,$s0,$s1
		beq $t0,$zero,while_end
		nop

		sw $s1,8($sp)
		sw $s0,4($sp)
		sw $ra,0($sp)
		move $a0,$s0
		move $a1,$s1

		jal patition
		nop
		move $t0,$v0
		
		sw $t0,12($sp)
		lw $a0,4($sp)
		addiu $a1,$t0,-1
		jal quick_sort
		nop

		lw $ra,0($sp)
		lw $s0,4($sp)
		lw $s1,8($sp)
		lw $t0,12($sp)

		addiu $s0,$t0,1
		j while_begin
		nop	

	while_end:
	addiu $sp,$sp,16
	jr $ra
	nop

patition:
	move $s0,$a0 #low
	move $s1,$a1 #high
	la $t7,array
	li $t1,4
	mul $t1,$t1,$s0
	addu $t1,$t1,$t7 #array+low
	lw $s2,0($t1) #array[low],$s2 as pivotkey

	while_1_begin:
		slt $t1,$s0,$s1
		beq $t1,$zero,while_1_end
		nop

		while_2_begin:
			slt $t1,$s0,$s1
			li $t2,4
			mul $t2,$t2,$s1
			addu $t2,$t2,$t7
			lw $t3,0($t2) #array[high]

			slt $t2,$s2,$t3
			li $t4,2
			addu $t5,$t2,$t1
			bne $t5,$t4,while_2_end
			nop

			addiu $s1,$s1,-1
			j while_2_begin
			nop
		while_2_end:
			li $t1,4
			li $t2,4
			mul $t1,$t1,$s0
			mul $t2,$t2,$s1
			addu $t1,$t1,$t7
			addu $t2,$t2,$t7
			lw $t6,0($t2)
			sw $t6,0($t1)

		while_3_begin:
			slt $t1,$s0,$s1
			li $t2,4
			mul $t2,$t2,$s0
			addu $t2,$t2,$t7
			lw $t3,0($t2) #array[low]

			slt $t2,$t3,$s2
			li $t4,2
			addu $t5,$t2,$t1
			bne $t5,$t4,while_3_end
			nop

			addiu $s0,$s0,1
			j while_3_begin
			nop
		while_3_end:
			li $t1,4
			li $t2,4
			mul $t1,$t1,$s0
			mul $t2,$t2,$s1
			addu $t1,$t1,$t7
			addu $t2,$t2,$t7
			lw $t6,0($t1)
			sw $t6,0($t2)
		j while_1_begin
		nop	
	while_1_end:
	li $t1,4
	mul $t1,$t1,$s0
	addu $t1,$t1,$t7
	sw $s2,0($t1)
	move $v0,$s0
	jr $ra
	nop 

output:
	move $t0,$a0
	li $t1,0
	for_output_begin:
		slt $t2,$t1,$t0
		beq $t2,$zero,for_output_end
		nop

		la $s0,array
		li $t2,4
		mult $t2,$t1
		mflo $t2
		addu $s0,$s0,$t2

		lw $a0,0($s0)
		li $v0,1
		syscall

		la $a0,space
		li $v0,4
		syscall

		addiu $t1,$t1,1
		j for_output_begin
		nop
	for_output_end:
	jr $ra
	nop

main:
	#load stack to $sp
	la $sp,stack
	addiu $sp,$sp,400
	addiu $sp,$sp,-20
	jal input
	nop

	move $t0,$v0
	li $a0,0
	addiu $a1,$t0,-1
	sw $t0,16($sp)

	jal quick_sort
	nop

	lw $t0,16($sp)

	move $a0,$t0
	jal output 
	nop

	addiu $sp,$sp,20
	li $v0,10
	syscall
