module carry_skip_adder #(parameter n = 4) (
    input [n-1:0] A,
    input [n-1:0] B,
    input carry_in,
    output [n-1:0] sum,
    output carry_out
);
    wire [n:0] carry; // Intermediate carry signals
    wire [n-1:0] skip; // Skip signals

    assign carry[0] = carry_in;

    genvar i;
    generate
        for (i = 0; i < n; i = i + 1) begin: CSA
            assign sum[i] = A[i] ^ B[i] ^ carry[i];
            assign carry[i+1] = (A[i] & B[i]) | (carry[i] & (A[i] ^ B[i]));
            assign skip[i] = (A[i] & B[i]);
        end
    endgenerate

    assign carry_out = carry[n];

endmodule