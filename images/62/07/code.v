module top_module(bit_a, bit_b, bit_carry_in, bit_sum, bit_carry_out, start, done);input bit_a;
input bit_b;
input bit_carry_in;
input start;

output bit_sum;
output bit_carry_out;
output done;

assign bit_sum = (bit_a ^ bit_b) ^ bit_carry_in;
assign bit_carry_out = ((bit_a ^ bit_b) & bit_carry_in) | (bit_a & bit_b);
assign done = start;

endmodule