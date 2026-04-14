module mux_2_to_1 (
    input in_0,
    input in_1,
    input select,
    output out
);

    assign out = select ? in_1 : in_0;

endmodule