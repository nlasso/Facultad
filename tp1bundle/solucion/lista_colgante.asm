global lista_crear
global lista_borrar
global lista_concatenar
global lista_ahijar
global lista_imprimir
global lista_filtrar
global lista_colapsar
global nodo_crear
global lista_colgar_descendiente

global tiene_ceros_en_decimal
global parte_decimal_mayor_que_un_medio
global tiene_numeros

global raiz_cuadrada_del_producto
global raiz_de_la_suma
global revolver_primeras_5

; auxiliares ...


; cambiar las xxx por su valor correspondiente

%define TAM_LISTA 8
%define TAM_NODO 28
%define TAM_dato_int 4
%define TAM_dato_double 8
%define TAM_puntero 8
%define TAM_value 8
%define offset_primero   0
%define offset_tipo      0
%define offset_siguiente 4
%define offset_hijo      12
%define offset_valor     20

%define ENUM_int 0
%define ENUM_double 1
%define ENUM_string 2

%define NULL 0

extern fprintf
extern fopen
extern fclose
extern malloc
extern free


section .data

;----------FILE mode-------

modoFOpen: DB 'a', 0

;-------constant structure strings-------

llaveAbrir: DB '{ ', 0
llaveCerrar: DB ' }', 0
corcheteAbrir: DB '[ ', 0
corcheteCerrar: DB ' ]', 0
espacio: DB ' ', 0 
listaVacia: DB '<vacia>', 0

;-------print structures--------

printOneString: DB '%s', 0
string: DB '%s%s%s', 0
double: DB '%f', 0
int:	DB '%i', 0

section .text
; ~ lista* lista_crear()
lista_crear:
	PUSH rbp
	MOV rbp, rsp

	MOV rdi, TAM_LISTA
	CALL malloc
	MOV qword[rax], NULL

	POP rbp
	ret

; ~ nodo_t* nodo_crear(tipo_elementos tipo, valor_elemento value)
nodo_crear:
	PUSH rbp
	MOV rbp, rsp
	PUSH r15
	PUSH r14
	PUSH r13
	SUB rsp, 8
	
	MOV r15, rdi
	MOV r14, rsi
	MOV rdi, TAM_NODO
	CALL malloc
	MOV r13, rax
	MOV [r13 + offset_tipo], r15
	MOV qword[r13 + offset_siguiente], NULL
	MOV qword[r13 + offset_hijo], NULL
	CMP r15, ENUM_double
	JE .crearTipoDouble
	MOV [r13 + offset_valor], r14
	JMP .fin

.crearTipoDouble:
	MOVQ [r13 + offset_valor], xmm0

.fin:
	ADD rsp, 8
	POP r13
	POP r14
	POP r15
	POP rbp	
	ret

; ~ void lista_borrar(lista *self)
lista_borrar:
	PUSH rbp
	MOV rbp, rsp
	PUSH r15
	SUB rsp, 8

	MOV r15, rdi
	MOV rdi, [rdi]
	CALL borrarNodos
	MOV rdi, r15
	CALL free

	ADD rsp, 8
	POP r15
	POP rbp
	ret

; ~ void borrarNodos(nodo *self)
borrarNodos:
	PUSH rbp
	MOV rbp, rsp
	PUSH r15
	SUB rsp, 8

	MOV r15, rdi
	CMP qword [r15 + offset_siguiente], NULL
	JE borrarHijos
	MOV rdi, [r15 + offset_siguiente]
	CALL borrarNodos

borrarHijos:
	CMP qword [r15 + offset_hijo], NULL
	JE borrarActual
	MOV rdi, [r15 + offset_hijo]
	CALL borrarNodos

borrarActual:
	CMP qword[r15 + offset_tipo], ENUM_string
	JNE .fin
	MOV rdi, [r15 + offset_valor]
	CALL free

.fin:
	MOV rdi, r15
	CALL free
	ADD rsp, 8
	POP r15
	POP rbp
	ret

; ~ void lista_imprimir(lista *self, char *archivo)
lista_imprimir:
	PUSH rbp
	MOV rbp, rsp
	PUSH r15
	PUSH r14
	PUSH r13
	SUB rsp, 8

	MOV r15, rdi
	MOV r14, rsi
	MOV rsi, modoFOpen
	MOV rdi, r14
	CALL fopen
	MOV r13, rax
	CMP qword[r15], NULL
	JE .ImprimirVacia
	MOV rdi, r13
	MOV rsi, [r15 + offset_primero]
	CALL imprimirNodos
	JMP .fin

.ImprimirVacia:
	MOV rdi, r13
	MOV rsi, printOneString
	MOV rdx, listaVacia
	MOV rax, 1
	CALL fprintf

.fin:
	MOV rdi, r13
	CALL fclose
	ADD rsp, 8
	POP r13
	POP r14
	POP r15
	POP rbp
	ret

