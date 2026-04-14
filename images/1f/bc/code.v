module KoggeStoneAdder(
    input [4:0] A,
    input [4:0] B,
    output [5:0] Sum
);
    wire [4:0] G, P; // Generate and Propagate signals
    wire [4:0] G1, P1, G2, P2;

    assign P = A ^ B; // Propagate
    assign G = A & B; // Generate

    assign G1[0] = G[0];
    assign P1[0] = P[0];

    genvar i;
    generate
        for (i = 1; i < 5; i = i + 1) begin : stage1
            assign G1[i] = G[i] | (P[i] & G1[i-1]);
            assign P1[i] = P[i] & P1[i-1];
        end
    endgenerate

    assign Sum[0] = P[0]; // Sum bit 0
    assign Sum[1] = G1[0] ^ P[1]; // Sum bit 1
    assign Sum[2] = G1[1] ^ P[2]; // Sum bit 2
    assign Sum[3] = G1[2] ^ P[3]; // Sum bit 3
    assign Sum[4] = G1[3] ^ P[4]; // Sum bit 4
    assign Sum[5] = G[4] | (P[4] & G1[4]); // Final carry out

endmodule