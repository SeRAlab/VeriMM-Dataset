module png_filter_sub (
    input [7:0] current_pixel, // Current pixel input
    input [7:0] previous_pixel, // Previous pixel input
    input valid, // Signal to indicate valid previous pixel
    output reg [7:0] filtered_pixel // Filtered output pixel
);
    always @(*) begin
        if (valid) begin
            filtered_pixel = current_pixel - previous_pixel; // Sub filter
        end else begin
            filtered_pixel = current_pixel; // No previous pixel
        end
    end
endmodule