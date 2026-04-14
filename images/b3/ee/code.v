module top_module(A, B, C, S);input [3:0] A, B;
input C;
output [3:0] S;

wire [3:0] B_comp;
wire [4:0] temp;
wire carry;

assign B_comp = ~B + 1;

assign temp = {1'b0, A} + {1'b1, B_comp, C};

assign carry = temp[4];

assign S = temp[3:0];

endmodule