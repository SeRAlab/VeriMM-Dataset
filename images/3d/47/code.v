module DAC_24_to_12(
    input [23:0] digital_input,
    output [11:0] analog_output
);
    assign analog_output = digital_input[23:12];
endmodule