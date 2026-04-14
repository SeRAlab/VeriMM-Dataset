module mux_2to1(
    input sel,          // Select signal.
    input [7:0] a,      // 8-bit input.
    input [7:0] b,      // 8-bit input.
    output [7:0] y      // 8-bit output.
);

// Multiplexer logic
assign y = (sel) ? b : a;

endmodule