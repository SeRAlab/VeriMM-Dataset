module carry_skip_adder #(parameter n = 4) (
    input [n-1:0] A,
    input [n-1:0] B,
    input Cin,
    output [n-1:0] Sum,
    output Cout
);
    wire [n:0] C; // Carry bits
    assign C[0] = Cin;

    genvar i;
    generate
        for (i = 0; i < n; i = i + 1) begin : CSA
            assign Sum[i] = A[i] ^ B[i] ^ C[i];
            assign C[i+1] = (A[i] & B[i]) | (C[i] & (A[i] ^ B[i]));
        end
    endgenerate

    assign Cout = C[n];
endmodule