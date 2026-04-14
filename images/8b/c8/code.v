module top_module(
    input in0,
    input in1,
    input in2,
    input in3,
    input sel0,
    input sel1,
    output out
);// Select the output based on the select lines
assign out = (sel1 & sel0) ? in3 : (sel1 & ~sel0) ? in2 : (~sel1 & sel0) ? in1 : in0;

endmodule