bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
; a - byte, b - word, c - double word, d - qword - Interpretare fara semn
segment data use32 class=data
    ; ...
    a db 55
    b dw 53
    c dd 50
    d dq 100

; (a+b+d)-(a-c+d)+(b-c)
; our code starts here
segment code use32 class=code
    start:
        ; ...
        
        movzx ax, byte [a] ; ax = a
        mov bx, [b] ; bx = b 
        
        add ax, bx ;ax = ax + bx = (a+b)
        
        mov dx, 0
        
        push dx
        push ax ; stack = [ax, dx]
        
        pop eax ; eax = (a+b) de forma word
        
        mov edx, 0 ; edx : eax = (a+b)
        
        mov ebx, dword [d]
        mov ecx, dword [d+4] 
        
        add eax, ebx ; 
        adc edx, ecx
            
        push edx
        push eax ; stack = [eax, edx] = (a+b+d)
        
        movzx eax, byte [a]
        mov ebx, [c]
        
        sub eax, ebx
        
        mov edx, 0 ; edx : eax = (a-c)
        
        mov ebx, dword [d]
        mov ecx, dword [d+4]; ecx : ebx = d
        
        add eax, ebx
        adc edx, ecx ; edx : eax = a - c + d
        
        mov ebx, eax
        mov ecx, edx ; ecx : ebx = (a-c+d)
        
        pop edx
        pop eax 
       
        
        ;(a+b+d) - (a-c+d)
        
        sub eax, ebx
        sbb edx, ecx  
        
        push edx
        push eax ; stack = [eax, edx]
        
        movzx eax, word [b]
        mov ebx, [c]
        
        sub eax, ebx ; eax = (b-c)
        
        mov ebx, eax
        mov ecx, 0 ; ecx : ebx = (b-c)
        
        ;(a+b+d)-(a-c+d)+(b-c)
        
        pop eax 
        pop edx ; edx : eax = (a+b+d)-(a-c+d)
                ; ecx : ebx = (b-c)
                
        add eax, ebx
        adc edx, ecx
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
