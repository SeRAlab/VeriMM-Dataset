module binary_decoder_6to64(
    input [5:0] in,
    output [63:0] out
);
    assign out = 1 << in;
endmodule