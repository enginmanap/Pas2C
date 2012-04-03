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
%token DEF_INTEGER
%token SEMICOLON
%token ASSIGNMENT
%token <str> VARIABLE


%type <str> program block math definition assignment stmt stmt_list
%type <num> const_val

%%

program:
	program block				{ printf(" %s \n", $2); }
	|
	;

const_val:
	INTEGER					{ $$ = $1; }

block:
	BLOCK_BEGIN stmt_list BLOCK_END		{ $$ = strconcat("{", strconcat($2,"}")); }

stmt_list:
	stmt					{ $$ = $1; }
	| stmt_list stmt			{ $$ = strconcat($1, $2); }
stmt:
	math					{ $$ = $1; }
	| definition	 			{ $$ = $1; }
	| assignment 				{ $$ = $1; }
	| block					{ $$ = $1; }
math:
	const_val SEMICOLON			{ $$ = strconcat(intToStr($1), ";"); }
	| const_val '+' const_val SEMICOLON	{ $$ = strconcat(intToStr($1), strconcat("+", strconcat(intToStr($3), ";"))); }
	| const_val '-' const_val SEMICOLON	{ $$ = strconcat(intToStr($1), strconcat("-", strconcat(intToStr($3), ";"))); }
	| const_val '*' const_val SEMICOLON	{ $$ = strconcat(intToStr($1), strconcat("*", strconcat(intToStr($3), ";"))); }
	| const_val '/' const_val SEMICOLON	{ $$ = strconcat(intToStr($1), strconcat("/", strconcat(intToStr($3), ";"))); }

definition:
	 DEF_INTEGER VARIABLE SEMICOLON		{ $$ = strconcat("int ", strconcat($2, ";"));}

assignment:
	VARIABLE ASSIGNMENT math			{ $$ = strconcat($1, strconcat("=",$3)); }
	

%%
void yyerror(char *s) {
	fprintf(stderr, "%s\n", s);
}

int main(void) {
	yyparse();
	return 0;
}

