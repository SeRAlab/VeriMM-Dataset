module top_module(clk, rst, in, out);parameter width=16;
input clk, rst;
input [width-1:0] in;
output [width-1:0] out;
reg [width-1:0] out;

always @ (posedge clk)
	if(!rst)
		out <= {(width-1){1'b0}};
	else
		out <= in;

endmodule