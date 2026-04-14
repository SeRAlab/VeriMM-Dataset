module top_module(
	input clk_i,
	input reset_i,
	input rd_i,
	input wr_i,
	input [7:0] D_i,
	output reg [7:0] D_o,
	output reg [7:0] wp_o = 7'h00
);always @(posedge clk_i or posedge reset_i)
	if( reset_i ) wp_o <= 8'd0;
	else begin 
		if( wr_i ) wp_o <= D_i[7:0];
		if( rd_i ) D_o <= wp_o;
	end
endmodule