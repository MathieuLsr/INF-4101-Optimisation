; Perrine MOLINAS
; Mathieu LESUR

.data
TAB: .word 0,0,0,0,0,0,0,0 ,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 8x8 = 64

MX: .word -1,0,1,-2,0,2,-1,0,1
MY: .word 1,2,1,0,0,0,-1,-2,-1

A: .word 448 ; 448 = 56 * 8 ; Pour ne pas avoir la dernière ligne (commencer à l'avant dernière ligne)
B: .word 56 ; Pour arrêter avant la première ligne

C: .word 64 ;
D: .word 120 ;

Z: .word 0 ;

.text

lw R1, Z(r0)

lw R20, TAB(r0) ; Tableau par défaut
lw R21, TAB(r0) ; Tableau de Mx
lw R22, TAB(r0) ; Tableau de My

 
 
LOOP1:

  addi R1, R1, #1 ; R1 = it 



lw R1, A(r0) ;
lw R2, B(r0)

lw R4, C(r0)
lw R5, D(r0)

LOOP:
  addi R1, R1, #-8

  beq R1, R2, END ; R1 == 56 : break

  div R1, R4 ; R1%64
  MFLO R3 ;
  BEQZ R3, LOOP

  div R1, R5 ; R1%64
  MFLO R3 ;
  addi R3, R3, #-54 ; -54 pour pouvoir == 0
  BEQZ R3, LOOP

  lw R10, TAB(R1)
  addi R10, R10, #1
  sw R10, TAB(R1)

  BNEZ R1, LOOP

END:
halt
