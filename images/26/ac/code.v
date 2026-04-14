module DAC_24bit (
    input [23:0] digital_input,
    output [31:0] analog_output
);
    assign analog_output = {digital_input, 8'b0}; // Concatenate 24-bit input with 8 zeroes
endmodule