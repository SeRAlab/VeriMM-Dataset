module top_module(
    input [3:0] A,
    input [3:0] B,
    input carry_in,
    output [3:0] S,
    output carry_out
);wire [3:0] sum;
    wire [3:0] carry;

    assign sum = A + B + carry_in;
    assign carry = (A[3] & B[3]) | (A[3] & carry_in) | (B[3] & carry_in);

    assign S = sum;
    assign carry_out = carry[3];

endmodule