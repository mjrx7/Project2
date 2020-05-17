#Project 2 Matthew Johnson

#####################################	
#		C Code to Shift Hex			#
#  (Template for Assembly Language) #
#		Author: Matthew Johnson		#
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

.text 0x00400000 		#Tells the assembler where to put your code

MAIN:
	jal INIT			# Reset/Initialize variables
	
	addi $s1,$s1,0x400	# Move source address reg to 0x10000400
	addi $s2,$s2,0x500	# Move destin address reg to 0x10000500
	jal LOOP			# Reorder LOOP
	
	addi $s1,$s1,0x424	# Move source address reg to 0x10000424
	addi $s2,$s2,0x504	# Move destin address reg to 0x10000504
	ori $s0, $0, 0		# Reset results register
	jal LOOP			# Reorder LOOP
	
	addi $s1,$s1,0x438	# Move source address reg to 0x10000438
	addi $s2,$s2,0x508	# Move destin address reg to 0x10000508
	ori $s0, $0, 0		# Reset results register
	jal LOOP			# Reorder LOOP
	
	j SPIN				# Jump to SPIN trap

INIT:
	ori $t0, $0, 4		# Loop amount
	lui $s1, 0x1000		# Load base memory address into register
	lui $s2, 0x1000		# Load base memory address into register
	xor $t1, $t1, $t1	# Clear $t1 register
	xor $t2, $t2, $t2	# Clear $t2 register
	lui $t1, 0xf000		# Reset $t1 to 0xf000
	addi $t2, $t2, 0xf	# Reset $t1 to 0xf
	xor $t5, $t5, $t5	# Clear $t5 shift amount register
	addi $t5, $t5, 28	# shift amount register
	xor $t3, $t3, $t3	# shift amount of 0xf to be & with n as mask
	xor $t4, $t4, $t4	# i index
	jr $ra				# Return to jumped from routine
	
LOOP:
	lw $a0, 0($s1)		# Load data from memory pointer
	beq $t4, $t0, INIT	# If i < 4 loop, else jump to done
	
	# RESULTS($t7) = RESULTS($t7) | (( $a0 & ($t2 << $t3)) << $t5)
	sll $t6, $t2, $t3	# Shift left the mask
	and $t7, $a0, $t6	# And shift left mask with number
	sll $t7, $t7, $t5	# Shift left masked number
	or $s0, $s0, $t7	# Or results with prior results
	
	# RESULTS($t7) = RESULTS($t7) | (( $a0 & ($t1 >> $t3)) >> $t5)
	srl $t6, $t1, $t3	# Shift right the mask 
	and $t7, $a0, $t6	# And shift right mask with number
	srl $t7, $t7, $t5	# Shift right masked number
	or $s0, $s0, $t7	# Or results with prior results
	
	addi $t5, $t5, -8	# Decrease shift amount register by 8
	addi $t3, $t3, 4	# Increase mask shift by 4
	addi $t4, $t4, 1	# Increment i by 1
	
	sw $s0, 0($s2)		# Store data at memory pointer
	
	j LOOP				# Loop back to start of LOOP

SPIN:	
	j SPIN				# Infinite loop