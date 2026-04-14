module mux8to1 (
    input wire [7:0] D,     // Data inputs D0 to D7
    input wire [2:0] S,     // Select inputs S0, S1, S2
    output wire Y           // Output
);
    assign Y = D[S];        // Select the appropriate data input based on select lines
endmodule