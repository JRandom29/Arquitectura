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
 		beq $s0, 1, impar
 	par:
 		la $a0, text2
 		j terminar

 	impar:
  		la $a0, text3
 		j terminar

	terminar:
		syscall
 		li $v0, 10
 		syscall

 	paridad:
 		andi $v0 , $a0 , 1
 		jr $ra
