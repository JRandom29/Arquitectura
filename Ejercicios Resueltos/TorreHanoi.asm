	
.macro print_char(%char)
    li $v0, 11
    li $a0, %char
    syscall
.end_macro

.macro print_reg_char(%char)
    li $v0, 11
    move $a0, %char
    syscall
.end_macro

.macro sI(%1,%2)


.end_macro
.macro stack(%arg)
	subi $sp , $sp , 4
	sw %arg , 0($sp)
.end_macro 

.macro pop_unstack(%arg)
	lw %arg , 0($sp)
	addi $sp , $sp , 4
.end_macro 

.macro save_in_pila()
	stack($s3)
	stack($s0)
	stack($s1)
	stack($s2)
	stack($ra)
.end_macro

.macro load_in_pila()
	pop_unstack ($ra)
	pop_unstack ($s2)
	pop_unstack ($s1)
	pop_unstack ($s0)
	pop_unstack ($s3)
.end_macro

.data
	text1 : .asciiz "Mover Disco 1 de "
	text2: .asciiz "Mover Disco "
	text3: .asciiz " a "
	text4: .asciiz " de "
.text
	main:
	li $s0 , 'A'
	li $s1 , 'C'
	li $s2 , 'B'
	li $s3 , 3
	
	jal TorreHanoi
	
	return:
	li $v0 , 10
	syscall
	
	TorreHanoi: # (S3 : n  , S0 : origen , S1 : Destino , S2: auxiliar )
		bne $s3 , 1 , recursion_case 
		 base_case:
			#Mostrar Movimiento
			li $v0  , 4
			la $a0 , text1
			syscall
			print_reg_char ($s0)
			li $v0  , 4
			la $a0 , text3
			syscall
			print_reg_char($s1)
			print_char('\n')
			#-----Retornar-----------
			jr $ra
		recursion_case:
				#Guardar en la pila
				save_in_pila()
				#---Modificar para la recursion :: (n-1 , origen ,auxiliar ,destino)
				subi $s3 , $s3 , 1
				move $t0 , $s1
				move $s1 , $s2
				move $s2 , $t0
				jal TorreHanoi  # Llamada Recursiva
				#---Regresar los valores anteriores
				load_in_pila()
				#---Mostrar Movimiento Actual
				li $v0 , 4
				la $a0 , text2
				syscall			
				li $v0 , 1
				move $a0 , $s3 
				syscall
				li $v0 , 4
				la $a0 , text4
				syscall			
				print_reg_char($s0)
				li $v0 , 4
				la $a0 , text3
				syscall			
				print_reg_char($s1)
				print_char('\n')
				#---Segunda Parte recursiva
				save_in_pila() 
				subi $s3 , $s3 , 1
				move $t0 , $s0
				move $s0 , $s2
				move $s2 , $t0
				jal TorreHanoi  # Llamada Recursiva
				load_in_pila()
				jr $ra
	end_TorreHanoi:
