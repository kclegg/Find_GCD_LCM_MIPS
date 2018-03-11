# Program 2
# Name: Kyler Ferrell-Clegg
# Class: CDA3101 - 6692
# Date: 10/1/2017

.data
in1: .asciiz "Enter first integer n1: "
in2: .asciiz "Enter second integer n2: "
out1: .asciiz "The greatest common divisor of n1 and n2 is "
out2: .asciiz "\nThe least common multiple of n1 and n2 is "
error: .asciiz "Invalid input! please try again.\n"

.globl main
.text

main:
	la $a0, in1			# load address of in1 to store in a0
	li $v0, 4			# load I/O code to print string to console
	syscall				# print string

	li $v0, 5			# Inputs an integer
	syscall

	move $s0, $v0		# move the first integer n1 into register s0

	la $a0, in2			# load address of in2 to store in a0
	li $v0, 4			# load I/O code to print string to console
	syscall				# print string

	li $v0, 5			# Inputs an integer
	syscall

	move $s1, $v0		# move the second integer n2 into register s1

	slt $t1, $s0, $zero # checks if the value n1 is less than 0
	beq $t1, 1, Error	# if n1 is less then zero go to Error label
	
	slt $t2, $s1, $zero # checks if the value n2 is less than 0
	beq $t2, 1, Error	# if n2 is less then zero go to Error label
	
	addi $s4, $zero, 255	# store 255 in s4 register
	add $s5, $s0, $s1		# adds n1 + n2 and stores in s5
	
	slt $t3, $s4, $s0   # checks if the value n1 is greater than 255
	beq $t3, 1, Error	# if n1 is greater than 255 go to Error label	

	slt $t4, $s4, $s1   # checks if the value n2 is greater than 255
	beq $t4, 1, Error	# if n2 is greater than 255 go to Error label
	
	beq $s5, $zero, Error	# if s5 value is 0 then go to Error label
	
	addi $sp, $sp, -8	# create 2 stacks
	sw $s0, 4($sp)		# store n1 in s0
	sw $s1, 0($sp)		# store n2 in s1
	
	jal GCD				# procedure call GCD
	
	lw $s1, 0($sp)		# restore s1
	lw $s0, 4($sp)		# restore s0
	
	addi $sp, $sp, 4	# deallocate a word
	add $s2, $v0, $zero # Get GCD value
	sw $s2, 0($sp)		# Store GCD value
	
	jal LCM				# produce call LCM
	
	add $s3, $v0, $zero	# Get LCM value
	lw $s2, 0($sp)		# Load GCD result to stack
	addi $sp, $sp 4		# Remove an element from the stack
	
	la $a0, out1		# load address of out1 to store in a0
	li $v0, 4			# load I/O code to print string to console
	syscall				# print string
	
	li $v0, 1			# Load I/O code
	add $a0, $s2, $zero # Store GCD value in a0
	syscall				# print value
	
	la $a0, out2		# load address of out2 to store in a0
	li $v0, 4			# load I/O code to print string to console
	syscall				# print string	
	
	li $v0, 1			# Load I/O code
	add $a0, $s3, $zero # Store LCM value in a0
	syscall				# print value
	
	li $v0, 10			# syscall code 10 for terminating the program
	syscall
	
GCD:
	addi $sp, $sp -8	# creates a stack for 2 items
	sw $ra, 4($sp)		# 
	div $s0, $s1		# divide n1 / n2
	mfhi $s2			# store the remainder of n1/n2 in s2
	sw $s2, 0($sp)		# push the remainder value to the stack

	bne $s2, $zero, Recursion	# If the remainder doesn't equal 0 then, go to recursion else continue below
								
	add $v0, $s1, $zero	# put n1 in register v0
	addi $sp, $sp, 8	# then remove two elements from the stack

	jr $ra				# returns to original linked address
	
Recursion:
	add $s0, $s1, $zero	# set n1 equal to n2
	lw $s2, 0($sp)		# load the remainder value from the stack
	add $s1, $s2, $zero	# set n2 equal to the remainder
	jal GCD
	
	lw $ra, 4($sp)		
	addi $sp, $sp, 8	# remove 2 values from stack
	
	jr $ra				# returns to original linked address
	
LCM:
	addi $sp, $sp, -12	# Create stack for 3 elements
	sw $ra, 8($sp)		
	sw $s0, 4($sp)		# store n1 in the stack
	sw $s1, 0($sp)		# store n2 in the stack
	
	jal GCD
	
	lw $s1, 0($sp)		# load n2 from the stack
	lw $s0, 4($sp)		# load n1 from the stack
	lw $ra, 8($sp)		
	
	mult $s0, $s1		# multiply n1 * n2
	mflo $t0			# storing value of n1 * n2
	div $t0, $v0		# computes appropriate division
	mflo $v0			# storing that division
	addi $sp, $sp 12	# remove 3 values from stack
	
	jr $ra				# returns to original linked address
	
Error:
	la $a0, error		# load address of error to store in a1
	li $v0, 4			# load I/O code to print string to console
	syscall				# print string
	
	j main				# go to main label