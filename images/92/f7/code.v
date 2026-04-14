module top_module(
    input [15:0] input1,
    input [15:0] input2,
    output equal,
    output greater_than
);assign equal = (input1 == input2);
    assign greater_than = (input1 > input2);

endmodule