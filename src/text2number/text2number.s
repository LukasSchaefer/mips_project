# given arguments: $a0 = address of first element, $a1 = base of the given number
	.text
	.globl text2number
text2number:
	li $v0 0
	b start
	
start:
	lb $t0 ($a0)
	beq $t0 $0 end
	mul $v0 $v0 $a1
	sltiu $t1 $t0 65
	li $t2 1
	beq $t1 $t2 number
	b letter
	
letter:
	subiu $t0 $t0 55
	addu $v0 $v0 $t0
	addiu $a0 $a0 1
	b start

number:
	subiu $t0 $t0 48
	addu $v0 $v0 $t0
	addiu $a0 $a0 1
	b start
	
end:
	jr $ra
