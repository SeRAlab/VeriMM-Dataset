module DAC_16bit (
    input [15:0] digital_input,
    output [15:0] analog_output
);
    assign analog_output = digital_input;
endmodule