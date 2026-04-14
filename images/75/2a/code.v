module top_module(
    input [3:0] A, B,
    input Cin, Sub,
    output [3:0] S,
    output Cout
);wire [3:0] A_bar, B_bar, C_bar, S_bar1, S_bar2;
    wire C1, C2, C3;

    // 1's complement of A and B
    assign A_bar = ~A;
    assign B_bar = ~B;

    // Compute the first level of the subtractor
    assign S_bar1[0] = Sub ? B_bar[0] : B[0];
    assign C1 = Sub ? B_bar[0] & Cin : B[0] & Cin;

    // Compute the second level of the subtractor
    assign S_bar1[1] = Sub ? B_bar[1] ^ C1 : B[1] ^ C1;
    assign C2 = Sub ? B_bar[1] & C1 : B[1] & C1;

    // Compute the third level of the subtractor
    assign S_bar1[2] = Sub ? B_bar[2] ^ C2 : B[2] ^ C2;
    assign C3 = Sub ? B_bar[2] & C2 : B[2] & C2;

    // Compute the fourth level of the subtractor
    assign S_bar1[3] = Sub ? B_bar[3] ^ C3 : B[3] ^ C3;

    // Compute the 2's complement of S_bar1
    assign S_bar2 = S_bar1 + 4'b0001;

    // Compute the carry-out of the adder
    assign Cout = S_bar2[3];

    // Compute the final result
    assign S = Sub ? S_bar2 : S_bar1;
endmodule