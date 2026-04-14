module top_module(
    input [1:0] A,
    input [1:0] B,
    input C,
    output reg [2:0] S
);// Full Adder 1
    wire w1 = A[0] ^ B[0];
    wire w2 = A[0] & B[0];
    wire w3 = w2 & C;
    reg s1 = w1 ^ C;
    wire c1 = w3 | (w1 & C);

    // Full Adder 2
    wire w4 = A[1] ^ B[1];
    wire w5 = A[1] & B[1];
    wire w6 = w5 & c1;
    reg s2 = w4 ^ c1;
    wire c2 = w6 | (w4 & c1);

    // Output
    assign S = {c2, s2, s1};

endmodule