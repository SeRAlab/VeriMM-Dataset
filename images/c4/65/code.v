module mux_2_to_1 (
    input sel,
    input in0,
    input in1,
    output out
);

    assign out = sel ? in1 : in0;

endmodule