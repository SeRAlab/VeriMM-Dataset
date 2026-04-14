module non_max_suppression (
    input [7:0] pixel00, input [7:0] pixel01, input [7:0] pixel02,
    input [7:0] pixel10, input [7:0] pixel11, input [7:0] pixel12,
    input [7:0] pixel20, input [7:0] pixel21, input [7:0] pixel22,
    output reg [7:0] output_pixel
);
    always @* begin
        // Initialize output_pixel to zero
        output_pixel = 8'b0;

        // Non-maximum suppression logic
        if (pixel11 >= pixel10 && pixel11 >= pixel12 && pixel11 >= pixel00 && pixel11 >= pixel20) begin
            output_pixel = pixel11; // Retain the pixel
        end else if (pixel11 < pixel10 || pixel11 < pixel12 || pixel11 < pixel00 || pixel11 < pixel20) begin
            output_pixel = 8'b0; // Suppress the pixel
        end
    end
endmodule