.data
	message_output:.asciiz "String is:"
	string:.space 1
.text
main:
	li $v0,5
	syscall 
	move $t0,$v0

	li $t1,0
	for_read_begin:
		slt $t2,$t1,$t0
		beq $t2,$zero,for_read_end

		li $v0,12
		syscall
		move $s0,$v0

		li $t2,97
		sub $t2,$s0,$t2

		bgez $t2,upper
		
		j upper_end

		upper:
			addiu $s0,$s0,-32
		upper_end:

		sb $s0,string($t1)

		addiu $t1,$t1,1

		li $v0,12
		syscall #ignore \n
		j for_read_begin
	for_read_end:
	la $a0,message_output
	li $v0,4
	syscall

	la $a0,string
	li $v0,4
	syscall
