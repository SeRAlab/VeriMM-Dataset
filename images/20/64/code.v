module DAC_Controller (
    input wire [23:0] digital_input,
    input wire enable,
    output reg [11:0] analog_output
);

always @(*) begin
    if (enable) begin
        analog_output = digital_input[23:12]; // Take the upper 12 bits
    end else begin
        analog_output = 12'b0; // Output zero when not enabled
    end
end

endmodule