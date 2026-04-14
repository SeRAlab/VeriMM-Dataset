module top_module(in, rst, out, clock);input rst, clock;
output reg [31:0] out;
input [31:0] in;

always @ (posedge clock)
	if (rst)
		out <= 32'b0;
	else
		out <= in;

endmodule