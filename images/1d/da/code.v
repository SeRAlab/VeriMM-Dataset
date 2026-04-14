module KoggeStoneAdder #(parameter n = 8) (
    input [n-1:0] A,
    input [n-1:0] B,
    output [n-1:0] SUM,
    output CO
);
    wire [n:0] P; // Propagate
    wire [n:0] G; // Generate
    wire [n:0] C; // Carry

    genvar i;
    
    // Generate and propagate signals
    assign P = A ^ B;
    assign G = A & B;
    
    // Carry computation
    assign C[0] = 1'b0; // Initial carry
    generate
        for (i = 0; i < n; i = i + 1) begin: carry_gen
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate
    
    // Sum calculation
    assign SUM = P ^ C[n-1:n-1-1];

    // Final carry out
    assign CO = C[n];

endmodule