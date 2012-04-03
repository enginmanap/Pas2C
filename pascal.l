%{
  #include <stdlib.h>
  void yyerror(char *);
  #include "y.tab.h"
%}

digit           [0-9]
alpha           [a-zA-Z]
variable 	{alpha}({alpha}|{digit})*

%%

"begin"		{return BLOCK_BEGIN; }
"end"		{return BLOCK_END; }
"integer"	{return VAR_INTEGER;}

{variable}	{
		  yylval.str = yytext;
		  return VARIABLE;
		}
[0-9]+		{
		  yylval.num = atoi(yytext);
		  return INTEGER;
		}
[-+]		return *yytext;
;		return SEMICOLON;

[ \t\n]+ 	; /* skip whitespace */
. yyerror("invalid character");

%%

int yywrap(void) {
	return 1;
}

