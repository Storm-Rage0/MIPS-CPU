#	$1,$2 a[i-1],b[i-1]
#	$3,$4,$5 i,3*i,4*i
#	$11,$12,$13,$14 a[i],b[i],c[i],d[i]
#	$15,$16,$17,$18 a[i+1],b[i+1],c[i+1],d[i+1]
#	$21,$22,$23,$24 base offset
#	$25,$26,$27,$28 acctually offset = base offset + 4 * i
#	$10 flag
#
# initial offset
	lui $21,0x1001
	lui $22,0x1001
	lui $23,0x1001
	lui $24,0x1001

	addi $10,$0,19
	#initial a[0],b[0],c[0],d[0]
	addi $11,$0,0
	addi $12,$0,1
	addi $13,$11,0
	addi $14,$12,0
	#initial i,3*i,offset
	addi $3,$0,0
	addi $4,$0,0
	addi $5,$0,0
	# initial base offset
	addi $21,$21,0
	addi $22,$22,256
	addi $23,$23,512
	addi $24,$24,768
	# set x[0] to dmem
	sw $11,($21)
	sw $12,($22)
	sw $13,($23)
	sw $14,($24)

between_1_to_19:
	addi $3,$3,1
	addi $4,$4,3
	addi $21,$21,4
	addi $22,$22,4
	addi $23,$23,4
	addi $24,$24,4
	
	add $11,$11,$3
	add $12,$12,$4	
	add $13,$11,$0
	add $14,$12,$0
	
	sw $11,($21)
	sw $12,($22)
	sw $13,($23)
	sw $14,($24)
	
	bne $3,$10,between_1_to_19
	
	addi $10,$10,20
between_20_to_39:
	addi $3,$3,1
	addi $4,$4,3
	addi $21,$21,4
	addi $22,$22,4
	addi $23,$23,4
	addi $24,$24,4
	
	add $11,$11,$3
	add $12,$12,$4
	sw $11,($21)
	add $13,$11,$12
	sw $12,($22)	
	
	mul $14,$11,$13
	sw $13,($23)
	sw $14,($24)
	
	bne $3,$10,between_20_to_39
	
	addi $10,$10,20
between_40_to_59:
	addi $3,$3,1
	addi $4,$4,3
	addi $21,$21,4
	addi $22,$22,4
	addi $23,$23,4
	addi $24,$24,4
	
	add $11,$11,$3
	add $12,$12,$4
	sw $11,($21)
	mul $13,$11,$12
	sw $12,($22)
	
	mul $14,$13,$12
	sw $13,($23)
	sw $14,($24)
	
	bne $3,$10,between_40_to_59
	
loop:
	addi $31,$31,0xffffffff
	j loop
	
	
	
