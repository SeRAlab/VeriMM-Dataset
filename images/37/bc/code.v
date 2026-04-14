module DAC_24bit (
    input [23:0] digital_input,
    input [15:0] V_ref, // Reference voltage scaled to 16 bits
    output reg [15:0] analog_output // 16-bit output to represent analog voltage
);
    always @(*) begin
        analog_output = (digital_input * V_ref) >> 24; // Scale the output
    end
endmodule