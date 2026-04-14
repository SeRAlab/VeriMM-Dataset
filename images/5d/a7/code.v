module top_module(A, B, C_in, S, C_out);input [3:0] A, B;
input C_in;
output [3:0] S;
output C_out;

wire [3:0] sum;
wire carry;

//unsigned addition
assign sum = A + B + C_in;
assign C_out = (sum > 4'b1111) ? 1 : 0;
assign S = sum;

//two's complement addition
assign {carry, sum} = A + B + C_in;
assign C_out = carry;
assign S = sum;

endmodule