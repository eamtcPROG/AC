NULL EQU 0
STD_OUTPUT_HANDLE EQU -11

extern _GetStdHandle@4
extern _WriteFile@20
extern _ExitProcess@4

global Start

section .data
    Message db "I don't like to write code in .asm", 0
    MessageLength EQU $-Message

section .bss
    StandardHandle resd 1
    Written resd 1

section .text
Start:
    ; Get the standard output handle
    push STD_OUTPUT_HANDLE
    call _GetStdHandle@4
    mov dword [StandardHandle], EAX

    ; Write the message to standard output
    push NULL
    push Written
    push MessageLength
    push Message
    push dword [StandardHandle]
    call _WriteFile@20

    ; Exit the program
    push NULL
    call _ExitProcess@4
