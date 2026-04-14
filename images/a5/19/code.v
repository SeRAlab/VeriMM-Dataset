module top_module(
	input clk_i,
	input reset_i,
	input wr_i,
	input [7:0] D_i,
	output reg [7:0] D_o
);always @(posedge clk_i or posedge reset_i)
	if( reset_i ) D_o <= 8'd1;				
	else if( wr_i ) D_o <= D_i[7:0];
endmodule