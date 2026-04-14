module top_module(
    input signed [3:0] A,
    input signed [3:0] B,
    output equal,
    output greater_than,
    output less_than
);assign equal = (|A == B);
    assign greater_than = (A > B) && (!equal);
    assign less_than = (A < B) && (!equal);

endmodule