`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// Module Name:    testbench
//
//////////////////////////////////////////////////////////////////////////////////

//`define BONUS

module testbench;

`ifdef BONUS
parameter PATTERN_NUMBER = 6'd11;
`else
parameter PATTERN_NUMBER = 6'd6;
`endif

logic          clk;
logic          rst_n;
logic [32-1:0] src1_in;
logic [32-1:0] src2_in;
logic  [4-1:0] operation_in;
logic  [3-1:0] bonus_in; 

logic  [8-1:0] mem_src1   [0:(PATTERN_NUMBER*4-1)];
logic  [8-1:0] mem_src2   [0:(PATTERN_NUMBER*4-1)];
logic  [8-1:0] mem_opcode [0:(PATTERN_NUMBER-1)];
logic  [8-1:0] mem_bonus  [0:(PATTERN_NUMBER-1)];
logic  [8-1:0] mem_result [0:(PATTERN_NUMBER*4-1)];
logic  [8-1:0] mem_zcv    [0:(PATTERN_NUMBER-1)];

logic  [6-1:0] pattern_count;
logic          start_check;
logic  [6-1:0] error_count;
logic  [6-1:0] error_count_tmp; 

logic [32-1:0] result_out;
logic          zero_out;
logic          cout_out;
logic          overflow_out;

logic  [3-1:0] zcv_out;
logic [32-1:0] result_correct;
logic  [8-1:0] zcv_correct;
logic  [8-1:0] opcode_tmp;
logic  [8-1:0] bonus_tmp; 

assign zcv_out = {zero_out, cout_out, overflow_out};

assign opcode_tmp = mem_opcode[pattern_count];
assign bonus_tmp = mem_bonus[pattern_count];
assign result_correct = {mem_result[4*(pattern_count-5'd2) + 5'd3],
                         mem_result[4*(pattern_count-5'd2) + 5'd2],
                         mem_result[4*(pattern_count-5'd2) + 5'd1],
                         mem_result[4*(pattern_count-5'd2) + 5'd0]};
assign zcv_correct = mem_zcv[pattern_count-5'd2];

initial begin
    clk   = 1'b0;
    rst_n = 1'b0;
    src1_in = 32'd0;
    src2_in = 32'd0;
    operation_in = 4'h0;
	 bonus_in = 3'h0;
    start_check = 1'd0;
    error_count = 6'd0;
    error_count_tmp = 6'd0;
    pattern_count = 6'd0;
    
    $readmemh("testbench/src1.txt", mem_src1);
    $readmemh("testbench/src2.txt", mem_src2);
    $readmemh("testbench/op.txt", mem_opcode);
	 $readmemh("testbench/bonus.txt", mem_bonus);
    $readmemh("testbench/result.txt", mem_result);
    $readmemh("testbench/zcv.txt", mem_zcv);
    
    #100 rst_n = 1'b1;
    #15 start_check = 1'd1;
end

always #5 clk = ~clk;

`ifdef BONUS
alu alu(.clk(clk),
        .rst_n(rst_n),
        .src1(src1_in),
        .src2(src2_in),
        .ALU_control(operation_in),
		  .bonus_control(bonus_in),
        .result(result_out),
        .zero(zero_out),
        .cout(cout_out),
        .overflow(overflow_out)
       );
`else
alu alu(.clk(clk),
        .rst_n(rst_n),
        .src1(src1_in),
        .src2(src2_in),
        .ALU_control(operation_in),
        .result(result_out),
        .zero(zero_out),
        .cout(cout_out),
        .overflow(overflow_out)
       );
`endif

always_ff @(posedge clk) begin
   if(pattern_count == (PATTERN_NUMBER+1)) begin
		if(error_count == 5'd0) begin
			$display("***************************************************");
         $display(" Congratulation! All data are correct! ");
         $display("***************************************************");
		end
      $stop;
	end
   else if(rst_n) begin
		src1_in       <= {mem_src1[4*pattern_count + 6'd3],
                        mem_src1[4*pattern_count + 6'd2],
                        mem_src1[4*pattern_count + 6'd1],
                        mem_src1[4*pattern_count + 6'd0]};
      src2_in       <= {mem_src2[4*pattern_count + 6'd3],
                        mem_src2[4*pattern_count + 6'd2],
                        mem_src2[4*pattern_count + 6'd1],
                        mem_src2[4*pattern_count + 6'd0]};
      operation_in  <= opcode_tmp[4-1:0];
		bonus_in      <= bonus_tmp[3-1:0];
      pattern_count <= pattern_count + 6'd1;
	end
end

always_ff @(negedge clk) begin
	if(start_check) begin
		if(pattern_count)
			if ((result_out == result_correct )&& ( zcv_out==zcv_correct) )begin
				if((mem_opcode[pattern_count-2] == 4'd2) || (mem_opcode[pattern_count-2] == 4'd6) && (zcv_out == zcv_correct[3-1:0])) begin
				end
				else if(zcv_out[2] == zcv_correct[2]) begin
				end
			end
			else begin
				$display("***************************************************");    
				case(mem_opcode[pattern_count-2])
					4'd0:$display(" AND error! ");                  
					4'd1:$display(" OR error! ");
					4'd2:$display(" ADD error! ");
					4'd6:$display(" SUB error! ");
					4'd7:$display(" SLT error! ");
					4'd12:$display(" NOR error! ");
					default: begin
					end
				endcase
				
				$display(" No.%2d error!",pattern_count-1);
				$display(" Currect result: %h     Currect ZCV: %b",result_correct, zcv_correct[3-1:0]);
				$display(" Your result: %h     Your ZCV: %b\n",result_out, zcv_out);
				$display("***************************************************");    
				error_count <= error_count + 6'd1;
			end
	end
end

endmodule
