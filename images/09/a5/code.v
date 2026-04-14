module brent_kung_adder (
    input [4:0] A,
    input [4:0] B,
    output [5:0] SUM
);
    wire [4:0] C; // Carry bits
    wire [4:0] P; // Propagate bits
    wire [4:0] G; // Generate bits

    // Generate and propagate signals
    assign P = A ^ B;
    assign G = A & B;

    // Carry calculation using Brent-Kung method
    assign C[0] = G[0];
    assign C[1] = G[1] | (P[1] & G[0]);
    assign C[2] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]);
    assign C[3] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
    assign C[4] = G[4] | (P[4] & G[3]) | (P[4] & P[3] & G[2]) | (P[4] & P[3] & P[2] & G[1]) | (P[4] & P[3] & P[2] & P[1] & G[0]);

    // Sum calculation
    assign SUM = {C[4], A ^ B ^ {C[3:0], 1'b0}};
endmodule