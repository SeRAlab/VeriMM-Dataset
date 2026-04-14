module top_module(
    input [3:0] A,
    input [3:0] B,
    input CIN,
    output [3:0] S,
    output COUT
);wire [3:0] sum;
    wire carry_out;

    assign {carry_out, sum} = A + B + CIN;

    assign S = sum;
    assign COUT = carry_out;

endmodule