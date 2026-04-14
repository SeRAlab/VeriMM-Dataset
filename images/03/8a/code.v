module DAC_24bit (
    input wire [23:0] binary_input,
    input wire enable,
    output reg [23:0] analog_output
);
    always @(*) begin
        if (enable) begin
            analog_output = binary_input; // Pass through the input when enabled
        end else begin
            analog_output = analog_output; // Hold the output when not enabled
        end
    end
endmodule