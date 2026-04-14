module top_module(O,A,B);input [1:0]A;
input [1:0]B;
output [1:0]O;
assign O[0]=A[0]^B[0];
assign O[1]=A[1]^B[1];
endmodule