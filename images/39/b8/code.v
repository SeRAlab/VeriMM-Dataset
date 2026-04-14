module comparator_64bit (
    input [63:0] A,
    input [63:0] B,
    output less_than,
    output equal_to,
    output greater_than
);
    assign less_than = (A < B);
    assign equal_to = (A == B);
    assign greater_than = (A > B);
endmodule