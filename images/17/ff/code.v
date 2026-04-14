module image_convolution (
    input [7:0] pixel_00, input [7:0] pixel_01, input [7:0] pixel_02,
    input [7:0] pixel_10, input [7:0] pixel_11, input [7:0] pixel_12,
    input [7:0] pixel_20, input [7:0] pixel_21, input [7:0] pixel_22,
    output reg [15:0] conv_result
);
    always @* begin
        // Example kernel (Edge detection)
        // Kernel: 1  0  -1
        //         1  0  -1
        //         1  0  -1
        conv_result = (pixel_00 * 1 + pixel_01 * 0 + pixel_02 * -1 +
                       pixel_10 * 1 + pixel_11 * 0 + pixel_12 * -1 +
                       pixel_20 * 1 + pixel_21 * 0 + pixel_22 * -1);
    end
endmodule