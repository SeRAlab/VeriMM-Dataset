module adc_8_to_4(
    input [7:0] adc_input,
    output reg [3:0] adc_output
);

always @(*) begin
    if (adc_input > 255) 
        adc_output = 4'b1111; // Max output for values above 255
    else 
        adc_output = adc_input[7:4]; // Use the upper 4 bits to represent the value.
end

endmodule