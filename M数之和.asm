.data
	initial_array:.space 400
	sum_index_array:.space 400
	outcome:.space 4
.text
main:
	jal input
	nop
	#�õ�input��������ֵ,��������
	move $t0,$v0 #sum_index_array����Ԫ���ܸ���
	move $a0,$t0#����Ԫ�ظ�����������
	jal get_sum
	nop
	
	move $s0,$v0 #$s0�洢���ս��
	sw $s0,outcome
	lw $a0,outcome
	li $v0,1
	syscall
	
	li $v0,10
	syscall
input:
	#the first:memorize initial_array's data
	li $v0 5
	syscall
	move $t0,$v0 #$t0�д洢����Ԫ�ظ���
  
  li $t1 0
  for_initial_array_begin:
  	slt $t2,$t1,$t0
  	beq $t2,$zero,for_initial_array_end
  	nop
  		
  	li $t3,4
  	la $t2,initial_array
  	mult $t3,$t1
  	mflo $t3
  	addu $t2,$t2,$t3
  	
  	li $v0,5
  	syscall
  	sw $v0,0($t2)
  	
  	addiu $t1,$t1,1
  	j for_initial_array_begin
  	nop	
 	for_initial_array_end:
 	#the second:memorize sum_index_array
  li $v0 5
  syscall 
  move $t0,$v0
  
  li $t1,0
 	for_sum_index_array_begin:
 		slt $t2,$t1,$t0
 		beq $t2,$zero,for_sum_index_array_end
 		nop
 		
 		la $t2,sum_index_array
 		li $t3,4
 		mult $t3,$t1
 		mflo $t3
 		addu $t2,$t2,$t3
 		
 		li $v0,5
 		syscall
 		sw $v0,0($t2)
 		
 		addiu $t1,$t1,1
 		j for_sum_index_array_begin
 		nop
    for_sum_index_array_end:	
 	move $v0,$t0
 	jr $ra
 	nop
 	
get_sum:
	move $t0,$a0#index�����Ԫ�ظ���
	li $s0,0 #$s0����Ϊ�ۼӺͼĴ���
	li $t1,0 #use $t1 as i
	la $a0,initial_array #$a0���initial_array���׵�ַ
	for_sum_begin:
		slt $t2,$t1,$t0
		beq $t2,$zero,for_sum_end
		nop
		
		la $t2,sum_index_array
		li $t3,4
		mult $t3,$t1
		mflo $t3
		addu $t2,$t2,$t3
		
		lw $t3,0($t2)
		move $t2,$t3
		li $t3,4
		mult $t3,$t2
		mflo $t3
		addu $t2,$t3,$a0
		
		lw $t3,0($t2)
		addu $s0,$s0,$t3
		addi $t1,$t1,1
		j for_sum_begin
		nop
		
	for_sum_end:
	move $v0,$s0
	jr $ra
	nop
 	
