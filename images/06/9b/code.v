module DAC_24bit (
    input [23:0] digital_input,
    output reg [31:0] analog_output
);
    
    always @(*) begin
        // Scale the 24-bit input to a 32-bit output
        analog_output = {8'b0, digital_input}; // Just zero-extend the 24-bit to 32-bit
    end
    
endmodule