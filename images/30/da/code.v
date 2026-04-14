module DAC_16bit (
    input [15:0] digital_input,
    output reg [11:0] analog_output
);
    always @(*) begin
        // Scale the 16-bit input to a 12-bit output representing a voltage level
        analog_output = digital_input >> 4; // Scale down from 16 bits to 12 bits
    end
endmodule