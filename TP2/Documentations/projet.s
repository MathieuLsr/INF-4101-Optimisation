########## 12/04/2013
########## Paul Gerst
########## Stan Wilhelm

.data

fileIn :	.space 30
fileOut :	.space 40

Fx :		.word 1, 0, -1, 2, 0, -2, 1, 0, -1
Fy :		.word 1, 2, 1, 0, 0, 0, -1, -2, -1

seuil8 :	.word 180
seuil4 :	.word 12

.text

########## Nom du fichier image au clavier

	la $a0, fileIn
	la $a1, fileIn
	li $v0, 8
	syscall
	jal fileName 

########## Ouverture du fichier

	li $v0 13
	la $a0 fileIn
	li $a1 0
	li $a2 0
	syscall
	move $s0 $v0			#file descriptor dans $s0

########## Lecture de la taille du fichier

	subu $sp $sp 2			#lecture des 2 premiers octets (non utilisés)
	li $v0 14
	move $a0 $s0
	move $a1 $sp
	li $a2 2
	syscall
	addu $sp $sp 2

	subu $sp $sp 4
	li $v0 14
	move $a0 $s0
	move $a1 $sp
	li $a2 4
	syscall
	lw $s2 0($sp)			#taille du fichier dans $s2
	addu $sp $sp 4
	
########## Lecture de l'offset de l'image

	subu $sp $sp 8
	li $v0 14
	move $a0 $s0
	move $a1 $sp
	li $a2 8
	syscall
	lw $s3 4($sp)			#offset dans $s3
	addu $sp $sp 8


########## Lecture de la largeur de l'image

	subu $sp $sp 8
	li $v0 14
	move $a0 $s0
	move $a1 $sp
	li $a2 8
	syscall
	lw $s4 4($sp)			#largeur dans $s4
	addu $sp $sp 8

########## Lecture de la hauteur de l'image

	subu $sp $sp 4
	li $v0 14
	move $a0 $s0
	move $a1 $sp
	li $a2 4
	syscall
	lw $s6 0($sp)			#hauteur dans $s6
	addu $sp $sp 4

########## Lecture de la profondeur de codage de la couleur

	subu $sp $sp 4
	li $v0 14
	move $a0 $s0
	move $a1 $sp
	li $a2 4
	syscall
	lh $s5 2($sp)			#profondeur dans $s5
	addu $sp $sp 4

########## Fermeture du fichier

	li $v0 16
	move $a0 $s0
	syscall

########## Ouverture du fichier d'entrée et de sortie
	
	li $v0 13
	la $a0 fileIn
	li $a1 0
	li $a2 0
	syscall
	move $s0 $v0			#file descriptor dans $s0

	li $v0 13
	la $a0 fileOut
	li $a1 1
	li $a2 0
	syscall
	move $s1 $v0			#file descriptor dans $s1	
	
########## Ecriture de l'entête de l'image

	subu $sp $sp 4
	li $v0 9
	move $a0 $s3			#taille à allouer dans le tas
	syscall
	sw $v0 0($sp)			#allocation et stockage de l'adresse

	li $v0 14			#lecture de l'entête
	move $a0 $s0
	lw $a1 0($sp)
	move $a2 $s3
	syscall
	
	li $v0 15			#écriture de l'entête
	move $a0 $s1	
	lw $a1 0($sp)
	move $a2 $s3
	syscall
	addu $sp $sp 4

########## Taille restante (codage de l'image)

	subu $s2 $s2 $s3		#taille de l'image restante dans $s2

########## Allocation et lecture de l'image

	subu $sp $sp 12			#réservation de 3 adresses dans la pile
	
	li $v0 9			#image d'origine
	move $a0 $s2			#taille à allouer
	syscall
	sw $v0 0($sp)
	move $s7 $v0			#adresse dans $s7

	li $v0 9			#Gx (puis plus tard |Gx| + |Gy|)
	move $a0 $s2			
	syscall
	sw $v0 4($sp)

	li $v0 9			#Gy
	move $a0 $s2			
	syscall
	sw $v0 8($sp)			

	li $v0 14			#lecture de l'image
	move $a0 $s0
	lw $a1 0($sp)
	move $a2 $s2
	syscall

########## Opérations (produit de convolution et addition)

	lw $a0 4($sp) 			#produit de convolution avec Fx
	la $a1 Fx
	jal storeConv

	lw $a0 8($sp)			#produit de convolution avec Fy
	la $a1 Fy
	jal storeConv
	
	lw $a0 4($sp)			#addition de |Gx| et |Gy|
	lw $a1 4($sp)
	lw $a2 8($sp)
	jal addMat

