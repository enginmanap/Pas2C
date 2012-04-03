%{
  #include <stdlib.h>
  void yyerror(char *);
  #include "y.tab.h"
%}

digit           [0-9]
alpha           [a-zA-Z]
variable 	{alpha}({alpha}|{digit})*

%%

"program"	{ return START_PROGRAM; }
"begin"		{ return BLOCK_BEGIN; }
"end"		{ return BLOCK_END;  }
"integer"	{ return DEF_INTEGER; }
":="		{ return ASSIGNMENT; }
"."		{ return PERIOD; }
":"		{ return COLON; }

{variable}	{
		  yylval.str = strdup(yytext);
		  return VARIABLE;
		}
[0-9]+		{
		  yylval.num = atoi(yytext);
		  return INTEGER;
		}
[-+/*]		return *yytext;
;		return SEMICOLON;

[ \t\n]+ 	; /* skip whitespace */
. yyerror("invalid character");

%%

int yywrap(void) {
	return 1;
}

