module carry_skip_adder(
    input [3:0] A,         // 4-bit input A
    input [3:0] B,         // 4-bit input B
    input Cin,             // Carry input
    output [3:0] Sum,      // 4-bit Sum output
    output Cout            // Carry output
);
    wire [3:0] P;         // Propagate signals
    wire [3:0] G;         // Generate signals
    wire [3:0] C;         // Carry signals

    // Generate and propagate signals
    assign P = A ^ B;     // Propagate
    assign G = A & B;     // Generate

    // Carry signals
    assign C[0] = G[0] | (P[0] & Cin);
    assign C[1] = G[1] | (P[1] & C[0]);
    assign C[2] = G[2] | (P[2] & C[1]);
    assign C[3] = G[3] | (P[3] & C[2]);

    // Sum output
    assign Sum = P ^ {C[2:0], Cin};

    // Final carry output
    assign Cout = C[3];

endmodule