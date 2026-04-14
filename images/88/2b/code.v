module top_module(a, b, sum, c);input [7:0] a;
input [7:0] b;
output [7:0] sum;
output c;

wire [7:0] temp_sum;
wire [7:0] temp_carry;

assign temp_sum = a ^ b;
assign temp_carry = a & b;

assign sum = temp_sum ^ temp_carry;
assign c = temp_carry[7];

endmodule