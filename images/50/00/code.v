module binary_decoder_10to1024(
    input [9:0] in,
    output [1023:0] out
);
    assign out = 1 << in;
endmodule