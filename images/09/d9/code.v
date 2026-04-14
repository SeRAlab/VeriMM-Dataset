module DAC_24bit (
    input [23:0] binary_input,  // 24-bit binary input
    output reg [7:0] analog_output // 8-bit analog output
);
    always @(*) begin
        analog_output = (binary_input * 255) >> 24; // Scale to 8-bit
    end
endmodule