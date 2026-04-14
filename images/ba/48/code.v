module demux_1to2 (
    input a,
    input sel,
    output y0,
    output y1
);

    assign y0 = sel ? 0 : a;
    assign y1 = sel ? a : 0;

endmodule