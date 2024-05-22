# Variables
FLEX_FILE = src/lexer.l
FLEX_OUTPUT = target/lex.yy.c
BISON_FILE = src/parser.y
BISON_OUTPUT_C = target/parser.tab.c
BISON_OUTPUT_H = target/parser.tab.h
MAIN_CPP = src/main.cpp
OUTPUT = target/parser
# Default target
all: $(OUTPUT)
# Generate C source from Flex file
$(FLEX_OUTPUT): $(FLEX_FILE)
	@mkdir -p $(dir $@)
	@flex -o $@ $<
# Generate C source and header from Bison file
$(BISON_OUTPUT_C) $(BISON_OUTPUT_H): $(BISON_FILE)
	@mkdir -p $(dir $@)
	@bison -vdy -o $(BISON_OUTPUT_C) $<
# Compile the program
$(OUTPUT): $(BISON_OUTPUT_C) $(FLEX_OUTPUT) $(MAIN_CPP)
	@g++ $^ -o $@ -lm -std=c++17
# Run the program with an input file
run: $(OUTPUT)
	@./$< $(filter-out $@,$(MAKECMDGOALS))
# Run the REPL
repl: $(OUTPUT)
	@./$<
# Clean target
clean:
	@rm -f -r target
# Phony targets
.PHONY: all run clean repl
