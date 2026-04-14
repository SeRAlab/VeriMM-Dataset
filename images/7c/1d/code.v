module adder_4bit(A, B, SUM, CARRY_OUT);
input [3:0] A, B;
output [3:0] SUM;
output CARRY_OUT;

assign {CARRY_OUT, SUM} = A + B;

endmodule