module DAC_24bit (
    input [23:0] digital_input,
    output [7:0] analog_output
);

assign analog_output = digital_input[23:16]; // Take the upper 8 bits

endmodule