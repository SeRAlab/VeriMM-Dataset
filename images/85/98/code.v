module top_module(
    out,
    in0,
    in1,
    in2,
    in3,
    sel0,
    sel1
);output out;
    input in0;
    input in1;
    input in2;
    input in3;
    input sel0;
    input sel1;

    wire sel0_inv;
    wire sel1_inv;
    wire in0_and_sel0_and_sel1;
    wire in1_and_sel0_and_not_sel1;
    wire in2_and_not_sel0_and_sel1;
    wire in3_and_sel0_and_sel1;

    assign sel0_inv = ~sel0;
    assign sel1_inv = ~sel1;

    assign in0_and_sel0_and_sel1 = in0 & sel0 & sel1;
    assign in1_and_sel0_and_not_sel1 = in1 & sel0 & sel1_inv;
    assign in2_and_not_sel0_and_sel1 = in2 & sel0_inv & sel1;
    assign in3_and_sel0_and_sel1 = in3 & sel0_inv & sel1_inv;

    assign out = in0_and_sel0_and_sel1 | in1_and_sel0_and_not_sel1 | in2_and_not_sel0_and_sel1 | in3_and_sel0_and_sel1;

endmodule