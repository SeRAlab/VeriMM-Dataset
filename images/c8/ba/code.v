module and_or_gate (
    input in1,
    input in2,
    input in3,
    input in4,
    output out
);

    wire or_out;
    assign or_out = in3 | in4 | out;

    assign out = in1 & in2 & or_out;

endmodule