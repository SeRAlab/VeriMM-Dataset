module mux_2to1 (
    input a,
    input b,
    input sel,
    output y
);

    // 2-to-1 MUX logic
    assign y = sel ? b : a;

endmodule