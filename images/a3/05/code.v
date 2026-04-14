module top_module(shiftLeft_in, shiftLeft_out);parameter width = 32;
	input wire [width-1:0] shiftLeft_in;
	output wire [width-1:0] shiftLeft_out;

	
	assign shiftLeft_out = {shiftLeft_in[width-3:0], 1'b0, 1'b0};
	
endmodule