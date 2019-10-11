.MODEL SMALL
.STACK
.DATA

igual DB 'Son iguales $'
mayorP DB 'El primero es mayor'
mayorS DB 'El segundo es mayor$'
input DB 'Ingrese un numero $'

num1 DB ?
num2 DB ?

.CODE
PROGRAMA:

MOV AX,@DATA
MOV DS, AX

;Imprimir input
XOR AX,AX
MOV DX, OFFSET input
MOV AH,09H
INT 21H

;Guardar num1
XOR AX,AX
MOV AH,01H
INT 21H
MOV num1,DL
SUB num1,30H

;Imprimir input
XOR AX,AX
MOV DX, OFFSET input
MOV AH,09H
INT 21H

;Guardar num1
MOV AH,01H
INT 21H
MOV num2,DL
SUB num2,30H

;Comparacion
MOV DL,num1
CMP DL,num2
JZ isEqual
JG first
JMP second


isEqual:
    XOR AX,AX
    MOV DX, OFFSET igual
    MOV AH,09H
    INT 21H
    JMP TERMINAR

first:
    XOR AX,AX
    MOV DX, OFFSET mayorP
    MOV AH,09H
    INT 21H
    JMP TERMINAR
    
second:
    XOR AX,AX
    MOV DX, OFFSET mayorS
    MOV AH,09H
    INT 21H
    JMP TERMINAR

TERMINAR:
MOV AH,4CH
INT 21H

END PROGRAMA