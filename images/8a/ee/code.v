module top_module(
    input [3:0] A,
    input [3:0] B,
    output [3:0] Y
);wire c1, c2, c3;
    wire sum0, sum1, sum2, sum3, carry0, carry1, carry2;

    // Using basic AND and XOR gates to implement 4-bit adder logic
    assign sum0 = A[0] ^ B[0];         // Sum bit 0
    assign carry0 = A[0] & B[0];       // Carry bit 0

    assign sum1 = A[1] ^ B[1] ^ carry0; // Sum bit 1
    assign carry1 = (A[1] & B[1]) | (carry0 & (A[1] ^ B[1])); // Carry bit 1

    assign sum2 = A[2] ^ B[2] ^ carry1; // Sum bit 2
    assign carry2 = (A[2] & B[2]) | (carry1 & (A[2] ^ B[2])); // Carry bit 2

    assign sum3 = A[3] ^ B[3] ^ carry2; // Sum bit 3
    // Carry out can be assigned if needed, but we are not using it here
    // reg carry_out
    // assign carry_out = (A[3] & B[3]) | (carry2 & (A[3] ^ B[3])); 

    assign Y = {sum3, sum2, sum1, sum0}; // Concatenate sum bits to form output Y

endmodule