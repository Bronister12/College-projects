.data
menu:			.asciiz "Enter 1) add\n2) addi\n3) exit: \n"
enterRs:		.asciiz "Enter Rs: "
enterRt:		.asciiz "Enter Rt: "
enterRd:		.asciiz "Enter Rd: "
enterImm:		.asciiz "Enter Immediate: "
hexDigits:		.asciiz "0123456789ABCDEF"
hexDigit:		.asciiz " "        
newLine:		.asciiz "\n"
inHex:			.asciiz "In Hex: "
inBinary:		.asciiz "In Binary: "

#Hex to binary transfer
space:			.asciiz " "
zero: 			.asciiz "0"
one:			.asciiz "1"

.text
.globl main
main:

menuLoop:		
			li $t0, 0				# Register for all work		
			la $a0, menu
			jal print				# Show a menu
			
			jal userInput				# User operation choice
			move $t9, $v0				
			

			
			beq $t9, 1, addOperation		# Choice 1- Add
			beq $t9, 2, addiOperation		# Choice 2 - Addi
			
			beq $t9, 3, endProgram			# If 3 - exit Program
			
			j menuLoop	

addOperation:
			la $a0, enterRs				#----RS----
			jal print				#Print
			jal userInput				#Input Rs
			move $t1, $v0				# Rs in $t1
			sll $t1, $t1, 21			# Shift in the Rs position
			or $t0, $t0, $t1			# Copy value in $t0 (25-21)
			
			la $a0, enterRt				#----RT----
			jal print				# Print
			jal userInput				#Input in RT
			move $t2, $v0				# RT in $t2
			sll $t2, $t2, 16			#Shift in the RT position ( 20-16)
			or $t0, $t0, $t2			# Copy in $t0
			
			la $a0, enterRd				#----RD----
			jal print				# Print
			jal userInput				#Input in Rd
			move $t3, $v0				# Rd in $t3
			sll $t3, $t3, 11			# Shift in the Rd position (15-11)
			or $t0, $t0, $t3			# Copu in $t0

			ori $t0, $t0, 32			#Inform MIPS that it is add instruction
								#(same as 0x20) to switch 5th bit
			la $a0, inHex
			jal print				#print inHex						
								
			move $a0, $t0
			jal prthex				#Call func to print Hex value
			
			la $a0, newLine				#go to new Line
			jal print
			
			move $a0, $t0
			jal hexToBinaryRtype				
			
			la $a0, newLine				#go to new Line
			jal print
			
			j menuLoop				# return to the menu
			
addiOperation:
			li $t8, 8
			sll $t8, $t8, 26
			or $t0, $t0, $t8			# Put 8 into oppcode for addi
			
			
			
			la $a0, enterRs				#----RS----
			jal print				#Print
			jal userInput				#Input Rs
			move $t1, $v0				# Rs in $t1
			sll $t1, $t1, 21			# Shift in the Rs position
			or $t0, $t0, $t1			# Copy value in $t0 (25-21)
			
			la $a0, enterRt				#----RT----
			jal print				# Print
			jal userInput				#Input in RT
			move $t2, $v0				# RT in $t2
			sll $t2, $t2, 16			#Shift in the RT position ( 20-16)
			or $t0, $t0, $t2			# Copy in $t0
			
			la $a0, enterImm			
			jal print				# Show enter immediate prompt
			jal userInput				# get immediate from user
			move $t3, $v0				# move immediate to $t3
			andi $t3, $t3, 0xFFFF			# clean everythining over 16 bits
			or $t0, $t0, $t3			# or to $t0
			
			la $a0, inHex
			jal print				#print inHex	
			
			move $a0, $t0
			jal prthex				# call prthex
			
			la $a0, newLine				#go to new Line
			jal print
			
			move $a0, $t0
			jal hexToBinaryItype
			
			
			la $a0, newLine				# new line
			jal print
			j menuLoop



endProgram:
			li $v0, 10
			syscall


#======================Hex To Binary I type Func ==========================================================
hexToBinaryItype:
			addi $sp,$sp -12
			sw $s0, 8($sp)
			sw $ra, 4($sp)				
			sw $s1, 0($sp)			#index for num of bits to print

			move $s0, $a0				
    			li $s1, 32			# store num of bits to print

			la $a0, inBinary
			jal print			# output in binary

