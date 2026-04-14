module top_module(
    input in1,
    input in2,
    input in3,
    input in4,
    input in5,
    output out1
);wire and_out;
    wire or_out;

    assign and_out = in1 & in2 & in3 & in4;
    assign or_out = and_out | in5;
    assign out1 = or_out;

endmodule