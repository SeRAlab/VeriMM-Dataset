module top_module(bit_a, bit_b, bit_parity_out, start, done);input bit_a;
input bit_b;
input start;

output bit_parity_out;
output done;

assign bit_parity_out = bit_a ^ bit_b;
assign done = start;

endmodule