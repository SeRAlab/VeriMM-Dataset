module top_module(input [31:0]A,B, output zero );assign zero = (A==B) ? 1 : 0;
endmodule