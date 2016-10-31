#care: one line can hold no more 10 numbers
.data
	array:.space 800
	stack:.space 100 #use as temp data memory
	message_output:.asciiz "The prime numbers are:\n"
	space:.asciiz " "
	turn_line:.asciiz "\n"
.text
main:
	la $sp,stack
	addiu $sp,$sp,100
	move $s0,$zero #$s0 use as array index counter 

	jal input

	move $t0,$v0 #value of m
	move $t1,$v1 #value of n
	
	move $a0,$t0
	move $a1,$t1
	jal find_prime

	jal output

	li $v0,10
	syscall	

input:
	li $v0,5
	syscall
	move $t0,$v0

	li $v0,5
	syscall
	move $t1,$v0

	move $v0,$t0
	move $v1,$t1

	jr $ra

find_prime:
	addiu $sp,$sp,-12
	move $t0,$a0  #$t0 use as m
	move $t1,$a1  #$t1 use as n
	addiu $t1,$t1,1

	loop_begin:
		slt $t2,$t0,$t1
		beq $t2,$zero,loop_end

		sw $t1,8($sp)
		sw $t0,4($sp)
		sw $ra,0($sp)

		move $a0,$t0
		jal is_prime

		move $t2,$v0 #is?

		lw $ra,0($sp)
		lw $t0,4($sp)
		lw $t1,8($sp)

	if_prime:
		beq $t2,$zero,end_if

		move $t2,$s0
		sll $t2,$t2,2

		sw $t0,array($t2)
		addiu $s0,$s0,1
	end_if:
		addiu $t0,$t0,1
		j loop_begin
	loop_end:
	addiu $sp,$sp,12
	jr $ra

is_prime:
	move $t0,$a0
	move $v0,$zero
	addiu $s1,$t0,-1
	
	beq $s1,$zero,end

	li $t1,2
	for_2_begin:
		mul $s1,$t1,$t1
		sub $s1,$s1,$t0
		bgtz $s1,for_2_end

		div $t0,$t1
		mfhi $t2
		beq $t2,$zero,end

		addiu $t1,$t1,1
		j for_2_begin

	for_2_end:
		li $v0,1
	end:
	jr $ra

output:
	la $a0,message_output
	li $v0,4
	syscall

	li $t0,0
	li $t1,0
	li $t7,10

	for_3_begin:
		slt $t2,$t0,$s0
		beq $t2,$zero,for_3_end

		move $t2,$t0
		sll $t2,$t2,2

		bne $t1,$t7,normal_output

		la $a0,turn_line
		li $v0,4
		syscall
		move $t1,$zero

	normal_output:
		lw $a0,array($t2)
		li $v0,1
		syscall

		la $a0,space
		li $v0,4
		syscall

		addiu $t0,$t0,1
		addiu $t1,$t1,1
		j for_3_begin
	for_3_end:
	jr $ra


	


