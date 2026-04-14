module comparator_4bit(a, b, a_gt_b);

    input  [3:0] a;
    input  [3:0] b;
    output a_gt_b;
    assign a_gt_b = (a > b);

endmodule