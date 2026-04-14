module adc_converter (
    input [15:0] analog_input,
    output [3:0] digital_output
);
    assign digital_output = analog_input >> 14; // Divide by 16384
endmodule