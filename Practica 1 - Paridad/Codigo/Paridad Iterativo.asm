.data
 	text1: .asciiz "Ingrese numero : "
 	text2: .asciiz "Su numero es par.\n"
 	text3: .asciiz "Su numero es impar.\n"
 	text4: .asciiz "Numero Invalido!\n"
.text
 	main:

 		li $v0, 4
 		la $a0, text1
		syscall

 		li $v0, 5
 		syscall

 		move $a0, $v0
 		jal paridad
 		move $s0, $v0

 		li $v0, 4
 		beq $s0, -1, error
 		beq $s0, 0, impar
 	par:

 		la $a0, text2
 		j terminar

 	impar:
  		la $a0, text3
 		j terminar
 	error:
 		la $a0, text4
 		j terminar


	terminar:
		syscall
 		li $v0, 10
 		syscall

 	paridad:
 		li $v0, -1
 		bltz $a0, return

 		li $t0, 0
 		li $v0, 1
 		li $t1, 1

 		beqz $a0, return
 		for:
 			sub $v0, $t1, $v0

 			addi $t0, $t0, 1
 			blt $t0, $a0, for
 	return:
 	jr $ra
