module top_module(
    input in0,
    input in1,
    input sel,
    output out
);wire and_out;
    wire or_out;
    wire not_sel;

    assign not_sel = ~sel;
    assign and_out = in0 & not_sel;
    assign or_out = in1 | and_out;
    assign out = ~or_out;

endmodule