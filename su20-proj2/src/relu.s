.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 8.
# ==============================================================================
relu:
	# check if the length is positive
    bge x0, a1, invalid_length_error_8
    
	#Calling Convention
    addi sp, sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw ra, 8(sp)
    
    mv s0, a0
    mv s1, a1
    li t0, 0
    slli t1, s1, 2

loop_start:
    add t2, s0, t0
	lw a0, 0(t2)
    bge a0, x0, loop_continue
    sw x0, 0(t2)

loop_continue:
	addi t0, t0, 4
    bge t0, t1, loop_end
    j loop_start
    
loop_end:
	lw s0, 0(sp)
    lw s1, 4(sp)
    lw ra, 8(sp)
    addi sp, sp, 12
    
	ret
invalid_length_error_8:
	li a1, 8
	j exit2