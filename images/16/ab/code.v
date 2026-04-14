module mux16to1 (
    input [15:0] D, // 16 data inputs
    input [3:0] S,  // 4 select lines
    output Y        // output
);
    assign Y = D[S]; // Multiplex the selected input
endmodule