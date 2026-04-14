module adc_processor (
    input [23:0] adc_input,
    output [7:0] msb_output
);
    assign msb_output = adc_input[23:16]; // Extracting the 8 MSBs
endmodule