module top_module(
    input [10:0] x1, y1, x2, y2, x3, y3,
    output sign
    );assign sign = (x1 - x3) * (y2 - y3) - (x2 - x3) * (y1 - y3);endmodule