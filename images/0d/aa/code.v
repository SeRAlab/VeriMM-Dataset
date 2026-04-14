module adc_output_processor(
    input [23:0] adc_input,
    output reg [7:0] adc_output
);
    
always @(*) begin
    if (adc_input < 8) begin
        adc_output = 8'b00000000; // Output 0 if input < 8
    end else if (adc_input <= 24'hFFFFFF) begin
        adc_output = adc_input[23:16]; // Output the top 8 bits
    end else begin
        adc_output = 8'b11111111; // Output 255 for inputs > 16777215
    end
end

endmodule