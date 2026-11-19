// x0=value, x1=results pointer; update only fields at offsets 0 and 8.
.text
.global update_min_max
.type update_min_max, %function
update_min_max:

    ldur x2, [x1, #0]
    cmp x0, x2
    b.ge check_max
    stur x0, [x1, #0]

check_max:
    ldur x2, [x1, #8]
    cmp x0, x2
    b.le finished
    stur x0, [x1, #8]

finished:
    ret

.size update_min_max, .-update_min_max
.section .note.GNU-stack,"",@progbits
