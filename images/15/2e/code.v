module DAC_24bit (
    input [23:0] digital_input,
    input [1:0] gain_control, // 2'b00 for 1x, 2'b01 for 2x, 2'b10 for 4x
    output reg [31:0] analog_output
);
    always @(*) begin
        case (gain_control)
            2'b00: analog_output = digital_input; // 1x gain
            2'b01: analog_output = digital_input << 1; // 2x gain
            2'b10: analog_output = digital_input << 2; // 4x gain
            default: analog_output = 32'b0; // Default case
        endcase
    end
endmodule