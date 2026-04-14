module mux2to1 (A, B, S, Z);
input A, B, S;
output Z;

buf buf_A (Z, A);
buf buf_B (Z, B);

// select A if S is 0, B if S is 1
assign Z = (~S & A) | (S & B);

endmodule