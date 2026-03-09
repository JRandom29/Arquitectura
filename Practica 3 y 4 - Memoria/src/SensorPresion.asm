# Direcciones de memoria
.eqv PresionControl 	0xFFFF0010
.eqv PresionEstado  	0xFFFF0014
.eqv PresionDatos   	0xFFFF0018

.macro ShowText(%text)
	li $v0 , 4
	la $a0 , %text
	syscall
.end_macro


.data 
	MsgEsperarSensor:  .asciiz "El sensor no esta listo\n"

	MsgErrorHardware:  .asciiz "El sensor tienen un error de hardware "

	MsgLectura:  .asciiz "Lectura obtenida :  "
	
	MsgSensorActivo:  .asciiz "El sensor esta activo \n"
	
	MsgForzandoReinicio:  .asciiz "El sensor tuvo una falla : Reiniciando \n"
	
	
.text 
	main:
		li $a1 , PresionControl
		li $a2 , PresionEstado
		li $a3 , PresionDatos
		jal InicializarSensorPresion
		
		LoopPrincipal:
            	# Mostrar Luminosidad 
            	
		jal LeerPresion
		
		li $t0 , -1
		move $t1 , $v0 # Codigo
		move $t2 , $v1 # valor  
		beq $t0 , $t1, ErrorHardware            
		
		#Mostrar valor
		ShowText(MsgLectura)	
		move $a0, $t2
		li $v0, 1
		syscall
            
		li $a0, '\n'          # Salto de linea
		li $v0, 11
		syscall

		# Pequeña pausa para no saturar la consola
		li $v0, 32
		li $a0, 200         # 200ms
		syscall
            
    		j LoopPrincipal

	return:
		li $v0 , 10
		syscall	
	

#-----------------------------------------------------------
# INSTRUCCIONES DEL EJERCICIO
#-----------------------------------------------------------

	#Entrada  a1 : PresionControl ,  a2: PresionEstado  , a3:  PresionDatos
	InicializarSensorPresion:
            	li $t0 , 5 # Se inicializa por defecto en 5
            	sw $t0, 0($a1)    
            	lw $t0, 0($a2)
		bne $t0, 0 ,EsperarSensor
            	ShowText(MsgEsperarSensor)
    		EsperarSensor:
            		lw $t0, 0($a2)
            		beq $t0, -1 , ErrorHardware 
           		beq $t0, $zero, EsperarSensor
			ShowText(MsgSensorActivo)                        
			#Escribir el valor inicializado en 0
			li $t0, 0
    			sw $t0, 0($a3)
    		jr $ra
            	
	#Entrada  a2: PresionEstado  , a3:  PresionDatos
	# Salida : v0:  Codigo Estado , v1: valor
	LeerPresion:
		subi $sp, $sp, 4
    		sw $ra, 0($sp)            # Guardar $ra por si a caso llamamos a Inicializar
    		li $t2, 0                 # $t2 será nuestro contador de reintentos
    		li $t3 ,0
    		IntentarLectura:
   	 		lw $t0, 0($a2)            # Leer estado
   			 if:
   			 	beq $t0 , 1 , endif
				beq $t3 , -1 , endif
				bgt $t3 , 0 ,else
				ShowText(MsgEsperarSensor)
				li $t3 , -1
				j endif
				 	
   			 else:
   			 	add $t3 , $t3 , 1
   			 endif:
   			 beq $t0, $zero, IntentarLectura      # Si es 0, seguir esperando
   			 
			# Verificar si hay error -1
    			li $t1, -1
    			beq $t0, $t1, ManejarError
    			
    			# La lectura es válida
    			lw $ra , 0 ($sp)
    			addi $sp, $sp, 4
    			lw $v1, 0($a3) # Leer valor de presion
    			li $v0, 0                 # Código de estado: OK
    			jr $ra
    			
    		ManejarError:
   	 		bne $t2, $zero, ErrorFinal # Si $t2 != 0, ya reintentamos una vez.
   			
   			  # Primer error: Reinicializar y reintentar
   			ShowText(MsgForzandoReinicio)		 
			# Pequeña pausa para reactivar el sensor
			
			li $v0, 30
			subi $sp , $sp , 4
			sw $a1 , 0($sp) 
			syscall
			move $t0,$a0
            		#bucle de espera
            		esperar5S:
            		li $v0, 30
            		syscall
            		sub $a0, $a0 , $t0
			blt $a0, 5000 ,esperar5S         #  5 Segundos de espera
 			lw $a1 , 0($sp)
 			addi $sp , $sp , 4
    			jal InicializarSensorPresion
    			li $t2, 1                 # Marcar que ya se hizo el reintento
    			j IntentarLectura
   	 	ErrorFinal:
   	 		lw $ra , 0 ($sp)
    			addi $sp, $sp , 4 
    			li $v0 , -1
    			jr $ra  
   	 	
    		
    	ErrorHardware:
		ShowText(MsgErrorHardware)
            	j return

