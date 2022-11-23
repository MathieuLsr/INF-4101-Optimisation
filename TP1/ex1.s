; Perrine MOOOOOOOLINAAAAS :) <3 alias Noopy
; Mathieu LESUR alias Le Boss

; 16 cycles & 5 instructions pour l'addition
; 19 cycles & 5 instructions pour la multiplication

.data
A: .double 2
B: .double 4
C: .double 0

.text
l.d f1,A(r0)
l.d f2,B(r0)
; add.d f4,f1,f2
mul.d f4,f1,f2
s.d f4,C(r0)
halt
