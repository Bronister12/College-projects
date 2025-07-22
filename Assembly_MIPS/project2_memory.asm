.data
inputPrompt:		.asciiz "Enter word: "
outputPrompt:		.asciiz "The vowels and their count are: \n"
vowels:			.word 'a','e','i','o','u','y'	# Array of Vowels
counters:		.word 0,0,0,0,0,0		# Counters for each letter
size:			.word 16			# Size 
buffer:			.space 16			# Buffer
newline:		.asciiz "\n"			# New line

# Each letter
lA:			.asciiz "a - "
lE:			.asciiz "e - "
lI:			.asciiz "i - "
lO:			.asciiz "o - "
lU:			.asciiz "u - "
lY:			.asciiz "y - "

.text
.globl main
main:
			lw $t2, size			# Set size to $t2
			li $t4, 5			# index of vowels
			
			li $v0, 4			
			la $a0, inputPrompt		
			syscall				# Show input Prompt
			
			la $a0, buffer			# Load address of buffer
			lw $a1, size			# Load max num of byttes
			li $v0, 8	
			syscall				# User word entry
			
			li $t1, 0			# Loop index
mainLoop:
			bltz $t4, counterY		# if vowel index < 0 branch to counterY
			la $t0, buffer			# Reset pointer of buffer
			li $t1, 0			# Reset loop index
scanVovel:			
			lb $t3, 0($t0)			# Load one char
			beq $t3, $zero, nextOne		#if char is zero, go to nextOne
			bge $t1, $t2, nextOne		#if index is equal to size, go to nextOne
			
			
			sll $t7, $t4, 2			# Multiply vowel index by 4 and assign to $t7
			la $t9, vowels			
			add $t9, $t9, $t7
			lw $t5, 0($t9)			# Load vowel char
			
			beq $t3, $t5, countPlus		# If word char is == vowel char, count++
			
			addi $t0, $t0, 1		# Else buffer pointer++
			addi $t1, $t1, 1		# Loop index++
			j scanVovel			# Next iteration
			
countPlus:
			la $t6, counters		# Assign array counters to $t6
			sll $t7, $t4, 2			# Multiply counter by 4 and assign to $t7
			add $t6, $t6, $t7		# Move pointer in array by 4 bytes
			lw $t8, 0($t6)			# load current count for this vowel in $t4
			addi $t8, $t8, 1		# Inctrement the counter
			sw $t8, 0($t6)			# Store incremented count to counters
			
			addi $t0, $t0, 1		# move buffer pointer to next char
			addi $t1, $t1, 1		# index++
			j scanVovel			# Go to next iteration
			
nextOne:
			addi $t4, $t4, -1		# Go to next vowel
			j mainLoop

counterY:						#Check whether Y is alone						# $t4 - index of vowels,     $t2 -  size,     $t1 - loop index,   $t0 - buffer
			la $t0, counters
			
			lw $t1, 0($t0)			# check A
			bnez $t1, eraseY
			
			lw $t1, 4($t0)			# check E
			bnez $t1, eraseY
			
			lw $t1, 8($t0)			# check I
			bnez $t1, eraseY
			
			lw $t1, 12($t0)			# check O
			bnez $t1, eraseY
			
			lw $t1, 16($t0)			# check U
			bnez $t1, eraseY
			
			j output

eraseY:
			sw $zero, 20($t0)		# set y in array counters to 0
			j output
			
output:
			li $v0, 4
			la $a0, outputPrompt
			syscall				# Show output prompt
			
			li $t4, 0			# set vowel index to 0

printLoop:
			bge $t4, 6, exit		#if index is greater or equal 6, branch to exit
			la $t6, counters		# Pointer to counters
			sll $t7, $t4, 2			# Multiply counter value by 4
			add $t6, $t6, $t7		# Move pointer to counter by ($t4 * 4)
			lw $t8, 0($t6)			# load word from $t6 to $t8
			beq $t8, $zero, skip		# if $t8 is zero, skip


			beq $t4, 0, A			#Match index to vowels
			beq $t4, 1, E
			beq $t4, 2, I
			beq $t4, 3, O
			beq $t4, 4, U
			
			la $a0,lY			# load address if vowel to print
			j printIt
A:			la $a0,lA
			j printIt
E:			la $a0,lE
			j printIt
I:			la $a0,lI
			j printIt
O:			la $a0,lO
			j printIt
U:			la $a0,lU

printIt:
			li $v0,4
    			syscall				# output the vowel letter
			
    			move $a0,$t8
			li $v0,1
			syscall				# Output vowen count
			li $v0,4	
			la $a0,newline
			syscall				#new line

skip:
			addi $t4,$t4,1			# increment counter
			j printLoop			

exit:
			li $v0,10			#Exit program
			syscall








			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			