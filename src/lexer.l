%{
    #include "parser.tab.h"
    #include <stdlib.h>
%}

%option yylineno

%%

[0-9]+(\.[0-9]+)?([eE][-+]?[0-9]+)? { yylval.number = atof(yytext); return NUMBER; }
[ \t]                             { /* ignore whitespace */ }
"+"                                 { return ADD; }
"-"                                 { return SUBTRACT; }
"*"                                 { return MULTIPLY; }
"/"                                 { return DIVIDE; }
"**"                                { return POWER; }
"%"                                 { return MOD; }
"_"+                                { yylval.ans_count = strlen(yytext); return ANS; }
"!"                                 { return FACTORIAL; }
"pi"                                { return PI; }
"e"                                 { return E; }
\n                                  { return 0; }
"quit"                              { return QUIT; }
[a-z]+                              { yylval.str = new std::string(yytext); return FUNC; }
.                                   { return yytext[0]; }

%%

int yywrap() {
    return 1;
}