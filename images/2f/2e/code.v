module adc_24_to_12 (
    input [23:0] adc_input,
    output [11:0] adc_output
);
    assign adc_output = adc_input[11:0];
endmodule