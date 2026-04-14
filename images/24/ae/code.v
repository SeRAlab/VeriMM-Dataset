module paeth_filter (
    input [7:0] current_pixel,
    input [7:0] left_pixel,
    input [7:0] above_pixel,
    input [7:0] above_left_pixel,
    output [7:0] predicted_pixel
);
    wire signed [8:0] p;
    wire signed [8:0] pa;
    wire signed [8:0] pb;
    wire signed [8:0] pc;

    assign p = left_pixel + above_pixel - above_left_pixel;

    assign pa = (p - left_pixel) < 0 ? -(p - left_pixel) : (p - left_pixel);
    assign pb = (p - above_pixel) < 0 ? -(p - above_pixel) : (p - above_pixel);
    assign pc = (p - above_left_pixel) < 0 ? -(p - above_left_pixel) : (p - above_left_pixel);

    assign predicted_pixel = (pa <= pb && pa <= pc) ? left_pixel :
                             (pb <= pc) ? above_pixel : above_left_pixel;
endmodule