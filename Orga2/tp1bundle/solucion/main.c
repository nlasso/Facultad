#include <stdlib.h>

#include "lista_colgante.h"

int main(int argc, char *argv[])
{	
	char nombre[] = "hola.txt";
	lista_colgante_t* lista = lista_crear();
	valor_elemento var;
	var.i = 10;
	valor_elemento var2;
	var2.i = 20;
	nodo_t* nodo1 = nodo_crear(Integer, var);
	nodo_t* nodo2 = nodo_crear(Integer, var2);
	lista_concatenar(lista, nodo1);
	lista_colgar_descendiente(lista,0, nodo2);
	lista_imprimir(lista, nombre);
	lista_borrar(lista);
	exit(0);
}
