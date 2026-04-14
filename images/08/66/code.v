module adc_decoder (
    input [15:0] adc_value,
    output reg [3:0] range
);
    always @(*) begin
        case (adc_value)
            16'h0000: range = 4'b0000; // 0-1023
            16'h0400: range = 4'b0001; // 1024-2047
            16'h0800: range = 4'b0010; // 2048-3071
            16'h0C00: range = 4'b0011; // 3072-4095
            16'h1000: range = 4'b0100; // 4096-5119
            16'h1400: range = 4'b0101; // 5120-6143
            16'h1800: range = 4'b0110; // 6144-7167
            16'h1C00: range = 4'b0111; // 7168-8191
            16'h2000: range = 4'b1000; // 8192-9215
            16'h2400: range = 4'b1001; // 9216-10239
            16'h2800: range = 4'b1010; // 10240-11263
            16'h2C00: range = 4'b1011; // 11264-12287
            16'h3000: range = 4'b1100; // 12288-13311
            16'h3400: range = 4'b1101; // 13312-14335
            16'h3800: range = 4'b1110; // 14336-15359
            16'hFFFF: range = 4'b1111; // 15360-65535
            default: range = 4'b0000; // Out of range
        endcase
    end
endmodule