module top_module(
    input [31:0] A,
    input [31:0] B,
    output [31:0] C
);wire [31:0] sum;
    wire [31:0] carry;

    assign sum[0] = A[0] ^ B[0];
    assign carry[0] = A[0] & B[0];

    generate
        genvar i;
        for (i = 1; i < 32; i = i + 1) begin : loop
            assign sum[i] = A[i] ^ B[i] ^ carry[i-1];
            assign carry[i] = (A[i] & B[i]) | (A[i] & carry[i-1]) | (B[i] & carry[i-1]);
        end
    endgenerate

    assign C = sum;

endmodule