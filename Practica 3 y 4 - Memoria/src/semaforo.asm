.eqv KEYBOARD_CTRL 0xFFFF0000
.eqv KEYBOARD_DATA 0xFFFF0004
.eqv DISPLAY_CTRL  0xFFFF0008
.eqv DISPLAY_DATA  0xFFFF000C

.data
	semaforo_verde: .asciiz "Semaforo en verde, esperando pulsador\n"
	semaforo_amarillo: .asciiz "Semaforo en amarillo, en amarillo, en 10 segundos, semáforo en rojo\n"
	semaforo_rojo: .asciiz "Semaforo en rojo, en 30 segundos, semáforo en verde\n"
	iniciar_ciclo: .asciiz "Pulsador activado: en 20 segundos, el semaforo cambiara a amarillo\n"
	cerrando_programa: .asciiz "Saliendo.....\n"
.text
	la $a0, semaforo_verde	# Mostramos el primer mensaje
	jal mostrar_mensaje	# para indicar que el semaforo esta en verde

	main_loop:
	
	li $s0, KEYBOARD_CTRL	  # Revisamos si el teclado esta
	lw $s1, 0($s0)		  # activo, si lo esta pasamos a procesar la tecla
	beq $s1, $zero, main_loop # si no, seguimos esperando
	
	li $s2, KEYBOARD_DATA	# Si el teclado esta activo
	lw $s3, 0($s2)		# vemos el caracter ingresado
	
	beq $s3, 27, exit_loop	# Si es ESC, salimos del programa
	bne $s3, 115, main_loop	# Si es s, iniciamos el semaforo
				# Si no es ninguno, seguimos esperando
	
	iniciar_semaforo:
	la $a0, iniciar_ciclo	# Indicamos que en 20 segundos el semaforo
	jal mostrar_mensaje	# estara en amarillo
	
	li $a0, 20000		# Esperamos 20s
	li $v0, 32
	syscall
	
	la $a0, semaforo_amarillo	# Indicamos que en 10 segundos el semaforo
	jal mostrar_mensaje		# estara en rojo
	
	li $a0, 10000		# Esperamos 10s
	li $v0, 32
	syscall
	
	la $a0, semaforo_rojo	# Indicamos que en 30 segundos el semaforo
	jal mostrar_mensaje	# estara en verde
	
	li $a0, 30000		# Esperamos 30s
	li $v0, 32
	syscall
	
	la $a0, semaforo_verde	# Indicamos que el semaforo esta en verde
	jal mostrar_mensaje	# y que esperamos la siguiente tecla
	
	j main_loop		# Regresamos al loop, a esperar por otra tecla
	
	exit_loop:
	la $a0, cerrando_programa	# Indicamos el cierre del programa
	jal mostrar_mensaje
	li $v0, 10			# Salimos
	syscall
		
	mostrar_mensaje:
	addi $sp, $sp, -4
	sw $a0, 0($sp)		# Guardamos en la pila la direccion del mensaje
	
	for_char:
	lb $t0, 0($a0)		# Por cada caracter
	beq $t0, $zero, return	# Si es \0 (fin del string), salimos de la funcion
	 
	esperar_display:	
	li $t1, DISPLAY_CTRL		# Revisamos si el display esta disponible
	lw $t2, 0($t1)			# a traves del valor de DISPLAY_CTRL 
	beq $t2, $zero, esperar_display # si no esta, seguimos esperando
	
	li $t1, DISPLAY_DATA	# Si esta disponible le pasamos
	sb $t0, 0($t1)		# el caracter actual al display
	addi $a0, $a0, 1	# Pasamos al siguiente caracter
	j for_char		# Saltamos al for hasta que lleguemos al caracter \0
	
	return:
	lw $a0, 0($sp)		# Restauramos la direccion de $a0
	addi $sp, $sp, 4	# Desapilamos
	jr $ra			# Regresamos al invocador
