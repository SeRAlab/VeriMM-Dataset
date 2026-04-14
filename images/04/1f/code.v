module canny_edge_detection (
    input [7:0] pixel1,
    input [7:0] pixel2,
    input [7:0] pixel3,
    input [7:0] pixel4,
    output [9:0] gradient_magnitude
);
    wire [9:0] Gx, Gy;

    assign Gx = (pixel1 - pixel3) + (2 * (pixel2 - pixel4));
    assign Gy = (pixel1 - pixel2) + (2 * (pixel3 - pixel4));
    assign gradient_magnitude = Gx + Gy;

endmodule