%{
#include <stdio.h>    
#include <stdlib.h>
#include <string.h>  // Necesario para strdup y strcmp

// Nodo
typedef struct NodoIdentificador
{
    char* valor;
    struct NodoIdentificador *siguiente;
} NodoIdentificador;

// Lista
typedef struct Lista
{
    int tamanio;
    NodoIdentificador *cabeza; // Primer elemento
} Lista;

void insertar_principio(Lista *lista, char* valor);

Lista *listaIdentificadores;
%}

%option noyywrap

IDENTIFICADOR [_a-zA-Z][_a-zA-Z0-9]*

%%

{IDENTIFICADOR} { insertar_principio(listaIdentificadores, yytext);} 

%%

int main(int argc, char *argv[]) {
      if (argc < 2) {
        fprintf(stderr, "Uso: %s <archivo de entrada>\n", argv[0]);
        exit(1);
    }

     FILE *archivo = fopen(argv[1], "r");
    yyin = archivo;
       
    listaIdentificadores = (Lista *)malloc(sizeof(Lista));
    listaIdentificadores->tamanio=0;
    listaIdentificadores->cabeza=NULL;

    

    yylex();

     // Imprimir la lista
    NodoIdentificador *actual = listaIdentificadores->cabeza; 
    while (actual != NULL)
    {
        printf("Valor: %s\n", actual->valor); 
        actual = actual->siguiente;
    }
    fclose(archivo);
    return 0;
}

void insertar_principio(Lista *lista, char*valor)
{
    NodoIdentificador *nodoNuevo = (NodoIdentificador *)malloc(sizeof(NodoIdentificador));
    nodoNuevo->valor = strdup(valor);;

    if (lista->tamanio == 0)
    {
        lista->cabeza = nodoNuevo;
        nodoNuevo->siguiente = NULL;
    }
    else
    { // Ya hay más de un nodo
        nodoNuevo->siguiente = lista->cabeza;
        lista->cabeza = nodoNuevo;
    }
    lista->tamanio = lista->tamanio + 1;
    
}
