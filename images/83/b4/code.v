module top_module(input [0:1] p, output [0:1] o);reg [0:1] state;

	
	
	
	
	
	assign state[0] = p[0];

	assign o = state;


endmodule