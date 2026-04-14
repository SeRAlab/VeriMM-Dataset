module jpeg_quantizer (
    input [3:0] intensity,
    output [2:0] quantized_value
);
    assign quantized_value = intensity >> 1; // Right shift by 1 for quantization
endmodule