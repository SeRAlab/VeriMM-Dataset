module top_module(
    input  wire in0,
    input  wire in1,
    input  wire in2,
    input  wire in3,
    input  wire sel0,
    input  wire sel1,
    output wire out
);assign out = sel1 & sel0 ? in3 :
                 sel1 & !sel0 ? in2 :
                 !sel1 & sel0 ? in1 :
                 !sel1 & !sel0 ? in0 :
                 1'bx;

endmodule