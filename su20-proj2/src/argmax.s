.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.
# =================================================================
argmax:
    # Prologue
    #Check the length of the vector.
    bge x0, a1, invalid_length_error_7

    #Calling Convention
    addi sp, sp, -16
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw ra, 12(sp)
    
    mv s0, a0
    mv s1, a1
    li t0, 0

    #Assume the index of the largest element is 0.
    li s2, 0

loop_start:
	#a0 is the current element
	slli t1, t0, 2
    add t1, s0, t1
    lw a0, 0(t1)
	#a1 is the largest element
    slli t2, s2, 2
	add t2, s0, t2
	lw a1, 0(t2)

	bge a1, a0, loop_continue
	#Store the current index to the memory.
    mv s2, t0

loop_continue:
	addi, t0, t0, 1
	bge t0, s1, loop_end
    j loop_start

loop_end:
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16

    ret
   	
invalid_length_error_7:
	li a1, 7
    j exit2