########## Ecriture de l'image finale

	li $v0 15
	move $a0 $s1
	lw $a1 4($sp)
	move $a2 $s2
	syscall

	addu $sp $sp 12

########## Fermerture des fichiers

	li $v0 16
	move $a0 $s0
	syscall
	
	li $v0 16
	move $a0 $s1
	syscall

########## Exit

	li $v0 10
	syscall

#########################################################
##########		FONCTIONS		#########
#########################################################

########## rBits : lecture de n bits à partir d'un octet
##### arg1 : $a0 = nombre de bits à lire (4 ou 8)
##### arg2 : $a1 = offset
##### arg3 : $a2 = octet

rBits:

##### prologue

	subu $sp $sp 16
	sw $a0 0($sp)
	sw $a1 4($sp)
	sw $a2 8($sp)
	sw $ra 12($sp)

##### code

	beq $a0 4 fourBits
	beq $a0 8 oneByte

fourBits:				#4 bits
	li $t0 0x0000000f
	li $t1 4
	j findBit

oneByte:				#8bits (renvoyer directement $a2)
	move $v0 $a2
	j rBitsEnd

findBit:
	subu $a1 $t1 $a1
	srlv $a2 $a2 $a1
	and $v0 $a2 $t0
	j rBitsEnd

##### épilogue

rBitsEnd:
	lw $a0 0($sp)
	lw $a1 4($sp)
	lw $a2 8($sp)
	lw $ra 12($sp)
	addu $sp $sp 16
	jr $ra

########## getElementA : obtenir un element de la matrice de pixels
##### arg1 : $a0 = adresse de l'image
##### arg2 : $a1 = i
##### arg3 : $a2 = j

##### prec1 : $s4 = largeur de l'image
##### prec2 : $s5 = profondeur de codage de la couleur

getElementA:

##### prologue

	subu $sp $sp 24
	sw $a0 0($sp)
	sw $a1 4($sp)
	sw $a2 8($sp)
	sw $s4 12($sp)
	sw $s5 16($sp)
	sw $ra 20($sp)

##### code

	mul $t0 $a1 $s4
	addu $t0 $t0 $a2
	mul $t0 $t0 $s5
	li $t1 8
	div $t0 $t1
	mfhi $t0			#offset
	mflo $t1			#adresse de l'octet à partir duquel lire

	addu $a0 $a0 $t1
	lbu $a2 0($a0)
	move $a0 $s5
	move $a1 $t0
	jal rBits 

##### épilogue

getElementAEnd:	
	lw $a0 0($sp)
	lw $a1 4($sp)
	lw $a2 8($sp)
	lw $s4 12($sp)
	lw $s5 16($sp)
	lw $ra 20($sp)
	addu $sp $sp 24
	jr $ra

########## setElementA : modifier un element de la matrice de pixels
##### arg1 : $a0 = adresse de l'image
##### arg2 : $a1 = i
##### arg3 : $a2 = j
##### arg4 : $a3 = element à écrire

##### prec1 : $s4 = largeur de l'image
##### prec2 : $s5 = profondeur de codage de la couleur
##### prec3 : la matrice doit être vide

setElementA:

##### prologue

	subu $sp $sp 28
	sw $a0 0($sp)
	sw $a1 4($sp)
	sw $a2 8($sp)
	sw $s4 12($sp)
	sw $s5 16($sp)
	sw $ra 20($sp)
	sw $a3 24($sp)

##### code

	mul $t0 $a1 $s4
	addu $t0 $t0 $a2
	mul $t0 $t0 $s5
	li $t1 8
	div $t0 $t1
	mfhi $t0			#offset
	mflo $t1			#adresse de l'octet à partir duquel lire

	addu $a0 $a0 $t1
	lbu $a2 0($a0)

	li $t3 8
	subu $t2 $t3 $t0
	subu $t2 $t2 $s5
	sllv $a3 $a3 $t2
	or $a3 $a3 $a2
	
	sb $a3 0($a0)

##### épilogue

setElementAEnd:
	lw $a0 0($sp)
	lw $a1 4($sp)
	lw $a2 8($sp)
	lw $s4 12($sp)
	lw $s5 16($sp)
	lw $ra 20($sp)
	lw $a3 24($sp)
	addu $sp $sp 28
	jr $ra

########## getElementF : obtenir un element de Fx/Fy
##### arg1 : $a0 = Fx/Fy
##### arg2 : $a1 = i
##### arg3 : $a2 = j

getElementF:

##### prologue

	subu $sp $sp 16
	sw $a0 0($sp)
	sw $a1 4($sp)
	sw $a2 8($sp)
	sw $ra 12($sp)
	
