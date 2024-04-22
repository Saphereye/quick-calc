%{
    #include "parser.tab.h"
    #include <stdlib.h>
%}

%option yylineno

%%

[0-9]+(\.[0-9]+)?      { yylval.number = atof(yytext); return NUMBER; }
[ \t\n]                { /* ignore whitespace */ }
"+"                    { return ADD; }
"-"                    { return SUBTRACT; }
"*"                    { return MULTIPLY; }
"/"                    { return DIVIDE; }
"**"                   { return POWER; }
"_"                    { return ANS; }
"!"                    { return FACTORIAL; }
"sin"                  { return SIN; } // Takes radians as input
"cos"                  { return COS; } // Takes radians as input
"tan"                  { return TAN; } // Takes radians as input
"log"                  { return LOG; }
"pi"                   { return PI; }
"e"                    { return E; }
.                      { return yytext[0]; }

%%

int yywrap() {
    return 1;
}