; Perrine MOLINAS
; Mathieu LESUR


; Résultats sans Forwarding :
; 2990 Cycles & 1665 instructions
; 1258 RAW Stalls

; Résultats avec Forwarding :
; 1692 Cycles & 1476 instructions
; 149 RAW Stalls


.data
tab1: .word 11,12,13,14,21,22,23,24,31,32,33,34,41,42,43,44
tab2: .word 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
tab3: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

A: .word 0
B: .word 4
C: .word 8
P: .word 120

I: .word 4 ; 4 loop
J: .word 4 ; 4 loop
K: .word 4 ; 4 loop

.text

lw R21, A(r0) ; indice tab1
lw R22, A(r0) ; indice tab2
lw R23, A(r0) ; indice tab3


lw R30, B(r0) ; 4
lw R31, C(r0) ; 8

lw R10, A(r0) ;


lw R4, P(r0) ; P

LOOP1:
  addi R4, R4, #-32
  lw R5, J(r0) ; J

  LOOP2:
    addi R5, R5, #-1
    lw R6, K(r0) ; K

    LOOP3:
      addi R6, R6, #-1

      ; tab3[i*4+j] += tab1[i*4+k] * tab2[k*4+j];


      ; dmult R4, R30 ; R30 = 4
      ; MFLO R11 ; R11 = i*4

      dmult R6, R30 ; R30 = 4


      dadd R12, R11, R5 ; i*4 + j = R12
      dadd R13, R11, R6 ; i*4 + k = R13

      MFLO R11 ; R11 = k*4

      dadd R14, R11, R5 ; k*4 + j = R14

      lw R15, tab1(R13)
      lw R16, tab2(R14)
      dmult R15, R16 ;
      MFLO R17 ; R17 = tab1[i*4+k] * tab2[k*4+j]

      lw R18, tab3(R12)
      dadd R18, R18, R17
      sw R18, tab3(R12)


      BNEZ R6, LOOP3

    BNEZ R5, LOOP2

  BNEZ R4, LOOP1

halt
