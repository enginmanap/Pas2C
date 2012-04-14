%{
  #include <stdlib.h>
  void yyerror(char *);
  #include "y.tab.h"
%}

digit                       [0-9]
alpha                       [a-zA-Z]
variable                    {alpha}({alpha}|{digit}|_)*
const_string 	            L?\'(\\.|[^\\'])*\'
	

%%

"program"                   { return START_PROGRAM; }
"begin"                     { return BLOCK_BEGIN; }
"end"                       { return BLOCK_END;  }
"integer"                   { return DEF_INTEGER; }
"var"                       { return VAR_BLOCK_START; }
"const"                     { return CONST_BLOCK_START; }
":="                        { return ASSIGNMENT; }
"="                         { return EQUAL_SIGN; }
"."                         { return PERIOD; }
","                         { return COMMA; }
":"                         { return COLON; }
"\""                        { return DOUBLE_QUOTES; }

{variable}                  {
                                yylval.str = strdup(yytext);
                                return VARIABLE;
                            }
{const_string}              {
                                yylval.str = strdup(yytext);
                                return CONST_STRING;
                            }
[0-9]+                      {
                                yylval.num = atoi(yytext);
                                return CONST_INTEGER;
                            }
[-+/*()]                    { return *yytext; }
;                           { return SEMICOLON; }

[ \t\n]+                    ; /* skip whitespace */
.                           yyerror("invalid character");

%%

int yywrap(void) {
	return 1;
}

