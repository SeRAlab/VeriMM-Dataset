module hough_transform (
    input wire [7:0] pixel_val, // binary pixel value: 0 (black) or 255 (white)
    output reg [15:0] rho,      // rho value for the Hough transform
    output reg [7:0] theta      // theta value for the Hough transform
);

    always @(*) begin
        if (pixel_val == 255) begin // If pixel is white
            // Calculate rho and theta based on some simple logic
            rho = 100; // Example fixed value for rho
            theta = 45; // Example fixed value for theta
        end else begin
            rho = 0;   // If pixel is not white
            theta = 0;
        end
    end
endmodule