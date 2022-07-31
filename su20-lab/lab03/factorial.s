.globl factorial

.data
n: .word 8

.text
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

factorial:
    #Store the data may be used by caller.
    addi sp, sp, -8
    sw t1, 0(sp)
    sw t2, 4(sp)

    add t1, x0, a0
    addi t2, x0, 1
    addi a0, x0, 1
    loop:
        beq t1, x0, end
        mul a0, a0, t2
        addi t2, t2, 1
        addi t1, t1, -1
        jal x0, loop
        end:
            #Give back the data and return. 
            lw t1, 0(sp)
            lw t2, 4(sp)
            addi sp, sp, 8
        	jr ra
