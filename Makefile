all: lexico.l  analizadorSintactico.y
	lex lexico.l
	yacc -d analizadorSintactico.y
	gcc y.tab.c lex.yy.c -o analizadorSintactico

clean:
	rm -f analizadorSintactico lex.yy.c y.tab.c y.tab.h 
