module binary_decoder_1to2(
    input in,
    output [1:0] out
);
    assign out = 1 << in;
endmodule