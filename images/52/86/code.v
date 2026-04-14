module top_module(
    in0,
    in1,
    in2,
    in3,
    out,
    sel0,
    sel1
);input in0, in1, in2, in3, sel0, sel1;
    output out;

    wire w1, w2, w3;

    assign w1 = sel0 & sel1;
    assign w2 = sel0 & ~sel1;
    assign w3 = ~sel0 & sel1;

    assign out = (w1 & in3) | (w2 & in2) | (w3 & in1) | (~sel0 & ~sel1 & in0);

endmodule