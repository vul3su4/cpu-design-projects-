//////////////////////////////////////////////////////////////////////////////////
// Author : Brian Chen
// Date   : 08/10/2025
// File name : Instruction_Memory.sv
//////////////////////////////////////////////////////////////////////////////////
module Instruction_Memory(
    addr_i,
    instr_o
    );

// Interface
input   [31:0]  addr_i;
output  [31:0]  instr_o;

// Instruction File
logic     [31:0]  instruction_file    [0:31];

assign  instr_o = instruction_file[addr_i / 4];  

endmodule

