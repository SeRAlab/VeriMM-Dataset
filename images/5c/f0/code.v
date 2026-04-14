module decoder_1to2(
    input a,          // 1-bit input signal.
    output [1:0] y    // 2-bit output signal.
);

assign y = 1 << a;   // Decoder operation.

endmodule