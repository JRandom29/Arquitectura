.data
	vector : .word 1,2,3,4,5
.text

	
	main:
		la $s0, vector  	#  Vector
		li $s1 , 0 		#  Inicio del vector
		li $s2 , 4	 		#  Tamaño del vector
		li $s3 , 1			#  Numero a buscar
		jal Busqueda_Binaria  # s0 s1 s2 s3 : regresa s4
		 #Mostrar Resultado
		 li $v0 , 1
		 move $a0 , $s4
		 syscall
		
	return_0:
		li $v0, 10
		syscall
	
	Busqueda_Binaria: 	 # 	( s0 : vector , s1  : ini ,   s2 :last ,  s3 : find ) :   int ( s4)
			bgt $s1 ,$s2, no_encontrado   # si ini >= last , no existe el numero y sale del bucle
			#------------------Mostrar Divisiones
			li $v0 , 1
			move $a0 , $s1
			syscall
			
			li $v0 , 11
			li $a0 , '-'
			syscall
			
			li $v0 , 1
			move $a0 , $s2
			syscall
					
			li $v0 , 11
			li $a0 , '\n'
			syscall
	
			# -------promedio = (ini + last) div 2---------------
			add $t2 ,$s1, $s2
			div $t2 , $t2 , 2
			mflo $t2 		#punto medio
			#-------Obtener numero--------------------------------
			mul $t3 , $t2 , 4
			addu $t3 , $s0 , $t3
			lw $t3, 0($t3)
			
			#----Comprobar si es el numero fue encontrado-------
			beq  $t3 , $s3, encontrado		# si es igual sale del bucle (break) 
			ble $s3 , $t3 , redefine_last
				
				redefine_ini:
				add $t2, $t2 , 1
				move $s1 , $t2
				j Busqueda_Binaria
				
				redefine_last:
				sub $t2, $t2 , 1
				move $s2 , $t2
				 j Busqueda_Binaria
					 
		encontrado:
			move $s4 , $t2 
			jr $ra
		no_encontrado:
			li $s4 , -1
			jr $ra
			
	end_Busqueda_Binaria:
		