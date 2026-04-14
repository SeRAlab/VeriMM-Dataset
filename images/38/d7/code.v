module adc_16_to_4 (
    input [15:0] adc_input,
    output [3:0] adc_output
);
    assign adc_output = adc_input / 4096;
endmodule