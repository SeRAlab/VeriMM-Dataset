module adc_processor (
    input wire [23:0] adc_input,
    output wire [11:0] adc_output
);
    assign adc_output = adc_input[23:12];
endmodule