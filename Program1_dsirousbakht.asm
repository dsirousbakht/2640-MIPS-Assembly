# Objective: Get familiarized with different MIPS instructions, syscall services, the MARS environment, and overall practice with Assembly programming
# Class: CS 2640
# Name: Daniel Sirousbakht
# Date: 10/26/2022

.data
welcomeMSG: .asciiz "Welcome, please enter two values of the inetger type and intger type only.\nInputting any other data type will break the program.\n\n"
firstINP: .asciiz "Please enter your first integer: "
secondINP: .asciiz "Please enter your second integer: "
firstOUT: .asciiz "Your first input was: "
secondOUT: .asciiz "Your second input was: "  
newline: .asciiz "\n"
opMenu: .asciiz "Enter the corresponding symbol to perform an arithmetic operation: \n + \n - \n * \n / \nOperation: "
exitMSG: .asciiz "\nHave a nice day!"
result: .asciiz "\n\nYour answer is: "
quotient: .asciiz "\n\nThe quotient is: "
remainder: .asciiz "\nThe remainder is: "
equal: .asciiz "\nUser inputs are the same"
notequal: .asciiz "\nUser inputs are different"

# Task 1
.text
main:
	# prompt the welcoming message/sanitize user inputs
	li $v0, 4
	la $a0, welcomeMSG
	syscall
	
	# prompt user for first input
	li $v0, 4
	la $a0, firstINP
	syscall
	
	# get first input from user
	li $v0, 5
	syscall
	
	# move user input to register $s0
	move $s0, $v0
	
	# prompt user for second input
	li $v0, 4
	la $a0, secondINP
	syscall
	
	# get second input from user
	li $v0, 5
	syscall
	
	# move user input to register $s1
	move $s1, $v0
	
	# output a newline
	li $v0, 4
	la $a0, newline
	syscall
	
	# output first input
	li $v0, 4
	la $a0, firstOUT
	syscall
	li $v0, 1
	move $a0, $s0
	syscall
	li $v0, 4
	la $a0, newline # output a newline
	syscall
	
	
	# output second input
	li $v0, 4
	la $a0, secondOUT
	syscall
	li $v0, 1
	move $a0, $s1
	syscall
	li $v0, 4
	la $a0, newline # output a newline
	syscall
	
	# output a newline
	li $v0, 4
	la $a0, newline
	syscall

# Task 2:
operationMenu:
	# prompt the user to choose which arithmetic operation they would like to perform
	li $v0, 4
	la $a0, opMenu
	syscall
	# retrieve and evaluate operator input from user
	li $v0, 12
	syscall
	# move to register $s3
	move $s3, $v0
	
	#check user inputs with branch if equal
	beq $s3, '+', ADD
	beq $s3, '-', SUB
	beq $s3, '*', MUL
	beq $s3, '/', DIV
	
ADD: # prompt and find the result of the addition operation
	la $a0, result
	li $v0, 4
	syscall
	add $t0, $s0, $s1 # add inputs from registers $s0 and $s1
	move $a0, $t0
	li $v0, 1
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	j checkIfSame

SUB: # prompt and find the result of the subtraction operation 
	la $a0, result
	li $v0, 4
	syscall
	sub $t0, $s0, $s1 # subtract inputs from registers $s0 and $s1
	move $a0, $t0
	li $v0, 1
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	j checkIfSame

MUL: # prompt and find the result of the multiplication operation
	la $a0, result
	li $v0, 4
	syscall
	mul $t0, $s0, $s1 # multiply inputs from registers $s0 and $s1
	move $a0, $t0
	li $v0, 1
	syscall
	li $v0, 4
	la $a0, newline # output newline
	syscall
	j checkIfSame
	
DIV: # prompt and find the quotient and remainder from the integer division operation
	div $t0, $s0, $s1
	move $a0, $t0
	la $a0, quotient
	li $v0, 4
	syscall
	li $v0, 1
	mflo $a0 # move from LO register
	syscall
	la $a0, remainder
	li $v0,4
	syscall
	li $v0,1
	mfhi $a0 # move from HI register 
	syscall
	li $v0, 4
	la $a0, newline # output newline
	syscall
	j checkIfSame 
	
checkIfSame:
	# prompt and check if the two user inputs are equal to each other
	beq $s0, $s1, ifEqual # branching if the contents of registers $s0 and $s1 are equal
	bne $s0, $s1, ifNotEqual # branching if the contents of registers $s0 and $s1 are not equal
	syscall

# Task 3
ifEqual:
	# allow the user to know that the inputs are the same 
	li $v0, 4
	la $a0, equal
	syscall
	j exit

ifNotEqual:
	# allow the user to know that the inputs are not the same
	li $v0, 4
	la $a0, notequal
	syscall
	j exit
	
exit:
	# exit the program with a final message
	li $v0, 4
	la $a0, newline # output newline
	syscall
	la $a0, exitMSG # output exit message
	li $v0, 4
	syscall
	li $v0, 10 # exit
	syscall