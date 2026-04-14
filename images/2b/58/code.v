module adc_output_processor (
    input [23:0] adc_input,
    output reg [15:0] adc_output
);
    always @(*) begin
        if (adc_input > 24'hFFFFFF) begin
            adc_output = 16'hFFFF; // Maximum 16-bit value
        end else begin
            adc_output = adc_input[23:8]; // Take the most significant 16 bits
        end
    end
endmodule