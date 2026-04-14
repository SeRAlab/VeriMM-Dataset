module DAC_24bit (
    input [23:0] binary_input,
    output reg [31:0] analog_output
);
    parameter REFERENCE_VOLTAGE = 32'd5000000; // 5V in microvolts
    always @(*) begin
        analog_output = (binary_input * REFERENCE_VOLTAGE) >> 24; // division by 2^24
    end
endmodule