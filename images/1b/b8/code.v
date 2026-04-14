module adc_processor (
    input wire [15:0] adc_input,
    input wire enable,
    output wire [9:0] adc_output
);
    assign adc_output = enable ? adc_input[15:6] : 10'b0;
endmodule