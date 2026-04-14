module brent_kung_adder #(parameter N = 8) (
    input [N-1:0] A,
    input [N-1:0] B,
    output [N-1:0] SUM,
    output COUT
);
    wire [N:0] P; // Propagate
    wire [N:0] G; // Generate
    wire [N:0] C; // Carry

    // Generate and propagate signals
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin: gen_prop
            assign P[i] = A[i] ^ B[i];
            assign G[i] = A[i] & B[i];
        end
    endgenerate

    // Carry computation using Brent-Kung logic
    assign C[0] = 1'b0; // Initial carry
    generate
        for (i = 0; i < N; i = i + 1) begin: carry_gen
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    // Sum computation
    assign SUM = P ^ C[N-1:0];
    assign COUT = C[N];

endmodule