module top_module(
    input A,
    input B,
    input C,
    input D,
    input sel0,
    input sel1,
    output Y
);wire w1, w2, w3, w4, w5, w6;

    assign w1 = (~sel1 & ~sel0) ? A : 1'b0;
    assign w2 = (~sel1 & sel0) ? B : 1'b0;
    assign w3 = (sel1 & ~sel0) ? C : 1'b0;
    assign w4 = (sel1 & sel0) ? D : 1'b0;

    assign w5 = w1 | w2;
    assign w6 = w3 | w4;

    assign Y = w5 | w6;

endmodule