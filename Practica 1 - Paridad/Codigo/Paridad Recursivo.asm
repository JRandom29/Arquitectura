
.data
	text1: .asciiz "Ingrese numero :  "
	text2: .asciiz "Su numero es Par "
	text3: .asciiz "Su numero es Impar"
	text4: .asciiz "ERROR EL NUMERO DEBE SER POSITIVO"
	
.macro save_in_pila(%arg)
	subi $sp , $sp , 4
	sw %arg, 0( $sp)
.end_macro


.macro Load_in_pila(%arg)
	lw %arg, 0( $sp)
	addi $sp , $sp , 4
.end_macro


.macro Show_Text(%arg)
		li $v0 , 4 
		la $a0 , %arg
		syscall	
.end_macro


.text

	main :
		#    Ingresar numero
		Show_Text(text1)
		#    Leer el numero
		li $v0 , 5
		syscall
		#Comprobar que sea positivo
		
		if_positivo:
			blt $v0 , 0 ,else_negativo
			move $a0 , $v0
			jal Paridad
			#Mostrar
			if_result:
				bne $v0 , 0 , else_result
			
				Show_Text(text2)
				j return
			
			else_result:
				Show_Text(text3)
				j return
				
		else_negativo:
			Show_Text(text4)
				
	return:
		li $v0 , 10 
		syscall
	
	Paridad: # $a0 : n ; $v0 return
		if:
			bne $a0 , 0 , else
			li $v0 , 0 
			jr $ra
		else:
			#Se guarda en pila
			save_in_pila($ra) 					
			subi $a0 , $a0 , 1 # (n-1)
			jal Paridad
			addi $a0 , $a0 , 1 #Regresar a su valor anterior
			xori $v0, $v0, 1
			Load_in_pila($ra)
			jr $ra
	end_Paridad: