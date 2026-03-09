# Direcciones de memoria
.eqv LuzControl 0xffff0010
.eqv LuzEstado  0xffff0014
.eqv LuzDatos   0xffff0004


.macro ShowText(%text)
	li $v0 , 4
	la $a0 , %text
	syscall
.end_macro


.data 
	MsgEsperarSensor:  .asciiz "El sensor no esta listo\n"

	MsgErrorHardware:  .asciiz "El sensor tienen un error de hardware\n "

	MsgLectura:  .asciiz "\nLectura obtenida :  "
	
	MsgSensorActivo:  .asciiz "El sensor esta activo \n"

.text
	
	main:
		la $a1, LuzControl
		la $a2, LuzEstado  
		la $a3, LuzDatos
		jal InicializarSensorLuz
		
		LoopPrincipal:
		jal LeerLuminosidad
		
		li $t0 , -1
		move $t1 , $v0 # Valor de estado
		move $t2 , $v1 # Valor de luz
		beq $t0 , $t1, ErrorHardware            
		
		#Mostrar luminosidad
		ShowText(MsgLectura)	
		move $a0, $t2
		li $v0, 1
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

	#Entrada  a1 : LuzControl ,  a2: LuzEstado  , a3:  LuzDatos
	InicializarSensorLuz:
            	move $t0, $a1
            	li $t1 , 1 # Se inicializa por defecto en 1  
            	sw $t1, 0($t0)        
            	move $t0, $a2
            		
            	ShowText(MsgEsperarSensor)	
    		EsperarSensor:
            		lw $t1, 0($t0)
            		beq $t1, -1 , ErrorHardware 
           		beq $t1, $zero, EsperarSensor

			ShowText(MsgSensorActivo)                        
			#Escribir el valor inicializado en 0
			li $t2, 0
    			sw $t2, 0($a3)
    		jr $ra
            	
	#Entrada  a2: LuzEstado  , a3:  LuzDatos
	# Salida : v0:  Codigo de Estado , v1: valor
	LeerLuminosidad:
    		lw $v1, 0($a3)
    		#Comparar que no se pase de 0-1023
		sge $t1 , $v1 , 0
		slti $t2 ,  $v1, 1024  
		and $t1 , $t1 , $t2
		
   	 	lw $v0, 0($a2)
   	 	seq $v0 , $v0 , 1
   	 	and $v0 , $v0 , $t1 
		subi $v0 , $v0 , 1 # se resta para saber si se obtuvo el dato correcto ( bit[0 o 1] - 1 )
    		jr $ra
    		
    	ErrorHardware:
		ShowText(MsgErrorHardware)
            	j return
