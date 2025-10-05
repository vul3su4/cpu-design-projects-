//////////////////////////////////////////////////////////////////////////////////
// Author : Brian Chen
// Date   : 08/02/2025
// File name : alu32bit.sv
//////////////////////////////////////////////////////////////////////////////////
module alu32bit(
               input [31:0] src1,
               input [31:0] src2,
               input less,
               input A_invert,
               input B_invert,
               input cin,
               input [1:0] operation,
               output logic [31:0] result,
               output msbcin,
               output g,
               output p
               );
logic [3:0] clu_g;
logic [3:0] clu_p;
logic [3:0] carry;
logic [31:0] tmp;


carrylookaheadunit clu(
                       .cin(cin),
                       .g(clu_g),
                       .p(clu_p),
                       .cout(carry));

alu16bit alu0(
             .src1(src1[15:0]),
             .src2(src2[15:0]),
             .less(less),
             .A_invert(A_invert),
             .B_invert(B_invert),
             .cin(cin),
             .operation(operation),
             .result(tmp[15:0]),
             .g(clu_g[0]),
             .p(clu_p[0])
              );

alu16bit alu1(
             .src1(src1[31:16]),
             .src2(src2[31:16]),
             .less(1'b0),
             .A_invert(A_invert),
             .B_invert(B_invert),
             .cin(carry[0]),
             .operation(operation),
             .result(tmp[31:16]),
             .msbcin(msbcin),
             .g(clu_g[1]),
             .p(clu_p[1])
              );
              
assign g = clu_g[1] | (clu_p[1] & clu_g[0]);
assign p = clu_p[1] & clu_p[0];

always_combbegin
    result = tmp;
end

endmodule
