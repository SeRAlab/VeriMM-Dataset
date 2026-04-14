module DAC_8bit (
    input [7:0] binary_input,
    output reg [9:0] analog_output
);

always @(*) begin
    analog_output = binary_input * 10 / 2; // Analog output corresponding to 0 to 5V scaled to 10 bits
end

endmodule