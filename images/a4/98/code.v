module top_module(A, B, C, D, Z);input A;
input B;
input C;
input D;
output Z;

wire AB;
wire CD;
wire ABCD;

and #(2) and1 (AB, A, B);
and #(2) and2 (CD, C, D);
and #(2) and3 (ABCD, AB, CD);
assign Z = ABCD;

endmodule