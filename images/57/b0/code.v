module top_module( sel, in_0, in_1, out );input sel;
input [31:0] in_0;
input [31:0] in_1;


output [31:0] out;

assign out = (sel) ? in_1 : in_0;

endmodule