module KoggeStoneAdder #(parameter N = 4) (
    input [N-1:0] A,
    input [N-1:0] B,
    output [N-1:0] Sum,
    output Carry
);
    wire [N:0] P, G, C;

    // Generate P (propagate) and G (generate) signals
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : gen_pg
            assign P[i] = A[i] ^ B[i]; // Propagate
            assign G[i] = A[i] & B[i]; // Generate
        end
    endgenerate

    // Carry generation
    assign C[0] = 0; // Initial carry
    generate
        for (i = 0; i < N; i = i + 1) begin : carry
            assign C[i + 1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    // Sum calculation
    assign Sum = P ^ C[N-1:0];
    assign Carry = C[N];

endmodule