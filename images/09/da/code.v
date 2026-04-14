module DAC_8bit (
    input [7:0] digital_input,
    output reg [9:0] analog_output
);
    always @(*) begin
        // Scale the 8-bit input by 1.25 and ensure it fits in a 10-bit output
        analog_output = (digital_input * 125) >> 2; // equivalent to (digital_input * 1.25)
    end
endmodule