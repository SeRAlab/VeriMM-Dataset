module top_module(
    input in1,
    input in2,
    input in3,
    input in4,
    input in5,
    input in6,
    input in7,
    input in8,
    output out1,
    output out2,
    output out3,
    output out4
);assign out1 = in1 & in2 & in3;
    assign out2 = in4 | in5 | in6;
    assign out3 = in7 ^ in8;
    assign out4 = ~in1;

endmodule