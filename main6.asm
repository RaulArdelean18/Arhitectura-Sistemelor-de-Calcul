bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
;a - byte, b - word, c - double word, d - qword - Interpretare cu semn
segment data use32 class=data
    ; ...
    a db 5
    b dw 35
    c dd 50
    d dq 105

; (a-b-c)+(d-b-c)-(a-d) = (5-35-50)
; our code starts here
segment code use32 class=code
    start:
        ; ...
        
        movsx ax, [a]
        mov bx, [b]
        
        sub ax, bx
        
        cwde ; eax = (a-b)
        
        mov ebx, [c]
        
        sub eax, ebx ; a-b-c
        
        push eax
        
        mov eax, dword [d]
        mov edx, dword [d+4]; edx : eax = d
        
        movsx ebx, word [b]
        mov ecx, 0 ; ecx : ebx = b
        
        sub eax, ebx
        sbb edx, ecx ; edx : eax = d - b
        
        mov ebx, [c]
        mov ecx, 0 ; ecx : ebx = c
        
        sub eax, ebx
        sbb edx, ecx ; edx : eax = d - b - c
        
        mov ebx, eax
        mov ecx, edx 
        
        pop eax
        
        mov edx, 0 ; edx ; eax = a-b-c
        
        add eax, ebx
        adc edx, ebx ; (a-b-c) + (d-b-c)
        
        push edx
        push eax ; stack = [eax, edx]
        
        movsx eax, byte [a]
        mov edx, 0 ; edx: eax = a
        
        
        mov ebx, dword [d]
        mov ecx, dword [d+4]; edx : eax = d
        
        sub eax, ebx
        sbb edx, ecx ; edx : eax = (a-d)
        
        mov ebx, eax
        mov ecx, edx
        
        pop eax 
        pop edx
        
        sub eax, ebx
        sbb edx, ecx
        
        
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
