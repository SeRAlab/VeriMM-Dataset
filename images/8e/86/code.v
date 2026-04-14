module top_module(
    input [3:0] A,
    input [3:0] B,
    input SUB,
    output [3:0] OUT,
    output COUT
);wire [3:0] temp_out;
    wire temp_carry;

    // Adder
    assign temp_out = A + B + SUB;
    assign temp_carry = (A[3] & B[3]) | (SUB & (A[3] ^ B[3])) ;

    // Subtractor
    assign OUT = SUB ? A - B : temp_out;
    assign COUT = SUB ? ~(A[3] ^ B[3]) & (A[3] ^ OUT[3]) : temp_carry;

endmodule