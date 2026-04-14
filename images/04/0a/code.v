module sobel_edge_detection (
    input [7:0] pixel,
    input [7:0] left_pixel,
    input [7:0] right_pixel,
    input [7:0] top_pixel,
    input [7:0] bottom_pixel,
    output reg [7:0] edge_strength
);

    // Sobel kernels
    // Gx = [-1 0 1]
    // Gy = [1 2 1]
    
    wire signed [8:0] Gx;
    wire signed [8:0] Gy;

    assign Gx = (right_pixel - left_pixel) + (2 * bottom_pixel) - (2 * top_pixel);
    assign Gy = (bottom_pixel - top_pixel) + (2 * right_pixel) - (2 * left_pixel);

    always @(*) begin
        edge_strength = (Gx < 0 ? -Gx : Gx) + (Gy < 0 ? -Gy : Gy);
    end
endmodule