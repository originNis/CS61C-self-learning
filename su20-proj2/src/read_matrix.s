.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
#
# If you receive an fopen error or eof, 
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.
# ==============================================================================
read_matrix:
    # Prologue
    # Calling Convention
    addi sp, sp, -24
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw ra, 20(sp)

	mv s0, a0
    mv s1, a1
    mv s2, a2

    # Open the file.
    mv a1, s0
    li a2, 0
    jal ra, fopen
    # Check return code.
    blt a0, x0, fopen_error_50
    mv s0, a0

    # Allocate 8 bytes to read rows and columns and put the address into s5.
    li a0, 8
    jal ra, malloc
    mv s5, a0

    # Read rows and columns.
    mv a1, s0
    mv a2, s5
    li a3, 8
    jal ra, fread
    # Check return code.
    li t0, 8
    bne a0, t0, fread_error_51

    # Store the actual numbers read before.
    lw s3, 0(s5)
    lw s4, 4(s5)
    mul s6, s3, s4
    slli s6, s6, 2

    #Allocate for subsequent matrix.
    mv a0, s6
    jal ra, malloc
    mv s5, a0

    #Read matrix.
    mv a1, s0
    mv a2, s5
    mv a3, s6
    jal ra, fread
    #Check return code.
    bne a0, s6, fread_error_51

    # Epilogue
    # Close the file.
    jal ra, fclose
    # Check return code.
    blt a0, x0, fclose_error_52

    # Save the rows and columns into the given pointer.
    sw s3, 0(s1)
    sw s4, 0(s2)

    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw ra, 20(sp)
    addi sp, sp, 24

    mv a0, s5

    ret

fopen_error_50:
    li a1, 50
    j exit2

fread_error_51:
    li a1, 51
    j exit2

fclose_error_52:
    li a1, 52
    j exit2