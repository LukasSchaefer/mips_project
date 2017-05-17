	.data
buf:
	.asciiz "2A"

	.text
	.globl main
main:
	la   $a0 buf
	li   $a1 16
	jal  text2number
	move $a0 $v0
	li   $v0 1
	syscall
	li   $v0 10
	syscall
