module comparator_4bit(A, B, A_lt_B, A_eq_B, A_gt_B);
    input [3:0] A, B;
    output A_lt_B, A_eq_B, A_gt_B;

    assign A_lt_B = (A < B);
    assign A_eq_B = (A == B);
    assign A_gt_B = (A > B);
endmodule