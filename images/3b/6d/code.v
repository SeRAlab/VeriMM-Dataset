module dac_8bit (
    input [7:0] digital_input,
    output reg [9:0] analog_output
);
    always @(*) begin
        // Scale the 8-bit input to a 10-bit output voltage (0-1023 for 0-5V)
        analog_output = digital_input * 10 / 256; // 256 to scale 8-bit to 10-bit
    end
endmodule