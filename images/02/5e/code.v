module mux8to1 (
    input wire [7:0] D,    // Data inputs
    input wire [2:0] S,    // Select inputs
    output wire Y          // Output
);
    assign Y = D[S];
endmodule