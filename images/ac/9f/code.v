module top_module(a, b, is_equal);input [5:0] a, b;
output is_equal;

wire [5:0] xor_result;
wire [5:0] and_result;

assign xor_result = a ^ b;
assign and_result = &xor_result;

assign is_equal = ~|and_result;

endmodule