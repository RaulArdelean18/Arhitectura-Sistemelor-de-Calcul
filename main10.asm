bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
	a dw 1234h	
	b db 5bh	
	c resd 1	
segment code use32 class=code
    start:
;-----------------------------------------------------------------------------------
; Cerința:
;Se dau cuvantul a si octetul b. Dublucuvantul c se formează astfel:
;- bitii 0-2 ai lui c au valoarea 0
;- bitii 3-5 ai lui c au valoarea 1
;- bitii 6-9 ai lui c coincid cu bitii 11-14 ai lui a
;- bitii 10-15 ai lui c coincid cu bitii 1-6 ai lui b
;- bitii 16-31 ai lui c au valoarea 1
;Să se efectueze în interpretarea fara semn operația ((a+c)/b+c)*2-a
;-----------------------------------------------------------------------------------

; -------- CONSTRUIREA LUI c --------
; Logica din codul original este complet greșită.
; O rescriem pentru a respecta cerințele.

; Pas 1: Setăm biții cunoscuți (0-2=0, 3-5=1, 16-31=1)
; Biti 16-31 = 1 -> FFFF0000h
; Biti 3-5   = 1 -> ...00111000b = 38h
; Biti 0-2   = 0 -> (nu facem nimic, raman 0)
; Valoarea inițială a lui c este FFFF0038h; (sau pui 11111111111111110000000000111000b)
		MOV dword [c], 0FFFF0038h

; Pas 2: Adăugăm biții 6-9 din a (biții 11-14 ai lui a)
; a = 1234h = 0001 0010 0011 0100b. Biții 11-14 sunt 0010.
; Masca pentru biții 11-14 este 0111 1000 0000 0000b
		MOV EAX, 0                ; Curățăm EAX
		MOV AX, [a]               ; EAX = 00001234h
		AND EAX, 0111100000000000b; Izolăm biții 11-14 -> EAX = 00001000h ; sau 0000 0000 0000 0000 0001 0000 0000 0000 b
		SHR EAX, 5                ; Deplasăm biții la dreapta cu (11-6)=5 poziții 
                                  ; EAX = 00000080h (biții 0010 sunt acum în pozițiile 6-9) ; sau 0000 0000 0000 0000 0000 0000 1000 0000 b
		OR dword [c], EAX         ; Combinăm cu c. c = FFFF00B8h ; sau 1111 1111 1111 1111 0000 0000 1011 1000

; Pas 3: Adăugăm biții 10-15 din b (biții 1-6 ai lui b)
; b = 5Bh = 0101 1011b. Biții 1-6 sunt 101101.
; Masca pt biții 1-6 este 7Eh (0111 1110b)
; EROARE CORECTATĂ: Codul original folosea 0FEh (biții 1-7)
		MOV EAX, 0                ; Curățăm EAX
		MOV AL, [b]               ; EAX = 0000005Bh
		AND EAX, 7Eh              ; Izolăm biții 1-6 -> EAX = 0000005Ah
; EROARE CORECTATĂ: Codul original folosea "SHL AL, 9" (imposibil) și "XOR"
		SHL EAX, 9                ; Deplasăm biții la stânga cu (10-1)=9 poziții
                                  ; EAX = 0000B400h (biții 101101 sunt acum în pozițiile 10-15)
		OR dword [c], EAX         ; Combinăm cu c. Valoarea finală a lui c = FFFFB4B8h

; -------- CALCULUL EXPRESIEI (fără semn) --------
; ((a+c)/b+c)*2-a

; Original: mov ax,[a]
; Original: cwde (EROARE: 'cwde' este PENTRU SEMN)
		MOVZX EAX, word [a]       ; EAX = a (extins cu 0 la 32 biți)
		
; Original: add ax,[c] (EROARE: nepotrivire de mărime)
		ADD EAX, dword [c]        ; EAX = a + c
		
		MOV EDX, 0                ; Pregătim EDX:EAX pentru împărțirea FĂRĂ SEMN
		
; Original: movsx ebx,byte[b] (EROARE: 'movsx' este PENTRU SEMN)
		MOVZX EBX, byte [b]       ; EBX = b (extins cu 0 la 32 biți)
		
; Original: div ebx (OK)
		DIV EBX                   ; EAX = (a+c)/b ; EDX = restul
		
; Original: add eax,[c] (EROARE: sintaxă, ar trebui specificată mărimea)
		ADD EAX, dword [c]        ; EAX = (a+c)/b + c
		
		MOV EBX, 2                ; EBX = 2
		
; Original: imul ebx (EROARE: 'imul' este PENTRU SEMN)
		MUL EBX                   ; EDX:EAX = EAX * 2 (înmulțire FĂRĂ SEMN pe 64 biți)
		
; Păstrăm structura originală de a muta rezultatul în ECX:EBX
; Original: xchg eax,ebx
; Original: xchg ecx,edx
		XCHG EAX, EBX             ; EBX = partea joasă a înmulțirii ; poti scrie ca MOV EBX, EAX
		XCHG ECX, EDX             ; ECX = partea înaltă a înmulțirii ; poti scrie ca MOV ECX, ECX
                                  ; Acum ECX:EBX = ((a+c)/b+c)*2
        
; Original: movzx eax, word[a] (OK)
		MOVZX EAX, word [a]       ; EAX = a
		
; Original: mov edx,0 (OK)
		MOV EDX, 0                ; EDX:EAX = a (ca număr pe 64 biți)
		
; Scădem 'a' (EDX:EAX) din rezultat (ECX:EBX)
; Original: sbb ebx,eax (EROARE: trebuia SUB)
; Original: sub ecx,edx (EROARE: trebuia SBB)
		SUB EBX, EAX              ; Scădem partea joasă
		SBB ECX, EDX              ; Scădem partea înaltă (cu transport/borrow)
		
; Rezultatul final (pe 64 de biți) se află în ECX:EBX
		 
        push    dword 0  
        call    [exit]