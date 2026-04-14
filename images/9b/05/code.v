module top_module(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
);wire [3:0] sum;
    wire [3:0] carry;

    // First full adder
    assign sum[0] = A[0] ^ B[0] ^ Cin; // Using bitwise XOR for first bit
    assign carry[0] = (A[0] & B[0]); // Carry out for the first bit

    // Second full adder
    assign sum[1] = A[1] ^ B[1] ^ carry[0]; 
    assign carry[1] = (A[1] & B[1]) | (carry[0] & (A[1] ^ B[1])); // Carry out for the second bit

    // Third full adder
    assign sum[2] = A[2] ^ B[2] ^ carry[1];
    assign carry[2] = (A[2] & B[2]) | (carry[1] & (A[2] ^ B[2])); // Carry out for the third bit

    // Fourth full adder
    assign sum[3] = A[3] ^ B[3] ^ carry[2];
    assign Cout = (A[3] & B[3]) | (carry[2] & (A[3] ^ B[3])); // Final carry out

    // Output
    assign S = sum;

endmodule