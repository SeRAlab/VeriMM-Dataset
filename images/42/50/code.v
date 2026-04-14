module and_gate_4bit(A, B, Result);
input [3:0] A;
input [3:0] B;
output [3:0] Result;

assign Result = A & B;

endmodule