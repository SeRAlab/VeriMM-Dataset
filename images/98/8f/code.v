module top_module(
    input [3:0] data_in,
    output [3:0] data_out
);parameter [3:0] xor_value = 4'b1010;

assign data_out = data_in ^ xor_value;

endmodule