module adc_msb_processor (
    input [15:0] adc_input,
    output [3:0] msb_output
);
    assign msb_output = adc_input[15:12];
endmodule