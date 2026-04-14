module DAC_8bit_to_10bit (
    input [7:0] binary_input,
    output [9:0] analog_output
);
    assign analog_output = binary_input << 2; // Scale up the 8-bit input to 10-bit
endmodule