module mux_2to1(
    input [7:0] a,    // First 8-bit input
    input [7:0] b,    // Second 8-bit input
    input sel,        // Select signal
    output [7:0] y    // 8-bit output
);

// Multiplexer logic
assign y = sel ? b : a;

endmodule