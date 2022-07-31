.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # 
    # If there are an incorrect number of command line args,
    # this function returns with exit code 49.
    #
    # Usage:
    #   main.s -m -1 <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    # Calling Convention
    addi sp, sp, -52
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw s9, 36(sp)
    lw s10, 40(sp)
    lw s11, 44(sp)
    lw ra, 48(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2
    li t0, 4
    bne s0, t0, incorrect_argc_error_49

	# =====================================
    # LOAD MATRICES
    # =====================================

    # Load pretrained m0
    # Allocate an 8-byte memory, s4 denotes the pointer to rows/columns of m0 while s3 denotes the pointer to m0.
    li a0, 8
    jal ra, malloc
    mv s4, a0

    lw a0, 0(s1)
    mv a1, s4
    addi a2, s4, 4
    jal ra, read_matrix
    mv s3, a0

    # Load pretrained m1
    li a0, 8
    jal ra, malloc
    mv s6, a0

    lw a0, 4(s1)
    mv a1, s6
    addi a2, s6, 4
    jal ra, read_matrix
    mv s5, a0

    # Load input matrix
    li a0, 8
    jal ra, malloc
    mv s8, a0

    lw a0, 8(s1)
    mv a1, s8
    addi a2, s8, 4
    jal ra, read_matrix
    mv s7, a0

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    # Allocate memory for matrix to a6.
    lw t0, 0(s4)
    lw t1, 4(s8)
    mul a0, t0, t1
    jal ra, malloc
    mv a6, a0

    mv a0, s3
    lw a1, 0(s4)
    lw a2, 4(s4)
    mv a3, s7
    lw a4, 0(s8)
    lw a5, 4(s8)

    # Store m0 in t0 to free it later.
    mv t0, s3

    # Move rows/columns of matrix d to s4 in advance.
    sw a1, 0(s4)
    sw a5, 4(s4)

    # Result address should be in a6.
    jal ra, matmul

    # Free the memory of m0.
    mv a0, s3
    jal ra, free

    # Set matrix address into s3.
    mv s3, a6

    lw t0, 0(s4)
    lw t1, 4(s4)
    mul a1, t0, t1
    mv a0, s3

    jal ra, relu

    # Allocate the memory for matrix to a6.
    lw t0, 0(s6)
    lw t1, 4(s4)
    mul a0, t0, t1
    jal ra, malloc # REMEMBER TO FREE HERE!
    mv a6, a0

    mv a0, s5
    lw a1, 0(s6)
    lw a2, 4(s6)
    mv a3, s3
    lw a4, 0(s4)
    lw a5, 4(s4)

    jal ra, matmul

    mv s9, a6
    lw s10, 0(s6)
    lw s11, 4(s4)

    # Free the s3 ~ s8.
    mv a0, s3
    jal ra, free
    mv a0, s4
    jal ra, free
    mv a0, s5
    jal ra, free
    mv a0, s6
    jal ra, free
    mv a0, s7
    jal ra, free
    mv a0, s8
    jal ra, free

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix

    lw a0, 12(s1)
    mv a1, s9
    mv a2, s10
    mv a3, s11
    jal ra, write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax

    mv a0, s9
    mul a1, s10, s11
    jal ra, argmax

    # Print classification
    bne s2, x0, end
    mv a1, a0
    jal ra, print_int

    # Print newline afterwards for clarity
    li a1 '\n'
    jal ra print_char

end:
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw s9, 36(sp)
    sw s10, 40(sp)
    sw s11, 44(sp)
    sw ra, 48(sp)
    addi sp, sp, 52

    ret

incorrect_argc_error_49:
    li a1, 49
    j exit2