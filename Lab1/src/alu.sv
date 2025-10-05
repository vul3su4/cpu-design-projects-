//////////////////////////////////////////////////////////////////////////////////
// Author : Brian Chen
// Date   : 08/02/2025
// File name : alu.sv
//////////////////////////////////////////////////////////////////////////////////
module alu(
           input clk,
           input rst_n,
           input [31:0] src1,
           input [31:0] src2,
           input [3:0] ALU_control,
           output logic [31:0] result,
           output logic zero,
           output logic cout,
           output logic overflow
           );
logic less,msbcin,g,p;
logic [31:0] tmp;

alu32bit unit(.src1(src1),
              .src2(src2),
              .less(less),
              .A_invert(ALU_control[3]),
              .B_invert(ALU_control[2]),
              .cin(ALU_control[2]),
              .operation(ALU_control[1:0]),
              .result(tmp),
              .msbcin(msbcin),
              .g(g),
              .p(p)
              );
              
assign less = (src1[31] ^ ~src2[31]) ?  (src1[31] ^ ~src2[31]) ^ msbcin : src1[31];

always_ff @(posedge clk or negedge rst_n) 
begin
	if(rst_n) begin
	result = tmp;
	zero = ~|tmp;
	cout = (g | (p & ALU_control[2])) & (ALU_control[1] & ~ALU_control[0]);
	overflow = msbcin ^ (g | (p & ALU_control[2]));
	end
	else begin

	end
end

endmodule
