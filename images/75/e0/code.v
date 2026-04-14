module top_module(
	in3,
	in2,
	in1,
	out1
	);input [10:0] in3;
input [15:0] in2,
	in1;
output [31:0] out1;
wire [31:0] asc001;
wire [26:0] asc002;

assign asc002 = 
	+(in2 * in3);

assign asc001 = 
	+(asc002 * in1);

assign out1 = asc001;
endmodule