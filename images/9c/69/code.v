module top_module(out,inp,sel);input [31:0] inp;
	output out;
	input [4:0] sel;
	assign out = inp[sel];endmodule