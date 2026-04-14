module mux_2to1(
    input a,     // First input signal.
    input b,     // Second input signal.
    input sel,   // Select signal.
    
    output y     // Output signal.
);

//------------------------------------------------
// 2-to-1 multiplexer logic
assign y = sel ? b : a;

endmodule