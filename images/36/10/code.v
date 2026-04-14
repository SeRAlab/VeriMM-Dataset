module jpeg_quantization (
    input [7:0] pixel_value,   // 8-bit input pixel value
    input [3:0] quant_value,   // 4-bit quantization value
    output reg [7:0] quantized_value // 8-bit output quantized value
);

always @(*) begin
    if (quant_value != 0)
        quantized_value = (pixel_value + (quant_value >> 1)) / quant_value; // Round to nearest
    else
        quantized_value = 8'b0; // In case of zero quantization value
end

endmodule