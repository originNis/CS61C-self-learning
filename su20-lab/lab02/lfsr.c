#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "lfsr.h"

void lfsr_calculate(uint16_t *reg) {
    unsigned bit0 = *reg & 1;
    unsigned bit2 = (*reg >> 2) & 1;
    unsigned bit3 = (*reg >> 3) & 1;
    unsigned bit5 = (*reg >> 5) & 1;
    unsigned msb = bit0 ^ bit2 ^ bit3 ^ bit5;
    *reg >>= 1;
    *reg = *reg | (msb << 15);
}

