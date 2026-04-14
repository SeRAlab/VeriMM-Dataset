module adc_converter (
    input [23:0] analog_input,
    output [11:0] digital_output
);
    // Assuming reference voltage is 2^24 for simplicity in scaling
    assign digital_output = analog_input[23:12]; // Simply take the upper 12 bits
endmodule