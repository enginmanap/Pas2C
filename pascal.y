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

%token <num> CONST_INTEGER
%token <str> CONST_STRING
%token BLOCK_BEGIN
%token BLOCK_END
%token VAR_BLOCK_START
%token CONST_BLOCK_START
%token DEF_INTEGER
%token EQUAL_SIGN
%token SEMICOLON
%token ASSIGNMENT
%token START_PROGRAM
%token PERIOD
%token COMMA
%token COLON
%token DOUBLE_QUOTES
%token <str> VARIABLE


%type <str> program block math variable_declaration assignment stmt stmt_list main_block program_definition function const_string math_value const_val
%type <str> const_block var_block const_declaration const_declaration_list variable_declaration_list func_parameter func_parameter_list

%%
 
program:
	program_definition				{ printf("%s\n", $1); }
	;

const_block:
	CONST_BLOCK_START const_declaration_list		{ $$ = $2; }
	|						{ $$ = "";}
	;

var_block:
	VAR_BLOCK_START	variable_declaration_list	{ $$ = $2; }
	|						{ $$ = "";}
	;

program_definition:	
	START_PROGRAM VARIABLE SEMICOLON const_block var_block main_block	{ $$ = strconcat("int main() {", strconcat($4, strconcat($5, $6)));}
	;

main_block:
	BLOCK_BEGIN stmt_list BLOCK_END PERIOD		{ $$ = strconcat($2,"}"); }

const_val:
	CONST_INTEGER					{ $$ = intToStr($1); }

block:
	BLOCK_BEGIN stmt_list BLOCK_END	SEMICOLON	{ $$ = strconcat("{", strconcat($2,"}")); }

stmt_list:
	stmt						{ $$ = $1; }
	| stmt_list stmt				{ $$ = strconcat($1, $2); }
stmt:
	math						{ $$ = $1; }
	| assignment 					{ $$ = $1; }
	| function					{ $$ = $1; }
	| block						{ $$ = $1; }

math_value:
	const_val					{ $$ = $1; }
	| VARIABLE					{ $$ = $1; }
math:
	math_value SEMICOLON				{ $$ = strconcat($1, ";"); }
	| math_value '+' math				{ $$ = strconcat($1, strconcat("+", $3)); }
	| math_value '-' math				{ $$ = strconcat($1, strconcat("-", $3)); }
	| math_value '*' math				{ $$ = strconcat($1, strconcat("*", $3)); }
	| math_value '/' math				{ $$ = strconcat($1, strconcat("/", $3)); }

const_declaration_list:
	const_declaration				{ $$ = $1; }
	| const_declaration_list const_declaration	{ $$ = strconcat($1,$2); }

const_declaration:
	VARIABLE EQUAL_SIGN CONST_INTEGER SEMICOLON	{ $$ = strconcat("const int ", strconcat($1, strconcat("=", strconcat(intToStr($3),";"))));}

variable_declaration_list:
	variable_declaration				{ $$ = $1; }
	| variable_declaration_list variable_declaration	{ $$ = strconcat($1,$2); }

variable_declaration:
	VARIABLE COLON DEF_INTEGER SEMICOLON		{ $$ = strconcat("int ", strconcat($1, ";"));}


assignment:
	VARIABLE ASSIGNMENT math			{ $$ = strconcat($1, strconcat("=",$3)); }

func_parameter_list:
	func_parameter					{ $$ = $1;}
	| func_parameter_list COMMA func_parameter	{ $$ = strconcat($1, strconcat(",",$3));}

func_parameter:
	const_string					{ $$ = $1; VariableAttributes var; var.name="str"; var.data.un_str=$1; addParameterToList(var);}
	| VARIABLE					{ $$ = $1; VariableAttributes var; var.name="var"; var.data.un_str=$1; addParameterToList(var);}
	| CONST_INTEGER					{ $$ = intToStr($1); VariableAttributes var; var.name="int"; var.data.un_int=$1; addParameterToList(var);}

function:
	VARIABLE '(' func_parameter_list ')' SEMICOLON	{ $$ = createCVariantFor($1); }

const_string:
	CONST_STRING			 		{ $$ = $1; }


%%
void yyerror(char *s) {
	fprintf(stderr, "%s\n", s);
}

int main(void) {
	generateHeader();
	yyparse();
	return 0;
}

