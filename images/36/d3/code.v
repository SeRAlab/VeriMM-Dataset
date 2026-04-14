module kogge_stone_adder #(parameter N = 8) (
    input [N-1:0] A,
    input [N-1:0] B,
    output [N-1:0] SUM,
    output [N:0] COUT
);
    wire [N:0] G, P, C;

    // Generate and propagate signals
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin: genprop
            assign G[i] = A[i] & B[i];  // Generate
            assign P[i] = A[i] ^ B[i];  // Propagate
        end
    endgenerate

    // Carry computation
    assign C[0] = 0;  // Initial carry
    generate
        for (i = 0; i < N; i = i + 1) begin: carry
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    // Sum calculation
    assign SUM = P ^ C[N-1:0];
    assign COUT = C;

endmodule