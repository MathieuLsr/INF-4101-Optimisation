; Perrine MOLINAS
; Mathieu LESUR

; Résultats ex 2 :
; 101 Cycles & 65 instructions
; 21 RAW Stalls

; Résultats ex 3 après opti sans Forwarding :
; 78 Cycles & 54 instructions
; 11 RAW Stalls

; Résultats ex 3 après opti avec Forwarding :
; 67 Cycles & 54 instructions
; 0 RAW Stalls

.data
list: .word 1,2,3,4,5,6,7,8,9,10
A: .word 0
B: .word 10


.text

lw R1,A(r0)
lw R2, B(r0)
lw R5, A(r0)

LOOP:

  ; SLT R1, R2, R3 ; R1 = R2 < R3 ? 1 : 0

  addi R2, R2, #-1
  lw R4,list(R5)

  addi R5, R5, #8
  dadd R1,R1,R4

  BNEZ R2, LOOP

END: halt
