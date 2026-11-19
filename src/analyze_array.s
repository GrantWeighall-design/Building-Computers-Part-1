// x0=array, x1=length, x2=48-byte results; calls both helpers for each element.
.text
.global analyze_array
.type analyze_array, %function
analyze_array:

    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    str x23, [sp, #48]

    mov x19, x0
    mov x20, x1
    mov x21, x2
    mov x22, #0

    // Initialize all six result fields to zero
    mov x9, #0
    mov x10, #0
zero_fields:
    str x9, [x21, x10]
    add x10, x10, #8
    cmp x10, #48
    b.lt zero_fields

    // Empty array: return without reading it
    cbz x20, analyze_done

    // Initialize min and max from first element
    ldur x9, [x19, #0]
    stur x9, [x21, #0]
    stur x9, [x21, #8]

array_loop:
    cmp x22, x20
    b.hs analyze_done

    // Read current element
    ldr x23, [x19, x22, lsl #3]

    // Add to running sum
    ldur x9, [x21, #16]
    add x9, x9, x23
    stur x9, [x21, #16]

    // Classify current element
    mov x0, x23
    bl classify_value

    cmp x0, #0
    b.lt count_negative
    b.gt count_positive

    // Zero count
    ldur x9, [x21, #40]
    add x9, x9, #1
    stur x9, [x21, #40]
    b update_extrema

count_negative:
    ldur x9, [x21, #32]
    add x9, x9, #1
    stur x9, [x21, #32]
    b update_extrema

count_positive:
    ldur x9, [x21, #24]
    add x9, x9, #1
    stur x9, [x21, #24]

update_extrema:
    mov x0, x23
    mov x1, x21
    bl update_min_max

    add x22, x22, #1
    b array_loop

analyze_done:
    ldr x23, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

.size analyze_array, .-analyze_array
.section .note.GNU-stack,"",@progbits
