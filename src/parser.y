%code requires {
    #include <string>
    #include <vector>
}

%{
    #include <iostream>
    #include <cstdlib>
    #include <cmath>
    #include <map>
    #include <functional>
    
    int yylex();
    void yyerror(const char *s);
    extern int yylineno; // Needed to access yylineno from lexer.l
    std::vector<double> previous_results;
    std::map<std::string, std::function<double(std::vector<double>)>> functions = {
        {"sin", [](std::vector<double> args) { return sin(args[0]); }},
        {"cos", [](std::vector<double> args) { return cos(args[0]); }},
        {"tan", [](std::vector<double> args) { return tan(args[0]); }},
        {"asin", [](std::vector<double> args) { return asin(args[0]); }},
        {"acos", [](std::vector<double> args) { return acos(args[0]); }},
        {"atan", [](std::vector<double> args) { return atan(args[0]); }},
        {"sinh", [](std::vector<double> args) { return sinh(args[0]); }},
        {"cosh", [](std::vector<double> args) { return cosh(args[0]); }},
        {"tanh", [](std::vector<double> args) { return tanh(args[0]); }},
        {"asinh", [](std::vector<double> args) { return asinh(args[0]); }},
        {"acosh", [](std::vector<double> args) { return acosh(args[0]); }},
        {"atanh", [](std::vector<double> args) { return atanh(args[0]); }},
        {"sqrt", [](std::vector<double> args) { return sqrt(args[0]); }},
        {"cbrt", [](std::vector<double> args) { return cbrt(args[0]); }}, // cube root
        {"exp", [](std::vector<double> args) { return exp(args[0]); }},
        {"floor", [](std::vector<double> args) { return floor(args[0]); }},
        {"ceil", [](std::vector<double> args) { return ceil(args[0]); }},
        {"round", [](std::vector<double> args) { return round(args[0]); }},
        {"truncate", [](std::vector<double> args) { return trunc(args[0]); }},
        {"ln", [](std::vector<double> args) { return log(args[0]); }}, // natural log
        {"log", [](std::vector<double> args) { return log(args[0]) / log(args[1]); }}, // log(x, base)
        {"log2", [](std::vector<double> args) { return log2(args[0]); }},
        {"log10", [](std::vector<double> args) { return log10(args[0]); }},
        {"abs", [](std::vector<double> args) { return fabs(args[0]); }},
        {"max", [](std::vector<double> args) { return *std::max_element(args.begin(), args.end()); }},
        {"min", [](std::vector<double> args) { return *std::min_element(args.begin(), args.end()); }},
        {"sum", [](std::vector<double> args) { double sum = 0; for (double arg : args) sum += arg; return sum; }},
        {"avg", [](std::vector<double> args) { double sum = 0; for (double arg : args) sum += arg; return sum / args.size(); }},
        {"median", [](std::vector<double> args) { std::sort(args.begin(), args.end()); return args[args.size() / 2]; }},
        {"range", [](std::vector<double> args) { std::sort(args.begin(), args.end()); return args[args.size() - 1] - args[0]; }},
        {"stdev", [](std::vector<double> args) { double sum = 0, sum_sq = 0; for (double arg : args) { sum += arg; sum_sq += arg * arg; } return sqrt(sum_sq / args.size() - (sum / args.size()) * (sum / args.size())); }},
        {"var", [](std::vector<double> args) { double sum = 0, sum_sq = 0; for (double arg : args) { sum += arg; sum_sq += arg * arg; } return sum_sq / args.size() - (sum / args.size()) * (sum / args.size()); }},
        {"hypot", [](std::vector<double> args) { return hypot(args[0], args[1]); }},
        {"atan2", [](std::vector<double> args) { return atan2(args[0], args[1]); }},
        {"gcd", [](std::vector<double> args) { return args.size() == 2 ? std::__gcd((long long int)args[0], (long long int)args[1]) : 0; }},
        {"fact", [](std::vector<double> args) { double result = 1; for (double i = 1; i <= args[0]; i++) result *= i; return result; }},
        {"perm", [](std::vector<double> args) { return args.size() == 2 ? tgamma(args[0] + 1) / tgamma(args[0] - args[1] + 1) : 0; }},
        {"comb", [](std::vector<double> args) { return args.size() == 2 ? tgamma(args[0] + 1) / (tgamma(args[1] + 1) * tgamma(args[0] - args[1] + 1)) : 0; }},
        {"rand", [](std::vector<double> args) { return args.empty() ? static_cast<double>(rand()) / RAND_MAX : args.size() == 2 ? args[0] + (args[1] - args[0]) * static_cast<double>(rand()) / RAND_MAX : static_cast<double>(rand()) / RAND_MAX; }},
    };
%}

%locations

%union {
    double number;
    unsigned int ans_count;
    std::string* str;
    std::vector<double>* arg_list;
}

%token <number> NUMBER
%token ADD SUBTRACT MULTIPLY DIVIDE POWER FACTORIAL PI E QUIT MOD
%token <ans_count> ANS
%token <str> FUNC

%type <number> exp
%type <arg_list> exp_list

%left ADD SUBTRACT
%left MULTIPLY DIVIDE // Has higher precedence than ADD and SUBTRACT
%right POWER // Has higher precedence than MULTIPLY and DIVIDE
%right FACTORIAL

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
    | FUNC '(' exp_list ')' { if (functions.find(*$1) == functions.end()) yyerror("unknown function"); else $$ = functions[*$1](*$3); delete $3; }
    | exp ADD exp { $$ = $1 + $3; }
    | SUBTRACT exp { $$ = -$2; }
    | exp SUBTRACT exp { $$ = $1 - $3; }
    | exp POWER exp { $$ = pow($1, $3); }
    | exp MULTIPLY exp { $$ = $1 * $3; }
    | exp DIVIDE exp { if ($3 == 0.0) yyerror("divide by zero"); else $$ = $1 / $3; }
    | exp FACTORIAL { double result = 1; for (double i = 1; i <= $1; i++) result *= i; $$ = result; }
    | exp MOD exp { $$ = fmod($1, $3); }
    | exp 'C' exp { $$ = tgamma($1 + 1) / (tgamma($3 + 1) * tgamma($1 - $3 + 1)); }
    | exp 'P' exp { $$ = tgamma($1 + 1) / tgamma($1 - $3 + 1); }
    | '(' exp ')' { $$ = $2; }
    | '|' exp '|' { $$ = fabs($2); }
    ;

exp_list:
    /* empty */ { $$ = new std::vector<double>(); }
    | exp { $$ = new std::vector<double>(1, $1); }
    | exp_list ',' exp { $1->push_back($3); $$ = $1; }
    ;
%%
void yyerror(const char *s) {
    std::cerr << "Error [Line: " << yylineno << "]: " << s << std::endl;
}