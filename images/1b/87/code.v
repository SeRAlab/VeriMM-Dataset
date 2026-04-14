module sobel_edge_detection (
    input [7:0] pixel_0_0, pixel_0_1, pixel_0_2,
    input [7:0] pixel_1_0, pixel_1_1, pixel_1_2,
    input [7:0] pixel_2_0, pixel_2_1, pixel_2_2,
    output reg [7:0] edge_strength
);
    wire signed [10:0] Gx, Gy;
    
    // Sobel kernels
    assign Gx = (pixel_0_2 + 2 * pixel_1_2 + pixel_2_2) -
                 (pixel_0_0 + 2 * pixel_1_0 + pixel_2_0);
    assign Gy = (pixel_2_0 + 2 * pixel_2_1 + pixel_2_2) -
                 (pixel_0_0 + 2 * pixel_0_1 + pixel_0_2);
    
    always @(*) begin
        edge_strength = (Gx < 0) ? -Gx : Gx; // Absolute value
        edge_strength = (Gy < 0) ? -Gy : Gy; // Take the maximum of Gx and Gy
        edge_strength = (edge_strength > (Gx > Gy ? Gx : Gy)) ? edge_strength : (Gx > Gy ? Gx : Gy);
    end
endmodule