module comparator_32bit (
    input  [31:0] A,
    input  [31:0] B,
    output       A_gt_B,
    output       A_eq_B,
    output       A_lt_B
);

assign A_gt_B = (A > B);
assign A_eq_B = (A == B);
assign A_lt_B = (A < B);

endmodule