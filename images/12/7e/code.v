module adc_converter (
    input [7:0] analog_input,
    output [7:0] digital_output
);
    assign digital_output = analog_input;
endmodule