module DAC_8bit (
    input [7:0] binary_in,
    output reg [11:0] analog_out // assuming 12-bit resolution for voltage representation
);
    always @(*) begin
        // Map the 8-bit binary value to a 12-bit output voltage level
        // Scale it to represent voltages from 0V to 5V
        analog_out = (binary_in * 4095) / 255; // 4095 corresponds to maximum for 12-bit
    end
endmodule