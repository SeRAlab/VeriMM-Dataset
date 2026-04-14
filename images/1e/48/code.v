module conv_3x3 (
    input [24:0] image,       // 5x5 input image
    input [8:0] kernel,       // 3x3 kernel
    input enable,             // enable signal
    output reg [7:0] result,  // convolution result
    output reg valid          // valid signal
);
    always @(*) begin
        if (enable) begin
            result = 0;        // initialize result
            valid = 1;         // set valid signal
            
            // Perform convolution
            result = (kernel[0] * image[0] + kernel[1] * image[1] + kernel[2] * image[2] +
                      kernel[3] * image[5] + kernel[4] * image[6] + kernel[5] * image[7] +
                      kernel[6] * image[10] + kernel[7] * image[11] + kernel[8] * image[12]);
        end else begin
            valid = 0;         // reset valid signal if not enabled
        end
    end
endmodule