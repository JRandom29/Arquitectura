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
	 	jal Show
	 	jal burbuja_mejorada
	 	#
		li $v0 , 1
		li $a0 , 2
		syscall
		li $v0  , 11 
		li $a0 , ':'
		syscall
		#
	 	jal Show
	 	
	  return_0:
	    	li $v0 , 10
	    	syscall 
	
	burbuja_mejorada: #(s0::vector , s1::n)  : se guardaria en vector
		sub $t1 , $s1 , 1 # ultima =  n - 1
		while_burbuja:	
			blez $t1 , end_while_burbuja
			
			li $t0 , 0 # iterador J
			li $t2 , 0 # Last
			
			for_burbuja:
				bge $t0 , $t1 , end_for_burbuja # for ( j=0 ; j<ultima ; j++)
				#obtener valores v[j] 
				mul $t3 , $t0 , 4
				addu $t3 , $s0 , $t3
				lw $t4 , 0($t3)
				
				#obtener valores v[j+1] 
				lw $t5 , 4($t3)
					if_swap:
						ble $t4 , $t5 , end_if_swap
						#Intercambiar los valores
						sw $t5  , 0($t3)
						sw $t4 , 4($t3)
						move $t2 , $t0
					end_if_swap:
				add $t0  ,$t0 , 1 #   J++
				j for_burbuja		
			end_for_burbuja:
			move $t1 , $t2
			j while_burbuja
		end_while_burbuja:
			jr $ra
	end_burbuja_mejorada:
	


	Show:
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
		
		
	end_Show:
	
