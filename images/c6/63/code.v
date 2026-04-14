module mux_2to1 (
    input in0,
    input in1,
    input sel,
    output out
);

    assign out = (sel == 1'b0) ? in0 : in1;

endmodule