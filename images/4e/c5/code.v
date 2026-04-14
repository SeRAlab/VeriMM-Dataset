module top_module(bcd1, bcd0, in);output [3:0] bcd1, bcd0;
	input  [4:0] in;
	
	wire   [3:0] digS = {4{in[4] | (in[3] & (in[2]|in[1]))}};
	wire   [3:0] abv9 = {in[4]&in[1], ~(in[2]^in[1]), ~in[1], in[0]};
	
	assign bcd0 = (~digS & in[3:0]) | (digS & abv9);
	assign bcd1 = (~digS & 4'b0000) | (digS & 4'b0001);endmodule