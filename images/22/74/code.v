module adc_processor (
    input [23:0] adc_input,
    output [15:0] adc_output
);

assign adc_output = adc_input[23:8]; // Right shift by 8 bits

endmodule