module edge_detection (
    input [8:0] pixel_00, // Top-left
    input [8:0] pixel_01, // Top-center
    input [8:0] pixel_02, // Top-right
    input [8:0] pixel_10, // Middle-left
    input [8:0] pixel_11, // Middle-center
    input [8:0] pixel_12, // Middle-right
    input [8:0] pixel_20, // Bottom-left
    input [8:0] pixel_21, // Bottom-center
    input [8:0] pixel_22, // Bottom-right
    input [7:0] threshold, // Threshold for edge detection
    output reg [0:0] edge_out // Output signal
);
    wire [8:0] gx; // Gradient in x direction
    wire [8:0] gy; // Gradient in y direction
    wire [8:0] magnitude; // Gradient magnitude

    assign gx = (pixel_02 + 2*pixel_12 + pixel_22) - (pixel_00 + 2*pixel_01 + pixel_02);
    assign gy = (pixel_20 + 2*pixel_21 + pixel_22) - (pixel_00 + 2*pixel_10 + pixel_20);
    assign magnitude = gx + gy;

    always @(*) begin
        if(magnitude > threshold)
            edge_out = 1'b1;
        else
            edge_out = 1'b0;
    end
endmodule