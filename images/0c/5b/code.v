module DAC_24bit (
    input [23:0] digital_input,
    output reg [11:0] analog_output // Assuming 12-bit output for DAC resolution
);
    // For a 24-bit input (0 to 16777215) to 12-bit output (0 to 4095)
    // Scale factor: 4095 / 16777215
    always @* begin
        analog_output = (digital_input * 4095) / 16777215;
    end
endmodule