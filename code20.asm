bits 64
default rel
global main
extern printf

section .data
    result db 0
    format db "AL = %d, BL = %d, Memory = %d", 10, 0

section .text
main:
    sub rsp, 40
    mov al, 10
    add al, 20
    sub al, 5
    mov [result], al
    mov bl, [result]

    movzx eax, al
    movzx ebx, bl
    movzx r8d, byte [result]

    lea rcx, [format]
    mov rdx, rax
    ; r8 is already loaded with Memory value
    mov r9, rbx ; put BL into r9
    ; standard Win64 call for 3+ args: rcx=fmt, rdx=arg1, r8=arg2, r9=arg3
    ; swapped r8/r9 to match format: AL (%d), BL (%d), Memory (%d)
    mov r8, rbx
    movzx r9, byte [result]

    call printf
    add rsp, 40
    xor eax, eax
    ret