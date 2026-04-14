module DAC_24bit (
    input [23:0] digital_input,
    output [23:0] analog_output
);
    assign analog_output = digital_input; // Pass the input directly to output
endmodule