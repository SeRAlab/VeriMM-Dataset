module image_convolution (
    input [7:0] pixel,
    input [8:0] kernel,
    output reg [7:0] result
);
    always @(*) begin
        // Assume a simple convolution where we multiply the pixel with each kernel element
        // and sum the results. For simplicity, we assume pixel is the center pixel.
        result = (kernel[8:6] * pixel) + 
                 (kernel[5:3] * pixel) + 
                 (kernel[2:0] * pixel);
    end
endmodule