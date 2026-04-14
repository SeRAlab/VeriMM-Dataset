module top_module(in_a, in_b, out_sum, out_carry);input [7:0] in_a, in_b;
output [7:0] out_sum;
output out_carry;

wire [8:0] temp_sum;

assign temp_sum = in_a + in_b;
assign out_sum = temp_sum[7:0];
assign out_carry = temp_sum[8];

endmodule