module DAC_24bit (
    input [23:0] binary_input,
    output reg [11:0] analog_output
);
    parameter MAX_BINARY_VALUE = 24'hFFFFFF; // Maximum 24-bit value
    parameter MAX_ANALOG_VALUE = 12'hFFF; // Maximum 12-bit value corresponding to 5V

    always @(*) begin
        analog_output = (binary_input * MAX_ANALOG_VALUE) / MAX_BINARY_VALUE;
    end
endmodule