module downsample_2x2 (
    input [7:0] pixel1,
    input [7:0] pixel2,
    input [7:0] pixel3,
    input [7:0] pixel4,
    output reg [3:0] avg_pixel
);
    always @(*) begin
        avg_pixel = (pixel1 + pixel2 + pixel3 + pixel4) >> 2; // Divide by 4 (average)
    end
endmodule