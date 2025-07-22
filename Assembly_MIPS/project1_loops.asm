.data
preview:		.asciiz "Enter the sentinel value (may not be 0): "
enterNum:		.asciiz "Enter a number: "
sumOfPositive:		.asciiz "\nSum of positive numbers: "
sumOfNegative:		.asciiz "\nSum of negative numbers: "
# One sentence:
there:			.asciiz "\nThere were "
posNum:			.asciiz " positive numbers. "
negative:		.asciiz " negative numbers. "
andPrompt:		.asciiz "And "
zeroes:			.asciiz " zeroes."
# Zeroes, negatives or positives
tiePosNeg:		.asciiz "\nPositives and negatives are equal"
tiePosZero:		.asciiz "\nPositive and zeroes are equal"
tieNegZero:		.asciiz "\nNegative and zeros are equal"
allThreeEqual:		.asciiz "\nAll three equal"

morePosNums:		.asciiz "\nThere were more positives"
moreNegNums:		.asciiz "\nThere were more negatives"
moreZeroNums:		.asciiz "\nThere were more zeros"

# End
endProgram:		.asciiz "\nProgram exiting"




.text
.globl main
main:
			# Set registers to zero
			li $t1, 0		# Positive sum
			li $t2, 0		# Negative sum
			li $t3, 0		# Negative counter
			li $t4, 0		# Positive counter
			li $t5, 0		# Zero counter
			
# Input sentinel from user		
inputNotZero:
			li $v0, 4
			la $a0, preview
			syscall				# Ask user to input sentinel value
			
			li $v0, 5
			syscall				# Input sentinel value
			move $s0, $v0
			
			beqz $s0, inputNotZero
			
			
# Loop for user nums entry 				
loop:			
			li $v0, 4			
			la $a0, enterNum
			syscall				# Ask user enter Num
			
			li $v0, 5
			syscall				# User input num
			move $t0, $v0
		
			beq $t0, $s0, dataOutput
			
			
			beqz $t0, zeroLabel		# Condition if zero
			bltz $t0, negativeNum		# Condition pos or neg
#Increase poititve
			addi $t4, $t4, 1		# Positive counter increase
			add $t1, $t1, $t0
			j loop

# Increase Negative
negativeNum:	
			addi $t3, $t3, 1		# Negative counter increase
			add $t2, $t2, $t0
			j loop

# Increase zero	
zeroLabel:		
			addi $t5, $t5, 1		# Zero counter increase
			j loop

# Output data after user entered sentinel			
dataOutput:	
			li $v0, 4
			la $a0, sumOfPositive		
			syscall				# Show positive numbers' sum prompt
			
			li $v0, 1
			move $a0, $t1
			syscall				# Show positive sum
			
			li $v0, 4
			la $a0, sumOfNegative
			syscall				# Show negative numbers' sum prompt
			
			li $v0, 1
			move $a0, $t2
			syscall				# Show negative sum
			
			# All together:
			li $v0, 4
			la $a0, there			# Print first part of the sentence
			syscall
			
			li $v0, 1
			move $a0, $t4
			syscall				# Show positive counter
			
			li $v0, 4
			la $a0, posNum
			syscall				# Print next part of the sentence
			
			li $v0, 1
			move $a0, $t3
			syscall				# Show negative counter
			
			li $v0, 4
			la $a0, negative
			syscall				# Print next part of the sentence
			
			li $v0, 4
			la $a0, andPrompt
			syscall				# Connect sentence
			
			li $v0, 1
			move $a0, $t5
			syscall				# Show zero counter
				
			li $v0, 4
			la $a0, zeroes			# Print last part of the sentence
			syscall
			
# Check if there is a tie			
CheckForTie:
			beq $t4, $t3, tieCheckPosNeg	# If pos qual to neg, go to tieCheckPosNeg
			beq $t4, $t5, tieCheckPosZero	# If pos equal zero, go to tieChecKPosZero
			beq $t3, $t5, tieCheckNegZero  	# If neg equal zero, go to tieCheckNegZero
			j noTieFound
			
tieCheckPosNeg:
			beq $t4, $t5, allEqual		# cond if pos equal zero go to all three equal
			li $v0, 4
			la $a0, tiePosNeg
			syscall
			j exitProgram
			
tieCheckPosZero:	
			li $v0, 4
			la $a0, tiePosZero		# Output tie between positives and zeros
			syscall
			j exitProgram
			
tieCheckNegZero:	
			li $v0, 4
			la $a0, tieNegZero
			syscall				# Output tie between negatives and zeroes
			j exitProgram
			
allEqual:	
			li $v0, 4	
			la $a0, allThreeEqual
			syscall				# Output all three tie
			j exitProgram	
		
# Check greatest if there is no tie	
noTieFound:
			bgt $t4, $t3, posVsZero		# If pos > neg, then posVsZero
			bgt $t3, $t5, moreNegative	# If neg > zero, then Neg is more
			j moreZeros
			
posVsZero:
			bgt $t4, $t5, morePositive	#if pos > zero, then Pos is more
			j moreZeros
			
morePositive:
			li $v0, 4
			la $a0, morePosNums
			syscall				# output more positive
			j exitProgram
			
moreNegative:
			li $v0, 4
			la $a0, moreNegNums
			syscall				# Output more negative
			j exitProgram

moreZeros:	
			li $v0, 4
			la $a0, moreZeroNums
			syscall				# Output more zeros
	
			
# Exit program		
exitProgram:
			li $v0, 4
			la $a0, endProgram
			syscall				# Output exit prompt
			
			li $v0, 10
			syscall				# Exit program

	
			
