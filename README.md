# Assembly-Language-MMA-
This repository contains all the assembly language code (Microprocessor ,Microcontroller and its Applications)


## Petrol Price Display Using 8051 Microcontroller

## Project Overview

This project demonstrates how to interface a 16×2 LCD with an 8051 microcontroller using assembly language in the EdSim51 simulator.

The LCD displays the text `PETROL` on the first line and the predefined petrol price `104.05` on the second line. The project demonstrates LCD initialization, 4-bit data transmission, ASCII character handling, program memory access, subroutines, and software delay generation.

## Objectives

- Interface a 16×2 LCD with the 8051 microcontroller.
- Display text and numeric characters using assembly language.
- Implement 4-bit LCD communication.
- Understand LCD control signals and data transmission.
- Use program memory to store and retrieve display messages.

## Technologies Used

- **Microcontroller:** 8051
- **Simulator:** EdSim51
- **Programming Language:** 8051 Assembly Language
- **Display:** 16×2 LCD
- **Communication Mode:** 4-bit interface

## Hardware / Simulator Configuration

The project is implemented in EdSim51 using the following pin mapping:

| 8051 Pin | LCD Signal | Function |
|---|---|---|
| P1.7 | DB7 | Data bit 7 |
| P1.6 | DB6 | Data bit 6 |
| P1.5 | DB5 | Data bit 5 |
| P1.4 | DB4 | Data bit 4 |
| P1.3 | RS | Register Select |
| P1.2 | E | Enable |

The LCD operates in 4-bit mode, where each 8-bit command or character is transmitted in two 4-bit transfers.

## Working Principle

1. **Program Initialization:** Execution begins at the reset vector, jumps to the main program, and initializes the stack pointer.
2. **LCD Initialization:** The program configures the LCD to prepare it for receiving commands and character data.
3. **Display First Line:** The message `PETROL` is stored as ASCII bytes in program memory. The program reads each character using the DPTR register and the `MOVC` instruction.
4. **Cursor Positioning:** After the first message ends, the program sends the LCD command `C0H` to move the cursor to the beginning of the second line.
5. **Display Petrol Price:** The predefined price `104.05` is read from program memory and displayed character by character.
6. **Delay and Completion:** Software delays allow time for LCD operations. After displaying the price, the program enters an infinite loop, keeping the output visible.

## Key Instructions Used

| Instruction | Purpose |
|---|---|
| `ORG` | Specifies the code or data location |
| `LJMP` | Transfers execution to the main program |
| `MOV` | Transfers data between registers and supported destinations |
| `MOVC` | Reads data from program memory |
| `DPTR` | Points to the stored message |
| `SETB` / `CLR` | Sets or clears individual bits |
| `LCALL` / `CALL` | Executes a subroutine |
| `RET` | Returns from a subroutine |
| `INC` | Advances to the next character |
| `DJNZ` | Implements the software delay loop |
| `JZ` | Detects the null terminator |
| `SJMP` | Implements loops and the final infinite loop |
| `DB` | Defines bytes in program memory |

## Output

The expected LCD output is:

```text
PETROL
104.05
```

## Project Structure

```text
Petrol-Price-Display-8051/
├── README.md
└── petrol_price_display.asm
```

The assembly source file contains the complete program, including the main routine, LCD initialization, character transmission, delay subroutine, and ASCII message definitions.

## How to Run

1. Open the EdSim51 simulator.
2. Load or enter the assembly source code.
3. Assemble the program and verify that there are no assembly errors.
4. Start the simulation.
5. Observe the LCD output.

## Learning Outcomes

- Understanding 8051 assembly language programming.
- Interfacing a character LCD with a microcontroller.
- Implementing 4-bit LCD communication.
- Working with ASCII values and program memory.
- Using subroutines, loops, bit manipulation, and software delays.

## Limitations

- The petrol price is hardcoded in the program and is not fetched from a live data source.
- The displayed value must be modified in the source code to change the price.
- The project is a simulation-based demonstration and does not include a physical LCD or external petrol-price data connection.

## Future Improvements

- Allow the petrol price to be updated dynamically.
- Display prices for multiple fuel types, such as petrol and diesel.
- Add push-button controls to switch between different fuel prices.
- Interface with an external data source for updated prices.

## Author

**Parth Gawade**

## License

This project is intended for educational purposes. You may adapt and extend it for learning and academic projects.
