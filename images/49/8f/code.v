module decoder_6to64(
    input [5:0] a,    // 6-bit input signal.
    output [63:0] y   // 64-bit output signal.
);

assign y = 1 << a;   // Decoder operation.

endmodule