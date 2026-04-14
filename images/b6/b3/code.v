module top_module (
    input wire a,
    input wire b,
    output wire y0,
    output wire y1,
    output wire y2,
    output wire y3
);

    assign y0 = ~a & ~b;
    assign y1 = ~a & b;
    assign y2 = a & ~b;
    assign y3 = a & b;

endmodule