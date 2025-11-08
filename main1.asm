;(a+b-d)+(a-b-d)
;(40+15-30)+(40-15-30)=(55-30)+(40-15-30)=25+(40-15-30)=25+(25-30)=25+(-5)=

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
    a db 40
    b db 15
    d db 30

; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov ax, [a]; ax = a
        add ax, [b]; ax = a + b
        sub ax, [d]; ax = a + b - d
        push ax
        pop ebx
        
        mov ax, [a]; ax = a
        sub ax, [b]; ax = a - b
        sub ax, [d]; ax = a - b - d
        
        push ax
        pop eax
        
        add ebx, eax
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
