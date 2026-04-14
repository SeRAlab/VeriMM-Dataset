module mux_2to1_en(
    input [3:0] a,    // Input signal a with a data width of 4 bits.
    input [3:0] b,    // Input signal b with a data width of 4 bits.
    input sel,        // Selection signal.
    input en,         // Enable signal.
    output [3:0] y    // Output signal with a data width of 4 bits.
);

assign y = en ? (sel ? b : a) : 4'b0000;  // Multiplexer operation.

endmodule