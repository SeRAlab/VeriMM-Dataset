module decoder_3to8(
    input [2:0] a,    // 3-bit input signal.
    output [7:0] y    // 8-bit output signal.
);

assign y = 1 << a;   // Decoder operation.

endmodule