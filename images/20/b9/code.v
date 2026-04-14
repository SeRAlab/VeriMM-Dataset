module DAC_8bit (
    input [7:0] input_value,
    output [9:0] output_voltage
);
    assign output_voltage = (input_value * 10) / 255; // Scale to 10-bit representation of 0 to 5V
endmodule