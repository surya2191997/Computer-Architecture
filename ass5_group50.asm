# Group No. 50 
# kthlargest.asm -- prints the kth largest number in a stream of n numbers

# Registers used:
# $t0     -  used to store loop index i
# $t1     -  used to store 4*i
# $t2	  -  used to store n-i
# $t3 - $t7

# -4($fp) -  used to store k
# -8($fp) -  used to store n 



.text
main:
		subu				$sp, $sp, 4						# Allocate space for frame pointer regiser
		sw					$fp, ($sp)						# Store the contents of frame pointer register
		add 				$fp, $sp, 0 					# Assign the frame pointer as current stack top

		la 					$a0, printmsg1					# Load the address of printmsg in a0	
		li					$v0, 4							# Load syscall of print in v0
		syscall
		li					$v0, 5 							# Load syscall of readint in v0
		syscall
		subu				$sp, $sp, 4						# Allocating space for k
		sw					$v0, ($sp)						# -4($fp) stores k 


		la 					$a0, printmsg2					# Load the address of printmsg in a0	
		li					$v0, 4							# Load syscall of print in v0
		syscall
		li					$v0, 5 							# Load syscall of readint in v0
		syscall
		subu				$sp, $sp, 4						# Allocating space for n
		sw					$v0, ($sp)						# -8($fp) stores n 

		lw					$t0, -8($fp)					# load n

		mul					$t0, $t0, 4						# $t0 stores 4*n
		subu				$sp, $sp, $t0				    # Allocate space for array 
		li					$t0, 0							# Store 0 in i


loop:
		lw					$t1, -8($fp)					# Store n in $t1
		
		beq					$t1, $t0, endloop               # if i equals n we're done reading input  
		li					$v0, 5 							# Load syscall of readint in v0
		syscall
		mul					$t1, $t0, 4						# $t1 stores 4*i
		add 				$t1, $sp, $t1					# $t1 stores $sp + 4*i
		sw					$v0, ($t1)						# store contents of v0(read number) in $sp +4*i
		add				    $t0, $t0, 1
		b 					loop
		
endloop:
		li					$t0, 0							# store loop index i
		li					$t1, 0							# store loop index j

outerloop:
		lw					$t2, -4($fp)					# store k in $t2
		beq					$t2, $t0, endouterloop

innerloop:
		lw					$t2, -8($fp)					# store n in $t2
		subu				$t2, $t2, $t0					# store n-i		
		subu				$t2, $t2, 1						# store n-i-1
		beq					$t2, $t1, endinnerloop

		mul					$t3, $t1, 4						# store 4*j
		add 				$t3, $sp, $t3					# sp + 4*j
		lw					$t4, ($t3)						# t4 stores sp + 4*j
		addiu				$t3, $t1, 1						# j+1
		mul					$t3, $t3, 4						
		add				    $t3, $sp, $t3					# t3 <- sp + 4*(j+1)
		lw					$t5, ($t3)						# t5 stores (t3)

		bgt					$t4, $t5, swap					# if a[j] > a[j+1] swap
		add 				$t1, $t1, 1						# increment j
		b 					innerloop						# jump to innerloop

swap :		
		mul					$t3, $t1, 4
		add				    $t3, $sp, $t3
		lw					$t4, ($t3)						# store a[j] in t4

		addiu				$t3, $t1, 1
		mul					$t3, $t3, 4
		add				    $t3, $sp, $t3
		lw					$t5, ($t3)						# store a[j+1] in t5

		sw					$t4, ($t3)						# store t4 in a[j+1]
		mul					$t3, $t1, 4
		add				    $t3, $sp, $t3
		sw					$t5, ($t3)						# store t5 in a[j]
		addiu				$t1, $t1, 1
		b 					innerloop

endinnerloop:
		addiu				$t0, $t0, 1
		b 					outerloop

endouterloop:
		lw					$t6, -8($fp)
		lw					$t7, -4($fp)
		subu				$t7, $t6, $t7
		add				    $t6, $sp, $t7
		lw					$t7, ($t6)
		li 					$v0, 10							# exit syscall
		syscall								    			# exit

		 

.data
printmsg1:				.asciiz "Enter k :\n"
printmsg2:				.asciiz "Enter n :\n"