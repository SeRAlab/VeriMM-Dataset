module mux_2_to_1 (
    input a,
    input b,
    input sel,
    output y
);

    assign y = sel ? b : a;

endmodule