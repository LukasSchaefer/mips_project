# arguments: $a0 : first list element-address

	.text
	.globl rev_list
rev_list:
	move $t0 $a0
	lw $a0 ($a0)
	beqz $a0 empty_end
	sw $0 ($t0)
	
loop:
	lw $t1 ($a0)
	sw $t0 ($a0)
	move $t0 $a0
	move $a0 $t1
	beqz $a0 end
	b loop

end:
#	sw $t0 ($a0)
	move $v0 $a0
	jr $ra
	
empty_end:
	move $v0 $t0
	jr $ra
