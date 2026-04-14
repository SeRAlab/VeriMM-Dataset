module top_module(
    out1,
    in1,
    in2,
    in3,
    in4,
    VPWR,
    VGND
);output out1;
    input in1;
    input in2;
    input in3;
    input in4;
    input VPWR;
    input VGND;

    wire three_high;
    wire two_high;
    wire one_high;
    wire all_low;

    assign three_high = (in1 & in2 & in3) | (in1 & in2 & in4) | (in1 & in3 & in4) | (in2 & in3 & in4);
    assign two_high = (in1 & in2) | (in1 & in3) | (in1 & in4) | (in2 & in3) | (in2 & in4) | (in3 & in4);
    assign one_high = in1 | in2 | in3 | in4;
    assign all_low = ~in1 & ~in2 & ~in3 & ~in4;

    assign out1 = (three_high | one_high | all_low) & ~two_high;

endmodule