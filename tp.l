%{
#include <stdio.h>    
#include <stdlib.h>
#include <string.h>  // Necesario para strdup y strcmp

struct NodoIdentificador {
    char *info;
    struct NodoIdentificador *siguiente;
};

struct NodoIdentificador *listaIdentificadores = NULL;

void insertarOrdenado(struct NodoIdentificador **lista, char *infoNodo) {
    struct NodoIdentificador *nuevoNodo = malloc(sizeof(struct NodoIdentificador));
    nuevoNodo->info = strdup(infoNodo);
    nuevoNodo->siguiente = NULL;

    printf("Insertando: %s\n", infoNodo);

    if (*lista == NULL) {
        *lista = nuevoNodo;
        printf("Lista vacia, nodo %s insertado como primer nodo\n", infoNodo);
    } else {
        struct NodoIdentificador *paux = *lista;
        while (paux->siguiente != NULL) {
            paux = paux->siguiente;
        }
        printf("Insertado %s despues de %s\n", infoNodo, paux->info);
        paux->siguiente = nuevoNodo;
    }
}
%}

%option noyywrap

IDENTIFICADOR [_a-zA-Z][_a-zA-Z0-9]*

%%

{IDENTIFICADOR} {  
    insertarOrdenado(&listaIdentificadores, yytext); 
} 

%%

int main() {
    yylex();

    struct NodoIdentificador *paux;
    while (listaIdentificadores != NULL) {
        paux = listaIdentificadores; // Guardar el puntero al nodo actual
        printf("Nodo: %s\n", paux->info); // Imprimir el nodo
        listaIdentificadores = listaIdentificadores->siguiente; // Mover al siguiente nodo
        free(paux->info); // Liberar la memoria de la cadena
        free(paux); // Liberar la memoria del nodo
    }

    return 0;
}