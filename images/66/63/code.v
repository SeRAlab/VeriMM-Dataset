module subtractor_4bit(A, B, Difference, Borrow_out);
input [3:0] A;
input [3:0] B;
output [3:0] Difference;
output Borrow_out;

assign {Borrow_out, Difference} = A - B;

endmodule