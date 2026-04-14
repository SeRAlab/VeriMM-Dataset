module ADC_8_to_4 (
    input [7:0] analog_input,
    output [3:0] digital_output
);
    assign digital_output = analog_input[7:4]; // Truncate lower 4 bits
endmodule