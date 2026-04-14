module top_module(
    input [7:0] A,
    input [7:0] B,
    output equal,
    output A_greater_than_B,
    output A_less_than_B
);assign equal = (A == B);
    assign A_greater_than_B = (A > B);
    assign A_less_than_B = (A < B);

endmodule