; ~ void imprimirNodos(FILE *file, nodo *nodo)
imprimirNodos:
	PUSH rbp
	MOV rbp, rsp
	PUSH r15
	PUSH r14


	MOV r15, rdi
	MOV r14, rsi
	MOV rsi, printOneString								;Imprimo la llave
	MOV rdx, llaveAbrir
	MOV rax, 1
	CALL fprintf
	
	MOV rdi, r15
	MOV rsi, r14
	CALL imprimirValor									;imprimo el valor

	CMP qword[r14 + offset_hijo], NULL
	JE finalizarCadena
	MOV rdi, r15
	MOV rsi, [r14 + offset_hijo]
	CALL imprimirHijos

finalizarCadena:
	MOV rdi, r15
	MOV rsi, printOneString
	MOV rdx, llaveCerrar
	MOV rax, 1
	CALL fprintf


	CMP qword[r14 + offset_siguiente], NULL
	JE .fin
	MOV rdi, r15
	MOV rsi, printOneString
	MOV rdx, espacio
	MOV rax, 1
	CALL fprintf
	MOV rdi, r15
	MOV rsi, [r14 + offset_siguiente]
	CALL imprimirNodos

.fin:
	POP r14
	POP r15
	POP rbp
	ret

; ~ void imprimirHijos(FILE *file, nodo *nodo)
imprimirHijos:
	PUSH rbp
	MOV rbp, rsp
	PUSH r15
	PUSH r14

	MOV r15, rdi
	MOV r14, rsi
	MOV rdi, r15
	MOV rsi, r14
	CALL imprimirValor
	CMP qword[r14 + offset_hijo], NULL
	JE .fin
	MOV rdi, r15
	MOV rsi, [r14 + offset_hijo]
	CALL imprimirHijos

.fin:
	POP r14
	POP r15
	POP rbp
	ret

; ~ void imprimirValor(FILE *file, nodo *nodo)
imprimirValor:
	PUSH rbp
	MOV rbp, rsp
	PUSH r15
	PUSH r14

	MOV r15, rdi
	MOV r14, rsi
	MOV rsi, printOneString
	MOV rdx, corcheteAbrir
	MOV rax, 1
	CALL fprintf
	MOV rdi, r15
	CMP dword[r14 + offset_tipo], ENUM_string
	JE .printString
	CMP dword [r14 + offset_tipo], ENUM_double
	JE .printDouble
	MOV rsi, int
	MOV rdx, [r14 + offset_valor]
	JMP .fin

.printString:
	MOV rsi, string
	MOV rdx, [r14 + offset_valor]
	JMP .fin

.printDouble:
	MOV rsi, double
	MOVQ xmm0, [r14 + offset_valor]

.fin:
	MOV rax, 1
	CALL fprintf
	MOV rdi, r15
	MOV rsi, printOneString
	MOV rdx, corcheteCerrar
	MOV rax, 1
	CALL fprintf
	POP r14
	POP r15
	POP rbp
	ret

; ~ void lista_concatenar(lista *self, nodo_t *nodo)
lista_concatenar:
	PUSH rbp
	MOV rbp, rsp
	PUSH r15
	PUSH r14

	MOV r15, rdi
	MOV r14, rsi
	CMP qword[r15], NULL
	JE .cargarNodo
	MOV r15, [r15 + offset_primero]
	MOV rdi, r15
	CALL buscarUltimo
	MOV r15, rax
	MOV [r15 + offset_siguiente], r14
	JMP .fin

.cargarNodo:
	MOV [r15], r14

.fin:
	POP r14
	POP r15
	POP rbp
	ret

; ~ nodo_t* buscarUltimo(nodo_t *nodo)
buscarUltimo:
	PUSH rbp
	MOV rbp, rsp	
	PUSH r15
	SUB rsp, 8
	
	MOV r15, rdi
.loopSiguiente:
	CMP qword [r15 + offset_siguiente], NULL
	JE .fin
	MOV r15, [r15 + offset_siguiente]
	JMP .loopSiguiente

.fin:
	MOV rax, r15
	ADD rsp, 8
	POP r15
	POP rbp
	ret

; ~ void lista_colgar_descendiente(lista *self, uint posicion, nodo_t *nodo)
lista_colgar_descendiente:
	PUSH rbp
	MOV rbp, rsp
	PUSH r15
	PUSH r14
	PUSH r13

	MOV r15, [rdi]
	MOV r14, rsi
	MOV r13, rdx

buscarPosicion:
	CMP r14, NULL
	JE buscarHijo
	MOV r15, [r15 + offset_siguiente]
	SUB r14, 1
	JMP buscarPosicion

buscarHijo:
	CMP qword[r15 + offset_hijo], NULL
	JE .fin
	MOV r15, [r15 + offset_hijo]
	JMP buscarHijo

.fin:
	MOV [r15 + offset_hijo], r13
	POP r15
	POP r14
	POP r13
	POP rbp
	ret

; ~ void lista_filtrar(lista *self, nodo_bool_method method)
lista_filtrar:
	ret


; ~ lista* lista_colapsar(lista *self, lista_bool_method test_method, valor_elemento_method value_method)
lista_colapsar:
	ret

; ... funciones auxiliares y adicionales



