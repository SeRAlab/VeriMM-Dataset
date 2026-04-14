module top_module(
    in0,
    in1,
    in2,
    in3,
    sel0,
    sel1,
    out
);input in0, in1, in2, in3, sel0, sel1;
    output out;

    assign out = (sel1 & sel0) ? in3 : 
                 (sel1 & ~sel0) ? in2 : 
                 (~sel1 & sel0) ? in1 : in0;

endmodule