module comparator_64bit (
    input [63:0] A,
    input [63:0] B,
    output A_gt,
    output A_lt,
    output A_eq
);
    assign A_gt = (A > B);
    assign A_lt = (A < B);
    assign A_eq = (A == B);
endmodule