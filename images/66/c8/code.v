module binary_decoder_3to8(
    input [2:0] in,
    output [7:0] out
);
    assign out = 1 << in;
endmodule