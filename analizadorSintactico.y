%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(char *s);

#define YYERROR_VERBOSE

extern int yylineno;
extern FILE* yyin;
extern void yylex_destroy();
%}


%start Program

%token PROGRAM VAR ENTERO REAL ARRAY OF FUNCTION PROCEDURE NOT IF ELSE END THEN BEGIN_ DO WHILE
%token ID_VARIABLE NUMERO ASIGNACION COMPARACION SUMA_RESTA MULTIPLICACION_DIVISION_MODULO

%%
Program 				: PROGRAM ID_VARIABLE '(' ListadoVariables ')' ';'
						Declaraciones
						DeclaracionesSubprogram
						VariosStatement
						'.'
						;

ListadoVariables  		: ID_VARIABLE
						| ListadoVariables  ',' ID_VARIABLE
						;

Declaraciones 			: 
						| Declaraciones VAR ListadoVariables ':' Tipo ';'
						;

Tipo					: TipoEstandar
						| ARRAY '[' NUMERO '.' '.' NUMERO ']' OF TipoEstandar
						;

TipoEstandar			: ENTERO
						| REAL
						;

DeclaracionesSubprogram	: 
						| DeclaracionesSubprogram DeclaracionSubprogram ';'
						;

DeclaracionSubprogram 	: CabeceraSubprogram Declaraciones VariosStatement
						;

CabeceraSubprogram			: FUNCTION ID_VARIABLE Argumentos ':' TipoEstandar ';'
                        | PROCEDURE ID_VARIABLE Argumentos ';'
                        ;

Argumentos               : 
                        | '(' ListadoParametros ')'
                        ;

ListadoParametros          : ListadoVariables ':' Tipo
                        | ListadoParametros ';' ListadoVariables ':' Tipo
                        ;

VariosStatement       : BEGIN_ StatementsOpcionales END
                        ;

StatementsOpcionales      : 
                        | ListadoStatements
                        ;

ListadoStatements           : Statement
                        | ListadoStatements ';' Statement
                        ;

Statement               : Variable ASIGNACION Expresion
                        | Procedure
                        | VariosStatement
                        | IF Expresion THEN Statement ELSE Statement
                        | WHILE Expresion DO Statement
                        ;

Variable                : ID_VARIABLE
                        | ID_VARIABLE '[' Expresion ']'
                        ;

Procedure      		: ID_VARIABLE
                        | ID_VARIABLE '(' ListadoExpresiones ')'
                        ;


ListadoExpresiones          : Expresion
                        | ListadoExpresiones ',' Expresion
                        ;

Expresion              : ExpresionSimple
                        | ExpresionSimple COMPARACION ExpresionSimple
                        ;
ExpresionSimple       : Termino
                        | Signo Termino
                        | ExpresionSimple SUMA_RESTA Termino
                        ;

Termino                    : Factor
                        | Termino MULTIPLICACION_DIVISION_MODULO Factor
                        ;

Factor                  : ID_VARIABLE
                        | ID_VARIABLE '(' ListadoExpresiones ')'
                        | NUMERO
                        | '(' Expresion ')'
                        | NOT Factor
                        ;

Signo                    : '+'
                        | '-'
                        ;

%%

void yyerror(char *str) {
	printf("%s linea %d\n", str, yylineno);
	exit(EXIT_FAILURE);
}

int main(int argc, char* argv[]) {
    if(argc != 2) {
        printf("Modo de uso: %s <fichero>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    yyin = fopen(argv[1], "r");

    int result = yyparse();

    printf("Analisis sintactico correcto\n");

    // Clean up
    fclose(yyin);
    yylex_destroy();

    return result;
}
