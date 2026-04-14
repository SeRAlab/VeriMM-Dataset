module comparator_4bit (
    input [3:0] a,
    input [3:0] b,
    output a_eq_b,
    output a_lt_b,
    output a_gt_b
);

    assign a_eq_b = (a == b);
    assign a_lt_b = (a < b);
    assign a_gt_b = (a > b);

endmodule