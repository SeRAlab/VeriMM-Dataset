module top_module(
	input	wire					CLK, 
	input	wire					WEN_A,

	input	wire		[31:0]		W_DA,		


	input	wire		[3:0]		RA_A,
	input	wire		[3:0]		RA_B,
	input	wire		[3:0]		RA_C,

	input	wire		[3:0]		WA_A,

	output	wire		[31:0]		GRF_X,
	output	wire		[31:0]		GRF_Y,
	output	wire		[31:0]		GRF_Z
);reg		[31:0]		ram[15 : 0];

	assign	GRF_X = ram[RA_A];
	assign	GRF_Y = ram[RA_B];
	assign	GRF_Z = ram[RA_C];









endmodule