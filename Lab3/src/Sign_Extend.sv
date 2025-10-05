//////////////////////////////////////////////////////////////////////////////////
// Author : Brian Chen
// Date   : 08/05/2025
// File name : Sign_Extend.sv
//////////////////////////////////////////////////////////////////////////////////
module Sign_Extend(
                   input [16-1:0] data_i,
                   output logic [32-1:0] data_o
                   );

always_combbegin
	if(data_i[15])
		data_o = {16'b1111111111111111,data_i[15:0]};
	else
		data_o = {16'b0000000000000000,data_i[15:0]};
end

endmodule
