module top_module(
RESET, CLOCK, MEMORY_ADDR, MEMORY_DATA, INPUT0, INPUT1, OUTPUT0, OUTPUT1);input        RESET;
	input        CLOCK;
	output [5:0] MEMORY_ADDR;
	input  [7:0] MEMORY_DATA;
	input  [3:0] INPUT0;
	input  [3:0] INPUT1;
	output [3:0] OUTPUT0;
	output [3:0] OUTPUT1;

	wire [5:0] MEMORY_ADDR;
	wire [3:0] OUTPUT0;
	wire [3:0] OUTPUT1;

	assign MEMORY_ADDR = 6'b0;
	assign OUTPUT0 = 4'b0;
	assign OUTPUT1 = 4'b0;endmodule