module top_module(Out32, In32);output [31:0] Out32;
input [31:0] In32;

assign Out32 = {In32[29:0],2'b00};endmodule