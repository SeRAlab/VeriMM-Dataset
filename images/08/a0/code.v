module DAC (
    input [7:0] digital_input,
    input enable,
    output reg [7:0] analog_output
);

always @(*) begin
    if (!enable) begin
        analog_output = 8'b00000000; // Disable output
    end else begin
        analog_output = digital_input; // Output the input value
    end
end

endmodule