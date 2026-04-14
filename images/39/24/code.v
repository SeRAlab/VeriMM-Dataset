module DAC_24bit (
    input [23:0] digital_input,  // 24-bit digital input
    output reg [31:0] analog_output // 32-bit analog output to represent voltage
);

    always @(*) begin
        // Calculate the analog output based on the digital input
        analog_output = (digital_input * 3300) / 16777215; // Scale to 3.3V
    end
endmodule