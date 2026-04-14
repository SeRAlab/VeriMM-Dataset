module histogram_equalization (
    input [255:0] histogram,
    output reg [255:0] equalized_histogram
);
    integer i;
    integer cumulative_sum;
    integer total_pixels;
    reg [31:0] scaled_value;

    always @(*) begin
        total_pixels = 0;
        cumulative_sum = 0;
        equalized_histogram = 0;

        // Calculate total number of pixels
        for (i = 0; i < 256; i = i + 1) begin
            total_pixels = total_pixels + histogram[i];
        end

        // Perform histogram equalization
        for (i = 0; i < 256; i = i + 1) begin
            cumulative_sum = cumulative_sum + histogram[i];
            scaled_value = (cumulative_sum * 255) / total_pixels;
            equalized_histogram[i] = scaled_value[7:0];
        end
    end
endmodule