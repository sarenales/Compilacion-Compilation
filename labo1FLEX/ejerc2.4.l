%{  
int contadorID = 0;
int contador = 0;
%}
string [a-zA-Z][a-zA-Z0-9]*
int [0-9]+

%%
[Pp][Rr][Oo][Cc][Ee][Dd][Uu][Rr][Ee] ;
[Bb][Ee][Gg][Ii][Nn]                 ;
\/\/(.)*\n			     ;
\-?{int}\.{int}([Ee][+-]?{int})?     {plusReal();}
{string}(_[a-zA-Z0-9]+)*	     {plusId();}
\n    				     ;
.      				     ;
%%
main() {
  yylex() ;
  printf("Contado IDs: %d \n Contador Nums Reales: %d \n", contadorID, contador);
}
plusId(){
	contadorID++;
}
plusReal(){
	contador++;
}
