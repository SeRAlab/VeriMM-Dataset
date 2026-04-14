module top_module(A, B, sub, result);input [3:0] A, B;
input sub;
output [3:0] result;

wire [3:0] B_neg;
assign B_neg = (~B) + 1; //2's complement of B

//subtract B from A if sub is 1, else add A and B
assign result = sub ? A + B_neg : A + B;

endmodule