#include <iostream>
#include <string>

#include "../target/parser.tab.h"

int main() {
    srand(time(NULL));
    std::cout << "Welcome to my REPL. Type 'quit' to exit." << std::endl;
    while (1) {
        std::cout << "> " << std::flush;
        yyparse();
    }
    return 0;
}