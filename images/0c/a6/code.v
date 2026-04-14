module adc_processor (
    input [23:0] adc_input,
    output [11:0] scaled_output
);
    assign scaled_output = adc_input[23:12];
endmodule