module mux_2to1(
    input a,      // First input signal.
    input b,      // Second input signal.
    input sel,    // Select signal to choose between input a and input b.
    
    output y      // Output signal.
);

assign y = (sel) ? b : a; // Multiplexer logic

endmodule