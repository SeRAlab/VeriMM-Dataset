module top_module(
	in4,
	in3,
	in2,
	in1,
	out1
	);input [31:0] in4;
input  in3,
	in2;
input [27:0] in1;
output [31:0] out1;
wire [31:0] asc001;
wire  asc002;

assign asc002 = 
	(in3)
	&(in2);

wire [31:0] asc001_tmp_0;
assign asc001_tmp_0 = 
	+(in4)
	+(asc002);
assign asc001 = asc001_tmp_0
	+({{4{in1[27]}}, in1});

assign out1 = asc001;
endmodule