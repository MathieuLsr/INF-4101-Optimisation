; Perrine MOLINAS
; Mathieu LESUR

; ---------------------------------------
; Résultats sans Forwarding :
; 1585 Cycles & 916 instructions
; 602 RAW Stalls

; Résultats avec Forwarding :
; 1116 Cycles & 916 instructions
; 133 RAW Stalls

; ---------------------------------------
; ANCIEN RESULTATS : AVANT OPTIMISATION

; Résultats sans Forwarding :
; 2990 Cycles & 1665 instructions
; 1258 RAW Stalls

; Résultats avec Forwarding :
; 1692 Cycles & 1476 instructions
; 149 RAW Stalls
; ---------------------------------------


.data
tab1: .word 11,12,13,14,21,22,23,24,31,32,33,34,41,42,43,44
tab2: .word 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
tab3: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

I: .word 128 ;
J: .word 32 ;
K: .word 32 ;
K2: .word 128 ;

.text

lw R4, I(r0) ; I

LOOP1:
  addi R4, R4, #-32 ; I = R4 = 128 ; R4 - 32 ; R11 ; R12 = R11 + J ;
                  ; J = R5 = 32 ; R5 - 8 ;
                  ; K = R6 = 32 ; R6 - 8 ; R13 =+ R6 ;
                  ; K2 = R6 = 128 ; R6 - 32 ; R11 = R6 * 32 ; R14 += R11 ;
  lw R5, J(r0) ; J

  LOOP2:
    addi R5, R5, #-8
    lw R6, K(r0) ; K
    lw R7, K2(r0) ; K2

    LOOP3:
      addi R6, R6, #-8
      addi R7, R7, #-32


      dadd R13, R4, R6 ; i*4 + k = R13
      dadd R14, R7, R5 ; k*4 + j = R14
      dadd R12, R4, R5 ; i*4 + j = R12


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
