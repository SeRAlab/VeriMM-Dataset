module top_module(A, B, C, D, Z);input A;
input B;
input C;
input D;
output Z;

and (Z, A, B, C, D);

endmodule