module top_module(SW, LEDR);input [9:0] SW;				
	output [9:0] LEDR;			

	assign LEDR[9:0] = SW[9:0];
endmodule