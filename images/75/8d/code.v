module top_module(
    input [7:0] A,
    input [7:0] B,
    output [7:0] S,
    output C
);wire [7:0] sum;
    wire [7:0] carry;

    assign sum[0] = A[0] ^ B[0];
    assign carry[0] = A[0] & B[0];

    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : adder_loop
            assign sum[i] = A[i] ^ B[i] ^ carry[i-1];
            assign carry[i] = (A[i] & B[i]) | (A[i] & carry[i-1]) | (B[i] & carry[i-1]);
        end
    endgenerate

    assign S = sum;
    assign C = carry[7];

endmodule