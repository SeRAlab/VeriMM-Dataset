module top_module(
    input in1,
    input in2,
    input in3,
    input in4,
    output out
);wire all_ones = (in1 & in2 & in3 & in4);
    wire all_zeros = (~in1 & ~in2 & ~in3 & ~in4);
    
    assign out = all_ones | all_zeros;

endmodule