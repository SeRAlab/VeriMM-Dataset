module DAC (
    input [7:0] binary_input,
    output reg [9:0] analog_output
);
    always @(*) begin
        analog_output = binary_input * 1023 / 255; // Scale 8-bit to 10-bit output
    end
endmodule