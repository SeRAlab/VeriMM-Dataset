module adc_converter (
    input [11:0] adc_input,
    output [15:0] adc_output
);

    assign adc_output = (adc_input * 65535) / 4095;

endmodule