# Computer Organization Projects

A collection of computer  architecture lab projects implemented in SystemVerilog and C.

**Author:** Brian Chen

## Projects

### Lab 1: 32-bit ALU
- **Language:** SystemVerilog
- **Description:** Implementation of a 32-bit Arithmetic Logic Unit with carry lookahead adder
- **Files:** `alu.sv`, `alu4bit.sv`, `alu16bit.sv`, `alu32bit.sv`, `carrylookaheadunit.sv`

### Lab 2: Single Cycle CPU - Simple Edition
- **Language:** SystemVerilog
- **Description:** Basic single-cycle processor implementation
- **Files:** `Simple_Single_CPU.sv`, `Reg_File.sv`, `ALU.sv`, `Decoder.sv`

### Lab 3: Single Cycle CPU - Complete Edition
- **Language:** SystemVerilog
- **Description:** Enhanced single-cycle processor with memory operations
- **Files:** `Simple_Single_CPU.sv`, `Data_Memory.sv`, `MUX_3to1.sv`

### Lab 4: Pipelined CPU
- **Language:** SystemVerilog
- **Description:** Pipelined processor implementation with 5-stage pipeline
- **Files:** `Pipe_CPU_1.sv`, `Pipe_Reg.sv`

### Lab 5: Advanced Pipelined CPU
- **Language:** SystemVerilog
- **Description:** Advanced pipelined processor with hazard detection and forwarding
- **Files:** `Pipe_CPU_1.sv`, `ForwardUnit.sv`, `HazardDetectUnit.sv`, `MUX_4to1.sv`

### Lab 6: Cache Simulator
- **Language:** C
- **Description:** Cache memory simulation with configurable parameters
- **Files:** `cache.c`, `direct_map_cache.c`



### Compilation

**SystemVerilog:**
- Load project files in your preferred simulator
- Run simulation with provided testbenches

**C (Lab 6):**
```bash
gcc -o cache_sim src/cache.c -lm
gcc -o direct_cache direct_map_cache.c -lm
```

## Features

- Progressive learning from basic ALU to advanced pipelined CPU
- SystemVerilog implementation for hardware design
- C implementation for cache simulation
- Comprehensive testbenches and test cases

