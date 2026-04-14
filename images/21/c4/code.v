module adc_controller (
    input [23:0] adc_input,
    output [23:0] adc_output
);

assign adc_output = adc_input >> 8;

endmodule