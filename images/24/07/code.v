module image_convolution (
    input [8*9-1:0] img,  // flattened 3x3 image (each pixel is 8 bits)
    output reg [15:0] out  // output result of convolution
);
    integer i;
    reg signed [7:0] kernel [0:8];
    reg signed [7:0] pixel [0:8];

    initial begin
        // Define the kernel values
        kernel[0] = 0; kernel[1] = -1; kernel[2] = 0;
        kernel[3] = -1; kernel[4] = 5; kernel[5] = -1;
        kernel[6] = 0; kernel[7] = -1; kernel[8] = 0;
    end

    always @(*) begin
        // Unpack the image data
        for (i = 0; i < 9; i = i + 1) begin
            pixel[i] = img[8*(8-i)+:8]; // access each pixel
        end

        // Compute the convolution
        out = 0;
        for (i = 0; i < 9; i = i + 1) begin
            out = out + pixel[i] * kernel[i];
        end
    end
endmodule