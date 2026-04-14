module carry_skip_adder #(parameter n = 4) (
    input [n-1:0] A,
    input [n-1:0] B,
    input carry_in,
    output [n-1:0] sum,
    output carry_out
);
    wire [n:0] C; // carry signals
    wire [n-1:0] S; // sum bits

    assign C[0] = carry_in;

    generate
        genvar i;
        for (i = 0; i < n; i = i + 1) begin : adder
            assign S[i] = A[i] ^ B[i] ^ C[i];
            assign C[i + 1] = (A[i] & B[i]) | (C[i] & (A[i] ^ B[i]));
        end
    endgenerate

    assign sum = S;
    assign carry_out = C[n];

endmodule