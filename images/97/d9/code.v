module top_module(clock, reset, wren, data, q);input clock, reset, wren;
	input  [31:0] data;
	output reg [31:0] q;
	
	
	always @(posedge clock)
	if (reset==1'b1)
		q = 32'b0;
	else if(wren == 1'b1)
		q = data;

endmodule