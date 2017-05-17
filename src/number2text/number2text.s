# Expected arguments: $a0 = last buffer address, $a1 = number which is to convert, $a2 = new base in [2,36]

	.text
	.globl number2text
number2text:
	sb $0 ($a0) 
	subiu $a0 $a0 1
	
newbase:	# Switching the base from decimal to $a2 in [2,36]
	beq $a1 $0 end
	div $a1 $a2
	mflo $a1	# put quotient of $a1 / $a2 in $a1
	mfhi $t0	# put remainder of $a1 / $a2 in $t0
	subiu $a0 $a0 1
	sgtu $t1 $t0 9
	beq $t1 1 letter
	b number

letter:		# convert number in new base $a0 to ASCII number (refering to a letter)
 	addiu $t0 $t0 55	
 	sb $t0 ($a0)
 	b newbase
	
number:	 	# convert number in new base $a0 to ASCII number (refering to a number)
	addiu $t0 $t0 48
	sb $t0 ($a0)
	b newbase

end: 		# End
	move $v0 $a0
	jr $ra
