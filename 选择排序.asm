.data
	array: .space 400
	message_input_n: .asciiz "Please enter the length of array:\n"
	message_input_array: .asciiz "Please input an integer followed with a line: \n"
	message_output_array: .asciiz "The sorted sequence is: \n "
	space: .asciiz " "
	stack: .space 100 #栈空间
	
.globl main	
.text
input:
	la $a0, message_input_n #提示输入元素的总个数
	li $v0, 4
	syscall
	
	li $v0, 5 #读入输入的元素个数
	syscall 
	move $t0,$v0 	#$t0存储数据个数

	li $t1, 0 #use $t1 as 循环变量i
	for_1_begin:   #循环1用于n个数据的读取存储
		slt $t2,$t1,$t0
		beq $t2, $zero, for_1_end
		nop
		
		la $t2, array
		li $t3, 4
		mult $t3, $t1
		mflo $t3
		addu $t2, $t2, $t3
		
		la $a0, message_input_array
		li $v0, 4
		syscall
		
		li $v0, 5
		syscall 
		sw $v0, 0($t2) 
		
		addi $t1,$t1,1
		j for_1_begin
		nop
	for_1_end:
		move $v0, $t0
		jr $ra
		nop		
output:
	move $t0, $a0  #$a0-$a3是函数调用参数的存储寄存器，这里只有元素个数一个参数，因而放在$a0即可
	la $a0, message_output_array
	li $v0, 4
	syscall
	
	li $t1, 0
	for_2_begin:   #2循环用于输出
		slt $t2, $t1, $t0
		beq $t2, $zero, for_2_end
		nop
		
		la $t2, array
		li $t3, 4
		mult $t3, $t1
		mflo $t3
		addu $t2, $t2, $t3
		
		lw $a0, 0($t2)
		li $v0, 1
		syscall
		
		la $a0, space
		li $v0, 4
		syscall
		
		addi $t1, $t1, 1
		j for_2_begin
		nop 
	for_2_end:
	jr $ra
	nop

sort:   #排序
  	addiu $sp,$sp,-40
	move $t0, $a0
	addiu $t4, $t0, -1 #$t4 use as n-1
	li $t1, 0
	for_3_begin:   #3循环的目的在于排序
		slt $t2, $t1, $t4
		beq $t2, $zero, for_3_end
		nop
		
		la $t2, array
		li $t3, 4
		mult $t3,$t1
		mflo $t3
		addu $t2,$t2,$t3
		
		move $a0,$t0 #传递元素个数
		move $a1,$t1 #传递i值
		####数据维护利用栈
		sw $t4, 36($sp)
		sw $t2, 28($sp)
		sw $t1 ,24($sp)
		sw $t0 ,20($sp)
		sw $ra ,16($sp)

		jal findmin
		nop
		#数据加载回父过程
		lw $ra ,16($sp)
		lw $t0 ,20($sp)
		lw $t1 ,24($sp)
		lw $t2 ,28($sp)
		lw $t4 ,36($sp)
		
		lw $t3 ,0($v0) #$t3 is the location of min
		lw $t5 ,0($t2) #$t5 is the location of current
		sw $t3 ,0($t2)
		sw $t5 ,0($v0)
		
		addi $t1,$t1,1
		j for_3_begin
		nop
	for_3_end:
	addiu $sp,$sp,40
	jr $ra
	nop
	
findmin:
	move $t0,$a0
	move $t4,$a1 #$a1里面的值是当前下标
	addiu $t1,$t4,1
	la $t2, array
	li $t3,4
	mult $t3,$a1
	mflo $t3
	move $t4,$t3
	addu $t2,$t2,$t3
	lw $t7,0($t2)  #$t7存储的是当前下标对应的存储数值
	
	for_4_begin:
		slt $t2,$t1,$t0
		beq $t2,$zero,for_4_end
		nop
		
		la $t2, array
		li $t3, 4
		mult $t3,$t1
		mflo $t3
		addu $t2,$t2,$t3
		
		lw $t3,0($t2)
		slt $t5,$t3,$t7
		beq $t5,$zero,if_1_else
		nop
		#$t2,$t4存放的为数组的地址,其中$t4对应最小数据（min）下标
		move $t4,$t2
		move $t7,$t3
		j if_1_end
		nop
		if_1_else:
		if_1_end:
		
		addi $t1,$t1,1
		j for_4_begin
		nop
	for_4_end:
	move $v0,$t4
	jr $ra
	nop	
		
main:
	la $sp, stack
	addiu $sp,$sp,100
	addiu $sp,$sp,-20
	jal input
	nop
	move $t0,$v0
	move $a0,$t0
	sw $t0,16($sp)
	jal sort
	nop
	lw $t0,16($sp)
	
	move $a0,$t0
	jal output
	nop
	
	addiu $sp,$sp,20
	li $v0,10
	syscall
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
