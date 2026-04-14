module adc_24bit (
    input [11:0] analog_input,
    output reg [23:0] digital_output
);

always @(*) begin
    if (analog_input > 12'd4095) begin
        digital_output = 24'hFFFFFF; // max 24-bit value
    end else begin
        digital_output = analog_input * 24'd4096; // scale to 24-bit
    end
end

endmodule