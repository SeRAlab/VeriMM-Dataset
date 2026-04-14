module DAC_16bit (
    input [15:0] digital_input,
    output reg [15:0] analog_output
);
    always @(*) begin
        // Assuming a simple scaling to represent voltage in a 16-bit format
        analog_output = digital_input; // Direct mapping for simulation
    end
endmodule