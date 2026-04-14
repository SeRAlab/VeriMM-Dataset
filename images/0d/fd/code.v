module DAC_24bit (
    input wire [23:0] digital_input,
    input wire reset,
    output reg [11:0] analog_output
);

always @(*) begin
    if (reset) begin
        analog_output = 12'b0;
    end else begin
        analog_output = digital_input[23:12]; // Simple scaling
    end
end

endmodule