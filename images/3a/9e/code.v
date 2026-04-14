module DAC_24bit (
    input wire [23:0] dac_input,
    input wire enable,
    output reg [31:0] analog_output
);

always @(*) begin
    if (enable) begin
        analog_output = {dac_input, 8'b0}; // Concatenate the DAC input with 8 zeros
    end else begin
        analog_output = 32'b0; // Output zero when not enabled
    end
end

endmodule