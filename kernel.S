// a - b >= 0 ? (a + b) / c : (a - b) / c
.syntax unified
.cpu cortex-m4
.thumb

#define A #10
#define B #4
#define C #2

.global vtable_kernel
.global __kernel_reset__

.type vtable_kernel, %object
.type __kernel_reset__, %function

.section .interrupt_vector
vtable_kernel:
    .word __stack_start
    .word __kernel_reset__+1
    .size vtable_kernel, .-vtable_kernel

.section .rodata
    data:  .asciz "kernel started!\n"
    final: .asciz "Value in register #3: "
.section .text
__kernel_reset__:
    ldr r0, =data
    bl dbgput_line

    // calculate
    mov r2, A
    mov r3, B
    mov r4, C
    // r0 = a - b
    sub r0, r2, r3
    // r0 >= 0
    cmp r0, #0
    blt 1f
    // r2 = a + b
    add r2, r3
    bl 2f
1:
    // r2 = a - b
    sub r2, r3
2:
    // r1 = (a (+|-) b) / c -- result
    udiv r1, r3, r4
    // r3 = result
    mov r3, r1

    ldr r0, =final
    bl dbgput
    mov r0, r3
    bl dbgput_num

    end:
    b end
