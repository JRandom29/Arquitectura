.data
	arr: .word 8 1 6 4 7 3 5 2 9   # Arreglo inicial a ordenar

.text
	main:
	la $a0, arr          # $a0 = dirección base del arreglo
	li $a1, 9            # $a1 = tamaño del arreglo
	
	jal heapsort         # Llama a heapsort(arr, 9)
	jal prnt             # Imprime el arreglo ordenado
	
	li $v0, 10           # Código para terminar el programa
	syscall
	
	
	
	########################
	# heapsort(arr, n)
	# $a0 = dirección del arreglo
	# $a1 = tamaño del arreglo
	########################
	heapsort:
	addi $sp, $sp, -8    # Reserva espacio en la pila
	sw $ra, 4($sp)       # Guarda la dirección de retorno
	sw $a1, 0($sp)       # Guarda n
	
	# Construcción del heap (heap máximo)
	div $t0, $a1, 2      # t0 = n / 2
	subi $t0, $t0, 1     # t0 = (n/2) - 1 → último nodo padre
	
	for1:
	move $a2, $t0        # $a2 = índice actual
	jal heapify          # heapify(arr, n, i)
	subi $t0, $t0, 1     # i--
	bgez $t0, for1       # Mientras i >= 0
	
	# Extracción de elementos del heap
	subi $t0, $a1, 1     # t0 = n - 1
	li $a2, 0            # $a2 = índice raíz
	
	for2:
	sll $t1, $t0, 2      # t1 = i * 4 (offset en bytes)
	add $t1, $t1, $a0    # Dirección de arr[i]
	lw $t2, 0($t1)       # t2 = arr[i]
	lw $t3, 0($a0)       # t3 = arr[0]
	sw $t3, 0($t1)       # arr[i] = arr[0]
	sw $t2, 0($a0)       # arr[0] = arr[i]
	move $a1, $t0        # Nuevo tamaño del heap = i
	jal heapify          # Restaurar heap desde la raíz
	subi $t0, $t0, 1     # i--
	bgtz $t0, for2       # Mientras i > 0
	
	# Restaurar registros
	lw $a1, 0($sp)       # Recupera n original
	lw $ra, 4($sp)       # Recupera dirección de retorno
	addi $sp, $sp, 8     # Libera pila
	jr $ra               # Retorna
	
	
	
	########################
	# heapify(arr, n, i)
	# $a0 = dirección del arreglo
	# $a1 = tamaño del heap
	# $a2 = índice del nodo a hundir
	########################
	heapify:
	addi $sp, $sp, -24   # Reserva espacio en pila
	sw $ra, 20($sp)      # Guarda $ra
	sw $a2, 16($sp)      # Guarda i
	sw $t0, 12($sp)
	sw $t1, 8($sp)
	sw $t2, 4($sp)
	sw $t3, 0($sp)
	
	move $t0, $a2        # t0 = índice del mayor (inicialmente i)
	
	mul $t1, $a2, 2      # t1 = 2*i
	addi $t2, $t1, 2     # t2 = 2*i + 2 → hijo derecho
	addi $t1, $t1, 1     # t1 = 2*i + 1 → hijo izquierdo
	
	# Si hijo izquierdo >= n, no hay hijos → fin
	bge $t1, $a1, endif1
	
	# Cargar arr[hijo izquierdo]
	sll $t3, $t1, 2
	add $t3, $t3, $a0
	lw $t3, 0($t3)
	
	# Cargar arr[mayor]
	sll $t4, $t0, 2
	add $t4, $t4, $a0
	lw $t4, 0($t4)
	
	# Si arr[hijo izq] <= arr[mayor], no cambiar
	ble $t3, $t4, endif1
	
	if1:
	move $t0, $t1        # mayor = hijo izquierdo
	
	endif1:
	# Si hijo derecho >= n, saltar
	bge $t2, $a1, endif2
	
	# Cargar arr[hijo derecho]
	sll $t3, $t2, 2
	add $t3, $t3, $a0
	lw $t3, 0($t3)
	
	# Cargar arr[mayor]
	sll $t4, $t0, 2
	add $t4, $t4, $a0
	lw $t4, 0($t4)
	
	# Si arr[hijo der] <= arr[mayor], no cambiar
	ble $t3, $t4, endif2
	
	if2:
	move $t0, $t2        # mayor = hijo derecho
	
	endif2:
	# Si mayor sigue siendo i, el heap ya está bien
	beq $t0, $a2, end
	
	recur:
	# Intercambiar arr[i] y arr[mayor]
	sll $t3, $a2, 2
	add $t3, $t3, $a0
	lw $t4, 0($t3)
	
	sll $t5, $t0, 2
	add $t5, $t5, $a0
	lw $t6, 0($t5)
	
	sw $t4, 0($t5)
	sw $t6, 0($t3)
	
	move $a2, $t0        # Nuevo índice i = mayor
	jal heapify          # Llamada recursiva
	
	end:
	# Restaurar registros
	lw $t3, 0($sp)
	lw $t2, 4($sp)
	lw $t1, 8($sp)
	lw $t0, 12($sp)
	lw $a2, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp, 24
	jr $ra               # Retorna
		
		
		
	########################
	# prnt(arr, n)
	# Imprime el arreglo
	########################
	prnt:
	addi $sp, $sp, -4    # Reserva espacio en pila
	sw $a0, 0($sp)       # Guarda dirección del arreglo
	
	li $t0, 0            # i = 0
	while:
	sll $t1, $t0, 2      # t1 = i * 4
	add $t2, $t1, $a0    # Dirección de arr[i]
	
	lw $a0, 0($t2)       # Cargar arr[i]
	li $v0, 1            # Syscall imprimir entero
	syscall
	
	lw $a0, 0($sp)       # Restaurar dirección base
	addi $t0, $t0, 1     # i++
	blt $t0, $a1, while  # Mientras i < n
	
	addi $sp, $sp, 4     # Liberar pila
	jr $ra               # Retorna