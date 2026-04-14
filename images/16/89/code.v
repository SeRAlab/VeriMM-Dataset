module adc_16bit (
    input [15:0] adc_input,
    output reg [3:0] quantized_output
);

    always @(*) begin
        if (adc_input >= 16'hFFFF) begin
            quantized_output = 4'b1111; // Max output level
        end else begin
            quantized_output = adc_input[15:12]; // Taking the top 4 bits as quantization
        end
    end
endmodule