#include <string.h>
#include <iostream>
#include "../target/parser.tab.h"

int main(int argc, char **argv) {
    printf("Welcome to my REPL. Type 'quit' to exit.\n");
    while (1) {
        printf("> ");
        fflush(stdout);
        if (yyparse() != 0) {
            break;
        }
    }
    return 0;
}