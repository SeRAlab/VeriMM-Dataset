module KoggeStoneAdder #(parameter N = 4) (
    input [N-1:0] A,
    input [N-1:0] B,
    output [N:0] SUM
);
    wire [N-1:0] P; // propagate
    wire [N-1:0] G; // generate
    wire [N-1:0] C; // carry

    // Generate and propagate signals
    assign P = A ^ B;
    assign G = A & B;

    // Carry generation using Kogge-Stone logic
    assign C[0] = 1'b0; // C0 is always 0
    genvar i;
    generate
        for (i = 0; i < N-1; i = i + 1) begin : carry_gen
            if (i == 0) begin
                assign C[i+1] = G[i] | (P[i] & C[i]);
            end else begin
                assign C[i+1] = G[i] | (P[i] & G[i-1]) | (P[i] & P[i-1] & C[i-1]);
            end
        end
    endgenerate

    // Final sum calculation
    assign SUM = {C[N-1], P ^ {C[N-2:0], 1'b0}};
endmodule