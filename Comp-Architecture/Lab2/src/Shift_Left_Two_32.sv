//////////////////////////////////////////////////////////////////////////////////
// Author : Brian Chen
// Date   : 08/05/2025
// File name : Shift_Left_Two_32.sv
//////////////////////////////////////////////////////////////////////////////////
module Shift_Left_Two_32(
                         input [32-1:0] data_i,
                         output [32-1:0] data_o
                         );

assign data_o = {data_i[29:0],2'b00};

endmodule
