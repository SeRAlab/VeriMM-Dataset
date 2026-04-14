module histogram_equalization (
    input [7:0] pixel_in,
    output reg [7:0] pixel_out
);
    // Histogram array
    reg [7:0] histogram [0:255];
    reg [31:0] cdf [0:255]; // Cumulative distribution function
    reg [31:0] total_pixels;
    integer i;

    // Initialize histogram and CDF
    initial begin
        total_pixels = 0;
        for (i = 0; i < 256; i = i + 1) begin
            histogram[i] = 0;
            cdf[i] = 0;
        end
    end

    // Update histogram
    always @(*) begin
        histogram[pixel_in] = histogram[pixel_in] + 1;
        total_pixels = total_pixels + 1;
    end

    // Calculate CDF
    always @(*) begin
        cdf[0] = histogram[0];
        for (i = 1; i < 256; i = i + 1) begin
            cdf[i] = cdf[i-1] + histogram[i];
        end
    end

    // Map to equalized pixel value
    always @(*) begin
        pixel_out = (cdf[pixel_in] * 255) / total_pixels;
    end
endmodule