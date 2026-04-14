module png_filter (
    input [7:0] pixel,
    input [7:0] left_pixel,
    output reg [7:0] filtered_pixel
);

always @(*) begin
    filtered_pixel = pixel + (left_pixel >> 1); // Simple filter: pixel + left pixel / 2
end

endmodule