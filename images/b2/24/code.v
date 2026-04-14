module comparator_4bit(A, B, A_greater, A_equal, A_less);
input [3:0] A;
input [3:0] B;
output A_greater;
output A_equal;
output A_less;

assign A_greater = A > B;
assign A_equal = A == B;
assign A_less = A < B;

endmodule