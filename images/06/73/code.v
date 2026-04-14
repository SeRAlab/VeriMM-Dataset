module carry_skip_adder (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);
    wire [3:0] G;  // Generate
    wire [3:0] P;  // Propagate
    wire [3:0] C;  // Carry bits

    // Generate and propagate calculations
    assign G = A & B;  // Generate
    assign P = A ^ B;  // Propagate

    // Carry skip logic
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign Cout = G[3] | (P[3] & C[3]);

    // Sum calculation
    assign Sum = P ^ {C[2:0], Cin};

endmodule