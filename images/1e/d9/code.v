module histogram_equalization (
    input [255:0] histogram,
    output reg [255:0] equalized_histogram
);
    integer i;
    reg [15:0] cdf [0:255];
    reg [7:0] cdf_min;
    reg [15:0] total_pixels;

    always @(*) begin
        // Initialize
        total_pixels = 0;
        cdf_min = 255;

        // Calculate total pixels and CDF
        for (i = 0; i < 256; i = i + 1) begin
            total_pixels = total_pixels + histogram[i];
            if (histogram[i] > 0 && i < cdf_min) begin
                cdf_min = i[7:0];
            end
        end

        // Calculate CDF
        cdf[0] = histogram[0];
        for (i = 1; i < 256; i = i + 1) begin
            cdf[i] = cdf[i-1] + histogram[i];
        end

        // Calculate equalized histogram
        for (i = 0; i < 256; i = i + 1) begin
            if (total_pixels > 0) begin
                equalized_histogram[i] = ((cdf[i] - cdf_min) * 255) / (total_pixels - cdf_min);
            end else begin
                equalized_histogram[i] = 0;
            end
        end
    end
endmodule