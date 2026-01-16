.data
	vector: .word 45, -2, 18, 0, 93, 7, 21, -15, 34, 12 , -100
	n : .word 11

.text
	main:
		#cargar vector y tamaño
		la $s0 , vector
		lw $s1 , n  
		#
		li $v0 , 1
		li $a0 , 1
		syscall
		li $v0  , 11 
		li $a0 , ':'
		syscall
		#
	 	jal show
	 	jal selection_sort
	 	#
		li $v0 , 1
		li $a0 , 2
		syscall
		li $v0  , 11 
		li $a0 , ':'
		syscall
		#
	 	jal show
	 	
	  return_0:
	    	li $v0 , 10
	    	syscall 
	
	selection_sort: #(s0::vector , s1::n)  : se guardaria en vector
	
		#  t0 = n-1
		# t1 :: i = 0
		# t2 :: j = i+1
		#t3 :: pos = i 
		# t4 :: j_direccion 
		#t5 :: v[ j ]
		#t6 :: pos_direccion
		#t7 :: v [ pos ]
		#------------Inicializar t0 y t1---------------------
		sub $t0 , $s1 , 1 
		li $t1 , 0
		for1_selection:	
			#-----------------Inicializar J y pos-----------------
			beq $t1,$t0 , end_for1_selection
			add $t2 , $t1 	, 1	 # J = i + 1
			move $t3 , $t1	 # pos = i
			for2_selection:
				beq $t2 , $s1 , end_for2_selection  # for ( j = i+1  ; j< n  ; j++)
				#---------------obtener valores  de v[ j ] ----------------------
				mul $t4 , $t2 , 4 
				addu $t4 , $s0 , $t4 
				lw $t5 , 0($t4) 	#   t5 = v[ j ]  
				
				#--------------obtener valores de v[ pos ] -------------------
				mul $t6 , $t3 , 4 
				addu $t6 , $s0 , $t6 
				lw $t7 , 0($t6)        #  t7 = v[pos]
				if_change_pos:
					ble $t7 , $t5 , end_change_pos
					move $t3 , $t2
				end_change_pos:
				add $t2  ,$t2 , 1 #   J++
				j for2_selection
			end_for2_selection:		
				swap: #Intercambiar los valores
					mul $t4 , $t1 , 4 
					addu $t4 , $s0 , $t4 	
					lw $t5 , 0($t4) 	#   t5 = v[i ]

					mul $t6 , $t3 , 4 
					addu $t6 , $s0 , $t6 
					lw $t7 , 0($t6)        #  t7 = v[pos]		
					
					sw $t7  , 0($t4)
					sw $t5 , 0($t6)
				end_swap:
			add $t1  ,$t1 , 1 #   I++
			j for1_selection
		end_for1_selection:
			jr $ra
	end_selection_sort:
	


	show:
		li $t6 ,0 
		for_show:
			beq $t6 , $s1 , end_for_show
			mul $t0 , $t6 , 4
			addu $t0 , $s0 , $t0
			lw $t0 , 0($t0)
			
			li $v0 , 1
			move $a0 , $t0
			syscall			
			li $v0 , 11
			li $a0 , ','
			syscall
			
			add $t6 ,$t6 , 1
			j for_show
		end_for_show:
		li $v0 , 11
		li $a0 , '\n'
		syscall
		li $a0 , '\n'
		syscall
		jr $ra
		
		
	end_show:
	
