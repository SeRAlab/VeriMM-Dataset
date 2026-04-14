module top_module(
output[5:0] O,
input[5:0] A,
input[5:0] B
);assign O = ( A <<< 2'b10 ) + (B >>> 1'b1);endmodule