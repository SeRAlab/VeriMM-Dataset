module top_module(
    input [15:0] A,
    input [15:0] B,
    input C,
    output [15:0] S
);wire [15:0] B_comp;
    assign B_comp = (~B) + 1; // 2's complement of B

    assign S = (C == 1) ? A + B_comp : A + B; // Add A and B or A and 2's complement of B based on C

endmodule