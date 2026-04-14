module bilinear_interpolation (
    input [7:0] A, // Top-left pixel value
    input [7:0] B, // Top-right pixel value
    input [7:0] C, // Bottom-left pixel value
    input [7:0] D, // Bottom-right pixel value
    input [7:0] X, // X coordinate (0-255)
    input [7:0] Y, // Y coordinate (0-255)
    output reg [7:0] interpolated_value // Output interpolated pixel value
);
    always @(*) begin
        // Bilinear interpolation calculation
        interpolated_value = (A * (255 - X) * (255 - Y) + 
                              B * X * (255 - Y) + 
                              C * (255 - X) * Y + 
                              D * X * Y) / 65535;
    end
endmodule