module top_module(in_x, in_y, out_sum, out_carry);input  in_x;

input  in_y;

output out_sum;

output out_carry;

assign out_sum = in_x^in_y;

assign out_carry = in_x&in_y;

endmodule