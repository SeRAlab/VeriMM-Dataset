module top_module(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
);wire [3:0] sum;
    wire C1, C2, C3;

    // Use a simple full adder for each bit instead of the unknown module.
    // Create a full adder using a combination of XOR and AND gates.
    assign sum[0] = A[0] ^ B[0] ^ Cin;
    assign C1 = (A[0] & B[0]) | (Cin & (A[0] ^ B[0]));

    assign sum[1] = A[1] ^ B[1] ^ C1;
    assign C2 = (A[1] & B[1]) | (C1 & (A[1] ^ B[1]));

    assign sum[2] = A[2] ^ B[2] ^ C2;
    assign C3 = (A[2] & B[2]) | (C2 & (A[2] ^ B[2]));

    assign sum[3] = A[3] ^ B[3] ^ C3;
    assign Cout = (A[3] & B[3]) | (C3 & (A[3] ^ B[3]));
    
    assign S = sum;

endmodule