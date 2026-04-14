module decoder_4to16(
    input [3:0] a,    // 4-bit input signal.
    output [15:0] y   // 16-bit output signal.
);

assign y = 1 << a;   // Decoder operation.

endmodule