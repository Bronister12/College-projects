.data
inputA:			.asciiz "Enter a value for side A: "
inputB:			.asciiz "Enter a value for side B: "
inputC:			.asciiz "Enter a value for side C: "
coma:			.asciiz ", "
isRight:		.asciiz " - is a right triangle\n"
isNotRight:		.asciiz " - is not a right triangle\n"


.text
.globl main

main:
			jal allWork			#Call allWork Func
			li $v0, 10
			syscall
			
			
allWork:
			addi $sp, $sp, -4
			sw $ra, 0($sp)			# Save return register
			
			la $a0, inputA			# Input A
			jal print
			jal input
			move $t1, $v0
			move $a0, $t1
			li $a1, 2			# Set a power
			jal power
			move  $t7, $v0			# Store squared A in $t7
			
			la $a0, inputB			# Input B
			jal print
			jal input
			move $t2, $v0
			move $a0, $t2
			li $a1, 2			# Set a power
			jal power
			move  $t8, $v0			# Store squared B in $t8
			
			la $a0, inputC			# Input C
			jal print
			jal input
			move $t3, $v0
			move $a0, $t3
			li $a1, 2			# Set a power
			jal power
			move  $t9, $v0			# Store squared C in $t9
			
			
			jal check			# Call Check Func
			move $t0, $v0			# 1 - Right, 0 - Not Right
			
			jal output			# Call output func

			lw $ra 0($sp)			# Load return register
			addi $sp, $sp, 4
			jr $ra
			
# $t1 = Original A
# $t2 = Original B
# $t3 = Original C
# $t7 = Squared A
# $t8 = Squared B
# $t9 = Squared C


			

#====================== Power Function ============================================================
power:			
			addi $sp, $sp, -4
			sw $ra, 0($sp)			# Save return register
			
			move $t4, $a0			# Save base in     $t4
			move $t5, $a1			# Save exponent in $t5
			li $t6, 1			
loop:
			beqz $t5, out			# If exponent is zero, stop multiply
			addi $t5, $t5, -1		# Subtract 1 from the exponent
			mul $t6, $t6, $t4		# Multiply by itself for each iteration
			j loop
			
out:			
			move $v0, $t6			# Return value in $v0

			lw $ra, 0($sp)			# Load return register
			addi $sp, $sp, 4
			jr $ra
#======================================================================================================
			
#====================== Input Function ==============================================================
input:			
			addi $sp, $sp, -4
			sw $ra, 0($sp)			# Save return register

			
			li $v0, 5			# Input from user
			syscall
			
			
			lw $ra, 0($sp)			# Load return register
			addi $sp, $sp, 4
			jr $ra
#=====================================================================================================

#====================== Print function ===========================================================
print:
			addi $sp, $sp, -4
			sw $ra, 0($sp)			# Save return register
			
			li $v0, 4			# Output 
			syscall
			
			lw $ra, 0($sp)			# Load return register
			addi $sp, $sp, 4
			jr $ra				
#=====================================================================================================

# $t1 = Original A
# $t2 = Original B
# $t3 = Original C
# $t7 = Squared A
# $t8 = Squared B
# $t9 = Squared C

#===================== Check Function =================================================================
check:
			addi $sp, $sp, -16
			sw $t1, 12($sp)				# Store my temp registers in the stack since I run out of them
			sw $t2, 8($sp)
			sw $t3, 4($sp)
			sw $ra, 0($sp)				# Save return register
			
			add $t1, $t7, $t8			# Check if A^2 + B^2 = C^2
			beq $t1, $t9, itRight			
			
			add $t2, $t8, $t9			# Check if B^2 + C^2 = A^2
			beq $t2, $t7, itRight
			
			add $t3, $t7, $t9			# Check if A^2 + C^2 = B^2
			beq $t3, $t8, itRight
			
			li $v0,0
			j leaveCheck
			
itRight:
			li $v0, 1
leaveCheck:						
			lw $ra, 0($sp)				# Load return register
			lw $t3, 4($sp)
			lw $t2, 8($sp)
			lw $t1, 12($sp)				# Load my registers back from the stack
			addi $sp, $sp, 16
			jr $ra					
#========================================================================================================															

#====================== Output Function ===============================================================	
output:
			addi $sp, $sp, -4
			sw $ra, 0($sp)				# Save return register
			
			li $v0, 1
			move $a0, $t1				
			syscall					# Output num A
			
			la $a0, coma				# Output coma
			jal print
			
			li $v0, 1
			move $a0, $t2
			syscall					# Output num B
			
			la $a0, coma				# Output coma
			jal print
			
			li $v0, 1
			move $a0, $t3
			syscall					# Output num C
			
			beqz $t0, NotRightPrompt		# If flag is 0,go to not right
			la $a0, isRight				# Else: Load isRitht in $a0
			j justPrintIt				# Jump to print
			
NotRightPrompt:		
			la $a0, isNotRight			#load isNotRight in $a0
justPrintIt:		
			jal print				# Call print func
			
			
			
			lw $ra, 0($sp)			# Load return register
			addi $sp, $sp, 4
			jr $ra
#========================================================================================================
