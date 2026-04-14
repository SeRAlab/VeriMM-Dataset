module binary_decoder_9to512(
    input [8:0] in,
    output [511:0] out
);
    assign out = 1 << in;
endmodule