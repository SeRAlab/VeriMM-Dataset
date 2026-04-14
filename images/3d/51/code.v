module adc_processor(
    input [15:0] adc_input,
    output [7:0] msb_output
);
    assign msb_output = adc_input[15:8];
endmodule