//////////////////////////////////////////////////////////////////////////////////
// Author : Brian Chen
// Date   : 08/05/2025
// File name : Decoder.sv
//////////////////////////////////////////////////////////////////////////////////
module Decoder(
               input [6-1:0] instr_op_i,
	           output logic RegWrite_o,
	           output logic [4-1:0] ALU_op_o,
	           output logic ALUSrc_o,
	           output logic RegDst_o,
	           output logic Branch_o
	           );

always_comb begin
	ALU_op_o = instr_op_i[3:0];
	Branch_o = instr_op_i[2];
	ALUSrc_o = instr_op_i[3];
	RegWrite_o = ~instr_op_i[2];
	RegDst_o = (instr_op_i == 0);
end

endmodule
