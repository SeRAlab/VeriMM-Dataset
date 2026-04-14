module DAC_24bit (
    input [23:0] digital_input,
    output reg [15:0] analog_output
);
    // Conversion constant for scaling digital to analog (3.3V corresponding to 24'hFFFFFF)
    parameter MAX_DIGITAL = 24'hFFFFFF;
    parameter MAX_ANALOG = 16'hFFFF; // Corresponds to 3.3V in fixed-point representation

    always @(*) begin
        // Scale the digital input to the analog output
        analog_output = (digital_input * MAX_ANALOG) / MAX_DIGITAL;
    end
endmodule