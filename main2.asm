
bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    a dw 312
    b dw 512
    c dw 13
    d dw 273

;(b+c+d)-(a+a)    

; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov ax, [b]
        add ax, [c]
        add ax, [d]
        push ax
        pop ebx
        mov ax, [a]
        add ax, [a]
        push ax
        pop eax
        sub ebx, eax
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
