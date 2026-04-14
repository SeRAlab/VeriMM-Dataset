module mux_2to1(
    input d0,
    input d1,
    input sel,
    output y
);

    assign y = (sel) ? d1 : d0;

endmodule