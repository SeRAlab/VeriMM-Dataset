module dac_16bit (
    input [15:0] digital_input,
    input enable,
    output reg [15:0] analog_output
);

always @(*) begin
    if (enable) begin
        analog_output = digital_input; // Direct mapping of digital input to output
    end else begin
        analog_output = 16'b0; // Output zero when not enabled
    end
end

endmodule