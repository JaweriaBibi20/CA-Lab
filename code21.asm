default rel
global main
extern printf

section .data
    format1 db "AH = 0x%02X, AL = 0x%02X -> AX = 0x%04X", 10, 0
    format2 db "Full EAX after packing = 0x%08X", 10, 0

section .text
main:
    sub rsp, 40          ; Shadow space (32 bytes) + 8-byte alignment

    ; Step 1: Start with a completely clean 32-bit register
    xor eax, eax

    ; Step 2: Load values into the 8-bit sub-registers
    mov ah, 0x12
    mov al, 0x34

    ; Step 3: Print AX, AL, AH
    movzx r9d, ax        ; 4th argument -> AX
    movzx r8d, al        ; 3rd argument -> AL
    movzx edx, ah        ; 2nd argument -> AH
    lea rcx, [format1]   ; 1st argument -> Format string
    call printf

    ; Step 5: Shift AX into upper half of EAX
    shl eax, 16

    ; Load new values into lower bytes
    mov ah, 0x56
    mov al, 0x78

    ; Step 6: Print full 32-bit EAX register
    mov edx, eax         ; 2nd argument -> EAX
    lea rcx, [format2]   ; 1st argument -> Format string
    call printf

    xor eax, eax
    add rsp, 40          ; Shadow space clean karein
    ret