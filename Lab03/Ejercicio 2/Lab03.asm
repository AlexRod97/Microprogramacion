.MODEL small
.DATA

A DB ?
B DB ?
inputA DB 'Ingrese el primer numero: $'
inputB DB 'Ingrese el segundo numero: $' 
suma DB 'La suma es: $'; $ significa el final de la cadena 
resta DB 'La resta es: $'
mult DB 'La multiplicacion es: $'
division DB 'La division es: $'


.CODE
    programa:
    MOV AX, @DATA
    MOV DS, AX
    
    ; Imprimir nombre
    MOV DX, OFFSET inputA ;asignando a DX la variable suma
    MOV AH, 09h           ;decimos que se imprimira una cadena
    INT 21h               ;ejecuta la interrupcion, imprimira
    
    ;valor A
    XOR AX, AX
    MOV AH, 1h
    INT 21h
    SUB AL, 30h
    MOV A, AL
    
    
    ; Imprimir nombre
    MOV DX, OFFSET inputB ;asignando a DX la variable suma
    MOV AH, 09h           ;decimos que se imprimira una cadena
    INT 21h               ;ejecuta la interrupcion, imprimira

    ;valor B
    XOR AX, AX
    MOV AH, 1h
    INT 21h
    SUB AL, 30h
    MOV B, AL
    
    ;suma
    XOR AX, AX
    MOV AL, B
    MOV AH, A
    ADD AL, AH
    MOV DL, AL
    
    ; Imprimir nombre
    MOV DX, OFFSET suma ;asignando a DX la variable suma
    MOV AH, 09h           ;decimos que se imprimira una cadena
    INT 21h               ;ejecuta la interrupcion, imprimira

    XOR AX, AX
    MOV AH, 02h
    ADD DL, 30h
    INT 21h
    
    ;resta
    XOR AX, AX
    MOV DL, A
    SUB DL, B
    
    ; Imprimir nombre
    MOV DX, OFFSET resta ;asignando a DX la variable suma
    MOV AH, 09h           ;decimos que se imprimira una cadena
    INT 21h               ;ejecuta la interrupcion, imprimira
    
    XOR AX, AX
    MOV AH, 02h
    ADD DL, 30h
    INT 21h
    
    ;multiplicacion
    XOR DX, DX
    XOR AX, AX
    MOV AL, A
    MOV BL, B
    MUL BL
    
    ; Imprimir nombre
    MOV DX, OFFSET mult ;asignando a DX la variable suma
    MOV AH, 09h           ;decimos que se imprimira una cadena
    INT 21h               ;ejecuta la interrupcion, imprimira
    
    MOV DL, AL
    ADD DL, 30h
    MOV AH, 02h
    INT 21h
    
    ;Division
    XOR DX, DX
    XOR AX, AX
    XOR BX, BX
    MOV AL, A
    MOV BL, B
    DIV BL
    
    ; Imprimir nombre
    MOV DX, OFFSET division ;asignando a DX la variable suma
    MOV AH, 09h           ;decimos que se imprimira una cadena
    INT 21h               ;ejecuta la interrupcion, imprimira
    
    MOV DL, AL
    ADD DL, 30h
    MOV DH, AH
    MOV AH, 02h
    INT 21h
    
    MOV DL, DH
    ADD DL, 30h
    MOV AH, 02h
    INT 21h
    
    MOV AH, 4Ch
    INT 21h

.STACK
END programa
    
