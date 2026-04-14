module decoder_5to32(
    input [4:0] a,    // 5-bit input signal.
    output [31:0] y   // 32-bit output signal.
);

assign y = 1 << a;   // Decoder operation.

endmodule