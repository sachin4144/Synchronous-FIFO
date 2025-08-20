# Synchronous FIFO

A Synchronous FIFO (First-In-First-Out) is a fundamental digital design component frequently used in data buffering, communication between asynchronous systems, and pipeline management. This repository provides a parametrizable and synthesizable Verilog implementation of a Synchronous FIFO module, suitable for inclusion in larger digital systems or for educational purposes.

## Table of Contents

- [Features](#features)
- [Architecture](#architecture)
- [Directory Structure](#directory-structure)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Parameters](#parameters)
- [Interface Signals](#interface-signals)
- [Testbench](#testbench)
- [Simulation](#simulation)
- [Synthesis](#synthesis)
- [Contributing](#contributing)
- [License](#license)

---

## Features

- **Parametrizable Depth and Data Width**: Easily configure FIFO depth and data width to fit your requirements.
- **Synchronous Operation**: Both read and write operations are synchronized to a single clock domain.
- **Status Flags**: Provides `full`, `empty`, and optionally `almost_full`/`almost_empty` signals for flow control.
- **Simple and Clean Interface**: Designed for ease of integration and understanding.
- **Synthesizable**: Ready for FPGA or ASIC implementation.
- **Testbench Provided**: Includes a Verilog testbench for functional simulation.

## Architecture

The Synchronous FIFO is implemented using a circular buffer (RAM array) with separate read and write pointers. All operations (read/write) occur on the rising edge of the clock. The status flags are updated based on the pointer positions and the occupancy of the FIFO.

Typical block diagram:

```
+---------------------+
|        FIFO         |
|  +-------------+    |
|  |  RAM Array  |    |
|  +-------------+    |
|  | Write Ptr   |    |
|  | Read Ptr    |    |
|  | Full/Empty  |    |
+---------------------+
```

## Directory Structure

```
Synchronous-FIFO/
├── src/                # Verilog source files
│   └── synchronous_fifo.v
├── tb/                 # Testbenches
│   └── tb_synchronous_fifo.v
├── sim/                # Simulation scripts or results
├── README.md           # Project documentation
└── LICENSE             # License file
```

## Getting Started

### Prerequisites

- [Icarus Verilog](http://iverilog.icarus.com/) or any Verilog simulator
- (Optional) FPGA synthesis tools (Quartus, Vivado, etc.)

### Clone the Repository

```sh
git clone https://github.com/sachin4144/Synchronous-FIFO.git
cd Synchronous-FIFO
```

## Usage

### Integrating FIFO in Your Design

1. Copy `src/synchronous_fifo.v` into your project.
2. Instantiate the FIFO module in your top-level Verilog file:

```verilog
synchronous_fifo #(
    .DATA_WIDTH(8),
    .DEPTH(16)
) fifo_inst (
    .clk(clk),
    .reset(reset),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .din(din),
    .dout(dout),
    .full(full),
    .empty(empty)
);
```

### Example Testbench

The repository includes a testbench (`tb/tb_synchronous_fifo.v`) that demonstrates typical FIFO operations: writing, reading, and status flag checking.

## Parameters

| Parameter   | Description                | Default |
|-------------|----------------------------|---------|
| DATA_WIDTH  | Width of data (bits)       | 8       |
| DEPTH       | Number of FIFO entries     | 16      |

## Interface Signals

| Signal   | Direction | Description                         |
|----------|-----------|-------------------------------------|
| clk      | input     | Clock signal                        |
| reset    | input     | Synchronous reset                   |
| wr_en    | input     | Write enable                        |
| rd_en    | input     | Read enable                         |
| din      | input     | Data input                          |
| dout     | output    | Data output                         |
| full     | output    | FIFO full flag                      |
| empty    | output    | FIFO empty flag                     |

## Testbench

The provided testbench covers:
- Write and read operations
- Full and empty flag behavior
- Edge cases (underflow, overflow prevention)

To run the testbench (using Icarus Verilog):

```sh
iverilog -o fifo_tb src/synchronous_fifo.v tb/tb_synchronous_fifo.v
vvp fifo_tb
```

## Simulation

For waveform viewing, generate a `.vcd` file in the testbench and open it with [GTKWave](http://gtkwave.sourceforge.net/):

```sh
gtkwave fifo_tb.vcd
```

## Synthesis

The FIFO module is designed to be synthesizable and can be integrated into FPGA or ASIC flows. Parameterize for your technology’s RAM resources and timing requirements.

## Contributing

Contributions are welcome! Please open issues or submit pull requests for bug fixes, improvements, or new features.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

**Author:** [sachin4144](https://github.com/sachin4144)
