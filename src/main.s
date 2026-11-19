// Analyze demo_array using demo_length; store demo_results; return 0.
.text
.global main
.type main, %function
main:

    stp x29, x30, [sp, #-16]!
    mov x29, sp

    ldr x0, =demo_array
    ldr x1, =demo_length
    ldr x1, [x1]
    ldr x2, =demo_results

    bl analyze_array

    mov x0, #0
    ldp x29, x30, [sp], #16
    ret

.size main, .-main
.section .note.GNU-stack,"",@progbits

.data
.balign 8
.global demo_array, demo_length
demo_array: .quad -4, 0, 7, -2, 7, 0
demo_length: .quad 6
.bss
.balign 8
.global demo_results
demo_results: .skip 48
