.data
	outcome:.space 4
	message_input:.asciiz "Please enter the number of fib you want to get whose outcome.\n"
	message_output:.asciiz "The outcome is:\n"
.text
main:
	jal input
	nop

	move $t0,$v0 #get the return value
	move $a0,$t0

	jal calculate
	nop

	move $t0,$v0
	move $a0,$t0

	jal output
	nop

	li $v0,10
	syscall

input:
	la $a0,message_input
	li $v0,4
	syscall

	li $v0,5
	syscall
	
	jr $ra
	nop

calculate:
	move $t0,$a0
	li $t2,0  
	li $t3,1

	li $t1,0 #$t1 use as loop var
	for_1_begin:
		slt $t4,$t1,$t0
		beq $t4,$zero,for_1_end
		nop

		move $t4,$t2
		move $t2,$t3
		add $t3,$t4,$t3

		addi $t1,$t1,1
		j for_1_begin
		nop

	for_1_end:
	move $v0,$t2
	jr $ra
	nop

output:
	sw $a0,outcome

	la $a0,message_output
	li $v0,4
	syscall

	lw $a0,outcome
	li $v0,1
	syscall

	jr $ra
	nop




