#Project 2 Matthew Johnson

#####################################	
#		C Code to shift hex			#
#####################################
#
#	unsigned int RESULTS = 0;
#	int numShift = 28;
#	int maskShift = 0;
#	for (int i = 0; i < 4; i++) {
#		RESULTS = RESULTS | ((n & (0x0000000f << maskShift)) << numShift) | ((n & (0xf0000000 >> maskShift)) >> numShift);
#		maskShift = maskShift + 4;
#		numShift = numShift - 8;
#	}
#
#####################################
	
.data 0x10000400
.word 0x12345678

.data 0x10000424
.word 0xFEDC0123

.data 0x10000438
.word 0xF4C210B5

.text 0x00400000 #This assembler directive tells the assembler to put your code at the beginning of the user text segment

main:
	lui $t0, 0x1000		# Load memory address into register
	addi $t1, $t1, 4	# Loop amount
	
	lw $a0, 0x400($t0)	# Load data from memory pointer
	jal CLEARVAR		# Reset variables
	jal LSB				# Reorder LSB
	jal CLEARVAR		# Reset variables
	jal MSB				# Reorder MSB
	sw $s0, 0x500($t0)	# Store data at memory pointer
	
	xor $s0, $s0, $s0	# Reset results register
	lw $a0, 0x424($t0)	# Load data from memory pointer
	jal CLEARVAR		# Reset variables
	jal LSB				# Reorder LSB
	jal CLEARVAR		# Reset variables
	jal MSB				# Reorder MSB
	sw $s0, 0x504($t0)	# Store data at memory pointer
	
	xor $s0, $s0, $s0	# Reset results register
	lw $a0, 0x438($t0)	# Load data from memory pointer
	jal CLEARVAR		# Reset variables
	jal LSB				# Reorder LSB
	jal CLEARVAR		# Reset variables
	jal MSB				# Reorder MSB
	sw $s0, 0x508($t0)	# Store data at memory pointer
	
	j spin				# Jump to spin trap

CLEARVAR:
	xor $t2, $t2, $t2	# Clear $t2 register
	xor $t3, $t3, $t3	# Clear $t3 register
	lui $t2, 0xf000		# Reset $t2 to 0xf000
	addi $t3, $t3, 0xf	# Reset $t2 to 0xf
	xor $t6, $t6, $t6	# Clear $t6 shift amount register
	addi $t6, $t6, 28	# shift amount register
	xor $t4, $t4, $t4	# shift amount of 0xf to be & with n as mask
	xor $t5, $t5, $t5	# i index
	jr $ra				# Return to jumped from routine
	
LSB:
	beq $t5, $t1, done	# If i < 4 loop, else jump to done
	sll $t7, $t3, $t4	# Shift left the mask
	and $t8, $a0, $t7	# And shift left mask with number
	sll $t8, $t8, $t6	# Shift left masked number
	or $s0, $s0, $t8	# Or results with prior results
	
	addi $t6, $t6, -8	# Decrease shift amount register by 8
	addi $t4, $t4, 4	# Increase mask shift by 4
	addi $t5, $t5, 1	# Increment i by 1
	
	j LSB				# Loop back to start of LSB

MSB:
	beq $t5, $t1, done	# If i < 4 loop, else jump to done
	srl $t7, $t2, $t4	# Shift right the mask 
	and $t8, $a0, $t7	# And shift right mask with number
	srl $t8, $t8, $t6	# Shift left masked number
	or $s0, $s0, $t8	# Or results with prior results
	
	addi $t6, $t6, -8	# Decrease shift amount register by 8
	addi $t4, $t4, 4	# Increase mask shift by 4
	addi $t5, $t5, 1	# Increment i by 1
	
	j MSB				# Loop back to start of MSB

done:
	jr $ra				# Return to function jump called from

spin:	
	j spin				#This instruction will "trap" the processor and give it something to execute after your instructions are finished