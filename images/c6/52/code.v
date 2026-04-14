module and_with_control (
    input in1,
    input in2,
    input ctrl,
    output out
);

    wire and_out = in1 & in2;
    wire not_ctrl = ~ctrl;
    wire or_out = and_out | not_ctrl;
    assign out = ~or_out;

endmodule