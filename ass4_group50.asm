# Matrix Determinant
# Group 50
# Registers Used :
# $t0 - $t9, $s0 - $s7, $a0 - $a3



.text
main:
		la 					$a0, prntmsg
		li					$v0, 4							# print message
		syscall		
		
		li					$v0, 5
		syscall
		move				$t0, $v0						# store n
		
		mul					$t1, $t0, $t0
		mul					$t1, $t1, 4						# store 4*n*n

		sub					$sp, $sp, $t1					# allocate space for array A
		li					$t1, 0

		la 					$a0, seed
		li					$v0, 4							# print message
		syscall	

		li 					$v0, 5
		syscall
		move 				$a0, $v0  						# pass seed s
		move 				$a1, $sp 						# pass the stack pointer
		move 				$a2, $t0 						# pass the value of n
		jal 				fillArray
			

		move				$a0, $sp 						# pass the stack pointer
		move				$a1, $t0 						# pass n
		jal					findDet 						# call findDet

		move 				$t0, $v0

		la 					$a0, final
		li					$v0, 4							# print final message
		syscall	

		move				$a0, $t0
		li 					$v0, 1							# print value of determinant
		syscall

		la 					$a0, nl
		li					$v0, 4							# print final message
		syscall	
		
		li					$v0, 10
		syscall


fillArray:
		move 				$t2, $a0 						# seed s
		move 				$t3, $a1 						# stack pointer 
		move 				$t4, $a2 						# n

		sw 					$t2, ($t3) 						# X[0] = s

		li	 				$t5, 1 							# loop counter i = 1

loop:
		mul 				$t6, $t4, $t4 					# $t6 stores n*n
		bgt 				$t5, $t6, endloop 				# if i>n*n break
		sub 				$t7, $t5, 1 					# stores i-1
		mul 				$t7, $t7, 4 					# 4*(i-1)
		add 				$t7, $t3, $t7 					# sp + 4*(i-1)

		mul 				$t8, $t5, 4
		add 				$t8, $t3, $t8 					# sp + 4*(i)

		lw 					$t9, ($t7) 						# store X[i-1]

		mul					$t9, $t9 ,330
		add					$t9, $t9, 100					# stores X[i-1]*330 + 100
		rem					$t9, $t9, 481					# stores (X[i-1]*330 + 100)mod M in $t9

		

		sw					$t9, ($t8) 						# store $t9 in X[i]
		add					$t5, 1
		b 					loop			
endloop:
		jr 					$ra 							# return


findDet:
		
	
		mul 				$s0, $a1, $a1
		mul 				$s0, $s0, 4

		sub 				$sp, $sp, $s0 				
		sub 				$sp, $sp, 44 					# Allocate space for temp array, local variable

		sw 					$ra, ($sp) 						# preserve return address
		sw 					$t0, 4($sp) 					# preserve local variables
		sw 					$t1, 8($sp)
		sw					$t2, 12($sp)
		sw 					$t3, 16($sp)
		sw 					$t4, 20($sp)
		sw 					$t5, 24($sp)
		sw					$t6, 28($sp)
		sw 					$t7, 32($sp)
		sw 					$t8, 36($sp)
		sw 					$t9, 40($sp)

		move				$t0, $a0						# stack pointer
		move				$t1, $a1						# store n


		la 					$a0, mat
		li 					$v0, 4
		syscall 											# print message

		move 				$a0, $t0 						# pass the stack pointer
		move 				$a1, $t1 						# pass n
		jal 				sqMatprint 						# print the matrix in this call

		la 					$a0, nl
		li 					$v0, 4
		syscall 											# print message


		
		mul					$t2, $t1, $t1					# store n*n
		mul					$t3, $t2, 4						# store 4*n*n

		sub					$t3, $t0, $t3					# $t3 cofactor array address
		
		

		li					$s0, 1
		beq					$t1, $s0, findDet_base			# if n==1 , base case

		li					$t4, 1 							# store sign

		li					$t5, 0							# counter f
		li					$t6, 0							# value of determinant

loop1:
		bge					$t5, $t1, endloop1				# if f>=n then break

        
		move				$a0, $t3						# pass address of cofactor matrix, original - $t3 + 4*n*n
		li					$a1, 0							# pass p=0
		move				$a2, $t5						# pass q=f
		move				$a3, $t1						# pass n
		jal 				getCofactor						# store cofactor matrix in $t3



		mul					$t7, $t5, 4
		add 				$t7, $t7, $t0
		lw					$t8, ($t7)						# access mat[0][f]

		move				$a0, $t3 						# pass address of cofactor matrix, original - $t3 + 4*n*n
		sub					$a1, $t1, 1 					# pass n-1 
		jal					findDet							# findDet of cofactor matrix, stored in $v0
         
        
		mul					$t9, $t4, $t8					# Apply the formula
		mul					$t9, $t9, $v0
		add 				$t6, $t6, $t9					# d+=sign*mat[0][f]*det
		mul					$t4, $t4, -1 					# sign = -sign
		add 				$t5, $t5, 1 					# f++
		b 					loop1
