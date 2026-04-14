module canny_edge_detector (
    input [7:0] pixel00, // Top-left pixel
    input [7:0] pixel01, // Top-center pixel
    input [7:0] pixel02, // Top-right pixel
    input [7:0] pixel10, // Middle-left pixel
    input [7:0] pixel11, // Middle-center pixel
    input [7:0] pixel12, // Middle-right pixel
    input [7:0] pixel20, // Bottom-left pixel
    input [7:0] pixel21, // Bottom-center pixel
    input [7:0] pixel22, // Bottom-right pixel
    output reg [7:0] edge_strength
);
    
    wire signed [10:0] Gx; // Gradient in x-direction
    wire signed [10:0] Gy; // Gradient in y-direction
    
    assign Gx = (pixel02 + 2 * pixel12 + pixel22) - (pixel00 + 2 * pixel01 + pixel10); // Sobel Gx
    assign Gy = (pixel00 + 2 * pixel01 + pixel02) - (pixel20 + 2 * pixel21 + pixel22); // Sobel Gy
    
    always @(*) begin
        edge_strength = (Gx > 0 ? Gx : -Gx) > (Gy > 0 ? Gy : -Gy) ? (Gx > 0 ? Gx : -Gx) : (Gy > 0 ? Gy : -Gy);
        if (edge_strength > 255) edge_strength = 255; // Clipping
    end
    
endmodule