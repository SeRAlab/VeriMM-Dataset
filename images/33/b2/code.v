module KoggeStoneAdder #(parameter N = 8) (
    input [N-1:0] A,
    input [N-1:0] B,
    output [N:0] SUM
);
    wire [N:0] G; // Generate signals
    wire [N:0] P; // Propagate signals
    wire [N:0] C; // Carry signals

    // Generate and Propagate signals
    assign G = A & B;       // Generate
    assign P = A ^ B;       // Propagate

    // Carry signals computation
    assign C[0] = 1'b0; // Initial carry is 0
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin: carry_gen
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    // Sum computation
    assign SUM = P ^ C[N-1:0];

endmodule