##### code

	li $t3 4			#4 octets
	li $t4 12			#4*3 octets
	mul $t4 $a1 $t4 		#i*3*4
	mul $t3 $a2 $t3 		#j*4
	add $t3 $t3 $t4
	add $t3 $t3 $a0			#adresse modifiee
	lw $v0 0($t3)
	
##### épilogue

	lw $a0 0($sp)
	lw $a1 4($sp)
	lw $a2 8($sp)
	lw $ra 12($sp)
	addu $sp $sp 16
	jr $ra

########## convolution : produit de convolution
##### arg1 : $a0 = Fx/Fy
##### arg2 : $a1 = i
##### arg3 : $a2 = j

convolution:

##### prologue
	subu $sp $sp 36
	sw $s0 0($sp)
	sw $s1 4($sp)
	sw $s2 8($sp)
	sw $s3 12($sp)
	sw $a0 16($sp)
	sw $a1 20($sp)
	sw $a2 24($sp)
	sw $ra 28($sp)
	sw $s7 32($sp)
	
##### code

	move $t8 $a1			#i
	move $t9 $a2			#j
	li $s0 0			#G(i,j)
	li $s1 0 			#compteur loop0 (k)
	li $s2 0 			#compteur loop1 (l)
	li $s3 3 			#limite compteur loop0/loop1

	beq $t8 $0 finloop0		#i = 0
	beq $t9 $0 finloop0		#j = 0
	move $t0 $s4
	li $t1 1
	sub $t0 $t0 $t1			#N-1
	beq $t8 $t0 finloop0		#i = N-1
	move $t0 $s6
	sub $t0 $t0 $t1			#M-1
	beq $t9 $t0 finloop0		#j = M-1
		
loop0:
	beq $s1 $s3 finloop0
	li $s2 0
	
loop1:
	beq $s2 $s3 finloop1
	lw $a0 16($sp) 			#Fx/Fy
	move $a1 $s1 			#k
	move $a2 $s2			#l
	jal getElementF
	move $t3 $v0 			#F(k,l)

	li $t4 1
	sub $t4 $t8 $t4 		#i-1
	add $t4 $t4 $s1			#+k ($t4=i-1+k)
	li $t5 1
	sub $t5 $t9 $t5 		#j-1
	add $t5 $t5 $s2			#+l ($t5=j-1+l)
		
	move $a1 $t4
	move $a2 $t5
	move $a0 $s7
	jal getElementA
	move $t4 $v0			#A(i-1+k, j-1+l)

	mul $t3 $t3 $t4			#F(k,l)*A(i-1+k, j-1+l)
	add $s0 $s0 $t3			#G(i,j) += F(k,l)*A(i-1+k, j-1+l)

	addi $s2 $s2 1 			#l++
	j loop1
	
finloop1:
	addi $s1 $s1 1 			#k++
	j loop0
	
finloop0:
	bgez $s0 finconvolution		#valeur absolue
	sub $s0 $0 $s0			#0-$s0 (-$s0)
	
finconvolution:
	beq $s5 8 conv8b
	beq $s5 4 conv4b

conv8b:	
	li $t0 255
	lw $t1 seuil8
	j convEndSwitch

conv4b:	
	li $t0 15
	lw $t1 seuil4
	j convEndSwitch

convEndSwitch:
	ble $s0 $t0 convOk		#seuil 255/15
	move $s0 $t0

convOk:
	bge $s0 $t1 convOk2		#seuil 0 
	li $s0 0

convOk2:
	move $v0 $s0
	
##### épilogue

	lw $s0 0($sp)
	lw $s1 4($sp)
	lw $s2 8($sp)
	lw $s3 12($sp)
	lw $a0 16($sp)
	lw $a1 20($sp)
	lw $a2 24($sp)
	lw $ra 28($sp)
	lw $s7 32($sp)
	addu $sp $sp 36
	jr $ra

########## storeConvolution : stocker le resultat du produit de convolution
##### arg1 : $a0 = adresse de stockage
##### arg2 : $a1 = Fx/Fy

##### prec1 : $s4 = largeur de l'image
##### prec2 : $s5 = profondeur de codage de la couleur
##### prec3 : $s6 = hauteur de l'image

storeConv:

##### prologue

	subu $sp $sp 36
	sw $a0 0($sp)
	sw $a1 4($sp)
	sw $s4 8($sp)
	sw $s5 12($sp)
	sw $s6 16($sp)
	sw $ra 20($sp)	
	sw $s0 24($sp)
	sw $s1 28($sp)
	sw $s2 32($sp)

##### code

	li $s0 -1			#compteur i
storeConvLoop1:
	beq $s0 $s6 storeConvEnd

	addi $s0 $s0 1
	li $s1 0			#compteur j
	
