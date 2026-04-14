module adc_16_to_10 (
    input [15:0] adc_input,
    output [9:0] adc_output
);
    assign adc_output = adc_input >> 6; // Scale down from 16 bits to 10 bits
endmodule