ItypeLoop:
			blez $s1, stopLoop		# if <= 0, stop looping
			addi $s1, $s1, -1		# subtract from index

			bltz $s0, oneToPrint		# IF < 0, to print 1
			la $a0, zero			# else print 0
			j printIt
oneToPrint:
			la $a0, one			# to print one
printIt:		
			jal print
			
			beq $s1, 16, RSpaceit		#20-16	next to rt
			beq $s1, 21, RSpaceit		#25-21	next to rs
			beq $s1, 26, RSpaceit		#31-26	next to opcode
			
			j noSpace
Spaceit:
			la $a0, space			# print space
			jal print
noSpace:
			sll $s0, $s0, 1			# shift next bit
			j ItypeLoop			
			
stopLoop:
			la $a0, newLine
			jal print
			
			lw $s0, 8($sp)			# restoring 
			lw $ra, 4($sp)
			lw $s1, 0($sp)
			addi $sp, $sp, 12
			jr $ra
			
			
#======================Hex To Binary R type Func ==========================================================
hexToBinaryRtype:
			addi $sp,$sp, -12
			sw $s0, 8($sp)
			sw $ra, 4($sp)				
			sw $s1, 0($sp)			#index for num of bits to print

			move $s0, $a0				
    			li $s1, 32			# store num of bits to print

			la $a0, inBinary
			jal print			# output in binary

RtypeLoop:
			blez $s1, RstopLoop		# if <= 0, stop looping
			addi $s1, $s1, -1		# subtract from index

			bltz $s0, RoneToPrint		# IF < 0, to print 1
			la $a0, zero			# else print 0
			j RprintIt
RoneToPrint:
			la $a0, one			# to print one
RprintIt:		
			jal print
			#--- R type spacing check----
			beq $s1, 6, RSpaceit		#10-6	next to shamp
			beq $s1, 11, RSpaceit		#15-11	next to rd
			beq $s1, 16, RSpaceit		#20-16	next to rt
			beq $s1, 21, RSpaceit		#25-21	next to rs
			beq $s1, 26, RSpaceit		#31-26	next to opcode

			
			j RnoSpace
RSpaceit:
			la $a0, space			# print space
			jal print
RnoSpace:
			sll $s0, $s0, 1			# shift next bit
			j RtypeLoop			
			
RstopLoop:
			la $a0, newLine
			jal print
			
			lw $s0, 8($sp)			# restoring 
			lw $ra, 4($sp)
			lw $s1, 0($sp)
			addi $sp, $sp, 12
			jr $ra

			
#====================== Print Hex Func ===========================================================
prthex: 
        		addi $sp,$sp,-4
       			sw $ra 0($sp)
			li 	$t8,0xF0000000
			li	$t2,28		#number of bits to shift
			li	$v0,4           #prepared to print a string
			move     $s0,$a0        #save the number being printed
			la	$a0,hexDigit    #what is being printed
extractDigit:
			and	$t3,$s0,$t8	#extract the digit
			srlv	$t3,$t3,$t2	#shift it the lower 4 bits
			lb	$t4,hexDigits($t3)    #get the digit
			sb	$t4,hexDigit($zero)	#and store to print
			syscall				#and print
			srl	$t8,$t8,4	#go to next digit
			beqz	$t8,doneHex	#done when last digit wasn't shifted
			addi	$t2,$t2,-4	#which will need to shift 4 less
			j	extractDigit	#get next digit
doneHex:
         		lw $ra 0($sp)
         		addi $sp,$sp,4
         		jr $ra	
         




#====================== Output func ==================================================================
print:
			addi $sp, $sp, -4
			sw $ra, 0($sp)
			
			li $v0, 4
			
			syscall	
			lw $ra, 0($sp)
			addi $sp, $sp, 4
			jr $ra


#====================== User Input func ==============================================================
userInput:	
			addi $sp, $sp, -4
			sw $ra, 0($sp)
			
			li $v0, 5
			syscall
			
			lw $ra, 0($sp)
			addi $sp, $sp, 4
			jr $ra



