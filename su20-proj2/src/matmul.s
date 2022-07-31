.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   The order of error codes (checked from top to bottom):
#   If the dimensions of m0 do not make sense, 
#   this function exits with exit code 2.
#   If the dimensions of m1 do not make sense, 
#   this function exits with exit code 3.
#   If the dimensions don't match, 
#   this function exits with exit code 4.
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# =======================================================
matmul:
    # Error checks
    bge x0, a1, invalid_m0_error_2
    bge x0, a2, invalid_m0_error_2
    bge x0, a4, invalid_m1_error_3
    bge x0, a5, invalid_m1_error_3
    bne a2, a4, dimensions_not_match_error_4

    # Prologue
    #Calling Convention
    addi sp, sp, -32
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw ra, 28(sp)

    # s2 denotes the length of vetctor in dot function.
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, a5
    mv s6, a6

    # t0 is outer loop variable
    li t0, 0

    # t6 is the index of matrix d
    li t6, 0

    # Prapare agrs and call dot function.
    mv a2, s2 # a2 denotes the length of vectors.
    addi a3, x0, 1 # a3 = 1 denotes the stride of v0.
    add a4, x0, s5 # a4 = columns of m1 denotes the stride of v1.

outer_loop_start:
    # a0 = s0 + 4 * t0 * length
    slli a0, t0, 2
    mul a0, s2, a0
    add a0, s0, a0

    # t3 is inner loop variable
    li t3, 0

inner_loop_start:
    # a1 = s3 + 4 * t3
    slli a1, t3, 2
    add a1, s3, a1
    
    # Call dot function.
    # Store the variables in case that dot func may change them.
    addi sp, sp, -24
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)
    sw a0, 20(sp)

    jal ra, dot

    # Store the dot product into a6 contiguously.
    add a6, s6, t6
    sw a0, 0(a6)

    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    lw a0, 20(sp)
    addi sp, sp, 24

    addi t3, t3, 1
    addi t6, t6, 4
    bge t3, s4, inner_loop_end
    j inner_loop_start

inner_loop_end:
    addi, t0, t0, 1
    bge t0, s1, outer_loop_end
    j outer_loop_start


outer_loop_end:
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw ra, 28(sp)
    addi sp, sp, 32
    
    ret

invalid_m0_error_2:
    li a1, 2
    j exit2

invalid_m1_error_3:
    li a1, 3
    j exit2

dimensions_not_match_error_4:
    li a1, 4
    j exit2