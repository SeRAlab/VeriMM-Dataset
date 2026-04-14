module mux_2to1(
    input [7:0] a,    // Input signal a with a data width of 8 bits.
    input [7:0] b,    // Input signal b with a data width of 8 bits.
    input sel,        // Selection signal.
    output [7:0] y    // Output signal with a data width of 8 bits.
);

assign y = sel ? b : a;  // Multiplexer operation.

endmodule