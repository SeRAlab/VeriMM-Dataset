module top_module(
    in1,
    in2,
    in3,
    in4,
    in5,
    in6,
    in7,
    in8,
    out1
);input in1;
    input in2;
    input in3;
    input in4;
    input in5;
    input in6;
    input in7;
    input in8;
    output out1;

    assign out1 = in1 | in2 | in3 | in4 | in5 | in6 | in7 | in8;

endmodule