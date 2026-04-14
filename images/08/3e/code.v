module adc_processor (
    input [15:0] adc_input,
    output [3:0] upper_bits,
    output [3:0] lower_bits
);
    assign upper_bits = adc_input[15:12];
    assign lower_bits = adc_input[3:0];
endmodule