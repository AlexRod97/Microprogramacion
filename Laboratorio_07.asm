.386
.model flat, stdcall
option casemap:none


include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
include \masm32\include\masm32rt.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib
;Librerias importantes


.DATA

input DB "Ingrese un numero:  ",0,13h,10h

sum DB "Suma: ",0,13,10h
substract DB "Resta: ",0,13,10h

greater DB "Es mayor ",0,13,10h
equal DB "Son iguales ",0,13,10h
;Mensajes de interaccion con usuario

.DATA?

input1 Dw ?
input2 Dw ?

.code

PROGRAM:

MAIN PROC

INVOKE StdOut, addr input
INVOKE StdIn, addr input1,10	
XOR BX,BX
MOV BX,input1
SUB BX,30h
;lee el primer numero


INVOKE StdOut, addr input
INVOKE StdIn, addr input2,10	
SUB input2,30h
; lee el segundo numero


ADD BX,input2	
INVOKE StdOut, addr sum
print str$(BX),13,10
SUB input1,30h	
XOR BX,BX
MOV BX,input1
;realiza la suma

SUB BX,input2 
INVOKE StdOut, addr substract
print str$(BX),13,10
XOR BX,BX
MOV BX,input1
;realiza la resta


CMP BX,input2 ; realiza la comparacion

JG  input1Greater ;si input1 es mayor

JL  input2Greater ;si input2 es mayor

JE  equalInput ;si son iguales



input1Greater:
INVOKE StdOut, addr greater
print str$(BX),13,10
JMP end
;Si la entrada 1 es mayor


input2Greater:
XOR BX,BX
MOV BX,input2
INVOKE StdOut, addr greater
print str$(BX),13,10
JMP end
;Si la entrada 2 es mayor

equalInput:
INVOKE StdOut, addr equal
JMP end

;Si las entradas son iguales


end:
INVOKE ExitProcess,0
;Salida


MAIN ENDP

END PROGRAM