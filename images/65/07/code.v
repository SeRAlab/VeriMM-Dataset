module decoder2to4 (
    input a,
    input b,
    output y0,
    output y1,
    output y2,
    output y3
);

    assign y0 = ~a & ~b;
    assign y1 = ~a & b;
    assign y2 = a & ~b;
    assign y3 = a & b;

endmodule