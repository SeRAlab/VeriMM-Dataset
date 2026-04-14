module DAC_8bit (
    input [7:0] digital_input,
    output reg [9:0] analog_output
);
    always @(*) begin
        analog_output = digital_input * 1023 / 255; // Scale 8-bit to 10-bit
    end
endmodule