module jpeg_quantization(
    input [7:0] pixel_value,
    input enable,
    output reg [7:0] quantized_value
);
    always @(*) begin
        if (enable) 
            quantized_value = pixel_value / 32; // Simple quantization
        else 
            quantized_value = pixel_value; // Bypass
    end
endmodule