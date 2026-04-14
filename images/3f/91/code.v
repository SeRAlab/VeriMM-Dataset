module adc_16_to_4 (
    input [15:0] analog_input,
    output [3:0] digital_output
);
assign digital_output = analog_input[15:12];
endmodule