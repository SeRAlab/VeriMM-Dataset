module adc_converter (
    input [23:0] adc_input,
    output [11:0] adc_output
);

assign adc_output = adc_input[11:0]; // Truncate to 12 bits

endmodule