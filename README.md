# QuickCalc
A terminal based calculator program made using [flex](https://github.com/westes/flex), [bison](https://www.gnu.org/software/bison/) and C++.

![Demo](./image.png)

## Features
- **Basic Arithmetic Operations:** Addition, subtraction, multiplication, and division are supported.
- **Built-in Functions:** The calculator includes a variety of built-in functions such as trigonometric functions (sin, cos, tan), logarithmic functions (log, log10), exponential functions (exp), square root (sqrt), and [more](https://github.com/Saphereye/flex_bison_calc/blob/007331b9481497197572d4ec385c181f1686159f/src/parser.y#L23).
- **Reusing previous answer:** The calculator keeps track of the previous answer and allows users to reference it in subsequent calculations using `_`. If you want to access previous answer just use `_` in calculation. If you want to use the answer two calculation ago, just use `__` (2 times `_`)
- **Error Handling:** Comprehensive error handling for invalid input and mathematical errors.

## Installation
1. Requirements: >=C++17, flex, bison
2. **Clone the Repository**: Clone this repository to your local machine.

    ```bash
    git clone https://github.com/Saphereye/flex_bison_calc
    ```
3. **Build the project**

    ```bash
    cd flex_bison_calc
    make repl
    ```