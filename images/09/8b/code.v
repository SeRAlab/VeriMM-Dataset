module DAC_24bit (
    input [23:0] digital_input,
    output reg [7:0] analog_output
);
    
    always @(*) begin
        // Scale down the 24-bit input to 8 bits
        analog_output = digital_input[23:16] + digital_input[15:8] + digital_input[7:0];
    end
endmodule