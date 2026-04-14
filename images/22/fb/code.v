module DAC_16bit (
    input [15:0] binary_input,
    output reg [11:0] analog_output
);
    parameter MAX_VOLTAGE = 5; // Max output voltage
    parameter RESOLUTION = 4095; // 12-bit resolution

    always @(*) begin
        analog_output = (binary_input * RESOLUTION) / 65535; // Scale 16-bit to 12-bit
    end
endmodule