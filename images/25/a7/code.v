module comparator_2bit(
    input [1:0] A,
    input [1:0] B,
    output A_eq,
    output A_gt,
    output A_lt
);
    assign A_eq = (A == B);
    assign A_gt = (A > B);
    assign A_lt = (A < B);
endmodule