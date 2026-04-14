module comparator(A, B, GT);
input [3:0] A, B;
output GT;

assign GT = (A > B);

endmodule