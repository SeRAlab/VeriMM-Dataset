module dac_8bit (
    input [7:0] bin_input,
    output [9:0] analog_output
);
    assign analog_output = bin_input * 1023 / 255; // Scale to 10-bit range
endmodule