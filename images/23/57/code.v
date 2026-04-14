module jpeg_quantizer (
    input [7:0] dct_coeff,
    output reg [3:0] quantized_value
);

    // Predefined quantization table for JPEG
    reg [7:0] quantization_table [0:15];
    
    initial begin
        quantization_table[0] = 16; // Example values, adjust as needed
        quantization_table[1] = 11;
        quantization_table[2] = 10;
        quantization_table[3] = 16;
        quantization_table[4] = 24;
        quantization_table[5] = 23;
        quantization_table[6] = 29;
        quantization_table[7] = 21;
        quantization_table[8] = 24;
        quantization_table[9] = 29;
        quantization_table[10] = 28;
        quantization_table[11] = 34;
        quantization_table[12] = 48;
        quantization_table[13] = 50;
        quantization_table[14] = 64;
        quantization_table[15] = 72;
    end

    always @(*) begin
        if (dct_coeff < 16) begin
            quantized_value = dct_coeff / quantization_table[dct_coeff];
        end else begin
            quantized_value = 0; // Out of range handling
        end
    end
endmodule