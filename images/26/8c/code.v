module adc_msn_extractor (
    input [15:0] adc_input,
    output [3:0] msn_output
);
    assign msn_output = adc_input[15:12]; // Extract the most significant nibble
endmodule