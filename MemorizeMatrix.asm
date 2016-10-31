#the program is used as memorize 0~255 matrix
.data
	useless:.space 4092
	data:.word 0:256
.text
	li $s0,16 #$s0 use as rows' number
	li $s1,16 #$s1 use as columns' number

	move $t1,$zero #$t0 use as counter of rows
	move $t2,$zero #$t1 use as counter of clos
	move $t0,$zero #$t2 use as value of matrix

for_row_begin:
	slt $t3,$t1,$s0
	beq $t3,$zero,for_row_end
	nop

	la $a0,data
	add $t3,$t3,$t1
	sll $t3,$t3,2
	addu $a0,$a0,$t3

	for_col_begin:
		slt $t4,$t2,$s1
		beq $t4,$zero,for_col_end
		nop

		li $t3,4
		mul $t3,$t3,$s1
		mul $t4,$t3,$t2
		addu $t4,$a0,$t4

		sw $t0,0($t4)

		addiu $t2,$t2,1
		addiu $t0,$t0,1 
		j for_col_begin
		nop
	for_col_end:
	addiu $t1,$t1,1
	move $t2,$zero
	j for_row_begin
	nop
for_row_end:
