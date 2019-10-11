.MODEL small
.DATA

input DB 'Ingrese un numero $'
par DB 'El numero es par $'
impar DB 'El numero es impar $'

num DB ? 
residuo DB ?
.STACK
.CODE

PROGRAMA:

MOV AX,@DATA
MOV DS,AX

;muestra el mensaje en input
MOV DX,OFFSET input
MOV AH,09H
INT 21H

;Almacenar el valor del usuario
XOR AX,AX
MOV AH,01H
INT 21H
MOV num,AL

;Diferencial para el valor num
SUB num,30H

;Division para obtener el valor entero
XOR AX,AX
MOV BL,num
MOV AL, 02H
DIV BL

;Mover el diferencial de residuo
MOV residuo,AH

;Revisa si el residuo es 0

CMP RESIDUO,0
JZ isOdd

;Salto si es par
isEven:
MOV DX,OFFSET par
MOV AH,09H
INT 21H
JMP finish

CMP RESIDUO,0
JGE isOdd

;Salto si es impar
isOdd:
MOV DX,OFFSET impar
MOV AH,09H
INT 21H
JMP finish

finish:
MOV AH,4CH
INT 21H

END PROGRAMA