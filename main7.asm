bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
; a-doubleword; b-byte; c-word; x-qword ; fara semn
segment data use32 class=data
    ; ...
    a dd 105
    b db 3
    c dw 35
    x dq 15

;(a+b/c-1)/(b+2)-x; 
; our code starts here
segment code use32 class=code
    start:
        ; ...
        
        movzx ax, byte [b]
        mov dx, 0
        
        mov bx, [c]
        
        div bx ; ax = b/c
        
        mov dx, 0
        
        push dx
        push ax ; stack [ax,dx]
        
        pop eax ; stack = empty
        
        mov ebx, [a]
        
        add eax, ebx ; eax = (a+ b/c)
        
        mov ebx, 1
        
        sub eax, ebx ; eax = ( a + b / c - 1)
        
        mov edx, 0
        
        push edx 
        push eax ; stack = [eax, edx]
        
        movzx eax, byte [b]
        
        mov ebx, 2
        
        add eax, ebx ; eax = (b+2)

        mov ebx, eax
        
        pop eax
        pop edx 
        
        div ebx ; eax = (a+b/c-1)/(b+2)
        
        mov edx, 0
        
        mov ebx, dword [x]
        mov ecx, dword [x+4]
        
        sub eax, ebx
        sbb edx, ecx
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
