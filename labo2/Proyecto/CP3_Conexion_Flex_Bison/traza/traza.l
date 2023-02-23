%{
 #include <string>
 #include <iostream>
 #include <vector>
 #include "traza.hpp" 
 using namespace std ;

 #define TOKEN(t) processtoken(t, string(yytext, yyleng))

 void processtoken (int t, string id) {
   cout << t << " <" << id << ">" << endl ;
 }

%}
%option nounput
%%
programa                TOKEN(RPROGRAM) ;
{                TOKEN(RBEGIN) ;
}	                TOKEN(RENDPROGRAM) ;

"*"                     TOKEN(TMUL);

":="                     TOKEN(TASSIG);

";"                     TOKEN(TSEMIC);


[ \t\n]                 ;

 

[a-zA-Z][a-zA-Z0-9]*    TOKEN(TIDENTIFIER) ; 
[0-9]+\.[0-9]*          TOKEN(TDOUBLE);
[0-9]+                  TOKEN(TINTEGER); 

.                      { cout << "Token desconocido: " << yytext << endl; yyterminate();}
%%

int main() {
  yylex() ;
  cout << "Ha finalizado." << endl ; 
}
