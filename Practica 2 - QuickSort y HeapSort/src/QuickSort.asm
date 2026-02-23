.data 
    vector: .word 45, -10, 8, 100, 45, 0, 23, 1, 67, 12, 5, 99, -5, 30, 14

.macro LoadVector(%pos, %vector, %direction, %value)
	mul %direction, %pos, 4
	addu %direction, %direction, %vector
	lw %value, 0(%direction)
.end_macro


.macro Swap(%v1, %v2, %ptr1, %ptr2)
	sw %v1, 0(%ptr2)
	sw %v2, 0(%ptr1)
.end_macro

.macro SavePila(%arg)
	subi $sp, $sp, 4
	sw %arg, 0($sp)
.end_macro

.macro LoadPila(%arg)
	lw %arg, 0($sp)
	addi $sp, $sp, 4
.end_macro

.text
	main:
    		la $a1, vector 
    		li $a2, 0       # Inicio
    		li $a3, 11     # Fin
    		jal Show
    		jal QuickSort
    		jal Show
    	return:
    		li $v0, 10
    		syscall



	QuickSort:
            # Caso base: si inicio >= fin  entonces salir 
        	if_caso_base:
            	bge $a2, $a3, else_back

            	# Partición
            	move $t2, $a2        # i = inicio
            	move $t3, $a2        # j = inicio
        
            	LoadVector($a3, $a1, $t0, $t1) # t1 = Pivote (v[end])

        	while:
            		bge $t3, $a3, end_while
            		LoadVector($t3, $a1, $t4, $t5) # t5 = v[j]
            
			if: # Si v[j] <= pivote
                		bgt $t5, $t1, end_if      
                		LoadVector($t2, $a1, $t6, $t7) # t7 = v[i]
                		Swap($t5, $t7, $t4, $t6)
                		addi $t2, $t2, 1           # i++
            		end_if:
            
            		addi $t3, $t3, 1               # j++
            		j while
        	end_while:
            	# Colocar pivote en su posición final (i)
            	LoadVector($t2, $a1, $t6, $t7)
            	LoadVector($a3, $a1, $t4, $t5)
            	Swap($t5, $t7, $t4, $t6)

            	# Guardar en pila para recursión
            	SavePila($ra)
            	SavePila($a2)
            	SavePila($a3)
            	SavePila($t2)

            	# QuickSort(inicio, i - 1) - Izquierda
            	subi $a3, $t2, 1
            	jal QuickSort

            	# Restaurar y preparar para derecha
            	LoadPila($t2)
            	LoadPila($a3)
            	LoadPila($a2)
            
            	# QuickSort(i + 1, fin) - Derecha
            	addi $a2, $t2, 1
           	 jal QuickSort
            
           	 LoadPila($ra)

	else_back:
        	jr $ra

	end_QuickSort:
	
	
	Show: 
	# $a1: dirección base del vector
	# $a3: índice final (ej. 11)
    	li $t0, 0          # i = 0
    
    	for:
        	bgt $t0, $a3, end_for  # Si i > fin, salir
        
       	 	# Calcular dirección: base + (i * 4)
        	mul $t1, $t0, 4
        	addu $t1, $a1, $t1
        	lw $t2, 0($t1)     # Cargar valor en $t2
        
		# Imprimir el número
		li $v0, 1
		move $a0, $t2      # Mover el valor a $a0 para el syscall
		syscall 
        
        	# Imprimir espacio
        	li $v0, 11
        	li $a0, ' '
        	syscall 
        
        	addi $t0, $t0, 1    # i++
       		j for
        
    	end_for:
   	 	# Imprimir salto de línea al terminar el vector
    	li $v0, 11
	li $a0, '\n'
    	syscall     
   	 jr $ra
	  
