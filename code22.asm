default rel
global main
extern printf

section .data
    formatRaw   db "Raw EFLAGS = 0x%08X", 10, 0
    formatFlags db "Zero Flag (ZF) = %d, Carry Flag (CF) = %d", 10, 0

section .text
main:
    sub rsp, 40          ; Shadow space allocate karein

    ; Step 1: Operation that sets ZF = 1, CF = 0
    mov eax, 5
    sub eax, 5

    ; Step 2 & 3: Read 64-bit RFLAGS
    pushfq
    pop rbx

    ; Display raw flags
    mov edx, ebx         ; 2nd argument -> Raw EFLAGS (lower 32-bit of RBX)
    lea rcx, [formatRaw] ; 1st argument -> Format string
    call printf

    ; Step 4: Extract Zero Flag (Bit 6)
    mov rcx, rbx
    shr rcx, 6
    and ecx, 1           ; ECX = ZF (0 ya 1)

    ; Step 5: Extract Carry Flag (Bit 0)
    mov rdx, rbx
    and edx, 1           ; EDX = CF (0 ya 1)

    ; Step 6: Print flag values
    mov r8d, edx         ; 3rd argument -> CF
    mov edx, ecx         ; 2nd argument -> ZF
    lea rcx, [formatFlags] ; 1st argument -> Format string
    call printf

    xor eax, eax
    add rsp, 40          ; Shadow space clean karein
    ret