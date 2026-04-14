module DAC_24bit (
    input [23:0] digital_input,  // 24-bit digital input
    input [11:0] Vref,           // 12-bit reference voltage (0 to 4095)
    output reg [11:0] analog_output // 12-bit analog output voltage level (0 to 4095)
);

    always @(*) begin
        analog_output = (digital_input * Vref) >> 12; // Scale the digital input with the reference voltage
    end
endmodule