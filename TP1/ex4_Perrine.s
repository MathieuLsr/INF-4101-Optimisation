; Perrine MOLINAS
; Mathieu LESUR

.data
tab1: .word 11,12,13,14, 21,22,23,24,31,32,33,34,41,42,43,44
tab2: .word 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
tab3: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

A: .word 0
B: .word 4
C: .word 8
D: .word 32
T: .word 120 ; Taille tableau en sizeof
U: .word 128

.text
lw R1, C(r0) ;tj = à 8
lw R2, B(r0)
;lw R3, A(r0)
lw R4, U(r0) ;Tableau résultat
lw R5, A(r0)
lw R6, T(r0) ;registre pour les colonnes
lw R7, T(r0) ;registre pour les lignes
;lw R11, A(r0)
lw R12, A(r0)
;lw R13, A(r0)
lw R14, A(r0)
lw R15, D(r0) ;tj = à 32
lw R16, A(r0)
lw R17, A(r0)
;R8,R9,R10


LOOP:
  addi R17, R17, #-32

LOOP2:
  lw R13, B(r0) ;4 mult. à traiter pour la valeur d'1 case de tab3
  addi R4, R4, #-8 ;parcours de toutes les valeurs de tab3

  addi R2, R2, #-1
  addi R5, R5, #-8
  lw R12, A(r0)

;_____________________________
LOOP3:
  addi R13, R13, #-1 ;faire 4 additions

  lw R9,tab2(R7) ;valeur sur les colonnes de tab2
  addi R7, R7, #-32

  lw R8,tab1(R6) ;valeur sur les lignes de tab1
  addi R6, R6, #-8

  dmult R8, R9 ;multiplication des 2 valeurs
  MFLO R11 ;récupération du résultat dans LO
  dadd R12, R12, R11 ;ajout au résultat final


;LOOP4: ;boucle de multiplication
;  addi R9, R9, #-1
;  dadd R12, R12, R8
;
;  BNEZ R9, LOOP4


  BNEZ R13, LOOP3
;_____________________________

  lw R10,tab3(R4) ; Lire la valeur dans tab3
  dadd R10, R10, R12 ;R12 = résultat de la mult. matricielle pour tab3(R4)
  sw R10, tab3(R4) ; Affecter la valeur

  BEQZ R4,END


  lw R7, T(r0) ;registre pour les colonnes remis à 120
  dsub R7, R7, R5 ;R7=120-(8*(nb d'itération de R5))


  BNEZ R2, LOOP2

  lw R5, A(r0)
  lw R2, B(r0)

  lw R6, T(r0) ;registre pour les lignes remis à 120
  dsub R6, R6, R17 ;R6=120-(32*(nb d'itération de R17))


  BNEZ R4, LOOP


END:
  halt
