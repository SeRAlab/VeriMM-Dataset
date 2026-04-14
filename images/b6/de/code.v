module top_module(
    input [3:0] A,
    input [3:0] B,
    output [3:0] SUM,
    output CARRY
);wire [3:0] carry;

    // Simple Full Adder Implementation
    assign SUM[0] = A[0] ^ B[0];         // Sum bit 0
    assign carry[0] = A[0] & B[0];       // Carry out bit 0

    assign SUM[1] = A[1] ^ B[1] ^ carry[0]; // Sum bit 1
    assign carry[1] = (A[1] & B[1]) | (carry[0] & (A[1] ^ B[1])); // Carry out bit 1

    assign SUM[2] = A[2] ^ B[2] ^ carry[1]; // Sum bit 2
    assign carry[2] = (A[2] & B[2]) | (carry[1] & (A[2] ^ B[2])); // Carry out bit 2

    assign SUM[3] = A[3] ^ B[3] ^ carry[2]; // Sum bit 3
    assign CARRY = (A[3] & B[3]) | (carry[2] & (A[3] ^ B[3])); // Final carry out

endmodule