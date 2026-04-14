module top_module(
	input clk,
	input [2:0] in,
	output reg [2:0] nand_neg);reg [2:0] d_last;	
			
	always @(posedge clk) begin
		d_last <= in;
		nand_neg <= ~(in & d_last);
	end
	
endmodule