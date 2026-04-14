module mux_2to1_8bit(
    input [7:0] a,      // 8-bit input signal a.
    input [7:0] b,      // 8-bit input signal b.
    input sel,          // Select signal.

    output [7:0] y      // 8-bit output signal.
);

// Multiplexer logic
assign y = (sel) ? b : a;

endmodule