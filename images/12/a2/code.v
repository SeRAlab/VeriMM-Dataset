module DAC_24bit (
    input [23:0] binary_input,
    input enable,
    output reg [31:0] analog_output
);
    always @(*) begin
        if (enable) begin
            analog_output = {binary_input, 8'b0}; // Shift left for the fractional part
        end else begin
            analog_output = 32'b0; // Hold output at zero when not enabled
        end
    end
endmodule