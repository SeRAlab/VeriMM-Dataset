module mux_2to1(
    input   a,
    input   b,
    input   sel,
    output  y
);

assign y = (a & ~sel) | (b & sel);

endmodule