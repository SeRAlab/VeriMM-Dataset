module adc_8bit_to_4bit (
    input [7:0] adc_input,
    output [3:0] adc_output
);
    assign adc_output = adc_input[7:4]; // Select the most significant 4 bits
endmodule