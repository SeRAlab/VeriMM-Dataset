module DAC_Interface (
    input [23:0] digital_input,
    output reg [7:0] analog_output
);

always @(*) begin
    if (digital_input < 256) begin
        analog_output = 8'b00000000;
    end else begin
        analog_output = digital_input[23:16]; // Get the higher 8 bits
    end
end

endmodule