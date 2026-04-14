module top_module(
    input [3:0] A,
    input [3:0] B,
    input Sub,
    output [3:0] Sum,
    output Cout
);wire [3:0] B_inv;
    wire [3:0] Add;
    wire [3:0] Subt;

    // Invert B
    assign B_inv = ~B;

    // Adder
    assign Add[0] = A[0] ^ B_inv[0];
    assign Add[1] = A[1] ^ B_inv[1] ^ Add[0];
    assign Add[2] = A[2] ^ B_inv[2] ^ Add[1];
    assign Add[3] = A[3] ^ B_inv[3] ^ Add[2];

    // Subtractor
    assign Subt[0] = A[0] ^ B[0] ^ Sub;
    assign Subt[1] = A[1] ^ B[1] ^ Sub ^ Subt[0];
    assign Subt[2] = A[2] ^ B[2] ^ Sub ^ Subt[1];
    assign Subt[3] = A[3] ^ B[3] ^ Sub ^ Subt[2];

    // Select output based on Sub
    assign Sum = Sub ? Subt : Add;
    assign Cout = Sub ? ~Subt[3] : Add[3];

endmodule