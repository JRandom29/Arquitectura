.eqv TensionControl	0xffff0010
.eqv TensionEstado 	0xffff0014
.eqv TensionSistol     0xffff0018
.eqv TensionDiastol  	0xffff001c

.data 
	MsgTomandoMedicion:  .asciiz "Analizando los dato Espere ... \n"

	MsgDiastolica:  .asciiz "\n\nSu tension diastólica :  "
	
	MsgSistolica:  .asciiz "\n\nSu tension Sistolica :  "

.macro ShowText(%text)
	li $v0 , 4
	la $a0 , %text
	syscall
.end_macro

.text


	main:
		la $a0 , TensionSistol
		la $a1, TensionDiastol 
		la $a2, TensionControl  
		la $a3, TensionEstado
		
		jal controlador_tension
		
		move $t0 , $v0
		move $t1 , $v1
		ShowText(MsgDiastolica)
		li $v0 , 1
		move $a0 , $t0
		syscall
		ShowText(MsgSistolica)
		li $v0 , 1
		move $a0 , $t1
		syscall
		
		
	return:
		li $v0 , 10
		syscall

#-----------------------------------------------------------
# INSTRUCCIONES DEL EJERCICIO
#-----------------------------------------------------------

	#Entrada a0 : TensionSistolDireccion, a1: TensionDiastolDireccion,  a2: TensionControl  , a3:  TensionEstado
	# Salida : V0:  TensionSistol , V1: TensionDiastol
	controlador_tension:
    		# Iniciar la medición
    		li $t0, 1                      
    		sw $t0, 0($a2)
    		li $t0, 0                      
    		sw $t0, 0($a3)

		esperar_resultados:
    			lw $t0, 0($a3)
    			beq $t0, $zero, esperar_resultados   # Si es 0, el dispositivo sigue midiendo; repetir bucle

		#  Leer los resultados de la medición
		lw $v0, 0($a0)                  # Mover valor sistólico a $v0
    		lw $v1, 0($a1)                  # Mover valor diastólico a $v1

    		jr $ra