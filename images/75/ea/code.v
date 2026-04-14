module decoder_2to4 (
	input [1:0] in,
	input en,
	output [3:0] out);
	
	assign out = en ? (1 << in) : 4'b0000;
	
endmodule

module decoder_3to8 (
	input [2:0] in,
	input en,
	output [7:0] out);
	
	wire [3:0] d1_out, d2_out;
	
	decoder_2to4 d1(.in(in[1:0]), .en(en & ~in[2]), .out(d1_out));
	decoder_2to4 d2(.in(in[1:0]), .en(en & in[2]), .out(d2_out));
	
	assign out = {d2_out, d1_out};
	
endmodule