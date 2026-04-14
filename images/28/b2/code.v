module adc_scaler (
    input [23:0] adc_input,
    output [9:0] adc_output
);
    assign adc_output = (adc_input > 24'hFFFFFF) ? 10'd1023 : (adc_input >> 14);
endmodule