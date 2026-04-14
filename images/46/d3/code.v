module top_module(clock, reset, in, out);input clock, reset;
	input [63:0] in;
	output [63:0] out;
	reg [63:0] out;
	always @ (posedge clock)
	begin
		if(reset)
			out<=0;
		else
			out<=in;
	end
endmodule