module mux_2_1 (
    input a,
    input b,
    input sel,
    output out
);

    assign out = (sel == 1'b0) ? a : b;

endmodule