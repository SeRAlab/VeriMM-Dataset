module brent_kung_adder(
    input [3:0] A,
    input [3:0] B,
    output [4:0] SUM
);
    wire [3:0] P, G; // Propagate and Generate signals
    wire [3:0] P1, G1, P2, G2;
    wire [1:0] C;
    
    assign P = A ^ B; // Propagate
    assign G = A & B; // Generate

    // First level of generate and propagate
    assign P1[0] = P[0];
    assign G1[0] = G[0];
    assign P1[1] = P[1] | (G[0] & P[1]);
    assign G1[1] = G[1] | (G[0] & P[1]);
    assign P1[2] = P[2] | (G1[1] & P[2]);
    assign G1[2] = G[2] | (G1[1] & P[2]);
    
    // Second level
    assign C[0] = G1[0];
    assign C[1] = G1[1] | (G1[0] & P[2]);

    // Sum calculation
    assign SUM[0] = P[0];
    assign SUM[1] = P[1] ^ C[0];
    assign SUM[2] = P[2] ^ C[1];
    assign SUM[3] = P[3] ^ G[2];
    assign SUM[4] = G[3] | (P[3] & G[2]);

endmodule