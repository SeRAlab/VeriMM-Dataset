module and_4bit(A, B, Y);
input [3:0] A;
input [3:0] B;
output [3:0] Y;

assign Y = A & B;

endmodule