module mux_2to1(
    input a,    // Input signal a.
    input b,    // Input signal b.
    input sel,  // 1-bit Selection signal.
    output y    // Output signal.
);

assign y = (sel == 1'b0) ? a : b;  // Multiplexer operation.

endmodule