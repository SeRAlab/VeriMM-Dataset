module top_module(A, Z);input [3:0] A;
output [3:0] Z;

assign Z = A + 4'b0001;

endmodule