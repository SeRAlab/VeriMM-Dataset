module top_module(
    input in1,
    input in2,
    input in3,
    input in4,
    input in5,
    output out
);assign out = (in1 & in2 & in3) | (in4 & ~in5);

endmodule