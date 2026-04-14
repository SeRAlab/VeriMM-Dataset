module dac_8bit (
    input [7:0] binary_input,
    output [9:0] analog_output
);
    assign analog_output = (binary_input * 1023) / 255;
endmodule