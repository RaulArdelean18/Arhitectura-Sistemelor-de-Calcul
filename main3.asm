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
    a db 3
    b db 10
    c db 15
    d dw 278

    
;(100*a+d+5-75*b)/(c-5)    
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov al, [a]         ; AL = a
        mov ah, 0           ; AX = a
        mov bl, 100
        mul bl              ; AX = a * 100

        mov bx, ax          ; BX = 100 * a

        ; + d
        add bx, [d]         ; BX = 100*a + d

        ; + 5
        add bx, 5

        ; - (75 * b)
        mov al, [b]
        mov ah, 0
        mov bl, 75
        mul bl              ; AX = b * 75
        sub bx, ax          ; BX = 100*a + d + 5 - 75*b

        ; împărțim la (c - 5)
        mov al, [c]
        sub al, 5
        mov ah, 0           ; AX = (c - 5)
        mov cx, ax          ; CX = (c - 5)

        ; Pregătim pentru împărțire
        mov ax, bx          ; AX = numărător
        cwd                 ; extindem semnul în DX
        idiv cx             ; AX = (100*a + d + 5 - 75*b) / (c - 5)

        ; rezultatul e în AX
        
        
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
