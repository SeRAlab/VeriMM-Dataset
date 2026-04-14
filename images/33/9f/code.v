module ADC_24_to_12 (
    input [23:0] analog_input,
    output reg [11:0] digital_output
);
    always @(*) begin
        if (analog_input > 24'hFFFFFF) begin
            digital_output = 12'h0FFF; // Max output
        end else if (analog_input < 24'h000000) begin
            digital_output = 12'h000; // Min output
        end else begin
            digital_output = analog_input >> 12; // Convert to 12 bits
        end
    end
endmodule