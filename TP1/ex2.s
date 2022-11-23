; Perrine MOLINAS
; Mathieu LESUR

; 101 Cycles & 65 instructions
; 21 RAW Stalls

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

  BEQZ R2, END

  lw R4,list(R5)
  dadd R1,R1,R4

  addi R5, R5, #8
  addi R2, R2, #-1
  j LOOP

END: halt
