module ADC_24_to_12 (
    input [23:0] adc_in,
    output [11:0] adc_out
);
    assign adc_out = adc_in[23:12];
endmodule