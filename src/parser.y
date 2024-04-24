%{
    #include <iostream>
    #include <cstdlib>
    #include <cmath>
    #include <vector>
    int yylex();
    void yyerror(const char *s);

    extern int yylineno; // Needed to access yylineno from lexer.l

    std::vector<double> previous_results;
%}

%locations

%union {
    double number;
    unsigned int ans_count;
}

// %token means terminal
%token <number> NUMBER
%token ADD SUBTRACT MULTIPLY DIVIDE POWER FACTORIAL SIN COS TAN LOG PI E QUIT
%token <ans_count> ANS

// %type means non-terminal
%type <number> exp

%left ADD SUBTRACT
%left MULTIPLY DIVIDE // Has higher precedence than ADD and SUBTRACT
%right POWER // Has higher precedence than MULTIPLY and DIVIDE
%right SIN COS TAN LOG FACTORIAL

%define parse.error verbose

%%

input: /* empty string */
    | input exp { printf("%lf\n", $2); previous_results.push_back($2); return 0; }
    | QUIT { exit(0); }
    ;

exp: NUMBER { $$ = $1; }
    | PI { $$ = M_PI; }
    | E { $$ = M_E; }
    | ANS { if ($1 > previous_results.size()) yyerror("not enough previous results"); else $$ = previous_results[previous_results.size() - $1]; }
    | SIN exp { $$ = sin($2); }
    | COS exp { $$ = cos($2); }
    | TAN exp { $$ = tan($2); }
    | LOG exp { $$ = log($2); }
    | LOG '(' exp ',' exp ')' { $$ = log($3) / log($5); }
    | exp ADD exp { $$ = $1 + $3; }
    | SUBTRACT exp { $$ = -$2; }
    | exp SUBTRACT exp { $$ = $1 - $3; }
    | exp POWER exp { $$ = pow($1, $3); }
    | exp MULTIPLY exp { $$ = $1 * $3; }
    | exp DIVIDE exp { if ($3 == 0.0) yyerror("divide by zero"); else $$ = $1 / $3; }
    | exp FACTORIAL { double result = 1; for (double i = 1; i <= $1; i++) result *= i; $$ = result; }
    | '(' exp ')' { $$ = $2; }
    ;

%%

void yyerror(const char *s) {
    std::cerr << "Error [Line: " << yylineno << "]: " << s << std::endl;
    exit(1);
}