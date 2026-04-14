module adc_16_to_4 (
    input [15:0] analog_in,   // 16-bit analog input
    output [3:0] digital_out   // 4-bit digital output
);
    assign digital_out = analog_in / 4096; // Quantization logic
endmodule