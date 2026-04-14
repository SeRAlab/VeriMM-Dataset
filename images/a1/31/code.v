module binary_decoder_8to256(
    input [7:0] in,
    output [255:0] out
);
    assign out = 1 << in;
endmodule