# argument $a0 - address of the beginning
# $t6 - status of the remaining bits in the end
#	0 = 0 Bits remaining at the end
#	2 = 2 Bits remaining at the end	
#	4 = 4 Bits remaining at the end

# $t5 current element needed right shift (+ $t6) and end of line when 0
# $t4 current element needed left shift
# $t0 - element in work
# $t1 - here to shift around
	
	.text
	.globl decode
decode:
	li $t6 2
	li $t5 24
	li $t4 0
	lw $t0 ($a0)
	
loop:
	bltz $t5 lineshift
	sllv $t1 $t0 $t4
	addu $t2 $t5 $t6
	addu $t2 $t2 $t4
	srlv $t1 $t1 $t2
	beqz $t1 end
	li $t3 1				# comparing the character
	beq $t1 $t3 printspace		
	li $t3 27
	bleu $t1 $t3 printLetter
	li $t3 53
	bleu $t1 $t3 printletter
	b printnumber
	
printspace:
	move $t7 $a0				# save the address in $t7 for printing
	li $a0 32
	li $v0 11
	syscall
	move $a0 $t7
	subiu $t5 $t5 6
	addiu $t4 $t4 6
	b loop

printnumber:
	move $t7 $a0
	subiu $a0 $t1 6
	li $v0 11
	syscall
	move $a0 $t7
	subiu $t5 $t5 6
	addiu $t4 $t4 6
	b loop

printLetter:
	move $t7 $a0
	addiu $a0 $t1 63
	li $v0 11
	syscall
	move $a0 $t7
	subiu $t5 $t5 6
	addiu $t4 $t4 6
	b loop

printletter:
	move $t7 $a0
	addiu $a0 $t1 69
	li $v0 11
	syscall
	move $a0 $t7
	subiu $t5 $t5 6
	addiu $t4 $t4 6
	b loop
	
lineshift:
	li $t5 32
	subu $t5 $t5 $t6
	li $t7 32
	beq $t5 $t7 emptylineend
	b lineend
	
lineend:
	sllv $t7 $t0 $t5
	srlv $t7 $t7 $t5			# Overflow saved in $t7
	addiu $a0 $a0 4				# update address to new line address
	lw $t0 ($a0)				# load new line in $t0
	li $t2 30
	beq $t5 $t2 overflowshift
	li $t5 30
	b Overflow
	
overflowshift:
	li $t5 28
	b Overflow
	
statusupdate1:
	li $t6 0
	b leftshiftset
	
set_t4_1:
	li $t4 -4
	b rightshiftset
	
set_t4_2:
	li $t4 -2
	b rightshiftset
	
Overflow:
	srlv $t1 $t0 $t5			# extract overflow part
	li $t4 32
	subu $t5 $t4 $t5
	sllv $t7 $t7 $t5
	addu $t1 $t7 $t1
	beqz $t1 end
	addiu $t6 $t6 2
	li $t7 4
	bgtu $t6 $t7 statusupdate1

leftshiftset:	
	li $t4 -6				# Set new line left-shift
	li $t7 0
	beq $t7 $t6 set_t4_1
	li $t7 4
	beq $t7 $t6 set_t4_2
	
rightshiftset:
	li $t5 30
	li $t7 4
	beq $t6 $t7 lowert5

Overflowprint:					# Print the matched Overflow
	li $t3 1				# comparing the character
	beq $t1 $t3 printspace		
	li $t3 27
	bleu $t1 $t3 printLetter
	li $t3 53
	bleu $t1 $t3 printletter
	b printnumber
	
lowert5:					# Lover the rightshift - amount in case there is an 4-character Overflow next line
	subiu $t5 $t5 6
	b Overflowprint
	
emptylineend:					# $t6 was 0 -> No Overflow
	li $t4 0
	li $t5 24
	li $t6 2
	addiu $a0 $a0 4
	lw $t0 ($a0)
	li $t7 4
	bgtu $t6 $t7 statusupdate2
	b loop
	
statusupdate2:
	li $t6 0
	b loop
	
end:
	jr $ra
