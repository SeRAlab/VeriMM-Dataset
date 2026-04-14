module adder_8bit (A, B, SUM, CARRY);
input [7:0] A, B;
output [7:0] SUM;
output CARRY;

assign {CARRY, SUM} = A + B;

endmodule