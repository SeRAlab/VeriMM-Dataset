module top_module(in, cur, shiftIn, start, out);input [63:0] in, cur;
	input start, shiftIn;
	
	output [63:0] out;
	
	wire [63:0] shiftedIn;

	assign shiftedIn[63:33] = in[62:32];
	assign shiftedIn[32:1] = cur[31:0];
	assign shiftedIn[0] = shiftIn;
	
	assign out = start ? in : shiftedIn;
	
endmodule