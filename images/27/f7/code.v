module adc_processor (
    input [23:0] adc_input,
    output [11:0] adc_output
);
    assign adc_output = adc_input[23:12]; // Extract upper 12 bits
endmodule