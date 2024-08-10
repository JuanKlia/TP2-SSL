%{
#include <stdio.h>    
#include <stdlib.h>
#include <string.h>  // Necesario para strdup y strcmp

// Nodo
typedef struct NodoIdentificador
{
    char* valor;
    int repeticiones;
    struct NodoIdentificador *siguiente;
} NodoIdentificador;

// Lista
typedef struct Lista
{
    int tamanio;
    NodoIdentificador *cabeza; // Primer elemento
} Lista;
Lista *listaIdentificadores;
void insertar_final(Lista *lista, NodoIdentificador *nodoNuevo);
NodoIdentificador *buscar_nodo(Lista *lista, char* valorBuscado);

void enlistar_identificador(char* identificador){
    NodoIdentificador *resultadoBusqueda = buscar_nodo(listaIdentificadores, identificador);
    if(resultadoBusqueda == NULL){
            //Creamos uno nuevo
            NodoIdentificador *nodoNuevo = (NodoIdentificador *)malloc(sizeof(NodoIdentificador));
            nodoNuevo->valor = strdup(identificador);
            nodoNuevo->repeticiones = 1;
            nodoNuevo->siguiente = NULL;
           insertar_final(listaIdentificadores, nodoNuevo);
    }else{
        //Le sumamos una repeticion
        resultadoBusqueda->repeticiones = resultadoBusqueda->repeticiones+1;
    }
}


%}

%option noyywrap

IDENTIFICADOR [_a-zA-Z][_a-zA-Z0-9]*

%%

{IDENTIFICADOR} { enlistar_identificador(yytext);} 

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
    printf("\t *Listado de identificadores encontrados:\n");
    while (actual != NULL)
    {   
        printf("\t %s: aparece %d veces\n",actual->valor, actual->repeticiones); 
        actual = actual->siguiente;
    }
    fclose(archivo);
    return 0;
}


void insertar_final(Lista *lista, NodoIdentificador *nodoNuevo)
{
    if (lista->tamanio == 0)
    {
        lista->cabeza = nodoNuevo;
        
    }
    else
    { // Ya hay más de un nodo
       NodoIdentificador *nodoAux;
       nodoAux = lista->cabeza;
       while(nodoAux->siguiente != NULL){
         nodoAux = nodoAux->siguiente;
       }

       nodoAux->siguiente = nodoNuevo;
       
    }
    lista->tamanio = lista->tamanio + 1;
    
}


NodoIdentificador *buscar_nodo(Lista *lista, char* valorBuscado)
{
    NodoIdentificador *buscador = lista->cabeza;

    while (buscador != NULL)
    {
        if (strcmp(buscador->valor, valorBuscado) == 0)
        {
            break; // termina el bucle con buscador apuntando al nodo buscado
        }
        else
        {
            buscador = buscador->siguiente; //Hasta null en la cola
        }
    }
    return buscador; //apunta al nodo buscado, o apunta a null
};