storeConvLoop2:	
	beq $s1 $s4 storeConvLoop1

	move $a0 $a1
	move $a1 $s0
 	move $a2 $s1
 	jal convolution
 	
 	move $t0 $v0

	lw $a0 0($sp)
	move $a1 $s0
	move $a2 $s1
	move $a3 $t0
	jal setElementA

	lw $a1 4($sp)

	addi $s1 $s1 1
	j storeConvLoop2

##### épilogue

storeConvEnd:
	lw $a0 0($sp)
	lw $a1 4($sp)
	lw $s4 8($sp)
	lw $s5 12($sp)
	lw $s6 16($sp)
	lw $ra 20($sp)
	lw $s0 24($sp)
	lw $s1 28($sp)
	lw $s2 32($sp)
	addu $sp $sp 36
	jr $ra	

########## addMat : addition des 2 matrices
##### arg1 : $a0 = adresse de stockage
##### arg2 : $a1 = adresse de Gx
##### arg3 : $a2 = adresse de Gy

##### prec : $s5 = profondeur de codage de la couleur

addMat:

##### prologue	

	subu $sp $sp 32
	sw $a0 0($sp)
	sw $a1 4($sp)
	sw $a2 8($sp)
	sw $ra 12($sp)
	sw $s0 16($sp)
	sw $s1 20($sp)
	sw $s2 24($sp)
	sw $s3 28($sp)

##### code

	li $s0 -1			#compteur i
	
addLoop0:
	beq $s0 $s6 addEnd

	addi $s0 $s0 1
	li $s1 0			#compteur j
	
addLoop1:
	beq $s1 $s4 addLoop0

	move $a1 $s0
	move $a2 $s1
	lw $a0 4($sp)
	jal getElementA
	move $s2 $v0
	lw $a0 8($sp)
	jal getElementA
	move $s3 $v0
	
	addu $t0 $s2 $s3		#Gx(i,j) + Gy(i,j)

	beq $s5 8 add8b
	beq $s5 4 add4b

add8b:	
	li $t1 255
	lw $t2 seuil8
	j addEndSwitch

add4b:
	li $t1 15
	lw $t2 seuil4
	j addEndSwitch

addEndSwitch:
	ble $t0 $t1 addOk
	move $t0 $t1

addOk:
	bge $t0 $t2 addOk2
	li $t0 0

addOk2:
	lw $a0 0($sp)
	move $a1 $s0
	move $a2 $s1
	move $a3 $t0
	jal setElementA

	addi $s1 $s1 1
	j addLoop1

##### épilogue

addEnd:
	lw $a0 0($sp)
	lw $a1 4($sp)
	lw $a2 8($sp)
	lw $ra 12($sp)
	lw $s0 16($sp)
	lw $s1 20($sp)
	lw $s2 24($sp)
	lw $s3 28($sp)
	addu $sp $sp 32
	jr $ra	

########## fileName
##### remplacer '\n' par '\0'
##### rajouter Contour au nom du fichier de sortie

fileName:
	li $t0, 0			#compteur
	li $t1, 30			#max
name:
	beq $t0, $t1, nameEnd
	lb $t2, fileIn($t0)			
	sb $t2 fileOut($t0)		#copie dans fileOut
	bne $t2, 0x2e, name2		#si c'est un point, mettre l'indice dans $t3
	move $t3 $t0
name2:
	bne $t2, 0x0a, nameLoop
	sb $zero, fileIn($t0)		#remplacer '\n' par '\0'
	j nameEnd
nameLoop:
	addi $t0, $t0, 1
	j name
nameEnd:
	la $t0 0x43			#écrire Contour.bmp à partir du .
	sb $t0 fileOut($t3)
	addi $t3 $t3 1
	la $t0 0x6f
	sb $t0 fileOut($t3)
	addi $t3 $t3 1
	la $t0 0x6e
	sb $t0 fileOut($t3)
	addi $t3 $t3 1
	la $t0 0x74
	sb $t0 fileOut($t3)
	addi $t3 $t3 1
	la $t0 0x6f
	sb $t0 fileOut($t3)
	addi $t3 $t3 1
	la $t0 0x75
	sb $t0 fileOut($t3)
	addi $t3 $t3 1
	la $t0 0x72
	sb $t0 fileOut($t3)
	addi $t3 $t3 1
	la $t0 0x2e
	sb $t0 fileOut($t3)
	addi $t3 $t3 1
	la $t0 0x62
	sb $t0 fileOut($t3)
	addi $t3 $t3 1
	la $t0 0x6d
	sb $t0 fileOut($t3)
	addi $t3 $t3 1
	la $t0 0x70
	sb $t0 fileOut($t3)
	jr $ra
