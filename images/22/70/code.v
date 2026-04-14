module carry_skip_adder #(parameter N = 8) (
    input [N-1:0] A,
    input [N-1:0] B,
    input Cin,
    output [N-1:0] Sum,
    output Cout
);
    wire [N:0] C; // Carry signals
    wire [N-1:0] P; // Propagate signals
    wire [N-1:0] G; // Generate signals

    assign P = A ^ B; // Propagate
    assign G = A & B; // Generate

    assign C[0] = Cin; // Initial carry input
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : carry_logic
            assign C[i+1] = G[i] | (P[i] & C[i]); // Carry generation
        end
    endgenerate

    assign Sum = P ^ C[N-1:0]; // Sum output
    assign Cout = C[N]; // Final carry out

endmodule