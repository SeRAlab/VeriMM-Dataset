module top_module(A, B, C, S);input [3:0] A;
    input [3:0] B;
    input C;
    output [3:0] S;

    wire [3:0] A_inv;
    wire [3:0] B_inv;
    wire [3:0] B_neg;
    wire [3:0] sum;
    wire carry;

    // Invert A and B for subtraction
    assign A_inv = ~A;
    assign B_inv = ~B;

    // Calculate B's 2's complement for subtraction
    assign B_neg = B_inv + 1;

    // Calculate sum of A and B
    assign {carry, sum} = A + B;

    // Calculate difference of A and B
    assign {carry, S} = C ? A + B_neg + 1 : sum;

endmodule