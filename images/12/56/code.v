module DAC_24bit(
    input [23:0] binary_input,
    output reg [31:0] analog_output
);
    // Scaling factor: 5V corresponds to 16,777,215
    // Hence, we multiply binary_input by (5 * 2^24) / 5V
    // which simplifies to just binary_input
    always @(*) begin
        analog_output = binary_input; // Direct mapping for simplicity
    end
endmodule