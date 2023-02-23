
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
comienzo                TOKEN(RBEGIN) ;
fin	                TOKEN(RENDPROGRAM) ;

"*"                     TOKEN(TMUL);

"="                     TOKEN(TASSIG);

";"                     TOKEN(TSEMIC);

[ \t\n]                 ;

[a-zA-Z][a-zA-Z0-9]*    TOKEN(TIDENTIFIER) ; 
[0-9]+\.[0-9]+([eE][-+]?[0-9]+)?       TOKEN(TDOUBLE);
[1-9][0-9]*|0                  TOKEN(TINTEGER); 


\$[a-zA-Z](-?[a-zA-Z0-9])*-? TOKEN(TVAR26);
\$[a-zA-Z](_?_?[a-zA-Z0-9])* TOKEN(TVAR28);



.                       { cout << "Token desconocido: " << yytext << endl; yyterminate();}
%%

int main() {
  yylex() ;
  cout << "Ha finalizado." << endl ; 
}
