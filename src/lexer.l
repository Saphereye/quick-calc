/* $Id$ -*- mode: c++ -*- */
/** \file lexer.l Define the example Flex lexical scanner */

%{
    #include "parser.tab.h"
    #include <stdlib.h>
    size_t yycolumn = 1;
%}

%option yylineno

%%

[0-9]+(\.[0-9]+)?([eE][-+]?[0-9]+)? { yylval.number = atof(yytext); yycolumn += strlen(yytext); return NUMBER; }
[ \t]                               { yycolumn += strlen(yytext); /* ignore whitespace */ }
"+"                                 { yycolumn++; return ADD; }
"-"                                 { yycolumn++; return SUBTRACT; }
"*"                                 { yycolumn++; return MULTIPLY; }
"/"                                 { yycolumn++; return DIVIDE; }
"**"                                { yycolumn += 2; return POWER; }
"%"                                 { yycolumn++; return MOD; }
"_"+                                { yylval.ans_count = strlen(yytext); yycolumn += strlen(yytext); return ANS; }
"!"                                 { yycolumn++; return FACTORIAL; }
"pi"                                { yycolumn += 2; return PI; }
"e"                                 { yycolumn++; return E; }
[Cc]                                { yycolumn++; return COMBINATION; }
[Pp]                                { yycolumn++; return PERMUTATION; }
\n|\r\n                             { yycolumn = 1; return 0; }
"quit"                              { yycolumn += 4; return QUIT; }
[a-z]+                              { yylval.str = new std::string(yytext); yycolumn += strlen(yytext); return FUNC; }
.                                   { yycolumn++; return yytext[0]; }

%%

int yywrap() {
    return 1;
}