module top_module(Sum, Carry, A, B, Cin );input [63:0] A, B;
input Cin;

output [63:0] Sum;
output Carry;




assign {Carry, Sum} = A + B;

endmodule