module top_module(a, b, c, out1, out2);input a, b, c;
output out1, out2;

wire b_and_c;
wire b_xor_c;

assign b_and_c = b & c;
assign b_xor_c = b ^ c;

assign out1 = (a == 1) ? b_and_c : b_xor_c;
assign out2 = a ^ c;

endmodule