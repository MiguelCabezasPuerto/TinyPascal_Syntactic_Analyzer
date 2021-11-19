%{
#include "y.tab.h"
#include <stdio.h>

void tokenInesperado(char caracter)
{
    fprintf(stderr, "Error lexico, caracter inesperado '%c' linea %d\n", caracter, yylineno);
    exit(EXIT_FAILURE);
}

%}

%option noyywrap
%option caseless
%option yylineno

DIGITO 				[0-9]
DIGITOS  			{DIGITO}+
ENTERO 				{DIGITOS}
FLOAT				{ENTERO}(\.{DIGITOS}([Ee][+-]?{DIGITOS})?)
NUMERO 				{DIGITOS}

%%
[ \t]			                    ;
\n				                    {}
"{"[^"}"]*"}"                       ;
"program"                           { return PROGRAM; }
"var"                               { return VAR; }
"integer"                           { return ENTERO; }
"real"                              { return REAL; }
"array"                             { return ARRAY; }
"of"                                { return OF; }
"function"                          { return FUNCTION; }
"procedure"                         { return PROCEDURE; }
"not"                               { return NOT; }
"if"                                { return IF; }
"else"                              { return ELSE; }
"end"                               { return END; }
"then"                              { return THEN; }
"begin"                             { return BEGIN_; }
"while"                             { return WHILE; }
"do"                                { return DO; }
:=					                { return ASIGNACION; }
"<="|">="|"<>"|"="                  { return COMPARACION; }
"<"|">"                             { return COMPARACION; }
[+-]				                { return SUMA_RESTA; }
[*\/]				                { return MULTIPLICACION_DIVISION_MODULO; }
"mod"                               { return MULTIPLICACION_DIVISION_MODULO; }
"div"                               { return MULTIPLICACION_DIVISION_MODULO; }
{ENTERO}|{FLOAT}	                { return NUMERO; }
[a-zA-Z][_a-zA-Z0-9]*		        { return ID_VARIABLE; }
"("|")"|","|"+"|"-"|";"|":"|"."     { return *yytext; }
.                                   { tokenInesperado(yytext[0]); }
%%
