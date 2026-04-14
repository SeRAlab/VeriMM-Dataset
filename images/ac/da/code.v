module mux_2to1(
    input [7:0] a,  // First 8-bit input signal.
    input [7:0] b,  // Second 8-bit input signal.
    input sel,      // Select signal.

    output [7:0] y // 8-bit output of the multiplexer.
);

assign y = (sel) ? b : a; // Select between a and b based on sel

endmodule