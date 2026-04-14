module DAC (
    input [23:0] digital_input,
    output reg [23:0] analog_output
);
    
    always @(*) begin
        // Simulate the conversion from digital to analog
        analog_output = digital_input; // Direct mapping for simplicity
    end
endmodule