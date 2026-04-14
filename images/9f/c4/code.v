module mux_2to1(
    input sel,  // Select signal.
    input a,    // First input.
    input b,    // Second input.
    output y    // Output.
);

// Multiplexer logic
assign y = sel ? b : a;

endmodule