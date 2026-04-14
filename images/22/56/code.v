module mux_2to1(
    input [1:0] a,  // First input
    input [1:0] b,  // Second input
    input sel,      // Select signal
    output [1:0] y  // Output
);
    assign y = sel ? b : a;  // Selects input based on sel
endmodule