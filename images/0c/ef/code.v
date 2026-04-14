module quantizer (
    input [7:0] pixel_in,
    output reg [1:0] quantized_out
);

always @(*) begin
    if (pixel_in < 64) 
        quantized_out = 2'b00;
    else if (pixel_in < 128) 
        quantized_out = 2'b01;
    else if (pixel_in < 192) 
        quantized_out = 2'b10;
    else 
        quantized_out = 2'b11;
end

endmodule