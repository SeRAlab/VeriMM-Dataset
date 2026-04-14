module top_module(
    A,
    B,
    CIN,
    S,
    COUT
);input [3:0] A;
    input [3:0] B;
    input CIN;
    output [3:0] S;
    output COUT;

    wire [3:0] sum;
    wire carry;

    assign sum = A + B + CIN;
    assign S = sum[3:0];
    assign COUT = sum[4];

endmodule