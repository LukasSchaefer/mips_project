	.data
list_head:
	.word el1, 23
el1:
	.word el2, 42
el3:
	.word 0,   19
el2:
	.word el3, 1337

	.text
print_list:
	move $a1 $a0
	b    print_entry
print_loop:
	lw   $a0 4($a1)
	li   $v0 1
	syscall
	li   $a0 ' '
	li   $v0 11
	syscall
	lw   $a1 0($a1)
print_entry:
	bnez $a1 print_loop
	li   $a0 '\n'
	li   $v0 11
	syscall
	jr   $ra

	.globl main
main:
	la  $a0 list_head
	jal print_list
	la  $a0 list_head
	jal rev_list
	la  $a0 el3
	jal print_list
	li  $v0 10
	syscall
