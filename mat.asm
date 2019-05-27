# Matrix Transpose
# Group 50
# Registers Used : 
# $t0 - m
# $t1 - n
# $t2 - s
# $t3 - 4*m*n
# $t4 - loop counter i


.text
main:
		la 					$a0, prntmsg
		li					$v0, 4							# print message
		syscall		
		
		la					$a0, space						# print space
		li					$v0, 4
		syscall


		li					$v0, 5
		syscall
		move				$t0, $v0						# store m 
		
		li					$v0, 5
		syscall
		move				$t1, $v0						# store n

		li					$v0, 5
		syscall
		move				$t2, $v0						# store s


		mul					$t3, $t0, $t1
		mul					$t3, $t3, 4						# store 4*m*n

		sub					$sp, $sp, $t3					# Allocate space for array A
		add					$fp, $sp, 0                     # Set frame pointer as the current sp
		sub					$sp, $sp, $t3
		sub					$sp, $sp, 4

		sw					$t2, ($fp)						# X[0] = s
	
		

		li					$t4 , 1							# stores i		

loop:
		mul					$t3, $t0, $t1					
		bgt 				$t4, $t3, endloop				# i>m*n then break
		sub					$t5, $t4, 1						# $t5 stores i-1
		mul					$t5, $t5, 4						# 4*(i-1)
		add					$t5, $fp, $t5					# $fp + 4*(i-1)

		mul					$t6, $t4, 4						# 4*(i)
		add					$t6, $fp, $t6					# $fp + 4*(i)
		
		lw					$t7, ($t5)						# store X[i-1]
		
		

		mul					$t7, $t7 ,330
		add					$t7, $t7, 100					# stores X[i-1]*330 + 100
		rem					$t7, $t7, 481					# stores (X[i-1]*330 + 100)mod M

		sw					$t7, ($t6)
		add					$t4, 1
		b 					loop
endloop:
		
		la					$a0, space
		li					$v0, 4
		syscall

		move				$a0, $t0						# pass m as parameter
		move				$a2, $t1						# pass n as parameter
		move				$a1, $fp						# pass array A address as parameter
		jal					matPrint						# call print

		
		move				$a0, $t0						# pass m as parameter
		move				$s0, $t1						# pass n as parameter
		move 				$a1, $fp						# pass array A address as parameter
		move 				$a2, $sp 						# pass array B address as parameter
		jal 				matTrans						# call matrix transpose

		la					$a0, space						# print space
		li					$v0, 4
		syscall


		move				$a0, $t0						# pass m as parameter
		move				$a2, $t1						# pass n as parameter
		move				$a1, $sp
		jal					matPrint						# call print again

		li					$v0, 10
		syscall



matPrint:
		li 					$t4, 0							# loop counter
		mul					$t5, $t0, $t1					# m*n
		move				$t6, $a1						# store fp/sp	
		move				$t0, $a0						# store m
		move				$t1, $a2						# store n
			
loop2:
		bge					$t4, $t5, endloop2				# if i>=m*n endloop
		mul					$t7, $t4, 4 					# 4*i
		
		add					$t9, $t6, $t7 					# $fp + 4*i
		lw					$t8, ($t9)						# store contents of $fp + 4*i

		move				$a0, $t8						# move contents to $a0 for syscall
		li					$v0, 1
		syscall
		
		la					$a0, blank
		li					$v0, 4
		syscall
		
		add					$t4, $t4, 1
		b 					loop2
endloop2:
		jr					$ra								# jump to callers code



matTrans:
		li					$t3, 0							# loop counter
		mul					$t4, $t0, $t1					# m*n
		move				$t5, $a1						# store frame pointer
		move				$t6, $a2						# store stack pointer
		move				$t0, $a0						# store m
		move				$t1, $s0						# store n

loop3:
		bge					$t3, $t4, endloop3				# ifi>=m*n endloop
		div					$t3, $t1						# divide i/n					
		mfhi				$s1							    # store rem
		mflo				$s2								# store quotient
		mul					$t7, $s1, $t0
		add					$t7, $t7, $s2					# store m(i%n) + i/n

		mul					$t8, $t3, 4						# 4*i
		add					$t8, $t5, $t8					# address of ith element in original array 

		mul					$t9, $t7, 4
		add 				$t9, $t6, $t9					# address of m(i%n) +i/n in transpose array

		lw					$s3, ($t8)						
		sw					$s3, ($t9)						# B[m(i%n) + i/n] = A[i]   
		
		add 				$t3 , $t3, 1
		b 					loop3
endloop3:
		jr 					$ra



.data
		prntmsg: 		.asciiz	 "\nEnter three positive integers m, n and s : "
		space:			.asciiz	 " \n"
		blank:			.asciiz  ", "




