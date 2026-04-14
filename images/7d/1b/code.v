module decoder2to4(
	input [1:0] sel,
	input en,
	output [3:0] out);

	assign out = en ? (1 << sel) : 4'b0000;

endmodule