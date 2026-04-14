module xor_module(
    input [3:0] data_in,
    output [3:0] data_out
);

assign data_out = data_in ^ 4'hF;

endmodule