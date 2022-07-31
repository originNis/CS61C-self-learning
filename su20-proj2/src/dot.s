.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================
dot:
    # Prologue
    #Check lengths and strides.
    bge x0, a2, invalid_length_error_5
    bge x0, a3, invalid_length_error_6
    bge x0, a4, invalid_length_error_6

    #Calling Convention
    addi sp, sp, -16
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw ra, 12(sp)

    mv s0, a0
    mv s1, a1
    li s2, 0

    # t0/t1 denotes the index of the vector.
    li t0, 0
    li t1, 0
    
    # t2 denotes the current length.
    li t2, 0

loop_start:
    #t3/t4 is the address.
    slli t3, t0, 2
    add t3, s0, t3
    slli t4, t1, 2
    add t4, s1, t4

    lw a0, 0(t3)
    lw a1, 0(t4)

    mul t3, a0, a1
    add s2, s2, t3

    add t0, t0, a3
    add t1, t1, a4
    addi t2, t2, 1
    bge t2, a2, loop_end
    j loop_start

loop_end:
    # Epilogue
    mv a0, s2

    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16
    
    ret

invalid_length_error_5:
    li a1, 5
    j exit2

invalid_length_error_6:
    li a1, 6
    j exit2