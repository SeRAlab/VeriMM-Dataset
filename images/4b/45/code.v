module top_module(
	clock,
	ALU3,
	SH3,
	C3,
	T3,
	ALU4,
	SH4,
	C4,
	T4,
	DATA_ADDR_3,
	DATA_ADDR_4,
	M3,
	M4
);input clock;
	input [3:0] 		ALU3;
	input [1:0] 		SH3;
	input [5:0] 		C3;
	input [6:0] 		T3;
	input [10:0]		DATA_ADDR_3;
	input [1:0]			M3;
	output reg [3:0] 	ALU4;
	output reg [1:0] 	SH4;
	output reg [5:0] 	C4;
	output reg [6:0] 	T4;
	output reg [10:0]	DATA_ADDR_4;
	output reg [1:0]	M4;
	

	always @* 
	begin
		ALU4	=	ALU3;
		SH4	=	SH3;
		C4	=	C3;
		T4	=	T3;
		DATA_ADDR_4 = DATA_ADDR_3;
		M4 = M3;
	end
endmodule