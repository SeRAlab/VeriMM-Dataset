module mux_2to1(
    input in0,
    input in1,
    input sel,
    output out
);

    wire not_sel;
    assign not_sel = ~sel;

    assign out = (in0 & not_sel) | (in1 & sel);

endmodule