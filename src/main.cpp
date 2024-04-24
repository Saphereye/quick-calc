#include <iostream>
#include <string>

#include "../target/parser.tab.h"

#define RESET "\033[0m"
#define YELLOW "\033[33m"
#define GREEN "\033[32m"

int main() {
    srand(time(NULL));
    std::cout << YELLOW << "Welcome. Type 'quit' to exit." << RESET << std::endl;
    while (1) {
        std::cout << GREEN << "> " << RESET << std::flush;
        yyparse();
    }
    return 0;
}