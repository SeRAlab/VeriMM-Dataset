module top_module( A, B, out );parameter width = 16;
input  [width:1] A,B;
output [width:1] out;

assign out = A + B;

endmodule