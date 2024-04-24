#include <iostream>
#include <string>

#include "../target/parser.tab.h"

int main() {
    std::cout << "Welcome to my REPL. Type 'quit' to exit." << std::endl;
    while (1) {
        std::cout << "> " << std::flush;
        if (yyparse() != 0) {
            break;
        }
    }
    return 0;
}