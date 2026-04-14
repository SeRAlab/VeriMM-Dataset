module top_module(
    input [3:0] A,
    input [3:0] B,
    output [3:0] S,
    output C_out
    );wire [3:0] carry;
    assign carry[0] = 1'b0;
    assign carry[1] = A[0] & B[0];
    assign carry[2] = (A[1] & B[1]) | (A[1] & carry[1]) | (B[1] & carry[1]);
    assign carry[3] = (A[2] & B[2]) | (A[2] & carry[2]) | (B[2] & carry[2]);
    assign C_out = carry[3];
    assign S = A + B;

endmodule