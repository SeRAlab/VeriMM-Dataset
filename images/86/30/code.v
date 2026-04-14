module top_module(A,B,C,D,Z);input A,B,C,D;
output Z;

wire AB, CD, ABCD;
and (AB, A, B);
and (CD, C, D);
and (ABCD, AB, CD);
assign Z = ABCD;

endmodule