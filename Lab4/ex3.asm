NULL EQU 0
STD_OUTPUT_HANDLE EQU -11

extern _GetStdHandle@4
extern _WriteFile@20
extern _ExitProcess@4

global Start

section .data
    Message db "The sum of the array is:", 0
    MessageLength EQU $-Message
    array dd 1, 7, 3, 4, 5
    array_size equ ($ - array) / 4

section .bss
    StandardHandle resd 1
    Written resd 1
    result dd 0
    result_str resb 11

section .text
Start:
    ; Get the standard output handle
    push STD_OUTPUT_HANDLE
    call _GetStdHandle@4
    mov dword [StandardHandle], EAX

    ; Calculate the sum of the array
    mov ecx, array_size
    xor eax, eax
    mov esi, array
    add_loop:
        add eax, [esi]
        add esi, 4
        loop add_loop
    mov [result], eax

    ; Convert the result to a string
    mov EAX, [result]
    call DecimalToString

    ; Write the message and the result to standard output
    push NULL
    push Written
    push MessageLength
    push Message
    push dword [StandardHandle]
    call _WriteFile@20
    push NULL
    push Written
    push 11
    push result_str
    push dword [StandardHandle]
    call _WriteFile@20

    ; Exit the program
    push NULL
    call _ExitProcess@4

DecimalToString:
    push EBP
    mov EBP, ESP
    sub ESP, 8
    mov dword [EBP-4], 0
    mov dword [EBP-8], 10

.Loop:
    xor EDX, EDX
    div dword [EBP-8]
    add DL, '0'
    mov byte [result_str+eax], DL
    inc dword [EBP-4]
    test EAX, EAX
    jnz .Loop

    mov EAX, dword [EBP-4]
    add ESP, 8
    pop EBP
    ret
