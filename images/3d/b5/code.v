module carry_skip_adder (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] Sum,
    output Cout
);
    wire [7:0] P; // propagate
    wire [7:0] G; // generate
    wire [7:0] C; // carry

    assign P = A ^ B; // propagate
    assign G = A & B; // generate

    assign C[0] = Cin;
    generate
        genvar i;
        for (i = 0; i < 7; i = i + 1) begin : carry_gen
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    assign Sum = P ^ C;
    assign Cout = G[7] | (P[7] & C[7]);

endmodule