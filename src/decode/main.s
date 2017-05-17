# Own Test: "Das ist ein Test Kappa123 TEST" -> .word 0x15CB8192, 0xEBC1824A, 0x41560BAF, 0x04C72BAD, 0xCDF8E415, 0x46515000, 0x00000000
#						
	.data
code:
	.word 0x25C9E7A8, 0x16209EF0, 0x00000000

	.text
	.globl main
main:
	la  $a0 code
	jal decode
	li $v0 10
	syscall
