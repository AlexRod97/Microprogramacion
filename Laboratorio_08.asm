;Macro para hacer el factorial de un numero
Factorial MACRO number,result
	PUSHA
	
	XOR EAX , EAX
	XOR ECX , ECX

	MOV EAX , 1
	MOV CL , number
	operate:	
		MUL ECX
	LOOP operate
	MOV result , EAX
	POPA
ENDM

.386
.MODEL FLAT, STDCALL 
OPTION CASEMAP:NONE

INCLUDE \masm32\include\windows.inc 
INCLUDE \masm32\include\kernel32.inc
INCLUDE \masm32\include\masm32.inc
INCLUDE \masm32\include\masm32rt.inc 
INCLUDELIB \masm32\lib\kernel32.lib
INCLUDELIB \masm32\lib\masm32.lib
;Librerias importantes


.DATA
    UserMessage DB "Ingrese solo numeros menores a 120",0
	InputMessage DB 0ah,0dh,"Ingrese un numero de tres digitos",10,13,0
	OutputMessage DB "Factorial de: ",0
	diez DB 10
;Mensajes de interaccion con el usuario

.DATA?

	input DB 3 dup(?) ;Elemento de tres posiciones
	num DB ?
	result DD ?
;Variables

.CODE

;Main code
program:
main PROC
	INVOKE StdOut, ADDR UserMessage ; Mensaje para usuario
	INVOKE StdOut, ADDR InputMessage ;Mensaje de ingreso de un numero
	INVOKE StdIn, ADDR input, 10 ; Valor a leer

	MOV num , 0
	MOV AL , input[2]
	SUB AL , 30h
	ADD num , AL

	MOV AL , input[1]
	SUB AL , 30h
	MUL diez
	ADD num , AL

	MOV AL , input[0]
	SUB AL , 30h
	MUL diez
	MUL diez
	ADD num , AL

	INVOKE StdOut, ADDR OutputMessage
	print str$(num),10,13
	Factorial num,result
	print str$(result),10,13


end:
	INVOKE ExitProcess,0
main ENDP


END program