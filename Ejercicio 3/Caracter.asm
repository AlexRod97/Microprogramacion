.MODEL small
.DATA
; Variable que contiene el texto que queremos mostrar
nombre DB 'El simbolo elegido es: $'; $ significa el final de la cadena 

.STACK 
.CODE

Programa:              ; etiqueta de inicio de programa
;inicializar programa
MOV AX, @Data          ; guardando direccion de inicio de 
MOV DS, AX

; Imprimir nombre
MOV DX, OFFSET nombre ;asignando a DX la variable nombre
MOV AH, 09h           ;decimos que se imprimira una cadena
INT 21h               ;ejecuta la interrupcion, imprimira

;Salto de linea
MOV DX, 26h           ;10 es el valor ascii del enter
MOV AH,02h            ;decimos que se imprimira una cadena
INT 21h               ;ejecuta la interrupcion, imprimira

; finalizar programa
MOV AH, 4Ch           ; finalizar proceso 
INT 21h               ; ejecuta la interrupcion
END programa