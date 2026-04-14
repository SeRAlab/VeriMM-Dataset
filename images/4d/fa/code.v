module top_module(
    input [7:0] a,
    input [7:0] b,
    output a_gt_b,
    output a_eq_b,
    output a_lt_b);

    assign a_gt_b = (a > b);
    assign a_eq_b = (a == b);
    assign a_lt_b = (a < b);

endmodule