.eqv KEYBOARD_CTRL 0xFFFF0000
.eqv KEYBOARD_DATA 0xFFFF0004
.eqv DISPLAY_CTRL  0xFFFF0008
.eqv DISPLAY_DATA  0xFFFF000C

.data
    buffer:     .space 64          # Espacio para 64 caracteres
    buf_size:   .word 64
    msg_out:    .asciiz "\n--- Contenido del Buffer ---\n"
    new_line:    .asciiz "\n"
    msg_time1:  .asciiz "\nTiempo transcurrido: "

.text
main:
    	la $s0, buffer          # dirección base del buffer
    	li $s1, 0                # indice de escritura 
    	lw $s2, buf_size        # tamaño del buffer
    
main_loop:
    	# Obtener tiempo de inicio 
    	li $v0, 30
    	syscall
    	move $s3, $a0           # Guardar tiempo inicial en $s3

wait_20s:
    	#  Verificar tiempo actual
    	li $v0, 30
    	syscall
    	sub $t0, $a0, $s3       # diferencia
    	li $t1, 20000           # 20 segundos
    	bge $t0, $t1, show_buffer  # si pasaron 20s -> salir
	
	# calcular tiempo transcurrido
	li $t1, 1000
    	div $t0, $t1
    	mflo $t7
    
    	# mostrar segundos si cambio
    	beq $t7, $s4, check_keyboard
    	move $s4, $t7
    
    	li $v0, 4
    	la $a0, msg_time1
    	syscall
    
    	li $v0, 1
    	move $a0, $t7
    	syscall
check_keyboard:
    	# ver si hay entrada en el teclado
    	li $t2, KEYBOARD_CTRL
    	lw $t3, 0($t2)
    	andi $t3, $t3, 1        # si  1 -> tecla presionada
    	beq $t3, $zero, wait_20s

    	# leer caracter
    	li $t2, KEYBOARD_DATA
    	lw $t4, 0($t2)
    
    	# filtrar:  'A' (65) hasta 'Z' (90)
    	li $t5, 65              
    	blt $t4, $t5, wait_20s
    	li $t5, 90
    	bgt $t4, $t5, wait_20s

    	# almacenar en Buffer 
    	add $t6, $s0, $s1
    	sb $t4, 0($t6)
    
    	# actualizar indice
    	addi $s1, $s1, 1
    	rem $s1, $s1, $s2
    
    	j wait_20s            # volver al loop de espera

show_buffer:
    	# imprimir encabezado
    	li $v0, 4
    	la $a0, msg_out
    	syscall

    	li $t7, 0               # contador
print_loop:
    	add $t8, $s0, $t7
    	lb $a0, 0($t8)
    	beq $a0, $zero, skip_null # si está vacio no se imprime nada
    
    	li $v0, 11
    	syscall
    
    	# limpiar el buffer
    	sb $zero, 0($t8)

skip_null:
    	addi $t7, $t7, 1
    	blt $t7, $s2, print_loop

	#reset
    	li $s1, 0
    	li $v0, 4
    	la $a0, new_line
    	syscall
    
    	j main_loop         # Volver a empezar los 20 segundos