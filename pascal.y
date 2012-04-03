%{
  #include <stdio.h>
  #include "custom.h" 
  int yylex(void);
  void yyerror(char *);
%}

%union{
	int num;
	char* str;
}

%token <num> INTEGER
%token BLOCK_BEGIN
%token BLOCK_END
%token VAR_INTEGER
%token SEMICOLON
%token <str> VARIABLE


%type <str> program func block
%type <num> const_val

%%

program:
	program block				{ printf("\n"); }
	|
	;

const_val:
	INTEGER					{ $$ = $1; }

block:
	BLOCK_BEGIN func BLOCK_END		{ printf("{ %s }", $2); }

func:
	const_val '+' const_val SEMICOLON	{ $$ = strconcat(intToStr($1), strconcat("+", strconcat(intToStr($3), ";"))); }
	| const_val '-' const_val SEMICOLON	{ $$ = strconcat(intToStr($1), strconcat("-", strconcat(intToStr($3), ";"))); }
	| const_val '*' const_val SEMICOLON	{ $$ = strconcat(intToStr($1), strconcat("*", strconcat(intToStr($3), ";"))); }
	| const_val '/' const_val SEMICOLON	{ $$ = strconcat(intToStr($1), strconcat("/", strconcat(intToStr($3), ";"))); }
	| VAR_INTEGER VARIABLE SEMICOLON	{ $$ = strconcat("int ", strconcat($2, ";"));}

%%
void yyerror(char *s) {
	fprintf(stderr, "%s\n", s);
}

int main(void) {
	yyparse();
	return 0;
}

