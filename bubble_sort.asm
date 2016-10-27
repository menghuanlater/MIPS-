#bubble_sort(no more than 100 elements)
.data
	stack:.space 100
	array:.space 400
	message_input_n:.asciiz "Please input the number of array's contents.\n"
	message_input_array:.asciiz "Please input an integer with a new line.\n"
	message_out_array:.asciiz "The sorted array is:\n"
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
	for_1_begin:
		slt $t2,$t1,$t0
		beq $t2,$zero,for_1_end
		nop

		la $t2,array
		li $t3,4
		mult $t3,$t1
		mflo $t3
		addu $t2,$t2,$t3

		la $a0,message_input_array
		li $v0,4
		syscall

		li $v0,5
		syscall
		sw $v0,0($t2)

		addi $t1,$t1,1
		j for_1_begin
		nop

	for_1_end:
	move $v0,$t0
	jr $ra
	nop	

bubble_sort:
	move $t0,$a0
	addiu $s0,$t0,-1 #$s0 use as n-1
	move $s1,$t0  #$s1 use as n
	addiu $sp,$sp,-32

	li $t0,0 #$t0 use as i
	for_2_begin:
		slt $t1,$t0,$s0
		beq $t1,$zero,for_2_end
		nop

		addu $t1,$t0,1 #reuse $t1 as j
		for_3_begin:
			slt $t2,$t1,$s1
			beq $t2,$zero,for_3_end
			nop

			la $s2,array
			li $t2,4
			mult $t2,$t0
			mflo $t3
			mult $t2,$t1
			mflo $t4

			addu $t5,$s2,$t3 #array[i]
			addu $t6,$s2,$t4 #array[j]

			lw $s2,0($t5)
			lw $s3,0($t6)

			slt $t2,$s3,$s2
			bgtz $t2,if_else
			nop

			j if_end
			nop
			if_else:
				sw $t1,24($sp)
				sw $t0,20($sp)
				sw $ra,16($sp)

				move $a0,$t5
				move $a1,$t6  
				jal swap
				nop

				lw $ra,16($sp)
				lw $t0,20($sp)
				lw $t1,24($sp)
			if_end:
			addiu $t1,$t1,1
			j for_3_begin
			nop

		for_3_end:
		
		addiu $t0,$t0,1
		j for_2_begin
		nop
	for_2_end:
	addiu $sp,$sp,32
	jr $ra
	nop
swap:
	move $t0,$a0 #array+i
	move $t1,$a1 #array+j
	lw $t2,0($t0) #array[i]
	lw $t3,0($t1) #array[j]
	sw $t3,0($t0)
	sw $t2,0($t1)
	jr $ra
	nop

output:
 	move $t0,$a0
	la $a0,message_out_array
	li $v0,4
	syscall

	li $t1,0
	for_4_begin:
		slt $t2,$t1,$t0
		beq $t2,$zero,for_4_end
		nop

		la $t2,array
		li $t3,4
		mult $t3,$t1
		mflo $t3
		addu $t2,$t2,$t3

		lw $a0,0($t2)
		li $v0,1
		syscall

		la $a0,space
		li $v0,4
		syscall

		addiu $t1,$t1,1
		j for_4_begin
		nop

	for_4_end:
	jr $ra
	nop

main:
	la $sp,stack
	addiu $sp,$sp,100
    addiu $sp,$sp,-20
	
	jal input
	nop
	move $t0,$v0
	move $a0,$t0
	sw $t0,16($sp)

	jal bubble_sort
	nop 

	lw $t0,16($sp)
	move $a0,$t0
	jal output
	nop

	addiu $sp,$sp,20
	li $v0,10
	syscall
