module DAC_16bit (
    input [15:0] binary_input,  // 16-bit binary input
    input [15:0] reference_voltage, // Reference voltage (max analog voltage)
    output [15:0] analog_output   // 16-bit analog output
);
    assign analog_output = (binary_input * reference_voltage) >> 16; // Scale the output
endmodule