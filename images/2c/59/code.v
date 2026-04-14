module brent_kung_adder #(parameter N = 8) (
    input [N-1:0] A,
    input [N-1:0] B,
    output [N-1:0] S,
    output Cout
);
    wire [N:0] C; // Carry wires
    wire [N-1:0] P, G; // Propagate and Generate

    assign P = A ^ B; // Propagate
    assign G = A & B; // Generate

    // Carry computation using Brent-Kung logic
    assign C[0] = 0; // No carry-in for the first stage
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : carry_gen
            assign C[i+1] = G[i] | (P[i] & C[i]); // Carry-out
        end
    endgenerate

    // Sum computation
    assign S = P ^ C[N-1:N-1-N]; // Sum outputs
    assign Cout = C[N]; // Final carry-out

endmodule