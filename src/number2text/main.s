	.data
buf:
	.space 33
bufend:

	.text
	.globl main
main:
	la   $a0 bufend
	li   $a1 1337
	li   $a2 16
	jal  number2text
	move $a0 $v0
	li   $v0 4
	syscall
	li   $v0 10
	syscall