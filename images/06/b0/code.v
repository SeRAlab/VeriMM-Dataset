module adc_processor (
    input [15:0] adc_input,
    output [15:0] adc_output,
    output is_above_threshold
);
    assign adc_output = adc_input;
    assign is_above_threshold = (adc_input > 16'h8000) ? 1'b1 : 1'b0;
endmodule