endloop1:
		move				$v0, $t6						# store ans in $v0	

		la 					$a0, det
		li 					$v0, 4
		syscall 											# print message

		move				$a0, $t6
		li 					$v0, 1
		syscall 											# print the value of determinant

		la 					$a0, nl
		li 					$v0, 4
		syscall 											# print message


		move  				$v0, $t6

		b 					findDet_return					# jump to return
		
findDet_base:
		la 					$a0, det
		li 					$v0, 4
		syscall 											# print message

		lw					$a0, ($t0)
		li 					$v0, 1
		syscall 											# print the value of determinant

		la 					$a0, nl
		li 					$v0, 4
		syscall 											# print message	
	
		lw					$v0,($t0)						# first element is the answer

findDet_return:
		
		mul 				$s0, $t1, $t1,
		mul 				$s0, $s0, 4
		lw 					$ra, ($sp) 						# preserve return address
		lw 					$t0, 4($sp)
		lw 					$t1, 8($sp)
		lw					$t2, 12($sp)
		lw 					$t3, 16($sp)
		lw 					$t4, 20($sp)
		lw 					$t5, 24($sp)
		lw					$t6, 28($sp)
		lw 					$t7, 32($sp)
		lw 					$t8, 36($sp)
		lw 					$t9, 40($sp)
		add 				$sp, $sp, 44
		add 				$sp, $sp, $s0
		jr					$ra								# jump to $return address



getCofactor:
		
		li					$s0, 0							# index rows
		li					$s1, 0							# index cols
		move				$s2, $a0						# address of temp
		move				$s3, $a1						# p = 0
		move				$s4, $a2						# q
		move				$s5, $a3						# stores n
		li					$t7, 0							# stores i
		li 					$t8, 0							# stores j
		mul 				$t9, $s5, $s5          
		mul                 $t9, $t9, 4                     # stores 4*n*n
		add 				$t9, $s2, $t9                   # address of original matrix
	

		
outerloop:
		bge					$s0, $s5, endouterloop    		# if row >= n break
		li 					$s1, 0  						# col = 0

innerloop:
		bge					$s1, $s5, endinnerloop 			# if cols >= n break

		
		bne					$s0, $s3, one 					# if row != p , jump to one
		add 				$s1, $s1, 1
		b 					innerloop
one:
		bne					$s1, $s4, two 					# if col! = q jumpt to two
		add 				$s1, $s1, 1
		b 					innerloop
two: 					
		
                  
		add 				$s7, $t8, 0					 	# $s7 -> i*n + j
		mul 				$s7, $s7, 4
		add                 $s7, $s7, $s2

		add 				$t8, $t8, 1						# temp[i][j++] = mat[row][col]

		mul         		$a0, $s0, $s5
		add 				$a0, $a0, $s1					# $a0 -> row*n + col
		mul 				$a0, $a0, 4
		add 				$a0, $a0, $t9


		lw 					$a1, ($a0)						# load mat[row][col]

		

		sw 					$a1, ($s7) 						# store in temp[i][j++]


		
		add 				$s1, $s1, 1
		b 					innerloop

endinnerloop:
		add 				$s0, $s0, 1
		b 					outerloop

endouterloop:
		jr 					$ra





sqMatprint:
		move 				$s0, $a0                  		 # store array address
		move 				$s1, $a1 						 # store n
		mul 				$s2, $s1, $s1 				     # store n*n
		li 					$s3, 0 							 # counter i


loop2:
		bge 				$s3, $s2, endloop2 				 # if i >= n*n break
		
		mul 				$s4, $s3, 4
		add 				$s4, $s4, $s0
		
		lw 					$s5, ($s4) 						
		
		move 				$a0, $s5 						# print A[i]
		li 					$v0, 1
		syscall

		la 					$a0, space
		li					$v0, 4							# print message
		syscall		
						
		add 				$s3, $s3, 1
		b 					loop2
endloop2:
		jr 					$ra




.data
		prntmsg: 		.asciiz	 "Enter the order of square matrix whose determinant is to be found :\n"
		seed:           .asciiz  "Enter some positive integer for value of seed s:\n"
		space: 			.asciiz  " "
		debug:          .asciiz  "DEBUG\n"
		final: 			.asciiz  "Finally the determinant is : "
		mat:            .asciiz  "Matrix passed in this invocation is : "
		det:            .asciiz  "Determinant value in this invocation is : "
		nl: 			.asciiz  " \n"