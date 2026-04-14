module adc_converter (
    input [23:0] adc_input,
    output [7:0] adc_output
);
    assign adc_output = adc_input[23:16];
endmodule