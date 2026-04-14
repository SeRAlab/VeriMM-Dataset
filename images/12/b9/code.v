module DAC24 (
    input [23:0] digital_input,
    output [23:0] analog_output
);
    assign analog_output = digital_input;
endmodule