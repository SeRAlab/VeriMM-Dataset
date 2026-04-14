module top_module(A, B, C, D, Z);input A, B, C, D;
output Z;

wire w1, w2, w3;

and(w1, A, B);
and(w2, C, D);
and(w3, w1, w2);
assign Z = w3;

endmodule