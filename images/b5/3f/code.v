module top_module(in,out);input [25:0] in;
output [27:0] out;

assign out = { {in[25:0]}, {1'b0}, {1'b0} };
endmodule