module adc_encoder(
    input [23:0] adc_input,
    output reg [3:0] adc_output
);
    always @(*) begin
        if (adc_input > 24'hFFFFFF) begin
            adc_output = 4'b1111; // Saturate to maximum
        end else begin
            adc_output = adc_input[23:20]; // Take the upper 4 bits
        end
    end
endmodule