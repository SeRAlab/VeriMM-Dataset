module top_module(
	input clk,
	input rst,
	input freeze,
	input WB_en_in,
	input MEM_R_EN_in,

	input [31:0] ALU_result_in,
	
	input [31:0] MEM_read_value_in,
	input [4:0] Dest_in,

	output reg WB_en,
	output reg MEM_R_en,

	output reg [31:0] ALU_result,
	output reg [31:0] MEM_read_value,
	output reg [4:0] Dest
);always @(posedge clk, posedge rst) begin
		if(rst)
			{ALU_result, MEM_read_value, Dest} <= 69'b0;
		else if (freeze==0)
			{WB_en, MEM_R_en, ALU_result, MEM_read_value, Dest} <= {WB_en_in, MEM_R_EN_in, ALU_result_in, MEM_read_value_in, Dest_in};
	end
endmodule