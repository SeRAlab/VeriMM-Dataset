module decoder_2to4(
    input [1:0] a,    // 2-bit input signal.
    output [3:0] y    // 4-bit output signal.
);

assign y = 1 << a;   // Decoder operation.

endmodule