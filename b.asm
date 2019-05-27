# Group No. 50 
# kthlargest.asm -- prints the kth largest number in a stream of n numbers

# Registers used:
# $s0     -  k
# $s1     -  n



.text
main:
		la $a0, input_k
		li $v0, 4
		syscall
		li $v0, 5
		syscall
		move $s0, $v0			# $s0 = k
		
		la $a0, input_n
		li $v0, 4
		syscall
		li $v0, 5
		syscall
		move $s1, $v0			# $s1 = n

		bgt $s0, $s1, exception
		
		sll $t0, $s1, 2
		sub $sp, $sp, $t0 		# allocate space for array
		move $s3, $sp 			# $s3 = a

		la $a0, input_num
		li $v0, 4
		syscall
		li $t1, 0 				# $t1 = 0, loop counter

		

take_input:
		bge $t1, $s1, end_input
		li $v0, 5
		syscall

		sll $t0, $t1, 2
		add $t0, $t0, $s3
		sw $v0, 0($t0)
		add $t1, $t1, 1
		b take_input

end_input:
		
		la $a0, output_ans1
		li $v0, 4
		syscall
		li $t1,0

loop:
		bge $t1, $s1, endloop
		mul	$t2, $t1, 4
		add $t2, $t2, $s3
		lw	$t3, ($t2)

		move $a0, $t3
		li $v0, 1
		syscall

		la $a0, blank
		li $v0, 4
		syscall
		add $t1, $t1, 1
		b loop
endloop:
		
		la $a0, close
		li $v0, 4
		syscall

		li $t1, 1

for: 		
		bge $t1, $s1, end_for
		sll $t3, $t1, 2  		# $t1 = i
		add $t3, $t3, $s3      
		lw $t0, 0($t3)			# $t0 = a[i]		

		sub $t2, $t1, 1			# $t2 = j = i - 1
		sll $t3, $t2, 2 		# $t3 stores address of j
		add $t3, $t3, $s3

while: 		
		bltz $t2, after_while
		lw $t4, 0($t3)
		ble $t4, $t0, after_while
		
		add $t3, $t3, 4
		sw $t4, 0($t3)
		sub $t3, $t3, 8
		sub $t2, $t2, 1
		b while

after_while:	
		add $t3, $t3, 4
		sw $t0, 0($t3)
		
		add $t1, $t1, 1
		b for

end_for:
		sub $t4, $s1, $s0
		sll $t4, $t4, 2
		add $t4, $t4, $s3

		la $a0, output_ans2
		li $v0, 4
		syscall
		lw $a0, 0($t4)
		li $v0, 1
		syscall

		li $v0, 10
		syscall

exception:
		la $a0, rte
		li $v0, 4
		syscall
		
		li $v0, 10
		syscall	

.data
		input_k: 		.asciiz	 "\nEnter the value of k : "
		input_n: 		.asciiz	 "\nEnter the count of elements to be read : "
		input_num: 		.asciiz	 "\nEnter the numbers : "
		output_ans1: 	.asciiz  "\nk-th largest number among ["
		close:			.asciiz  "]"
		output_ans2:    .asciiz  " is : "
		blank:			.asciiz  ", " 
		rte: 			.asciiz  "\ncount of elements cannot be less than the value of k"