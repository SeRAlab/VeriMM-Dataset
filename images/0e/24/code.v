module mux16to1 (
    input [15:0] I,   // 16 input lines
    input [3:0] S,    // 4-bit select line
    output O          // output line
);
    assign O = I[S];   // Selects the input based on the select signal
endmodule